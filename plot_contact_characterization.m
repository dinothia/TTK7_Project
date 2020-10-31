clf;clear;close all;clc
load('Data/vanvikan/imu_measurements_1_2')

start_idx = length(imuData.acceleration(1,:))-250*60;
end_idx = length(imuData.acceleration(1,:))-250*0;

signal_y = imuData.acceleration(2,:);

t = imuData.t_imu;
t = t - imuData.t_imu(1);

%% Plot signals
clf;
fig = figure(1);

subplot(121);
t0=942.5*250; te=948*250;
plot(t(t0:te), signal_y(t0:te)); 
grid on;
xlim([t(t0),t(te)]);
ylim([-0.6,0.6]);
ylabel("acc [m/s^2]");
xlabel("time [s]");
legend("contact 1", 'Location','southwest');

subplot(122);
t0=948*250; te=953.5*250;
plot(t(t0:te), signal_y(t0:te)); 
grid on;
xlim([t(t0),t(te)]);
ylim([-0.6,0.6]);
ylabel("acc [m/s^2]");
xlabel("time [s]");
legend("contact 2", 'Location','southwest');



saveas(fig,'Img/contact_pulse','epsc')