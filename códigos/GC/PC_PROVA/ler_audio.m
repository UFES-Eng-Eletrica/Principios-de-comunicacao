function [DATA, amplitude,absoluto,Fs] = ler_audio(arquivo,n)
  
  [AUDIO, Fs] = audioread(arquivo);
  AUDIO = AUDIO(:,1);
  [XAUDIO, YAUDIO] = size(AUDIO);
 % plot(AUDIO);

%n = 8;       % bits para representacao
N = 2^n;     % niveis

vetor = AUDIO;

amplitude = abs(max(vetor)) + abs(min(vetor));
absoluto = abs(min(vetor));   %usado para jogar todo o sinal para a parte positiva do eixo Y

%quantizando
vetor = vetor + absoluto;
vetor = vetor*((N-1)/amplitude);
vetorquantizado = round(vetor);

%transformando em um vetor de bits
vetorbin = de2bi(vetorquantizado);
vetorbin = vetorbin';
vetorbin = vetorbin(:); %vetor pronto para ser enviado
  DATA  = vetorbin;
end