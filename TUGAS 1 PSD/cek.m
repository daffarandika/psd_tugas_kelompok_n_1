clc; clear; close all;

%% 1. Membaca File "speech.dat"
fid = fopen('speech.dat', 'r'); % Buka file
x = fread(fid, 'double'); % Baca data dalam format double
fclose(fid); % Tutup file

fs = 8000; % Frekuensi sampling

% Pastikan sinyal terbaca dengan benar
disp('5 Sampel pertama dari speech.dat:');
disp(x(1:5));

% Normalisasi sinyal ke rentang [-1, 1]
x = x / max(abs(x));

%% 2. Kuantisasi dengan 3, 8, dan 15 bit
bit_values = [3, 8, 15];
quantized_signals = cell(length(bit_values), 1); % Simpan hasil kuantisasi

figure;
subplot(4,1,1);
plot(x);
title('Sinyal Asli');
ylabel('Amplitudo');
xlabel('Sampel');

for i = 1:length(bit_values)
    n_bits = bit_values(i);
    L = 2^n_bits;
    delta = 2 / (L - 1);  % Perbaikan step size!

    % Proses kuantisasi
    xq = round((x + 1) / delta) * delta - 1;

    quantized_signals{i} = xq; % Simpan hasil kuantisasi

    subplot(4,1,i+1);
    plot(xq);
    title(['Sinyal Kuantisasi ', num2str(n_bits), ' Bit']);
    ylabel('Amplitudo');
    xlabel('Sampel');

    % Tampilkan perbedaan rata-rata antara sinyal asli dan kuantisasi
    disp(['Perbedaan rata-rata untuk ', num2str(n_bits), '-bit: ', num2str(mean(abs(x - xq)))]);
end

%% 3. Menghitung SNR untuk 3-15 bit
bit_range = 3:15;
SNR_values = zeros(size(bit_range));

for i = 1:length(bit_range)
    n_bits = bit_range(i);
    L = 2^n_bits;
    delta = 2 / (L - 1);
    xq = round((x + 1) / delta) * delta - 1;

    % Hitung error kuantisasi
    error_signal = x - xq;

    % Hitung SNR dalam dB
    SNR_values(i) = 10 * log10(sum(x.^2) / sum(error_signal.^2));
end

%% 4. Plot SNR vs Bit Kuantisasi
figure;
plot(bit_range, SNR_values, '-o', 'LineWidth', 2);
xlabel('Jumlah Bit Kuantisasi');
ylabel('SNR (dB)');
title('SNR vs Jumlah Bit Kuantisasi');
grid on;

%% 5. Memutar suara asli dan hasil kuantisasi
disp('Memainkan suara asli...');
sound(x, fs);
pause(3);

for i = 1:length(bit_values)
    disp(['Memainkan suara hasil kuantisasi ', num2str(bit_values(i)), ' bit...']);
    sound(quantized_signals{i}, fs);
    pause(3);
end

