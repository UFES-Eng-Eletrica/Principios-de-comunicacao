%%%%%%%%%%%%%%%% SIMULA MULTIPERCURSO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Este script simula os efeitos da comunica??o de sistemas de modula??o   % 
% digital do tipo PSK e QAM em um canal multipercurso.                    %
% O perfil da atenua??o no canal ? designado pela fun??o densidade de     %
% probabilidade Rayleigh.                                                 %
%                                                                         %
% Retidaro do Help do Matlab (ver 2007)                                   %
% by Prof. Dr. Jair A. Lima Silva                                         %
% $ Data: 15/06/2012$                                                     %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parametriza??o 
M   = 4;                % QPSK modulation order
taxaBits = 1000000;     % Taxa de transmiss?o em bps.
ts  = 1/taxaBits;       % periodo de amostragem 
fd  = 4;                % M?ximo desvio de Doppler em Hz
tau = [0 2e-19];         % Vetor de atrasos dos multicaminhos
pdb = [0 0];           % Ganhos de cada percurso em dB
numIter  = 100;         % Quantidade de itera??es do Loop
tp  = 1;                % Tipo de modula??o (0-PSk e 1-QAM)
qtd = 1;                % Quantidade de taps (0-1 e 1-mais de 1)             
snr = 25;               % SNR em dB

% Gera um objeto para a cria??o de um canal com desvanecimento Rayleigh
if qtd == 0
    ch = rayleighchan(ts,fd);
else
    ch = rayleighchan(ts,fd,tau,pdb);
end

%Indica se o filtro tem que ser "resetado" em cada itera??o do loop abaixo
ch.ResetBeforeFiltering = 0;  

% Inicia a plotagem da constela??o com os efeitos do desvanecimento
h = scatterplot(0);

% Aplica o canal em cada sequencia de s?mbolo gerada de forma cont?nua e 
% plota apenas a sequ?ncia corrente na itera??o 
for n = 1:numIter
    % Gera a sequencia de bits
    x = randint(5000,1,M); 

    % Modula??o (M-PSk ou M-QAM)
    if tp == 0
        simb  = pskmod(x,M);
    else
        simb  = qammod(x,M);
    end
    
    % O sinal passa pelo canal com desvanecimento Rayleigh
    sinalMultp = filter(ch, simb); 

    % Adiciona ru?do awgn ao sinal
    sinalMultp  = awgn(sinalMultp,snr,'measured');

    % Plota a constela??o desta itera??o depois de passar pelo canal 
    h = scatterplot(sinalMultp,1,0,'b.',h);
    if M == 4
        axis([-4 4 -4 4])
    else
        axis([-9 9 -9 9])
    end
    drawnow; 
end
%