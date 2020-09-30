%
% Gera uma onda triangular

function y = triangl(t)
y =(1-abs(t)).*(t>=-1).*(t<1); 

% i.e. iguala y a 1 -|t|  se  |t|<1 
% e igula y a zero caso contrario