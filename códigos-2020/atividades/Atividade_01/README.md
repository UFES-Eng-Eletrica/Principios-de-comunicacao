# atividade-01

O foco desta atividade é trabalhar com **Amostragem** de sinais nos domínios da frequência e do tempo.

## FFT_pot2.m

**Este arquivo é também conhecido como "Analisador_de_Espectro.m".**  
Os dois arquivos são iguais. Você usa essa enviando **dois** parâmetros de entrada e recebendo **quatro** parâmetros de saída.  
Entradas:
* sinal -> sinal de entrada para ser amostrado
* ts    -> período (tempo) de amostragem  
Saídas:
* Sinal_ff -> Espectro de amplitude do sinal (é o que chamamos de fft, eu acho)
* sinal_tf -> Novo sinal no domínio do tempo
* f        -> Vetor contendo as frequências
* df       -> Resolução no domínio da frequência (diferença de uma frequência para outra)
