function [saida] = conv_audio(vetorbin,amplitude,absoluto,n)
  
  %retornando para dimensoes reais do sinal
  
 N = 2^n;
saidabin = reshape(vetorbin',n,length(vetorbin)/n);
saidabin = saidabin';

saidadec = bi2de(saidabin);
saidadec = saidadec';

saida = saidadec*(amplitude/(N-1));
saida = saida - absoluto;
saida = saida';
end