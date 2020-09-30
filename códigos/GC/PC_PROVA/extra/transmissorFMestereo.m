% .................... Princ?pios de Comunica??es I........................
% 
% Lab IV 
% 
% Modula??o FM     
%
% by Jair Silva
% UFES/2014
% .........................................................................
%
clc, clear all, close all
%
% ............... Dados de entrada (AM-DSB/SC) ............................
fm_am = 1e3;      % Frequ?ncia do sinal modulante
fp_am = 19e3;     % Frequencia da portadora
fo_am = 2*fp_am;  % Frequencia da portadora
Fs_am = 500e3;    % Taxa de amostragem 

% ............... Dados de entrada (FM)....................................
Fs = 500e3 ;         % Taxa de amostragem 
fo = 100e3;          % Frequencia da portadora
fm = fo_am + fm_am;  % Frequ?ncia do sinal modulante
A  = 2;              % Amplitude do sinal modulante
Eo = 10;             % Amplitude do sinal Modulado em FM
B  = 3;              % ?ndice de modula??o angular [rad] 
C  = 0;              % Fase inicial
d  = 1;              % Dura??o do sinal de mensagem


%................ Dados calculados .......................................
kf = (B*fm)/A;    % Constante de modula??o FM 
Df = kf*A;        % Desvio frequencia -- Quando o sinal modulante ? um tom
Bw = 2*Df + 2*fm; % Largura de banda do sinal modulado (Crit?rio de Carson)
 
% ............ Gera??o do sinal modulante para AM-DSB/SC .................. 
t_am  = linspace(0, d, d*Fs_am+1);  % vetor tempo
ta_am = t_am(2);                    % Periodo de amostragem em banda base
m_am_esq  = cos(2*pi*fm_am*t_am);   % sinal de mensagem esquerdo
m_am_dir  = cos(2*pi*2*fm_am*t_am); % sinal de mensagem direito

% ............ Matriz para Modula??o Esterofonica .........................
esq = m_am_esq;          % sinal esquerdo 
dir = m_am_dir;          % sinal_direito
M_dif  = esq - dir;  % Saida da Matriz do sinal diferen?a
M_soma = esq + dir;  % Saida da Matriz do sinal diferen?a

% ............ Modula??o AM-DSB/TC ........................................
M_dif_mod = ammod(M_dif,fo_am,Fs_am);  % Modula??o AM-DSB/SC

% ............ Cria a portadora em 19 KHz .................................
port = 0.1*cos(2*pi*fp_am*t_am);  % Portadora n?o modulada 

% ............ Gera o sinal Banda Base da Modula??o FM ....................
c = M_dif_mod + port + M_soma; % Multiplexa??o 


% =============== MODULA??O FM ============================================
s = Eo*fmmod(c,fo,Fs_am,kf);     % Modula??o FM 


% ++++++++++++++++  Canal +++++++++++++++++++++++++++++++++++++++++++++++++

r = s;  % B2B

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


% =============== Demodula??o FM ==========================================
r_demod = fmdemod(r,fo,Fs_am,kf);

% ====== Demodula??o AM-DSB/SC e Recupera??o dos Tr?s sinais ==============
%
% ?????????????????????????????????
% ?????????????????????????????????
% ?????????????????????????????????


% ================ Plota alguns Gr?ficos ==================================
% Plota o sinal de mensagem FM no dominio do tempo e da frequencia
[C,cn,f_am,df_am] = FFT_pot2(c,ta_am);  % Determina o espectro
figure(1)         
subplot(2,1,1)
plot(t_am,c,'b'), grid, 
title ('Sinal Modulador (Modulado em AM-DSB/SC)'); 
xlabel('tempo [s]'), ylabel('ampl. [u.a.]')
subplot(2,1,2)
plot(f_am,10*log10(fftshift(abs(C))),'b'), grid
title ('Espectro em Banda Base (Sinal Modulador) para FM');
xlabel('Frequ?ncia[Hz]'), ylabel('PSD [dB/Hz]')


% Plota o sinal modulado no dominio do tempo e da frequencia
figure(2);   % transmiss?o
[S,sn,f,df] = FFT_pot2(s,ta_am);  % Determina o espectro
subplot(2,1,1)
plot(t_am,s,'g'); title ('Sinal Modulado'), xlabel('t [s]'); ylabel('Sinal modulado'); grid
subplot(2,1,2)
plot(f,(10*log10(fftshift(abs(S)))),'g');
title ('Espectro em Banda Passante (Sinal Modulado)');
xlabel('f [Hz]'); ylabel('Espectro do sinal modulado'); grid
