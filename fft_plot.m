load('Data/vanvikan/imu_measurements_1_2')

end_idx1 = length(imuData.acceleration(1,:))-250*0;
start_idx1 = length(imuData.acceleration(1,:))-250*30;

% 
end_idx = length(imuData.acceleration(1,:))-250*30;
start_idx = length(imuData.acceleration(1,:))-250*60;


assert(start_idx<end_idx);

signal_y = imuData.acceleration(2,start_idx:end_idx);
signal_y1 = imuData.acceleration(2,start_idx1:end_idx1);

signal = signal_y;
signal1 = signal_y1;
t = imuData.t_imu(start_idx:end_idx);
t = t- imuData.t_imu(1);

t1 = imuData.t_imu(start_idx1:end_idx1);

t1 = t1- imuData.t_imu(1);
sample_rate = mean(1./diff(t));
%signal = lowpass(signal,10,250);
%open_figure('IMU Data','clearFig',false)
figure(1);clf
hold on
plot(t,signal)
plot(t1,signal1)
xlabel('time [s]')
ylabel('acceleration [m/s^2]')
    


L = length(t);
Y = fft(signal);

P2 = abs(Y/L);
P1 = P2(1:floor(L/2+1));
P1(2:end-1) = 2*P1(2:end-1);
f = sample_rate*(0:(L/2))/L;


L = length(t1);
Y = fft(signal1);

P2 = abs(Y/L);
P11 = P2(1:floor(L/2+1));
P11(2:end-1) = 2*P11(2:end-1);
f1 = sample_rate*(0:(L/2))/L;



end_freq = 40;
end_freq_idx = ceil(end_freq/diff(f(1:2)));

%open_figure('FFT result','newFig',1)
figure(2);clf
subplot(2,1,1)
hold on
plot(f,P1) 
plot(f1,P11) 
ylim([0,0.1])
xlabel('frequenzy [Hz]')
ylabel('Amplitude')
legend('First 30 sec','Last 30 sec')

subplot(2,1,2)
hold on
plot(f,P1) 
plot(f1,P11) 
xlim([0,5])
ylim([0,0.1])
legend('First 30 sec','Last 30 sec')

%title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('frequenzy [Hz]')
ylabel('Amplitude')
