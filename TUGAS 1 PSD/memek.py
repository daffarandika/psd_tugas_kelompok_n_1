import numpy as np
import matplotlib.pyplot as plt

V_MIN = -5
V_MAX = 5

def plot_signal(signal, t, title="Signal"):
    plt.figure(figsize=(15, 8))
    plt.plot(t, signal)
    plt.xlabel('Time (s)')
    plt.ylabel('Amplitude')
    plt.title(title)
    plt.grid(True)

def find_closest(lst, n):
    return min(lst, key=lambda x: abs(x-n))

# Load the speech signal
signal = np.loadtxt("./speech.dat")
fs = 8000  # Sampling frequency in Hz
T = 1 / fs  # Sampling period
t = np.arange(0, len(signal)) * T

# Plot original signal
plot_signal(signal, t, "Original Speech Signal")

# Normalize the signal to fit within our voltage range
norm_signal = 4.5 * signal / max(abs(signal))
plot_signal(norm_signal, t, "Normalized Speech Signal")

# Calculate signal characteristics
Xmax = np.max(abs(norm_signal))
Xrms = np.sqrt(np.mean(norm_signal * norm_signal))
k = Xrms / Xmax
crest_factor_db = np.log10(k) * 20
print(f"Signal crest factor: {crest_factor_db:.2f} dB")

# Get quantization bits from user
bits = int(input("Enter number of bits for quantization: "))
level = 2**bits
print(f"Quantization levels: {level}")

# Calculate quantization step size
delta = (V_MAX - V_MIN) / level
print(f"Quantization step size (delta): {delta:.4f}")

# Generate quantization levels
quantization_levels = []
for i in range(level):
    level_value = V_MIN + (i + 0.5) * delta  # Mid-rise quantizer
    quantization_levels.append(level_value)

# Perform quantization
quantized_signal = np.zeros_like(norm_signal)
for i in range(len(norm_signal)):
    quantized_signal[i] = find_closest(quantization_levels, norm_signal[i])

# Calculate quantization error
quantization_error = norm_signal - quantized_signal
MSE = np.mean(quantization_error**2)
SQNR = 10 * np.log10(np.mean(norm_signal**2) / MSE)  # Signal to Quantization Noise Ratio
print(f"Mean Squared Error: {MSE:.6f}")
print(f"Signal to Quantization Noise Ratio: {SQNR:.2f} dB")

# Plot quantized signal
plot_signal(quantized_signal, t, f"Quantized Signal ({bits}-bit)")

# Plot quantization error
plot_signal(quantization_error, t, "Quantization Error")

# Plot normalized signal with quantization levels
plt.figure(figsize=(15, 8))
plt.plot(t, norm_signal, label="Normalized Signal")
plt.plot(t, quantized_signal, 'r--', label="Quantized Signal")
plt.xlabel('Time (s)')
plt.ylabel('Amplitude')
plt.title(f"Normalized vs Quantized Signal ({bits}-bit)")
plt.grid(True)
plt.legend()

# Draw horizontal lines for quantization levels
plt.figure(figsize=(15, 8))
plt.plot(t, norm_signal)
plt.xlabel('Time (s)')
plt.ylabel('Amplitude')
plt.title(f"Signal with Quantization Levels ({bits}-bit)")
for level_value in quantization_levels:
    plt.axhline(y=level_value, color='r', linestyle=':')
plt.grid(True)

# Convert to digital representation (binary code)
def decimal_to_binary(value, levels, bits):
    # Find the index of the closest level
    idx = np.argmin(np.abs(np.array(levels) - value))
    # Convert to binary representation with specified number of bits
    return format(idx, f'0{bits}b')

# Generate binary representation for a sample segment
sample_size = min(20, len(quantized_signal))  # Show first 20 samples or less
print("\nDigital Representation (First few samples):")
for i in range(sample_size):
    binary_code = decimal_to_binary(quantized_signal[i], quantization_levels, bits)
    print(f"Sample {i}: {quantized_signal[i]:.4f} V → {binary_code}")

# Save the quantized signal to a file
np.savetxt("quantized_speech.dat", quantized_signal)
print("\nQuantized signal saved to 'quantized_speech.dat'")

plt.tight_layout()
plt.show()
