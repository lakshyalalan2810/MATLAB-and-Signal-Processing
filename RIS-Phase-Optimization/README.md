# Phase Optimization in Reconfigurable Intelligent Surfaces (RIS) for Signal Enhancement

## Overview

This project investigates the use of Reconfigurable Intelligent Surfaces (RIS) to improve wireless communication performance through intelligent phase control of reflected signals.

In conventional wireless systems, multipath propagation causes transmitted signals to arrive at the receiver with different phase shifts, often resulting in destructive interference and reduced signal quality. This project demonstrates how RIS can transform the wireless environment into a controllable entity by aligning reflected signals constructively at the receiver.

The complete system was modeled and simulated in MATLAB using Monte Carlo analysis under varying Signal-to-Noise Ratio (SNR) conditions.

---

## Objectives

* Compare received signal power for:

  * No RIS
  * Random RIS configuration
  * Optimized RIS configuration

* Analyze performance across SNR values ranging from 0 dB to 20 dB.

* Evaluate the impact of RIS element count on received signal power.

* Measure signal gain achieved through optimized phase alignment.

* Visualize phase distributions to demonstrate constructive interference.

---

## Methodology

The wireless channel was modeled using Rayleigh fading with additive noise.

Three communication scenarios were evaluated:

### 1. Without RIS

Signal propagation occurs directly through the wireless channel without environmental control.

### 2. Random RIS

RIS elements apply random phase shifts resulting in partial constructive and destructive interference.

### 3. Optimized RIS

Each RIS element applies an optimized phase shift that aligns reflected signals at the receiver, maximizing received power.

Monte Carlo simulations were performed to obtain statistically reliable results.

---

## Tools and Technologies

* MATLAB
* Wireless Communication Modeling
* Rayleigh Fading Channels
* Monte Carlo Simulation
* Signal Processing

---

## Results

Key observations include:

* Optimized RIS consistently achieved the highest received signal power.
* Significant performance improvement was observed compared to both random RIS and no-RIS scenarios.
* Increasing the number of RIS elements improved received signal strength.
* Phase optimization successfully converted destructive interference into constructive interference.

---

## Applications

* 6G Wireless Networks
* Smart Radio Environments
* Indoor Coverage Enhancement
* Energy-Efficient Wireless Communication
* Beyond-5G Research

---

## Future Improvements

* Multi-user RIS optimization
* Machine learning based phase control
* Mobility-aware RIS adaptation
* MIMO-RIS integration
* Real-time optimization algorithms

---

## Author

Lakshya Lalan

B.Tech Electronics and Communication Engineering

VIT Vellore
