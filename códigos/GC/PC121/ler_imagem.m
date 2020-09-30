function [IBIN,x,y] =  ler_imagem(arquivo)
  
  I = imread(arquivo);
  [x,y] = size(I);
  I = double(I);    % converte pra double pra poder usar modulação
  IBIN = de2bi(I);         % CONVERTE PARA BINARIO
  IBIN = IBIN';
  IBIN = IBIN(:);

end