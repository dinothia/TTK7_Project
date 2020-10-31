load('Data/vanvikan/imu_measurements_1_2')

start_idx = 2e4;
signal_x = imuData.acceleration(1,start_idx:end);
signal_y = imuData.acceleration(2,start_idx:end);
signal = signal_x;%sqrt(signal_x.^2 + signal_y.^2);
t = imuData.t_imu(start_idx:end);
t = t-t(1);
sample_rate = mean(1./diff(t));
%signal = lowpass(signal,10,250);
open_figure('IMU Data')
plot(t,signal)

    


L = length(t);
Y = fft(signal);

P2 = abs(Y/L);
P1 = P2(1:floor(L/2+1));
P1(2:end-1) = 2*P1(2:end-1);
f = sample_rate*(0:(L/2))/L;

end_freq = 40;
end_freq_idx = ceil(end_freq/diff(f(1:2)));

open_figure('FFT result','new_fig',1)

plot(f,P1) 

title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('frequenzy [Hz]')
ylabel('|P1(f)|')

%% STFT
open_figure('STFT','clearFig',true);

%Same window size as the stationarity of signal 3 of the signal
window_size = 1*sample_rate;
window_size = fix(length(signal)/100);en til lengste kollisjon og vurdere vindu
spectrogram(signal,window_size,floor(window_size*0.5),800,sample_rate)
%xlim([0,50])

%% Wigner-Ville Transform
%open_figure('WVT','clearFig',true);
%wvd(signal,sample_rate)


%% Wavelet Transform
open_figure('Wavelet','clearFig',true)
cwt(signal,'bump',sample_rate)


%% Hilbert Huang


[imf,residual,info] = emd(signal,'Interpolation','spline');
open_figure('IMF')
n = size(imf,2);
axis = [];
for i = 1:n
    ax = subplot(n,1,i);
    axis = [axis,ax];
    plot(t,imf(:,i))
end
linkaxes(axis,'x')
open_figure('HHT');
hht(imf(:,1:end),sample_rate)

