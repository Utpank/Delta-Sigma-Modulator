# Delta-Sigma-Modulator
Converters are generally the bottleneck of a mixed technology system. Process control measurement requires modulator with resolution of 16 bits and operating input frequency from 1 to 100 Hz. The designed system will reduce the dependency process control operation on high precision analog circuits. They are best for applications that manage to provide very high resolution at comparatively lower frequencies. Nyquist rate converters cannot provide good accuracy with high-speed conversion. In contrast, Delta Sigma Modulators are able to provide a better resolution at a reasonable conversion speed. The objective of this paper is to simulate and analyze a stable, second-order Delta Sigma Modulator of CIFB topology in three different levels, Hardware-level (ADS1115 and ESP8266), Circuit level (LTSpice) and Software level (MATLAB) and analyze the findings in the time domain and frequency domain. For a given oversampling ratio of 512, the aim is to achieve an optimal SQNR of 125 dB which leads to better performance overall with the use of the same lower resolution ADC. The ideal converter is simulated and designed in MATLAB and the practical behaviour of the system is simulated in LTSpice.

MATLAB output:


<img width="364" alt="image" src="https://github.com/Utpank/Delta-Sigma-Modulator/assets/98480443/d006a152-a89f-4988-a31d-78d2465d2b1a">

Power spectral density at oversampling ratio of 64


<img width="380" alt="image" src="https://github.com/Utpank/Delta-Sigma-Modulator/assets/98480443/8dc92e30-448b-4d17-91bc-de903a33baa9">


LTspice Circuit design:

![2](https://github.com/Utpank/Delta-Sigma-Modulator/assets/98480443/2546188b-89ed-4896-bb4b-605d9ade6585)
![6](https://github.com/Utpank/Delta-Sigma-Modulator/assets/98480443/19795cf0-2c70-4fd7-85cc-d75f393b436b)
![9](https://github.com/Utpank/Delta-Sigma-Modulator/assets/98480443/4f28cf4d-6eb7-4261-8b4c-28fa7103aae5)
