close all; clear all; clc; 

load("Data/vanvikan/imu_measurements_1_2.mat");

fs = 250; 

run_resample = false;
resample_rate = 0.4;

signalx_raw = imuData.acceleration(1,:);
signaly_raw = imuData.acceleration(2,:);
signalz_raw = imuData.acceleration(3,:) - 9.81;

%% Resample signal

if run_resample == true
    signalx = resample(signalx_raw,resample_rate*fs,fs);
    signaly = resample(signaly_raw,resample_rate*fs,fs);
    signalz = resample(signalz_raw,resample_rate*fs,fs);
    fs = fs*resample_rate; 
else
    signalx = signalx_raw;
    signaly = signaly_raw;
    signalz = signalz_raw;
end

dt = 1 / fs;

N = length(signalx);
t = 0:dt:(N-1)*dt;
%%
start_idx_n_minutes = 1;
duration_idx_n_minutes = 1;
start_idx = start_idx_n_minutes * fs * 60;
duration_idx = duration_idx_n_minutes * fs * 60;
signal_interval = [N-start_idx:N-start_idx+duration_idx];

%% Trunc signals

signalx_trunc = signalx(signal_interval);
signaly_trunc = signaly(signal_interval);
signalz_trunc = signalz(signal_interval);
t_trunc = t(signal_interval);

interval_in_s = [(N-start_idx)/fs,(N-start_idx+duration_idx)/fs];

%% Plot raw signal

figure(1);
clf;
subplot(311); 
plot_nice(t_trunc, signalx_trunc, interval_in_s, [-1,1], "time [s]","x-acc");
subplot(312);
plot_nice(t_trunc, signaly_trunc, interval_in_s, [-1,1], "time [s]","y-acc");
subplot(313);
plot_nice(t_trunc, signalz_trunc, interval_in_s, [-2,2], "time [s]","z-acc");

currentFigure = gcf;
title(currentFigure.Children(end), "Raw");

%% Plot FFT
figure(2);
plot_fft(signalx_trunc, fs)

%%
cutoff_f = 5;

signal_lp_x = lowpass(signalx_trunc, cutoff_f, fs);
signal_lp_y = lowpass(signaly_trunc, cutoff_f, fs);
signal_lp_z = lowpass(signalz_trunc, cutoff_f, fs);

%%
clf;
subplot(311); 
plot_nice(t_trunc, signalx_trunc, interval_in_s, [-1,1], "time [s]","x-acc"); hold on;
plot_nice(t_trunc, signal_lp_x, interval_in_s, [-1,1], "time [s]","x-acc");
subplot(312);
plot_nice(t_trunc, signaly_trunc, interval_in_s, [-1,1], "time [s]","y-acc"); hold on;
plot_nice(t_trunc, signal_lp_y, interval_in_s, [-1,1], "time [s]","y-acc");
subplot(313);
plot_nice(t_trunc, signalz_trunc, interval_in_s, [-2,2], "time [s]","z-acc"); hold on;
plot_nice(t_trunc, signal_lp_z, interval_in_s, [-2,2], "time [s]","z-acc");

currentFigure = gcf;
title(currentFigure.Children(end), "Lowpass filtered");