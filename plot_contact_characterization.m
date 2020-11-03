clf;clear;close all;clc

%% Load raw data
load('Data/vanvikan/imu_measurements_1_2')

start_idx = length(imuData.acceleration(1,:))-250*60;
end_idx = length(imuData.acceleration(1,:))-250*0;

%% Transform IMU to body frame
signal_y = imuData.acceleration(1,:);

%% Load collision data
collisions = 0*imuData.colition_label;
collisions(950.5*250) = 1;
collisions(952.5*250) = 1;
collisions = -3+5*collisions;

%% Set time vector
t = imuData.t_imu;
t = t - t(1)-start_idx/250;

%% Plot signals
clf;
fig = figure(1);

subplot(121);
t0=(950.5-1.5)*250; te=(950.5+1.5)*250;
plot(t(t0:te), signal_y(t0:te)); 
grid on;
xlim([t(t0),t(te)]);
ylim([-0.5,1.5]);
ylabel("acc [m/s^2]");
xlabel("time [s]");
legend("contact 1", 'Location','southwest');

subplot(122);
t0=(952.5-1.5)*250; te=(952.5+1.5)*250;
plot(t(t0:te), signal_y(t0:te)); 
grid on;
xlim([t(t0),t(te)]);
ylim([-0.5,1.5]);
ylabel("acc [m/s^2]");
xlabel("time [s]");
legend("contact 2", 'Location','southwest');



saveas(fig,'Img/contact_pulse','epsc')