clc;
clear;
close all;

N = 50;
SNR_dB = 0:2:20;
num_iter = 500;

snr_noRIS = zeros(size(SNR_dB));
snr_randRIS = zeros(size(SNR_dB));
snr_optRIS = zeros(size(SNR_dB));

for i = 1:length(SNR_dB)
    
    p1 = 0; p2 = 0; p3 = 0;
    
    for k = 1:num_iter
        
        % Channels
        h_d = (randn + 1j*randn)/sqrt(2);
        h_r = (randn(N,1) + 1j*randn(N,1))/sqrt(2);
        g_r = (randn(N,1) + 1j*randn(N,1))/sqrt(2);
        
        % Noise based on SNR
        noise_power = 10^(-SNR_dB(i)/10);
        noise = sqrt(noise_power/2)*(randn + 1j*randn);
        
        % WITHOUT RIS
        p1 = p1 + abs(h_d + noise)^2;
        
        % RANDOM RIS
        theta_rand = exp(1j*2*pi*rand(N,1));
        ris_rand = sum(h_r .* g_r .* theta_rand);
        p2 = p2 + abs(h_d + ris_rand + noise)^2;
        
        % OPTIMIZED RIS
        theta_opt = exp(-1j*angle(h_r .* g_r));
        ris_opt = sum(h_r .* g_r .* theta_opt);
        p3 = p3 + abs(h_d + ris_opt + noise)^2;
        
    end
    
    snr_noRIS(i) = p1/num_iter;
    snr_randRIS(i) = p2/num_iter;
    snr_optRIS(i) = p3/num_iter;
end

figure;
plot(SNR_dB, 10*log10(snr_noRIS), '-o','LineWidth',2); hold on;
plot(SNR_dB, 10*log10(snr_randRIS), '-s','LineWidth',2);
plot(SNR_dB, 10*log10(snr_optRIS), '-^','LineWidth',2);
grid on;
xlabel('SNR (dB)');
ylabel('Received Power (dB)');
title('SNR Comparison: RIS vs No RIS');
legend('Without RIS','Random RIS','Optimized RIS');

N_values = [10 20 50 100];
power_vs_N = zeros(size(N_values));
num_iter2 = 200;

for i = 1:length(N_values)
    
    N_temp = N_values(i);
    temp_power = 0;
    
    for k = 1:num_iter2
        
        h_r = (randn(N_temp,1)+1j*randn(N_temp,1))/sqrt(2);
        g_r = (randn(N_temp,1)+1j*randn(N_temp,1))/sqrt(2);
        
        theta_opt = exp(-1j*angle(h_r .* g_r));
        ris_effect = sum(h_r .* g_r .* theta_opt);
        
        temp_power = temp_power + abs(ris_effect)^2;
    end
    
    power_vs_N(i) = temp_power / num_iter2;
end

figure;
plot(N_values, 10*log10(power_vs_N), '-o','LineWidth',2);
grid on;
xlabel('Number of RIS Elements');
ylabel('Received Power (dB)');
title('Effect of RIS Size on Signal Strength');

gain_dB = 10*log10(snr_optRIS) - 10*log10(snr_noRIS);

figure;
plot(SNR_dB, gain_dB, '-o','LineWidth',2);
grid on;
xlabel('SNR (dB)');
ylabel('Gain (dB)');
title('Gain Achieved Using RIS Phase Optimization');

N_phase = 20;

h_r = (randn(N_phase,1)+1j*randn(N_phase,1))/sqrt(2);
g_r = (randn(N_phase,1)+1j*randn(N_phase,1))/sqrt(2);

% Random phase
theta_rand = exp(1j*2*pi*rand(N_phase,1));
signal_rand = h_r .* g_r .* theta_rand;

% Optimized phase
theta_opt = exp(-1j*angle(h_r .* g_r));
signal_opt = h_r .* g_r .* theta_opt;

figure;

subplot(1,2,1);
stem(angle(signal_rand));
title('Random Phase Distribution');
xlabel('Element Index'); ylabel('Phase (radians)');

subplot(1,2,2);
stem(angle(signal_opt));
title('Optimized Phase Alignment');
xlabel('Element Index'); ylabel('Phase (radians)');