clc;
clear;
close all;

fc  = 10e6;        
flo = 9.5e6;       
fif = 500e3;       
fs  = 100e6;       
T   = 0.01;        
t = 0:1/fs:T-1/fs;

fm = 1e3;  
m = cos(2*pi*fm*t);
A = zeros(size(t));
A(t < 0.005) = 0.1;
A(t >= 0.005 & t < 0.008) = 1;
A(t >= 0.008) = 2;
x_rf = A .* (1 + m) .* cos(2*pi*fc*t);

SNR_dB = 20;
x_rf_noisy = awgn(x_rf, SNR_dB, 'measured');

lo = cos(2*pi*flo*t);
x_mixed = x_rf_noisy .* lo;
bpFilt = designfilt('bandpassfir', 'FilterOrder', 100, 'CutoffFrequency1', fif-100e3, 'CutoffFrequency2', fif+100e3, 'SampleRate', fs);
x_if = filter(bpFilt, x_mixed);

gain = 10;
x_amp = gain * x_if;

env = abs(hilbert(x_amp));

figure('Name', 'Base Receiver', 'Color', 'w');
subplot(3,1,1); plot(t, x_rf_noisy, 'r'); title('Input RF Signal (with AWGN)'); xlabel('Time (s)'); ylabel('Amplitude (V)'); grid on;
subplot(3,1,2); plot(t, x_if, 'r'); title('IF Signal after Mixing and Bandpass Filtering'); xlabel('Time (s)'); ylabel('Amplitude (V)'); grid on;
subplot(3,1,3); plot(t, env, 'r'); title('Output Signal after Fixed Gain (Envelope Detected)'); xlabel('Time (s)'); ylabel('Amplitude (V)'); grid on;
sgtitle('Figure 1: Base Superheterodyne Receiver Simulation (No AGC)', 'FontSize', 14);
set(findobj(gcf,'type','axes'), 'FontSize', 12, 'Color', 'w');
print(gcf, 'Figure1_BaseReceiver.png', '-dpng', '-r300');

env_if = abs(hilbert(x_if));
target_amp = 1;
target_power = target_amp^2;
K = 0.5;
tau = 0.01;
alpha = exp(-1/(fs*tau));
window_size = round(0.0001 * fs);
gain_agc = zeros(size(t));
gain_agc(1) = 10;
power_est = zeros(size(t));
smoothed_gain = gain_agc(1);
output_agc = zeros(size(t));

for n = window_size:length(t)
    output_agc(n) = smoothed_gain * env_if(n);
    window = output_agc(n-window_size+1:n);
    power_est(n) = mean(window.^2);
    error = target_power - power_est(n);
    gain_update = smoothed_gain + K * error;
    gain_update = min(max(gain_update,1),1000);
    smoothed_gain = alpha * smoothed_gain + (1-alpha) * gain_update;
    gain_agc(n) = smoothed_gain;
end

upper = 1.05 * target_amp;
lower = 0.95 * target_amp;
settling_index = find(output_agc > lower & output_agc < upper, 1, 'first');
if isempty(settling_index)
    settling_time = NaN;
else
    settling_time = t(settling_index);
end

figure('Name', 'Conventional AGC', 'Color', 'w');
subplot(4,1,1); plot(t, A, 'k', 'LineWidth', 1.5); title('Input Signal Amplitude'); grid on;
subplot(4,1,2); plot(t, gain_agc, 'b'); title('AGC Gain vs Time'); grid on;
subplot(4,1,3); plot(t, output_agc, 'b'); yline(target_amp,'r--'); title('Output Signal'); grid on;
subplot(4,1,4); plot(t, output_agc, 'b'); yline(upper,'g--'); yline(lower,'g--'); 
if ~isnan(settling_time), xline(settling_time,'r', 'LineWidth', 1.5); end
title('Settling Detail'); grid on;
sgtitle('Figure 2: Conventional AGC Performance', 'FontSize', 14);
set(findobj(gcf,'type','axes'), 'FontSize', 12, 'Color', 'w');
print(gcf, 'Figure2_ConventionalAGC.png', '-dpng', '-r300');

fd = 50; 
fs_fade = 5000; 
t_fade = 0:1/fs_fade:T;

I_fade = randn(size(t_fade));
Q_fade = randn(size(t_fade));
[b, a] = butter(3, fd/(fs_fade/2));
I_filt = filter(b, a, I_fade);
Q_filt = filter(b, a, Q_fade);

h_low = I_filt + 1j*Q_filt;
h_low = h_low / std(h_low);
fading_gain_low = abs(h_low);

fading_gain = interp1(t_fade, fading_gain_low, t, 'spline');

x_faded = x_rf .* fading_gain;
x_channel = awgn(x_faded, 10, 'measured');
x_mixed_ch = x_channel .* lo;
x_if_ch = filter(bpFilt, x_mixed_ch);

env_no_agc = abs(hilbert(10 * x_if_ch));
env_if_ch = abs(hilbert(x_if_ch));

gain_agc_ch = zeros(size(t));
gain_agc_ch(1) = 10;
smoothed_gain = gain_agc_ch(1);
output_agc_ch = zeros(size(t));

for n = window_size:length(t)
    output_agc_ch(n) = smoothed_gain * env_if_ch(n);
    window = output_agc_ch(n-window_size+1:n);
    power = mean(window.^2);
    error = target_power - power;
    gain_update = smoothed_gain + K * error;
    gain_update = min(max(gain_update,1),1000);
    smoothed_gain = alpha * smoothed_gain + (1-alpha)*gain_update;
    gain_agc_ch(n) = smoothed_gain;
end

figure('Name', 'Channel Model', 'Color', 'w');
subplot(4,1,1); plot(t, fading_gain, 'k', 'LineWidth', 1.5); title('Rayleigh Fading Gain |h(t)| (Interpolated)'); grid on;
subplot(4,1,2); plot(t(1:100:end), 10*log10((x_channel(1:100:end).^2)/1e-3 + eps), 'k'); title('Received Signal Power (dBm)'); grid on;
subplot(4,1,3); plot(t, env_no_agc, 'r'); title('Output WITHOUT AGC'); grid on;
subplot(4,1,4); plot(t, output_agc_ch, 'b'); title('Output WITH Conventional AGC'); grid on;
sgtitle('Figure 3: Realistic Channel Test (AWGN + Rayleigh)', 'FontSize', 14);
set(findobj(gcf,'type','axes'), 'FontSize', 12, 'Color', 'w');
print(gcf, 'Figure3_ChannelModel.png', '-dpng', '-r300');

Kp = 1.0; 
Ki = 0.3; 
tau_attack = 0.005; 
tau_decay = 0.05;
max_dB_step = 5; 
max_linear_step = 10^(max_dB_step/20);

gain_opt = zeros(size(t)); 
gain_opt(1) = 10;
smoothed_gain_opt = gain_opt(1); 
output_opt = zeros(size(t));
integral_error = 0; 
prev_error = 0;

for n = window_size:length(t)
    output_opt(n) = smoothed_gain_opt * env_if_ch(n);
    window = output_opt(n-window_size+1:n);
    power = mean(window.^2);
    error = target_power - power;
    
    if sign(error) ~= sign(prev_error)
        integral_error = 0; 
    end
    integral_error = integral_error + error;
    
    control_signal = Kp*error + Ki*integral_error;
    gain_update = smoothed_gain_opt + control_signal;
    
    if error < 0
        tau_current = tau_attack;
    else
        tau_current = tau_decay;
    end
    
    alpha_adapt = exp(-1/(fs*tau_current));
    
    ratio = gain_update / smoothed_gain_opt;
    ratio = min(max(ratio, 1/max_linear_step), max_linear_step);
    gain_update = smoothed_gain_opt * ratio;
    
    gain_update = min(max(gain_update, 1), 1000);
    smoothed_gain_opt = alpha_adapt*smoothed_gain_opt + (1-alpha_adapt)*gain_update;
    gain_opt(n) = smoothed_gain_opt;
    prev_error = error;
end

ref_env = abs(hilbert(x_faded));
snr_no_agc = 10*log10((ref_env.^2)./((env_no_agc-ref_env).^2+1e-12));
snr_conv   = 10*log10((ref_env.^2)./((output_agc_ch-ref_env).^2+1e-12));
snr_opt    = 10*log10((ref_env.^2)./((output_opt-ref_env).^2+1e-12));

figure('Name', 'Optimized AGC', 'Color', 'w');
subplot(3,1,1); plot(t, gain_agc_ch, 'b'); hold on; plot(t, gain_opt, 'g'); title('Gain Comparison'); legend('Conv','Opt', 'Location', 'best'); grid on;
subplot(3,1,2); plot(t, env_no_agc, 'r'); hold on; plot(t, output_agc_ch, 'b'); plot(t, output_opt, 'g'); title('Output Comparison'); legend('No AGC', 'Conv', 'Opt', 'Location', 'best'); grid on;
subplot(3,1,3); plot(t, snr_no_agc, 'r'); hold on; plot(t, snr_conv, 'b'); plot(t, snr_opt, 'g'); title('Instantaneous SNR (dB)'); legend('No AGC', 'Conv', 'Opt', 'Location', 'best'); grid on;
sgtitle('Figure 4: Optimized PI-based AGC Performance', 'FontSize', 14);
set(findobj(gcf,'type','axes'), 'FontSize', 12, 'Color', 'w');
print(gcf, 'Figure4_OptimizedAGC.png', '-dpng', '-r300');

metrics_no   = calculate_metrics(env_no_agc, target_amp, t, ref_env);
metrics_conv = calculate_metrics(output_agc_ch, target_amp, t, ref_env);
metrics_opt  = calculate_metrics(output_opt, target_amp, t, ref_env);

metric_names = {'Settling Time', 'Std Dev', 'P2P', 'MSE', 'SNR Improve', 'Overshoot', 'SS Error'};
fprintf('\n=========================================================\n');
fprintf('         PERFORMANCE METRICS COMPARISON\n');
fprintf('=========================================================\n');
fprintf('Metric                  No AGC    Conv. AGC   Opt. AGC\n');
fprintf('---------------------------------------------------------\n');
for i = 1:length(metric_names)
    fprintf('%-22s %8.3f   %8.3f   %8.3f\n', ...
        metric_names{i}, metrics_no(i), metrics_conv(i), metrics_opt(i));
end
fprintf('=========================================================\n');

ResultsTable = table(metric_names', metrics_no', metrics_conv', metrics_opt', ...
    'VariableNames', {'Metric', 'No_AGC', 'Conv_AGC', 'Opt_AGC'});
writetable(ResultsTable, 'AGC_Results.csv');

raw_data = [metrics_no; metrics_conv; metrics_opt]';
plot_data = abs(raw_data) + 1e-6; 

figure('Name', 'Metric Comparison', 'Units', 'pixels', 'Position', [100, 100, 1000, 600], 'Color', 'w');
tlo = tiledlayout(1,1,'Padding','loose');
nexttile;

b = bar(plot_data);
b(1).FaceColor = 'r'; 
b(2).FaceColor = 'b'; 
b(3).FaceColor = 'g'; 

set(gca, 'YScale', 'log', 'Color', 'w');
grid on;
set(gca, 'XTickLabel', metric_names, 'FontSize', 12);
ylabel('Absolute Value (Log Scale)');
legend('No AGC', 'Conventional', 'Optimized', 'Location', 'northeastoutside');

title(tlo, 'Figure 5: Performance Metrics Comparison (Log Scale)', 'FontSize', 16, 'FontWeight', 'bold');
subtitle(tlo, 'Log scale allows visualization of both large (MSE) and small (Time) values simultaneously', 'FontSize', 11);

print(gcf, 'Figure5_MetricsComparison.png', '-dpng', '-r300');

fprintf('\n=============================================\n');
fprintf('SIMULATION COMPLETE\n');
fprintf('Figures saved: Figure1 to Figure5 (.png)\n');
fprintf('Data saved: AGC_Results.csv\n');
fprintf('=============================================\n');

function metrics = calculate_metrics(signal, target_amp, t, ref_env)
    target_power = target_amp^2;
    steady_start = round(0.7 * length(signal));
    steady_signal = signal(steady_start:end);
    
    upper = 1.05 * target_amp; 
    lower = 0.95 * target_amp;
    idx = find(signal > lower & signal < upper, 1, 'first');
    if isempty(idx)
        settling_time = NaN;
    else
        settling_time = t(idx);
    end
    
    std_dev = std(steady_signal);
    p2p = max(steady_signal) - min(steady_signal);
    mse = mean((signal.^2 - target_power).^2);
    snr_out = mean(10*log10((ref_env.^2)./((signal - ref_env).^2 + 1e-12)));
    overshoot = max(0, ((max(signal) - target_amp) / target_amp) * 100);
    steady_error = mean(steady_signal) - target_amp;
    
    metrics = [settling_time, std_dev, p2p, mse, snr_out, overshoot, steady_error];
end