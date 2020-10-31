load('Data/vanvikan/imu_measurements_1_2')

start_idx = length(imuData.acceleration(1,:))-250*60;
end_idx = length(imuData.acceleration(1,:))-250*0;


signal_x = imuData.acceleration(1,start_idx:end_idx);
signal_y = imuData.acceleration(2,start_idx:end_idx);
signal_z = imuData.acceleration(3,start_idx:end_idx)-9.81;

collisions = -3+5*imuData.colition_label(start_idx:end_idx);

t = imuData.t_imu(start_idx:end_idx);
t = t - imuData.t_imu(1);


%% Plot signals
clf;
fig = figure(1);

subplot(311);
plot(t, signal_x); hold on;
plot(t,collisions, 'color', 'k')
grid on;
xlim([t(1),t(end)]);
ylim([-2,2]);
ylabel("acc [m/s^2]");
xlabel("time [s]");
legend("x-axis", "contacts", 'Location','northwest');

subplot(312);
plot(t, signal_y); hold on;
plot(t,collisions, 'color', 'k')
grid on;
ylim([-2,2]);
xlim([t(1),t(end)]);
ylabel("acc [m/s^2]");
xlabel("time [s]");
legend("y-axis", "contacts", 'Location','northwest');

subplot(313);
plot(t, signal_z); hold on;
plot(t,collisions, 'color', 'k')
grid on;
ylim([-2,2]);
xlim([t(1),t(end)]);
ylabel("acc [m/s^2]");
xlabel("time [s]");
legend("z-axis", "contacts", 'Location','northwest');


saveas(fig,'xyz_raw','epsc')

%currentFigure = gcf;xlabel("bins");
%title(currentFigure.Children(end), "IMU linear acceleration");