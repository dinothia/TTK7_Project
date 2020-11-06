%% Load raw data
load('Data/vanvikan/imu_measurements_1_2')

start_idx = length(imuData.acceleration(1,:))-250*35.7443;
end_idx = length(imuData.acceleration(1,:))-250*0;


signal_x = imuData.acceleration(1,start_idx:end_idx);
signal_y = imuData.acceleration(2,start_idx:end_idx);
signal_z = imuData.acceleration(3,start_idx:end_idx)-9.81;

%% Transform IMU to body frame
signal_x = imuData.acceleration(2,start_idx:end_idx);
signal_y = imuData.acceleration(1,start_idx:end_idx);
signal_z = -(imuData.acceleration(3,start_idx:end_idx)-9.81);

%% Load collision data
collisions = 0*imuData.colition_label;
collisions(950.5*250) = 1;
collisions(952.5*250) = 1;
collisions = -3+5*collisions(start_idx:end_idx);

%% Set time vector
t = imuData.t_imu(start_idx:end_idx);
t = t - t(1);


%% Plot signals
clf;
fig = figure(1);

subplot(311);
plot(t,collisions, '--k'); hold on;
plot(t, signal_x, 'color', 'r');
grid on;
xlim([t(1),t(end)]);
ylim([-2,2]);
ylabel("acc [m/s^2]");
xlabel("time [s]");
legend("x-axis", "contacts along y-axis", 'Location','northwest');

subplot(312);
plot(t,collisions, '--k'); hold on;
plot(t, signal_y, 'color', '#458b00'); 
grid on;
ylim([-2,2]);
xlim([t(1),t(end)]);
ylabel("acc [m/s^2]");
xlabel("time [s]");
legend("y-axis", "contacts along y-axis", 'Location','northwest');

subplot(313);
plot(t,collisions, '--k'); hold on;
plot(t, signal_z, 'color', 'b');
grid on;
ylim([-2,2]);
xlim([t(1),t(end)]);
ylabel("acc [m/s^2]");
xlabel("time [s]");
legend("z-axis", "contacts along y-axis", 'Location','northwest');


saveas(fig,'Img/xyz_raw','epsc')

%currentFigure = gcf;xlabel("bins");
%title(currentFigure.Children(end), "IMU linear acceleration");