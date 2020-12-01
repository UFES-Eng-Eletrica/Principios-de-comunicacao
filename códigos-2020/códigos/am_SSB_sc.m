% ========================================================================%
%                    Principios de Comunicações I                         %
%             ---------- Modulação AM-SSB/SC -----------                  %
% ========================================================================%
%% Compare Double-Sideband and Single-Sideband Amplitude Modulation
% Set the sample rate to 300 Hz. Create a time vector 100 seconds long.

fs = 300;             % taxa de amostragem (amostras/s)
tam = 2^18;           % quantidade de amostras de cada variavel
ts = 1/fs;            % periodo de amostragem 
t = (0:ts:(tam-1)*ts)';  % geracao do vetor tempo
%% 
% Set the carrier frequency to 10 Hz. Generate a sinusoidal signal.
%%

fm1 = 1;              % frequencia da primeira senoide
fm2 = 2;              % frequencia da segunda senoide
fc = 10*fm2; 

x = sin(2*pi*fm1*t) + sin(2*pi*fm2*t);   % sinal modulador

%% 
% Modulate |x| using single- and double-sideband AM.
%%
ydouble = ammod(x,fc,fs);
ysingle = ssbmod(x,fc,fs);
%% 
% Create a spectrum analyzer object to plot the spectra of the two signals. 
% Plot the spectrum of the double-sideband signal.
%%
sa = dsp.SpectrumAnalyzer('SampleRate',fs, ...
    'PlotAsTwoSidedSpectrum',false, ...
    'YLimits',[-60 40]);
step(sa,ydouble)

%% 
% Plot the single-sideband spectrum.
step(sa,ysingle)
%%
figure() , plot(t,ysingle,'g'), grid, title ('Sinal')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
axis tight

[S_mod,s1,f_mod,df_mod] = Analisador_de_Espectro(ysingle.',ts);           % Espectro
figure(), plot(f_mod,10*log10(fftshift(abs(S_mod))),'g'), grid
title ('Espectro de Potência');
xlabel('Frequência[Hz]'), ylabel('PSD [dB/Hz]'), axis tight

figure() , plot(t,ydouble,'g'), grid, title ('Sinal')
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
axis tight

[S_mod_double,s1,f_mod,df_mod] = Analisador_de_Espectro(ydouble.',ts);           % Espectro
figure(), plot(f_mod,10*log10(fftshift(abs(S_mod_double))),'g'), grid
title ('Espectro de Potência');
xlabel('Frequência[Hz]'), ylabel('PSD [dB/Hz]'), axis tight
