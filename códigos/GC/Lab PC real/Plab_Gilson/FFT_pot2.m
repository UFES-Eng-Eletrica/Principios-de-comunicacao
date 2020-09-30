%
% =========================================================================
function [Sinal_ff,sinal_tf,f,df] = FFT_pot2(sinal,ts) 
%
% FFT_pot2 --> Gera a transformada de Fourier de um sinal de tempo discreto
%              A sequencia ? preenchida com zeros para determinar a resolu??o
%              em frequencia final df e o o novo sinal ? sinal_tf. O
%              resultado est? no vetor Sinal_ff
%
%     Entradas: 
%              sinal - sinal de entrada
%              ts    - periodo de amostragem 
% 
%       Sa?das: 
%             Sinal_ff - Espectro de amplitude do sinal
%             sinal_tf - Novo sinal no dom?nio do tempo 
%             f        - Vetor frequencia
%             df       - resolu??o no dom?no da frequencia
%
%
% Prof. Jair Silva
% Comunica??o de Dados
% 
% See also: nextpow2 and fft
% =========================================================================
%
fs = 1/ts;               % Taxa de amostragem
ni = length(sinal);      % Tamanho do sinal de entrada
nf = 2^(nextpow2(ni));   % Novo tamanho do sinal

% A transformada via FFT
Sinal_ff = fft(sinal,nf); 
Sinal_ff = Sinal_ff/fs;  % Qual a raz?o disto?

% O novo sinal no dom?nio do tempo
sinal_tf = [sinal,zeros(1,nf-ni)];

% A resolu??o na frequencia
df = fs/nf;

% Vetor frequencia
f = (0:df:df*(length(sinal_tf)-1)) - fs/2;

% EOF