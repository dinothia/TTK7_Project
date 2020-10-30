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
ang_x = imuData.ang_velocity(1,start_idx:end_idx);
ang_y = imuData.ang_velocity(2,start_idx:end_idx);
ang_z = imuData.ang_velocity(3,start_idx:end_idx);


%signal = signal_y;
signal = -signal_x;
%signal = -lowpass(signal_y,5,250);
t = imuData.t_imu(start_idx:end_idx);
t = t- imuData.t_imu(1);
sample_rate = mean(1./diff(t));

%signal = sum(imf(:,4:7),2);

%signal = lowpass(signal,10,250);
%open_figure('IMU Data','clearFig',false)
figure(1)
hold on
plot(t,signal)

    
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
[imf,residual,info] = emd(signal,'Interpolation','pchip','Display',1,'SiftRelativeTolerance',0.3,'MaxNumIMF',1000,'SiftMaxIterations',1000);
%
%imf = eemd(signal,100);
%%
open_figure('IMF','newFig',true,'clearFig',true)
n = size(imf,2);
%n = 10;
axis = [];
for i = 1:n
    ax = subplot(n,1,i);
    hold on
    axis = [axis,ax];
    plot(t,imf(:,i))
end
linkaxes(axis,'x')


%% Compute inst freq of IMF
open_figure('Inst frwq imf')
inst_freqs = zeros(size(imf)-[1,0]);

for i = 1:n
    subplot(n,1,i)
    inst_freq = instfreq(imf(:,i),250,'Method','hilbert');
    plot(t(2:end),inst_freq);
    grid on
    inst_freqs(:,i) = inst_freq;
end


%% Compare IMF filter vs lowpass
filter_imf_idxs = (mean(inst_freqs,1)>0.1) .* (mean(inst_freqs,1)<8)
%filter_imf_idxs_h = (mean(inst_freqs,1)>0.1) .* (mean(inst_freqs,1)<8)


signal_low = lowpass(signal,1,250);
signal_low = highpass(signal_low,0.4,250);
signal_imf = sum(imf(:,filter_imf_idxs==1),2);
%signal_imf_h = sum(imf(:,filter_imf_idxs_h==1),2);

%

open_figure('IMF vs LowPass','newFig',true)
hold on
grid on
%plot(t,signal);

plot(t,signal_low,'LineWidth',0.5)
%plot(t,signal_imf)
plot(t,signal_imf)
%plot(t,signal_imf)
plot(t,imuData.colition_label(start_idx:end_idx).*max(signal_imf))

legend('Lowpass','imf','gt')
%xlim([940,965])
%xlim([949,952])
%%
wmin = 100
f_max = 8;
signal_stft = signal_imf;
open_figure('STFT imf');
%window_size = fix(length(signal)/100);
stft(signal_stft,sample_rate,'Window',kaiser(wmin,5),'OverlapLength',wmin-1,'FFTLength',wmin); 
ylim([-f_max, f_max])

[s,f] = stft(signal_stft,sample_rate,'Window',kaiser(wmin,5),'OverlapLength',wmin-1,'FFTLength',wmin);
idx = find(f>3,1);
f(idx)
open_figure('STFT 1 HZ');

hold on
t_stft = t(floor(wmin/2):end-floor(wmin/2));
plot(t(floor(wmin/2):end-floor(wmin/2)),abs(s(idx,:)))
plot(t,imuData.colition_label(start_idx:end_idx).*max(abs(s(idx,:))))


%%
% open_figure('HHT');
% %[hs,f,t] = hht(imf,sample_rate);
% mesh(seconds(t),f,hs,'EdgeColor','none','FaceColor','interp')
% ylim([0,10])
% xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% zlabel('Instantaneous Energy')
