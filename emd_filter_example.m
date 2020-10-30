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
t = imuData.t_imu(start_idx:end_idx);
t = t- imuData.t_imu(1);
sample_rate = mean(1./diff(t));


%% Compute IMFS
[imf,residual,info] = emd(signal,'Interpolation','pchip','Display',1);
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


%% Compute InstFreqs
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
imf_upper_freq = 8;
imf_lower_freq = 0.1;
mean_freqs = mean(inst_freqs,1);
filter_imf_idxs = (mean_freqs>0.1) .* (mean_freqs<imf_upper_freq);


signal_low = lowpass(signal,1,250);
signal_low = highpass(signal_low,0.4,250);
signal_imf = sum(imf(:,filter_imf_idxs==1),2);


open_figure('IMF vs LowPass','newFig',true)
hold on
grid on
%plot(t,signal);

plot(t,signal_low,'LineWidth',0.5)
plot(t,signal_imf)
plot(t,imuData.colition_label(start_idx:end_idx).*max(signal_imf))

legend('Lowpass','imf','gt')

