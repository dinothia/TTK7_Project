clc; clear; close all;

offset = false;
noise = true;
%% Generate signal
N = 3000;
fs = 1000;  % Hz
dt = 1 / fs;
t = [0:dt:N*dt];

f1 = 4;  % Hz
signal1 = sin(2*pi*f1*t);

f2 = 12;  % Hz
signal2 = sin(2*pi*f2*t);

f3 = 18;  % Hz1621
signal3 = sin(2*pi*f3*t);
signal3_trunc = zeros(size(signal3));
signal3_trunc(1001:2000) = signal3(1001:2000);

% Final composed signal
signal4 = signal1 + signal2 + signal3_trunc;

%% Plot signals
fig = figure(1);

subplot(411);
plot(signal1);
grid on;
xlim([0,N]);
ylabel("signal1");
xlabel("sample nr");

subplot(412);
plot(signal2);
grid on;
xlim([0,N]);
ylabel("signal2");
xlabel("sample nr");

subplot(413);
plot(signal3_trunc);
grid on;
xlim([0,N]);
ylabel("signal3");
xlabel("sample nr");

subplot(414);
plot(signal4);
grid on;
xlim([0,N]);
ylabel("signal4");
xlabel("sample nr");

currentFigure = gcf;xlabel("bins");
title(currentFigure.Children(end), "Signal components and final function (4, 12, and 18 Hz - 18 Int)");

%% Analysis goal: 
% to obtain a clear estimation of each components by working only with the final signal
signal = signal4
if offset == true
    signal = signal + 2;
end
if noise == true
    signal = signal + 0.25 * randn(1,N+1);
end
%% Analyse the final signal: stationary or non-stationary

% Stationarity is a property of a stochastic process. 
% A perfect sine wave is not a stochastic process. 
% Hence, it can't be stationary or non-stationary.

% Look at Plots: plot a run sequence plot to see anything with an obvious 
% trend or seasonal effects
figure(2);
subplot(411);
plot(signal);
xlim([0,N]);
title("Final signal");
xlabel("sample nr");

bins = 50

subplot(412);
hist(signal, bins);
title("Histogram: bins="+string(bins));

display("No trend, mean: " + string(mean(signal)));

% Summary Statistics: partition your data into intervals and check for 
% obvious or significant differences in summary statistics
winsize = floor(N/bins);
for i=1:bins-1
    i1 = i*winsize;
    i2 = (i+1)*winsize;
    m(i) = mean(signal(i1:i2));
    v(i) = var(signal(i1:i2));
end

subplot(413);
plot(m);
title("Windowed mean");
xlabel("bins");
xlim([0,bins]);

subplot(414);
plot(v);
title("Windowed variance");
xlabel("bins");
xlim([0,bins]);

figure(20);
plot(xcorr(signal,signal));
title("Autocorrelation");

%% Run a FFT analysis to get an idea of the frequency components. 
% Reflect on the results of this analysis
figure(3);
Y = fft(signal);

P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(0:(N/2))/N;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
f_max = 30;
xlim([0,f_max])
set(gca,'Xtick',0:2:f_max)

%% How to decide the window size if STFT or WT is going to be used?
% Window size should atleast be capturing the lowest freq. component

figure(4);
subplot(211);
wmin = fs / f1;
stft(signal,fs,'Window',kaiser(wmin,5),'OverlapLength',wmin-1,'FFTLength',wmin);
ylim([0,f_max]);
set(gca,'Ytick',0:4:f_max)

subplot(212);
wmin = 4 * fs / f1;
stft(signal,fs,'Window',kaiser(wmin,5),'OverlapLength',wmin-1,'FFTLength',wmin);
ylim([0,f_max]);
set(gca,'Ytick',0:4:f_max)

%%
figure(5);
cwt(signal,'bump',fs)

%%
%figure(6);
wvd(signal,fs);
ylim([0,30]);

%%
figure(7);
z = hilbert(signal);
instfrq = fs/(2*pi)*diff(unwrap(angle(z)));

plot(t(2:end),instfrq)
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title("Instanteneous frequency");

% Instanteneous frequency
instfreq(signal,fs)

%% Which signal processing technique is best for your signal (FFT, STFT, WVT, WT, HT)? 
% CWT gives best result

%% Add an offset and repeat the analysis

%% Add white noise and repeat the analysis

%% Add a linearly time varying frequency component (frequency=kt)

%% Add an offset and white noise and repeat the analysis

%% Synthetic Signal Analysis with EMD and HT (HHT)
figure(11);
sift_num = 100; % 10
subplot(211);
imf = emd(signal,'Display',1, 'Interpolation','spline', 'SiftMaxIterations',sift_num);
hht(imf,fs,'FrequencyLimits',[0 f_max])

subplot(212);
imf = emd(signal,'Display',1, 'Interpolation','pchip', 'SiftMaxIterations',sift_num);
hht(imf,fs,'FrequencyLimits',[0 f_max])

emd(signal,'Display',1, 'Interpolation','spline', 'SiftMaxIterations',sift_num)
emd(signal,'Display',1, 'Interpolation','pchip', 'SiftMaxIterations',sift_num);


% 12 Hz and 18 Hz are too similar, disadvantageuous hht method. 
% Ratio of 1.35 or around that

% Or: harmonicl signals

%%





