% Parameters
f0 = 50; % Fundamental frequency in Hz
w0 = 2 * pi * f0; % Angular frequency
Fs = 16000; % Sampling frequency in Hz
T = 0.1; % Sampling period
t = 0:1/Fs:T; % Time vector for 1 second

% SNR (Signal-to-Noise Ratio) in dB
SNR = 21; % SNR in dB

% Generate the signal v(t)
v = 0.3 ...
    + 5 * sin(w0 * t + 2.5) ...
    + 1.5 * sin(3 * w0 * t + 1.3) ...
    + 0.75 * sin(5 * w0 * t + 1.0) ...
    + 0.375 * sin(7 * w0 * t + 0.6) ...
    + 0.1875 * sin(9 * w0 * t + 0.3);

% Add noise to the signal
v_noisy = awgn(v, SNR, 'measured');

% Number of bits for quantization (selectable)
n = 12; % You can change this to 10 or 12

% Quantize the signal
v_min = min(v_noisy);
v_max = max(v_noisy);
v_scaled = (v_noisy - v_min) / (v_max - v_min); % Scale to 0-1 range
v_quantized = round(v_scaled * (2^n - 1)); % Quantize to n-bit unsigned integers

% Ensure the quantized values fit within n-bit range
v_quantized = min(max(v_quantized, 0), 2^n - 1);

% Create MIF file
mif_filename = 'quantized_signal.mif';
fileID = fopen(mif_filename, 'w');

% Write MIF file header
fprintf(fileID, 'DEPTH = %d;\n', length(v_quantized));
fprintf(fileID, 'WIDTH = %d;\n', n);
fprintf(fileID, 'ADDRESS_RADIX = HEX;\n');
fprintf(fileID, 'DATA_RADIX = HEX;\n');
fprintf(fileID, 'CONTENT BEGIN\n');

% Write MIF file content
for i = 1:length(v_quantized)
    fprintf(fileID, '%X : %X;\n', i-1, v_quantized(i));
end
fprintf(fileID, 'END;\n');
fclose(fileID);

% Create HEX file
hex_filename = 'quantized_signal.hex';
fileID = fopen(hex_filename, 'w');

% Write HEX file content
for i = 1:length(v_quantized)
    fprintf(fileID, '%X\n', v_quantized(i));
end
fclose(fileID);

disp('MIF and HEX files have been generated.');

% Plot the quantized signal in full window
figure;
stairs(t, v_quantized * (v_max - v_min) / (2^n - 1) + v_min);
title('Quantized Signal');
xlabel('Time (s)');
ylabel('Amplitude');
