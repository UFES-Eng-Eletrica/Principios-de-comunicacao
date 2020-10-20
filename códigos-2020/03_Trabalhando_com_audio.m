%% Definindo valores de gravacao
Fs = 10e3; % Frequencia de amostragem do sinal
bits_canal = 8; %Salva dados em 8, 16 ou 32 bits
num_canal = 1; %Numero de canais que serao gravados
secs = 5; %Tempo de gravacao

%% Gravando o Audio
recObj = audiorecorder(Fs,bits_canal,num_canal); %Objeto que vai gravar o audio
disp('Start speaking.')
recordblocking(recObj, secs);%gravando o audio
disp('End of Recording.');
%play(recObj); %Ouvindo o oudio gravado

%% Pegando  o sinal do audio gravado 
y = getaudiodata(recObj); y = y.';%Onda de sinal
clear recObj; %Onda de sinal salva, descartando recorder
%sound(y, Fs); %Reproduzindo o sinal %Acontece depois
filename = 'wavesound.wav'; %Nome do arquivo de saida
audiowrite(filename,y,Fs); %Salvando audio de saida
[y_r, Fs_r] = audioread(filename); % Lendo do arquivo de saida
sound(y_r, Fs_r); %Ouvindo o audio salvo no aquivo
%Limpando inuteis
clear y_r; %Vc ja tem y
clear Fs_r;%Vc ja tem Fs