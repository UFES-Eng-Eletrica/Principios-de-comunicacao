function [IBIN,x,y] =  ler_imagem(arquivo)
  
  I = imread(arquivo);
  I = I(:, :, 1);
  [x,y] = size(I);
  I = double(I);    % converte pra double pra poder usar modula��o
  IBIN = de2bi(I);         % CONVERTE PARA BINARIO
  IBIN = IBIN';
  IBIN = IBIN(:);

end