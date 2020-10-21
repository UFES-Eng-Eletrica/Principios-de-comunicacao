clear all;
clc;
close all;
[m,Fs] = audioread('salerno (2).wav');
dt        = 1/Fs;                          % Periodo de amostragem                              
t         = (0:dt:(length(m)-1)*dt).';     % Gera o vetor tempo

% Gerando o Primeiro Gráfico do Aúdio no Domínio do Tempo
figure(1)
subplot(1,2,1);
plot(t,m);
aux= ['Sinal de Audio com Fa = ' num2str(Fs,'%0.2f')];
title(aux);

% Caculando para Transformada de Fourier
fs=1/(t(2)-t(1));   %Calculo do Tempo de Amostragem
nf=2^(nextpow2(size(t,1)));   %Calculando o Tamanho do Vetor Frequência
deltaf=fs/nf;            %Calculando o Intervalo do Vetor Frequência
F=(0:deltaf:(nf-1)*deltaf)-(fs/2);   %Montando o Vetor Frequência
M=fft(m,nf);         %Fazendo o FFT
M=(fftshift(abs(M/fs)));  %Normalizando os valores da FFT

%Gerando o Gráfico no Domínio da Frequência
figure(2);
subplot(1,2,1);
plot(F,10*log10(M));
aux= ['FFT com Fa = ' num2str(fs,'%0.2f')];
title(aux);


%Começando a Codificação PCM
fa=8000;
dt_pcm        = 1/fa;                          % Periodo de amostragem                              
t_pcm         = (0:dt_pcm:t(length(t))).';     % Gera o vetor tempo
n=8; %bits de quantização;
d_v = (max(m)-min(m))/(2^n-1);
m_pcm = [];
i_pcm=1;
for i=1:length(t)
    if t(i) <= t_pcm(length(t_pcm)) & t(i) >= t_pcm(i_pcm)
       m_pcm(i_pcm,:) = min(m);
       while m_pcm(i_pcm) < m(i)
           m_pcm(i_pcm,1)=m_pcm(i_pcm,1)+d_v(1);
           m_pcm(i_pcm,2)=m_pcm(i_pcm,2)+d_v(2);
       end
       i_pcm=i_pcm+1;
    end
end
m_pcm(i_pcm,:) = min(m);
while m_pcm(i_pcm) < m(length(t))
   m_pcm(i_pcm,1)=m_pcm(i_pcm,1)+d_v(1);
   m_pcm(i_pcm,2)=m_pcm(i_pcm,2)+d_v(2);
end
figure(1);
subplot(1,2,2);
plot(t_pcm,m_pcm);
aux= ['Senóide Para Fa = ' num2str(fa,'%0.2f')];
title(aux);
sound(m_pcm,fa);


% Caculando para Transformada de Fourier
fs=1/(t_pcm(2)-t_pcm(1));   %Calculo do Tempo de Amostragem
nf=2^(nextpow2(size(t_pcm,1)));   %Calculando o Tamanho do Vetor Frequência
deltaf=fs/nf;            %Calculando o Intervalo do Vetor Frequência
F=(0:deltaf:(nf-1)*deltaf)-(fs/2);   %Montando o Vetor Frequência
M_pcm=fft(m_pcm,nf);         %Fazendo o FFT
M_pcm=(fftshift(abs(M_pcm/fs)));  %Normalizando os valores da FFT

%Gerando o Gráfico no Domínio da Frequência
figure(2);
subplot(1,2,2);
plot(F,10*log10(M_pcm));
aux= ['FFT com Fa = ' num2str(fs,'%0.2f')];
title(aux);
