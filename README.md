
Digital Communications I Lab - NTUA Course 2020-2021

This repository containts all lab exercises of the semester along with my MATLAB codes.

* Lab 1: Basic MATLAB commands and signal processing.
    * Sampling and FFT processing.

        \> lab1_signal_dig_com.m: FFT functions and Discrete signal.\
        \> lab1_noisy_dig_com.m: Noise signal combination and FFT.

* Lab 2: Filters - Bandpass filter.

    \>  lab2_bandpass_dig_com.m: Creating a bandpass filter for signal "lab2_sima.mat".

* Lab 3: Custom filters - L-ASK constellation.
    * Part 1: EbNo Relations.

        \> ask3_1_1.m: Verify uniform distribution of vector.\
        \> ask3_1_2.m: EbNo (Energy per bit to Noise Power) variations.

    * Part 2: BER (Bit error rate) to SNR -> Performance Curve.

        \> ask_ber_func.m: Matlab BER function.\
        \> ask_ber_part2_a.m: Custom BER function implementation.\
        \> ask_error.m: Errors function.

    * Part 3: Pulse Convolutions.

        \> ask3_3.m: Errors function using pulse convolutions.


* Lab 4: Nyquist Filters.
    * Part 1: Signal generation from Nyquist filters

        \> lab4_1-Nyquist.m

    * Part 4: Parameter adjustments, BER function 

        \> lab4_nyq_ber_function.m: Matlab BER function.

        \> lab4_4function.m: errors function adjusted for nyquist.

        \> lab4_4test.m : for part 2, performance comparison BER and Eb/No.

* Lab 5: QAM - PSK constellation.
    * Part 1: M-PSK.

        \> lab5_1.m: M-PSK Implementation. 

    * Part 2: PSK simulation and BER.
        
        \> lab5_2-ber.m: BERtool function.\
        \> lab5_2-func_of_ber.m: M-PSK system, transmitter, receiver simulation.

    * Part 3: lab5_3.m.

    * Part 5: QAM Implementation and Simulation.

        \> lab5_5_qam_ber.m: BERtool function.\
        \> lab5_5_qam_sim.m: QAM constellation function.

* Lab 6: FSK-MSK
    * Part 1: Non-coherent FSK

        \> lab6_1_fsk_errors_noncoh.m: Non-coherent FSK simulation.

    * Part 2: Coherent - Non-coherent FSK BER

        \> fsk_errors_coh.m: Coherent FSK.\
        \> lab6_1_fsk_errors_noncoh.m: Non-coherent FSK.\
        \> lab6_ber.m: BERtool function.

    * Part 3: lab6_3_fsk_coh_non_welch.m

    * Part 4: MSK simulation

        \> lab6_4_msk_print.m: MSK simulation and spectrum representation.\
        \> msk_errors.m: MSK error calculation.\
        \> lab6_ber.m: BERtool function.

    * Part 5: QPSK BER parameter evalutation

        \> lab6_5.m: QPSK equivalent system.\
        \> lab6_ber.m: BERtool function.
