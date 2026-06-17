# Adaptive Automatic Gain Control for a Superheterodyne Receiver

## Overview

This project presents the design and simulation of an Adaptive Automatic Gain Control (AGC) system for a Superheterodyne Receiver using MATLAB.

Wireless communication channels experience signal amplitude fluctuations caused by fading, mobility, path loss, and noise. These variations can lead to amplifier saturation for strong signals and poor signal-to-noise ratio (SNR) for weak signals. To address this challenge, an adaptive AGC architecture was developed to maintain a stable receiver output under dynamic channel conditions.

The proposed system incorporates a Variable Gain Amplifier (VGA), envelope detector, adaptive gain control mechanism, and a PI-based feedback controller. Performance was evaluated under Additive White Gaussian Noise (AWGN) and Rayleigh fading environments.

---

## Problem Statement

In wireless communication systems, received signal amplitudes vary continuously due to channel impairments such as:

* Multipath fading
* Mobility-induced fluctuations
* Thermal noise
* Path loss

Conventional AGC systems often face trade-offs between response speed, stability, and gain accuracy. A rapidly responding AGC may introduce oscillations, while a slower system may fail to adapt to sudden signal variations.

This project investigates an adaptive AGC approach capable of maintaining stable receiver performance across varying channel conditions.

---

## Objectives

* Model a Superheterodyne Receiver in MATLAB.
* Implement a conventional proportional AGC system.
* Design an optimized PI-based AGC controller.
* Introduce adaptive attack and decay mechanisms.
* Simulate AWGN and Rayleigh fading channels.
* Compare gain stability, response speed, and output amplitude regulation.
* Evaluate overall receiver performance under dynamic wireless conditions.

---

## System Architecture

The receiver model consists of:

1. RF Input Signal
2. Mixer and Local Oscillator
3. Intermediate Frequency (IF) Stage
4. Variable Gain Amplifier (VGA)
5. Envelope Detector
6. Power Estimation Block
7. Adaptive AGC Controller
8. Feedback Control Loop

The AGC continuously monitors output power and adjusts receiver gain to maintain a target output level.

---

## Methodology

### Conventional AGC

A proportional controller was implemented to regulate receiver gain based on output power error.

### PI-Based AGC

A proportional-integral controller was introduced to reduce steady-state error and improve gain stability.

### Adaptive Gain Dynamics

Two operating modes were implemented:

* Fast Attack Mode

  * Rapid gain reduction during sudden signal increases.
  * Prevents amplifier saturation.

* Slow Decay Mode

  * Gradual gain increase during signal fading.
  * Reduces noise amplification.

### Channel Modeling

The receiver was evaluated under realistic wireless environments including:

* Additive White Gaussian Noise (AWGN)
* Rayleigh Fading Channels

Monte Carlo-style simulations were used to observe system behavior under varying channel conditions.

---

## Tools and Technologies

* MATLAB
* Communication Systems Modeling
* Signal Processing
* Control Systems
* Rayleigh Fading Simulation
* AWGN Channel Modeling

---

## Results

The proposed AGC system demonstrated:

* Improved output amplitude stability.
* Reduced amplitude fluctuations.
* Lower steady-state error compared to conventional AGC.
* Better adaptation to rapidly changing channel conditions.
* Improved receiver reliability under fading environments.

The PI-based adaptive controller consistently outperformed the conventional proportional AGC architecture in maintaining stable receiver operation.

---

## Applications

* Wireless Communication Systems
* Cellular Receivers
* Software Defined Radio (SDR)
* IoT Communication Devices
* Satellite Communication Systems
* Adaptive RF Front Ends

---

## Future Improvements

* Adaptive PID Controller Design
* Machine Learning Assisted Gain Control
* MIMO Receiver Integration
* FPGA-Based AGC Implementation
* Real-Time SDR Deployment

---

## Author

Lakshya Lalan

B.Tech Electronics and Communication Engineering

VIT Vellore
