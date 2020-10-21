%% Atividade para a aula de 13/10/2020 de Principios de Comunicacao
%  Fonte: https://www.mathworks.com/help/matlab/import_export/record-and-play-audio.html
%% Gravando o Audio
recObj = audiorecorder; %Objeto que vai gravar o audio
disp('Start speaking.')
recordblocking(recObj, 5);%gravando o audio
disp('End of Recording.');
play(recObj); %Ouvindo o oudio gravado

%% Pegando  o sinal do audio gravado 

y = getaudiodata(recObj); y = y.';%Onda de sinal
Fs = recObj.SampleRate; % Taxa de Amostragem
ts = 1/Fs; % Periodo de amostragem
t = 0:ts:(length(y)-1)*ts;
figure, plot(t,y), xlabel('Tempo (s)'), ylabel('Amplitude (u.A.)')
%Plot Espectro do sinal em dB
[Sinal_ff,sinal_tf,f,df] = Analisador_de_Espectro(y,1/Fs) ;
figure; plot(f,10*log10(abs(fftshift(Sinal_ff))));
xlabel('Frequencia [Hz]')
ylabel('Densidade de potencia [dB/Hz]')

%% Filtragem do Sinal de Voz
fcorte1 = 0.5;    % Frequencia de corte do filtro  
ordem   = 21;     % Ordem do filtro passa baixas
tam = length(y);
% Geração do filtro passa baixas               
h = fir1(ordem,fcorte1);  %Filtro 
%figure, freqz(h,1,128)  % Filtro para baixa memoria
figure, freqz(h,1,tam)  % Plota a resposta do filtro

% Filtra sinal de som no dominio de tempo (convolucao)
y_filt = filter(h,1,y);

sound(y, Fs); %Som do Sinal original
sound(y_filt, Fs); %Som do Sinal filtrado

[Sinal_ff_filt,~,f,~] = Analisador_de_Espectro(y_filt,1/Fs) ;
plot(f,10*log10(abs(fftshift(Sinal_ff_filt))));