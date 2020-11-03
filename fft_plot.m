load('Data/vanvikan/imu_measurements_1_2')

end_idx1 = length(imuData.acceleration(1,:))-250*0;
start_idx1 = length(imuData.acceleration(1,:))-250*30;

% 
end_idx = length(imuData.acceleration(1,:))-250*30;
start_idx = length(imuData.acceleration(1,:))-250*60;


assert(start_idx<end_idx);

signal_y = imuData.acceleration(1,start_idx:end_idx);
signal_y1 = imuData.acceleration(1,start_idx1:end_idx1);

signal = signal_y;
signal1 = signal_y1;
t = imuData.t_imu(start_idx:end_idx);
t = t- imuData.t_imu(1);

t1 = imuData.t_imu(start_idx1:end_idx1);

t1 = t1- imuData.t_imu(1);

t1 = t1 - t(1);
t =  t - t(1);

sample_rate = mean(1./diff(t));

fig1=figure(1);clf
subplot(3,1,1)
hold on
plot(t,signal)
plot(t1,signal1)
ylim([-1,1]);
xlim([t(1),t1(end)]);
xlabel('time [s]')
ylabel("acc [m/s^2]");
legend('First 30 sec w. no contact','Last 30 sec w. contacts', 'Location','southwest');
xlabel("time [s]");
grid on;


%% FFT
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
subplot(3,1,2)
hold on
plot(f,P1) 
plot(f1,P11) 
ylim([0,0.1])
xlim([0 125]);
xlabel('frequenzy [Hz]')
ylabel('Amplitude')
legend('First 30 sec w. no contact','Last 30 sec w. contacts')
grid on;


subplot(3,1,3)
hold on
plot(f,P1) 
plot(f1,P11) 
xlim([0,5])
ylim([0,0.1])
legend('First 30 sec w. no contact','Last 30 sec w. contacts')

%title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('frequenzy [Hz]')
ylabel('Amplitude')
grid on;

saveas(fig1,'Img/y_fft_split','epsc')

