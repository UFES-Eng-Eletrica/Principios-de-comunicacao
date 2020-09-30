%% Laborat�rio Computacional de Princ�pios de Comunica��o 1 - maiky

%% Parametriza��o
ti = 0;     % tempo inicial
tf = 1e-6;  % tempo final
tam = 1000; % tamanho do vetor
A = 3;      % Amplitude do sinal
fat = 2;   % fator de amostragem
fc = 5e6;   % freque�ncia central

%% Processamento
%% Atividade - Processamento de �udio
fs = 44100; % quantidade de amostras por segundo
bits = 16; % n�mero de bits do sinal
n = 1; % n�mero de canais do sinal
tg = 10; % tempo de grava��o do �udio


%%
% voz = audiorecorder (fs, bits, n);
% o audio deve ser gravado na linha de comando usando record(voz, tg)
t = linspace(0, tg, voz.TotalSamples); % gera��o do vetor tempo
[a11,a12,a13,a14] = FFT_pot2(getaudiodata(voz)', t(2)-t(1)); % gera o FFT do sinal original
createfigureAula0(t,getaudiodata(voz)',a13, db(fftshift(abs(a11)))); % plota o sinal e o FFT do original

filtro = designfilt('lowpassfir', 'PassbandFrequency', .45, 'StopbandFrequency', 4000, 'PassbandRipple', 1, 'StopbandAttenuation', 60, 'SampleRate', voz.SampleRate); % cria o filtro
voz_filtrada = filter(filtro, getaudiodata(voz)); % filtra o audio
[a21,a22,a23,a24] = FFT_pot2(voz_filtrada', t(2)-t(1)); % gera o FFT do sinal 
createfigureAula0(t,voz_filtrada,a23, db(fftshift(abs(a21)))); % plota o sinal e o FFT do sinal filtrado

% Para executar o audio filtrado:

% audio_filtrado = audioplayer(voz_filtrada', fs);
% play(audio_filtrado, fs)


%% Plotagem
createfigureAula0(t,x1,f,db(fftshift(abs(X1))));


%% Fun��es criadas durante as aulas

% Aula 0
function [vetor_tempo, vetor_sinal] = geraSenPorFat (ti, tf, tam, A, fat)
% Gera uma sen�ide com os par�metros abaixo:
% 
% ti    % tempo inicial
% tf    % tempo final
% tam   % tamanho do vetor
% A     % Amplitude do sinal
% fat   % fator de amostragem

vetor_tempo = linspace(ti, tf, tam);  % gera��o do vetor tempo

fc = Fa/fat;
vetor_sinal = A*cos(2*pi()*fc*vetor_tempo);
end
function createfigureAula0(X1, Y1, X2, Y2)
%CREATEFIGURE(X1, Y1, X2, Y2)
%  X1:  vector of x data
%  Y1:  vector of y data
%  X2:  vector of x data
%  Y2:  vector of y data

%  Auto-generated by MATLAB on 11-Apr-2019 10:21:17

% Create figure
figure1 = figure;

% Create subplot
subplot1 = subplot(2,1,1,'Parent',figure1);
hold(subplot1,'on');

% Create plot
plot(X1,Y1,'Parent',subplot1,'DisplayName','Sinal');

% Create ylabel
ylabel('Amplitude [V]');

% Create xlabel
xlabel('Tempo [s]');

% Create title
title('Gera��o de uma sen�ide');

box(subplot1,'on');
% Create legend
legend(subplot1,'show');

% Create subplot
subplot2 = subplot(2,1,2,'Parent',figure1);
hold(subplot2,'on');

% Create plot
plot(X2,Y2,'Parent',subplot2,'DisplayName','FFT');

% Create ylabel
ylabel('Amplitude [dB/Hz]');

% Create xlabel
xlabel('Frequ�ncia [Hz]');

% Create title
title({'FFT da sen�ide gerada'});

box(subplot2,'on');
% Create legend
legend(subplot2,'show');
end
function [vetor_freq, vetor_FFT] = geraFFT (vetor_tempo, vetor_sinal)

ta = vetor_tempo(2) - vetor_tempo(1);   %intervalo de amostragem
Fa = 1/ta;  % taxa de amostragem

deltaf= 1/(ta*tam);
fpos= 0:deltaf:(tam/2)*deltaf;
fneg= -(tam/2-1)*deltaf:deltaf:-deltaf;
vetor_freq = [fneg fpos];

vetor_FFT = fft(vetor_sinal);
end

% Aula 1
function [vetor_tempo, vetor_sinal] = geraSenPorFc (ti, tf, tam, A, fc)

vetor_tempo = linspace(ti, tf, tam);  % gera��o do vetor tempo

vetor_sinal = A*cos(2*pi()*fc*vetor_tempo); % gera��o do sinal senoidal

end
function [vetor_tempo, vetor_sinal] = geraPulsoQuadrado (ti, tf, tam, A)

vetor_tempo = linspace(ti, tf, tam);  % gera��o do vetor tempo

vetor_sinal = zeros(size(vetor_tempo));
vetor_sinal((end/2)-(end/8):(end/2)+(end/8))=A*ones(size(vetor_sinal((end/2)-(end/8):(end/2)+(end/8))));


end



%% Fun��es do AVA

function[Sinal_ff,sinal_tf,f,df] = FFT_pot2(sinal,ts) 
%
% FFT_pot2 --> Gera atransformada de Fourier de um sinal de tempo discreto
%              A sequencia � preenchida com zeros para determinar a resolu��o
%              em frequ�nciafinal df e o o novo sinal � sinal_tf. O
%              resultado est� no vetor Sinal_ff.
%
%  Entradas: 
%              sinal -sinal de entrada
%              ts    -periodo de amostragem 
% 
%       Sa�das: 
%             Sinal_ff -Espectro de amplitude do sinal
%             sinal_tf -Novo sinal no dom�nio do tempo 
%             f        -Vetor frequencia
%             df       -resolu��o no dom�no da frequencia
%
%
% Prof. Jair Silva
% Comunica��o de Dados
% 
% See also: nextpow2 and fft
% =========================================================================
%
fs = 1/ts;            % Taxa de amostragem
ni = length(sinal);      % Tamanho do sinal de entrada
nf = 2^(nextpow2(ni));  % Novo tamanho do sinal

% A transformada via FFT
Sinal_ff = fft(sinal,nf); 
Sinal_ff = Sinal_ff/fs;  

% O novo sinal no dom�nio do tempo
sinal_tf = [sinal,zeros(1,nf-ni)];

% A resolu��o na frequencia
df = fs/nf;

% Vetor frequencia
f = (0:df:df*(length(sinal_tf)-1)) -fs/2;

end % Analisador de Espectro
function y = triangl(t)
y =(1-abs(t)).*(t>=-1).*(t<1); 

% i.e. iguala y a 1 -|t|  se  |t|<1 
% e igula y a zero caso contrario
end % Gera uma onda tri�ngular

%% Aulas Completas do AVA




