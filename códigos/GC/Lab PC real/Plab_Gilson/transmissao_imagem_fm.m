%                                                  
% .................... Principios de Comunicacoes I........................
% 
% Lab IV (cont - com Transmiss?o de imagem)
% 
% Modulacao FM   - Segunda parte   
%
% by Jair Silva
% UFES/2014
% .........................................................................
%
clc, clear all, close all
%
% ............... Dados de entrada ........................................
dev_freq = 0.1;   % desvio frequencia
Fc = 1000;        % Frequencia da portadora
fs = 10000;        % Taxa de amostragem 
B  = 600;         % indice de modulacao angular 
snr = 1000;         % Relacao Sinal-Ruido 
ch = 1;           % Tipo de canal: 0-B2B e 1-AWGN

% ............ Geracao do sinal modulante .................................
imagem = imread('imagem_cinza.gif');  % leitura da imagem em escla de cinza
[x,y] = size(imagem);                 % encontra o tamanho da matriz pixels
imshow(imagem);                       % mostra a imagem original (figura 1)
vetor_im = imagem(:);                 % transforma em vetor
vetor_im = vetor_im';                 % transforma em vetor coluna
m = double(vetor_im);                 % transforma de inteiro para double
t = linspace(0,fs-1,length(m))./fs;   % cria o vetor tempo (n?o usado)

% ............ Modulacao FM ...............................................
s = fmmod(m,Fc,fs,dev_freq);    % usando o comando fmmod 

% ............... Canal ...................................................
if ch == 0
    r = s;            % B2B
else
    r = awgn(s,snr);  % com ru?do AWGN
end
% ............ Demodulacao FM .............................................
% r_demod= 100*demod(r,Fc,fs,'fm',1);  % com comando demod
r_demod= fmdemod(r,Fc,fs,dev_freq);  % com comando demod


% ================ Mostra a imagem demodulada =============================
figure;                                       % figura 2
imag_demod = uint8(r_demod);              % transforma para inteiro 
[imagem_demod,paded] = vec2mat(imag_demod,x); % transforma em matriz
imagem_demod = imagem_demod';                 % trabalha a matriz
imshow(imagem_demod);                         % mostra a imagem demodulada
