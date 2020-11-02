load('Data/vanvikan/imu_measurements_1_2')

end_idx = length(imuData.acceleration(1,:))-250*0;
start_idx = length(imuData.acceleration(1,:))-250*240;

%
end_idx = length(imuData.acceleration(1,:))-250*0;
start_idx = length(imuData.acceleration(1,:))-250*200;


end_idx = length(imuData.acceleration(1,:))-250*0;
start_idx = find(imuData.speed<2,1);


assert(start_idx<end_idx);

signal_x = imuData.acceleration(2,start_idx:end_idx);
signal_y = imuData.acceleration(1,start_idx:end_idx);
signal_z = -imuData.acceleration(3,start_idx:end_idx);
ang_x = imuData.ang_velocity(2,start_idx:end_idx);
ang_y = imuData.ang_velocity(1,start_idx:end_idx);
ang_z = -imuData.ang_velocity(3,start_idx:end_idx);



signal = -signal_x;
signal = signal_y;
%signal = -lowpass(signal_y,5,250);
t = imuData.t_imu(start_idx:end_idx);
t = t- imuData.t_imu(1);
sample_rate = mean(1./diff(t));

contact_points = [945.5
    950.5
    952.5
    959.0];
%contact_points = []
if ~isempty(contact_points)
    contact_series = any(abs(imuData.t_imu-imuData.t_imu(1) -  contact_points)  < 0.1);
end
%imuData.colition_label = contact_series;

contact_series = imuData.colition_label(start_idx:end_idx);

%signal = sum(imf(:,4:7),2);

%signal = lowpass(signal,10,250);
%open_figure('IMU Data','clearFig',false)
open_figure('Signal Raw','newFig',true)
hold on
plot(t,signal)
grid on

%%

% L = length(t);
% Y = fft(signal);
% %Y = fft( imf(:,6));
% P2 = abs(Y/L);
% P1 = P2(1:floor(L/2+1));
% P1(2:end-1) = 2*P1(2:end-1);
% f = sample_rate*(0:(L/2))/L;
%
% %end_freq = 40;
% %end_freq_idx = ceil(end_freq/diff(f(1:2)));
%
% %open_figure('FFT result','newFig',1)
% figure(2)
% hold on
% plot(f,P1)
%
% %title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('frequenzy [Hz]')
% ylabel('Amplitude')
%
% %% STFT
% open_figure('STFT','clearFig',true);
%
% %Same window size as the stationarity of signal 3 of the signal
% window_size = 10*sample_rate;
% %window_size = fix(length(signal)/100);
% spectrogram(signal,window_size,floor(window_size*0.5),800,sample_rate)
% %xlim([0,50])
%
% %% Wigner-Ville Transform
% %open_figure('WVT','clearFig',true);
% %wvd(signal,sample_rate)
%
%
% %% Wavelet Transform
% open_figure('Wavelet','clearFig',true)
% cwt(signal,'morse',sample_rate)
%
%
% %% Hilbert Huang
% %signal = size(sum(imf(:,4:7),2));
%
[imf,residual,info] = emd(signal,'Interpolation','pchip','Display',1,'SiftRelativeTolerance',0.2,'MaxNumIMF',100,'SiftMaxIterations',1000);
%
%imf = eemd(signal,100);
%
open_figure('IMF','newFig',false,'clearFig',true)
n = size(imf,2);
%n = 10;
axis = [];
for i = 1:n
    ax = subplot(n,1,i);
    hold on
    axis = [axis,ax];
    plot(t,imf(:,i))
    %plot(t,contact_series.*max(imf(:,i)))
    ylabel('m/{s^2}')
end
linkaxes(axis,'x')
xlabel('time [s]')


%% Compute inst freq of IMF
open_figure('Inst frwq imf');
inst_freqs = zeros(size(imf)-[1,0]);

for i = 1:n
    subplot(n,1,i)
    inst_freq = instfreq(imf(:,i),250,'Method','hilbert');
    
    %inst_freq = instfreq(imf(:,i),t);
    %     if inst_freq(1)<0
    %         inst_freq(1)=0;
    %     end
    %     if inst_freq(end) <0
    %         inst_freq(end) = 0;
    %     end
    
    for j = 2:length(inst_freq)-1
        if inst_freq(j) < 0
            inst_freq(j) = NaN;%(inst_freq(j-1)+inst_freq(j+1))/2;
            1;
        end
    end
    plot(t(2:end),inst_freq);
    %plot(inst_freq)
    grid on
    inst_freqs(:,i) = inst_freq;
    ylabel('f [Hz]')
end
xlabel('t [s]')

%% Compare IMF filter vs lowpass
mean_freq = nanmean(inst_freqs,1)
filter_imf_idxs = (mean_freq>0.1) .* (mean_freq<5);
filter_imf_idxs_h = (mean_freq>0.1) .* (mean_freq<8);
filter_imf_idxs_all =  (inst_freqs>0.1) .*  (inst_freqs<8);


signal_low = signal;
%signal_low = lowpass(signal_low,1.4,250,'Steepness',0.999);
signal_low = highpass(signal_low,20,250);
signal_imf = sum(imf(:,filter_imf_idxs==1),2);
signal_imf_h = sum(imf(:,filter_imf_idxs_h==1),2);
%signal_imf_h =  zeros(size(signal_imf));



open_figure('IMF vs LowPass','newFig',false);
hold on
grid on
%plot(t,signal);

plot(t,signal_low,'LineWidth',0.5)
plot(t,signal_imf)
%plot(t,signal_imf_h)
%plot(t,signal_imf)
%plot(t,imuData.colition_label(start_idx:end_idx).*max(signal_imf))
real_ylim = ylim;
for i=1:length(contact_points)
    plot([contact_points(i) contact_points(i)], ylim, 'k--','LineWidth',0.8)
end

% plot([945.5 945.5], ylim, 'k--','LineWidth',0.8)
% plot([950.5 950.5], ylim, 'k--','LineWidth',0.8)
% plot([952.5 952.5], ylim, 'k--','LineWidth',0.8)
% plot([959.0 959.0], ylim, 'k--','LineWidth',0.8)
xlabel('time[s]')
ylabel('acc [m/{s^2}]')
ylim(real_ylim)
legend('Lowpass','EMD','Contact points')
open_figure('IMF vs LowPass Zoom','newFig',false);
hold on
grid on
%plot(t,signal);

plot(t,signal_low,'LineWidth',0.5)
plot(t,signal_imf)
%plot(t,signal_imf_h)
%plot(t,signal_imf)
%plot(t,imuData.colition_label(start_idx:end_idx).*max(signal_imf))
real_ylim = ylim;

for i=1:length(contact_points)
    plot([contact_points(i) contact_points(i)], ylim, 'k--','LineWidth',0.8)
end

% plot([945.5 945.5], ylim, 'k--','LineWidth',0.8)
% plot([950.5 950.5], ylim, 'k--','LineWidth',0.8)
% plot([952.5 952.5], ylim, 'k--','LineWidth',0.8)
% plot([959.0 959.0], ylim, 'k--','LineWidth',0.8)
ylim(real_ylim)
legend('Lowpass','EMD','Contact points')
xlim([948,955])
xlabel('time[s]')
ylabel('acc [m/{s^2}]')
%%
wmin = 100
f_max = 8;
signal_stft = signal_imf;
open_figure('STFT imf');
%window_size = fix(length(signal)/100);
stft(signal_stft,sample_rate,'Window',kaiser(wmin,5),'OverlapLength',wmin-1,'FFTLength',wmin);
ylim([-f_max, f_max])

[s,f] = stft(signal_stft,sample_rate,'Window',kaiser(wmin,5),'OverlapLength',wmin-1,'FFTLength',wmin);
idx = find(f>0,1);
f(idx)
open_figure('STFT 1 HZ');

hold on
t_stft = t(floor(wmin/2):end-floor(wmin/2));
plot(t(floor(wmin/2):end-floor(wmin/2)),abs(s(idx,:)))
%plot(t,imuData.colition_label(start_idx:end_idx).*max(abs(s(idx,:))))

real_ylim = ylim;
for i=1:length(contact_points)
    plot([contact_points(i) contact_points(i)], ylim, 'k--','LineWidth',0.8)
end
%plot([950.5 950.5], ylim, 'k--','LineWidth',0.8)
%plot([952.5 952.5], ylim, 'k--','LineWidth',0.8)
%plot([959.0 959.0], ylim, 'k--','LineWidth',0.8)
ylim(real_ylim)
%%
% open_figure('HHT');
% %[hs,f,t] = hht(imf,sample_rate);
% mesh(seconds(t),f,hs,'EdgeColor','none','FaceColor','interp')
% ylim([0,10])
% xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% zlabel('Instantaneous Energy')
