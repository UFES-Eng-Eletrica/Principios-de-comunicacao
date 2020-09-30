% .................... Princ?pios de Comunica??es I........................
%
% Lab III
% Modula??o AM - Detector Envolt?ria
%
% by Jair Silva
% UFES/2013
% .........................................................................

clc, clear all;

% .............  Parametros  .............................................. 
Fs = 100;               % Taxa de amostragem
fc = 20;                % Frequencia da portadora
Ac = 1;                 % Amplitude da portadora
Nf = 2^18;              % Tamanho da FFT
mu = 1.2;               % ?ndice de Modula??o (mu=k/A)

% Vetor tempo
t  = [0:2*Fs+1]'/Fs; 

% vetor frequencia
f = (0:Nf-1)'/Nf*Fs; % Vetor Frequ?ncia

%% ==================   TRANSMISSOR ======================================

% ----- Sinal Modulador - 2 Senoides a taxa Fs amostras por segundo -------

% O sinal ? a soma dos sen?ides
x = sin(2*pi*t) + sin(4*pi*t); 

% ---- Cria a portadora de frequ?ncia -------------------------------------

port = Ac * cos(2*pi*fc*t); % Portadora n?o modulada

% -------- Modula??o AM-DSB/TC --------------------------------------------
k = max(abs(x));           % Constante referente ao sinal modulante
A = k/mu;                  % Constante a ser adicionado ao sinal modulante
smod = (A + x) .* port; % sinal modulado

% =========================================================================


%% **********************  CANAL DE COMUNICACAO  **************************

Y = smod;  % back-to-back (B2B)

% *************************************************************************


% ===========================  RECEPTOR  ==================================

% -- Demodula??o AM com detec??o de envolt?ria com transformada Hilbert ---
sdemod = hilbert(smod); % r(t) = s(t) + j * hilb(s(t))
sdemod_bb = sdemod .* exp(-i*2*pi*fc*t); % Sinal complexo em banda base
sdemod_bb = abs(sdemod_bb); % Sa?da do detector
sdemod_bb = sdemod_bb - mean(sdemod_bb); % % Remove o valor DC


% Compara os sinais de mensagem transmitido e recebido
r = sdemod_bb.*max(abs(x));



%% ............ Plota os sinais ......................................... 

% Sinal Gerado
X = abs(fft(x, Nf)); % Espectro do sinal modulador
figure(1), subplot(211), plot(t,x)
title('Sinal Modulador')
xlabel('Tempo (seg)'), ylabel('Amplitude [u.a.]')
subplot(212), plot(f, X)
ax = axis; axis([0 Fs/2 ax(3) ax(4)]); % Plota metade da taxa de amostragem
title('Espectro do sinal Modulador'), ylabel('Amplitude [u.a.]')
xlabel('Frequencia (Hz)')

% Sinal Modulado
SMOD = fft(smod, Nf); % espectro do sinal modulado
figure(2)
subplot(211), plot(t,smod)
title('Sinal Modulado em AM')
xlabel('Tempo (seg.)'), ylabel('amplitude [u.a.]')
subplot(212), plot(f, abs(SMOD))
ax = axis; axis([0 Fs/2 ax(3) ax(4)]);
title('Espectro do sinal Modulado')
xlabel('Frequencia (Hz)'), ylabel('amplitude [u.a.]')

% Sinal demodulado
SDEMOD = fft(sdemod_bb, Nf); % Espectro do sinal
figure (3), subplot(211), plot(t,sdemod_bb)
title('Sa?da do detector de envolt?ria')
xlabel('Tempo (seg.)'), ylabel('amplitude [u.a.]')
subplot(212)
plot(f, abs(SDEMOD))
ax = axis;
axis([0 Fs/2 ax(3) ax(4)]);
title('Espectro do sinal na sa?da do detector')
xlabel('Frequencia (Hz)'), ylabel('amplitude [u.a.]')

% Compara os sinais recebidos
x = x./max(abs(x));    % normaliza x
r = r./(max(abs(r)));
figure(4), plot(t(1:end-15),x(1:end-15),t(1:end-15),r(1:end-15))
title('Comparando os sinais gerado e recuperado')
xlabel('tempo (seg.)'), ylabel('amplitude [u.a.]')
legend('sinal gerado','sinal recuperado')
%
% EOF
%