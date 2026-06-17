# Signal Recovery from Additive White Gaussian Noise Using Moving Average Filtering

## Overview

This project investigates the recovery of signals corrupted by Additive White Gaussian Noise (AWGN) using a Moving Average (MA) filter implemented in MATLAB.

A composite signal consisting of multiple sinusoidal components was generated and intentionally degraded using controlled AWGN. A 20-point Moving Average filter was then applied to recover the original signal. The system was evaluated using time-domain, frequency-domain, and statistical analysis techniques.

Performance was quantified using Signal-to-Noise Ratio (SNR), Mean Squared Error (MSE), Fast Fourier Transform (FFT), Power Spectral Density (PSD), autocorrelation analysis, and LTI system characterization.

---

## Objectives

- Generate a composite signal containing multiple sinusoidal components.
- Introduce controlled Additive White Gaussian Noise (AWGN).
- Implement a Moving Average (MA) filter for signal recovery.
- Evaluate filtering performance using:
  - Signal-to-Noise Ratio (SNR)
  - Mean Squared Error (MSE)
  - FFT Analysis
  - Power Spectral Density (PSD)
- Analyze temporal statistics including:
  - Mean
  - Variance
  - Autocorrelation
- Study the frequency response and impulse response of the filter.

---

## Signal Configuration

### Original Signal

The composite signal consists of:

- Sinusoid 1: 5 Hz, Amplitude = 1.0
- Sinusoid 2: 10 Hz, Amplitude = 0.5

### Sampling Parameters

| Parameter | Value |
|------------|---------|
| Sampling Frequency | 1000 Hz |
| Duration | 1 second |
| Total Samples | 1000 |

### Noise Model

- Additive White Gaussian Noise (AWGN)
- Input SNR ≈ 5 dB

---

## Methodology

### Step 1: Signal Generation

A two-tone composite signal was generated using sinusoidal components at 5 Hz and 10 Hz.

### Step 2: Noise Injection

AWGN was added to simulate practical communication channel impairments.

### Step 3: Signal Recovery

A 20-point Moving Average filter was implemented as a causal FIR Linear Time-Invariant (LTI) system.

The filter reduces high-frequency noise by averaging neighboring samples while preserving low-frequency signal components.

### Step 4: Performance Evaluation

The recovered signal was analyzed using:

- Time-domain comparison
- FFT spectrum analysis
- PSD estimation
- Statistical characterization
- LTI frequency response analysis

---

## Tools and Technologies

- MATLAB
- Digital Signal Processing
- Random Processes
- FFT Analysis
- PSD Estimation
- FIR Filter Design
- Statistical Signal Analysis

---

## Results

### Signal-to-Noise Ratio

| Metric | Value |
|----------|----------|
| Input SNR | 4.95 dB |
| Output SNR | 8.24 dB |
| SNR Gain | 3.29 dB |

### Mean Squared Error

| Metric | Value |
|----------|----------|
| MSE Before Filtering | 0.199903 |
| MSE After Filtering | 0.093735 |
| Improvement | 53.1% |

### Key Observations

- The Moving Average filter successfully reduced AWGN contamination.
- Primary frequency components at 5 Hz and 10 Hz were preserved.
- High-frequency noise components were attenuated.
- Residual error variance decreased significantly after filtering.
- Autocorrelation analysis confirmed effective noise suppression.
- The filter exhibited expected low-pass FIR behavior.

---

## Applications

- Communication Systems
- Biomedical Signal Processing
- Sensor Data Processing
- Embedded DSP Systems
- Noise Reduction Applications
- Real-Time Signal Conditioning

---

## Future Improvements

- Adaptive Moving Average Filtering
- Wiener Filtering
- Kalman Filtering
- Wavelet-Based Denoising
- FPGA-Based Real-Time Implementation

---

## Author

Lakshya Lalan

B.Tech Electronics and Communication Engineering

VIT Vellore