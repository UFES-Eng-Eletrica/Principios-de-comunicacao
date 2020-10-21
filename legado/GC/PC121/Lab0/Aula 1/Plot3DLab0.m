% PC I - Laboraório 0 - 03/04/2018
% Wagner Trarbach Frank

% Plots em 3D
% Uso do comando mesh
% Código da página 55 do slide do Lab 0 do AVA

%% 

x = -7.5:0.5:7.5;  % vetor x variando de -7.5 a 7.5 com passo de 0.5

y = x;

[X,Y] = meshgrid(x,y);

R = sqrt(X.^2 + Y.^2) + eps;

Z = sin(R)./R;    % sinc x = (senx)/x

mesh(X,Y,Z)