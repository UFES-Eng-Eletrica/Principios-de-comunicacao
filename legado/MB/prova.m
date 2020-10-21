% Funções para a prova de laboratório de Princípios de Comunicação 1
% Aluno: Maiky Barreto da Silva

%% Parâmetros
% Parâmetros gerais da Transmissão
M=      8;         % quantidade de símbolos
k=      log2(M);    % quantidade de bits para representar os símbolos
nsamp=  1;          % quantidade de amostras
snr=    19;         % relação sinal-ruído

% Parâmetros específicos para a transmissão de imagem
nome_foto_1 = 'foto1.jpg';     % nome do arquivo de imagem 1
nome_foto_2 = 'foto2.jpg';      % nome do arquivo de imagem 1

%% Processamento
close all

% Transmissor

% Leitura das Fotos
foto_1 = imread(nome_foto_1);
foto_2 = imread(nome_foto_2);

% Redimensionamento das fotos
foto_1 = imresize(foto_1, [252, 252], 'bicubic');
foto_2 = imresize(foto_2, [252, 252], 'bicubic');

% Codificando Foto 1
imagem_pb1 = rgb2gray(foto_1); % Transforma RGB em PB
imagem_pb1 = double(imagem_pb1); % Transforma uint8 em double para manuseamento da foto
[lin1, col1] = size(imagem_pb1); % Obtém linhas e colunas para reconstrução da imagem no receptor
imagem_lin1 = reshape(imagem_pb1, lin1*col1, []); % Transforma em vetor
imagem_bin1 = de2bi(imagem_lin1); % Transforma em binário
[lin12, col12] = size(imagem_bin1); % Obtém linhas e colunas para reconstrução do vetor no receptor
imagem_cod1 = reshape(imagem_bin1.', k, []); % Transforma em matriz com k colunas
x1 = bi2de(imagem_cod1'); % Transforma em codificação p/ QAM

% Modulação da foto 1
xmod1 = qammod(x1,M); % Modula para Transmissão
x_up1 = rectpulse(xmod1,nsamp); % Aplica o sinal anterior em um sinal retangular


% Codificando Foto 2
imagem_pb2 = rgb2gray(foto_2);
imagem_pb2 = double(imagem_pb2);
[lin2, col2] = size(imagem_pb2);
imagem_lin = reshape(imagem_pb2, lin2*col2, []);
imagem_bin2 = de2bi(imagem_lin);
[lin22, col22] = size(imagem_bin2);
imagem_cod2 = reshape(imagem_bin2.', k, []);
x2 = bi2de(imagem_cod2');

% Modulando Foto 2
xmod2 = qammod(x2,M);
x_up2 = rectpulse(xmod2,nsamp);

% Preparando Multiplexação
sinal1 = x_up1;    
sinal2 = x_up2; 

tvet=2*max([length(sinal1) length(sinal2)]); 
x_up = zeros(tvet,1);     

temp = sinal1;
sinal1 = zeros(tvet,1);
sinal1(1:length(temp)) = temp; 

temp = sinal2;
sinal2 = zeros(tvet,1);
sinal2(1:length(temp)) = temp; 

clear temp;

% Multiplexando
for i=0:(tvet/2-1)
    x_up(2*i+1) = sinal1(i+1);  % Preenchendo o vetor com a 1a imagem
    x_up(2*i+2) = sinal2(i+1);  % Preenchendo o vetor com a 2a imagem
end

% Fim do Transmissor

% Canal

% Adicionando Ruido
y_ruido = awgn(x_up,snr,'measured');

% Fim do Canal

% Receptor

% Demultiplexando
for i=0:(tvet/2-1)
    sinal12(1+i) = y_ruido(1 + i*2);   % Repreenchendo o vetor da 1a imagem
    sinal22(1+i) = y_ruido(2 + i*2);   % Repreenchendo o vetor da 2a imagem
end

% Demodulando Foto 1
y_down1 = intdump(sinal12,nsamp);
y1 = qamdemod(y_down1,M);

% Demodulando Foto 2
y_down2 = intdump(sinal22,nsamp);
y2 = qamdemod(y_down2,M);  

% Decodificando Foto 1
y_cod1 = de2bi(y1,k);
y_cod1 = y_cod1';
y_bin1 = reshape(y_cod1, col12, []);
y_mod1 = bi2de(y_bin1');
y_final1 = reshape(y_mod1, col1, []);
y_final1 = uint8(y_final1);

% Decodificando Foto 2
y_cod2 = de2bi(y2,k);
y_cod2 = y_cod2';
y_bin2 = reshape(y_cod2, col22, []);
y_mod2 = bi2de(y_bin2');
y_final2 = reshape(y_mod2, col2, []);
y_final2 = uint8(y_final2);

% Fim do Receptor

%% Plotagem

% Imagens
subplot(2,2,1);
imshow(uint8(imagem_pb1));
title('Imagem 1 Transmitida');
subplot(2,2,2);
imshow(uint8(imagem_pb2));
title('Imagem 2 Transmitida');
subplot(2,2,3);
imshow(uint8(y_final1));
title('Imagem 1 Recebida');
subplot(2,2,4);
imshow(uint8(y_final2));
title('Imagem 2 Recebida');

% Sinal na entrada do canal e na saída do canal
t = 0:1/1e6:length(y_ruido)/1e6;
figure;
plot(t(1:nsamp*50),real(x_up(1:nsamp*50)))  
hold on
plot(t(1:nsamp*50),real(y_ruido(1:nsamp*50)),'r')
title('Sinal na Saída do Transmissor e na Entrada do Receptor');

% FFT no receptor
figure;
[a11,a12,a13,a14] = FFT_pot2(y_ruido', t(2)-t(1));
plot(a13, db(fftshift(abs(a11))));
title('FFT no Receptor');


% Diagrama de Constelações
% figure;
% scatterplot(y_down1)
figure;
plot(real(y_down1), imag(y_down1), 'r.', real(xmod1),imag(xmod1),'b.')
hold on;
plot(real(y_down2), imag(y_down2), 'r.', real(xmod2),imag(xmod2),'b.')
title('Diagrama de Constelação');


%% Funções
%% Canal de Transmissão
function [y_down, y_ruido, x_up] = Canal(xmod, snr)

x_up = rectpulse(xmod,nsamp);
y_ruido = awgn(x_up,snr,'measured');
y_down = intdump(y_ruido,nsamp);

end

%% Audio/Voz
function [x,col] = CodificaAudio(nome_audio, offset, resolucao, k)

data_mod = (nome_audio+offset)*(2^resolucao);
data_bin = de2bi(data_mod);
[lin, col] = size(data_bin);
data_cod = reshape(data_bin.', k, []);
x = bi2de(data_cod');

end

function [y_decod] = DecodificaAudio(y, offset, resolucao, col)

y_cod = de2bi(y);
y_bin = reshape(y_cod.', col, []);
y_mod = bi2de(y_bin');
y_decod = y_mod/(2^resolucao)-offset;

end

%% Imagem
function [x, col, col2] = CodificaImagem(nome_foto)

imagem_pb = rgb2gray(nome_foto);
imagem_pb = double(imagem_pb);
[lin, col] = size(imagem_pb);
imagem_lin = reshape(imagem_pb, lin*col, []);
imagem_bin = de2bi(imagem_lin);
[lin2, col2] = size(imagem_bin);
imagem_cod = reshape(imagem_bin.', k, []);
x = bi2de(imagem_cod');

end

function [y_final] = DecodificaImagem(y, k, col, col2)

y_cod = de2bi(y,k);
y_cod = y_cod';
y_bin = reshape(y_cod, col2, []);
y_mod = bi2de(y_bin');
y_final = reshape(y_mod, col, []);
y_final = uint8(y_final);

end

%% Cálculo dos Erros
function [n_erros, ber_awgn, erro] = Erros(x,y)
d_bit    = (abs(x-y));
n_erros  = sum(d_bit);
ber_awgn = mean(d_bit);
erro = n_erros/n;
end

%% Outros
function[Sinal_ff,sinal_tf,f,df] = FFT_pot2(sinal,ts) 
%
% FFT_pot2 --> Gera atransformada de Fourier de um sinal de tempo discreto
%              A sequencia é preenchida com zeros para determinar a resolução
%              em frequênciafinal df e o o novo sinal é sinal_tf. O
%              resultado está no vetor Sinal_ff.
%
%  Entradas: 
%              sinal -sinal de entrada
%              ts    -periodo de amostragem 
% 
%       Saídas: 
%             Sinal_ff -Espectro de amplitude do sinal
%             sinal_tf -Novo sinal no domínio do tempo 
%             f        -Vetor frequencia
%             df       -resolução no domíno da frequencia
%
%
% Prof. Jair Silva
% Comunicação de Dados
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

% O novo sinal no domínio do tempo
sinal_tf = [sinal,zeros(1,nf-ni)];

% A resolução na frequencia
df = fs/nf;

% Vetor frequencia
f = (0:df:df*(length(sinal_tf)-1)) -fs/2;

end % Analisador de Espectro

% Filtro de áudio em 4khz
% filtro = designfilt('lowpassfir', 'PassbandFrequency', .45, 'StopbandFrequency', 4000, 'PassbandRipple', 1, 'StopbandAttenuation', 60, 'SampleRate', voz.SampleRate); % cria o filtro
% voz_filtrada = filter(filtro, getaudiodata(voz)); % filtra o audio

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
title('Geração de uma senóide');

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
xlabel('Frequência [Hz]');

% Create title
title({'FFT da senóide gerada'});

box(subplot2,'on');
% Create legend
legend(subplot2,'show');
end





