clear all; close all;
disp('Memuat data suara: speech.dat');
load speech.dat;

sig = speech;
fs = 8000;
lg = length(sig);
T = 1/fs;
t = [0:1:lg-1]*T;

sig = 4.5 * sig / max(abs(sig));

Xmax = max(abs(sig));
Xrms = sqrt(sum(sig .* sig) / length(sig));
disp('Xrms/Xmax');
k = Xrms / Xmax;
disp('20*log10(k) =>');
k = 20 * log10(k);

bits_range = 3:15;
snr_values = zeros(size(bits_range));

for b = bits_range
    for x = 1:lg
        [Index(x), pq] = biquant(b, -5, 5, sig(x));
    end

    for x = 1:lg
        qsig(x) = biqtdec(b, -5, 5, Index(x));
    end

    snr_values(b - 2) = calcsnr(sig, qsig);
end

figure;
plot(bits_range, snr_values, '-o', 'LineWidth', 2);
xlabel('Jumlah Bit Kuantisasi');
ylabel('SNR (dB)');
title('Grafik SNR vs Jumlah Bit');
grid on;

bit_values = [3, 8, 15];

figure;
for i = 1:length(bit_values)
    b = bit_values(i);

    for x = 1:lg
        [Index(x), pq] = biquant(b, -5, 5, sig(x));
    end

    for x = 1:lg
        qsig(x) = biqtdec(b, -5, 5, Index(x));
    end

    subplot(3, 1, i);
    plot(t, sig, 'b'); hold on;
    stairs(t, qsig, 'r');
    xlabel('Waktu (detik)');
    ylabel('Amplitudo');
    title(['Kuantisasi dengan ', num2str(b), ' bit']);
    legend('Sinyal Asli', 'Sinyal Kuantisasi');
    grid on;
end

disp('Memutar ulang suara asli...');
sound(sig / max(abs(sig)), fs);
pause(2);

for i = 1:length(bit_values)
    b = bit_values(i);

    for x = 1:lg
        [Index(x), pq] = biquant(b, -5, 5, sig(x));
    end

    for x = 1:lg
        qsig(x) = biqtdec(b, -5, 5, Index(x));
    end

    disp(['Memutar ulang suara dengan ', num2str(b), ' bit...']);
    sound(qsig / max(abs(qsig)), fs);
    pause(2);
end

