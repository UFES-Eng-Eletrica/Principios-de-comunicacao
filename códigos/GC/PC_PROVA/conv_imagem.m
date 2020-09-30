function [IM_REC] = conv_imagem(IMRBIN,x,y)
  
  IM_REC = vec2mat(IMRBIN,8); 

IM_REC = bi2de (IM_REC);

IM_REC = vec2mat(IM_REC,x);

IM_REC = uint8(IM_REC)';

%imshow(IM_REC);
  
end