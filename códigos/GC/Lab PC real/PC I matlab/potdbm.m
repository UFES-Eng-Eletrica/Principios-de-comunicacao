%% funcao potencia dbm
function [pmn1,pmndbm1] = potdbm(sinal)

%calcula a potencia media normalizada do sinal amostrado
%é preciso verificar se o valor encontrado pode ou não ser considerado
%infinito

pmn1=sum(abs(sinal).^2)/length(sinal); % somatorio de 
%todos os termos do vetor sinal, elevacoes de seus modulos ao quadrado 
%e divisao dessa soma pelo tamanho length do vetor

pmndbm1=10*log10(pmn1/1e-3); % 10log10 pois é sinal de potencia
%se fosse de tensão ou corrente, seria 20log10. valor em dBm