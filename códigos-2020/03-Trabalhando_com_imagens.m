% Atividade para a aula de 06/10/2020 de Principios de Comunicacao
% Desenvolvido por Ricardo Vieira
% Fonte: https://www.mathworks.com/help/matlab/import_export/record-and-play-audio.html

%% Gravando o Audio
recObj = audiorecorder; %Objeto que vai gravar o audio
disp('Start speaking.')
recordblocking(recObj, 5);%gravando o audio
disp('End of Recording.');
play(recObj); %Ouvindo o oudio gravado

%% Pegando  o sinal do audio gravado 

y = getaudiodata(recObj); y = y.';%Onda de sinal
Fs = recObj.SampleRate;
%Plot Espectro do sinal em dB
[Sinal_ff,sinal_tf,f,df] = FFT_pot2(y,1/Fs) ;
figure; plot(f,30+10*log10(abs(fftshift(Sinal_ff))));
xlabel('Frequencia [Hz]')
ylabel('Densidade de potencia [dBm/Hz]')

%% Modulando Sinal de Audio
Fc_audio = 2000;
s_audio = ssbmod(y,Fc_audio,Fs);                     % Modula o sinal de Audio

%% Lendo Imagem jpg
img_matrix  = imread('puppy.jpg');
image(img_matrix) % Mostrando meu Puppy
img_shape = size(img_matrix);
y_image = reshape(img_matrix,1,[]);
%[sinal_ff,img_y,f,~] = FFT_pot2(y_image,1/Fs) ;
%figure; plot(f,30+10*log10(abs(fftshift(sinal_ff))));

%% Modulando a imagem
%Fc_img = 3000;
%s_img = ssbmod(img_y, Fc_img, Fs);
