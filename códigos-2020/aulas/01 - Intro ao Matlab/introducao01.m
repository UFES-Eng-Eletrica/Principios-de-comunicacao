% Feito por Arthur Lorencini Bergamaschi

%% Definiçao, operaçao e manipulaçao de matrizes
% Feito por Arthur Lorencini
% Você, se preferir, pode executar as seçoes dos codigos, ao inves dele
% todo.
% https://drive.google.com/file/d/18vLNOOaoxAz0eBMpkflp_K3kV3wmkydP/view
a = [1,2,3] ;% vetor linha
b = [1;2;3] ;% vetor coluna
c = 1:5:30 ; % vetor linha sucinto
d = linspace(0,100,10); % start incluso, stop incluso, n of terms

%% Exemplo de aplicaçao

t = linspace(0,0.4e-6,100);
ta = t(2) - t(1);
t(2); % acessa o segundo elemento do vetor
deltaf = 1/ta;
fpos = 0:deltaf:(100/2)*deltaf;
fneg = -(100/2 - 1)*deltaf:deltaf:-deltaf;
f = [fpos fneg];

%% Criaçao de matrizes
m = [1 2 3; 4 5 6 ; 7 8 9]
m2 = [1 2 3;
      4 5 6;
      7 8 9]
m2' % matriz transposta
%% Matrizes uteis
zeros(1,2);
ones(1,2);
eye(10);
rand(3,4)
randn(4,4)
%% Operacoes com matrizes
% m(1) acessa o primeiro valor da matriz (e isso é muito podre, desculpa.) 
%% Operações de plot
% figure
% plot(x,y,x1,y1,...,xn,yn)