# códigos

Usualmente, tira-se os números do nome do código para poder chamar as funções dentro do código do MatLab.
00_Leitura_de_audio.m -> Leitura_de_audio.m

# AVISO

Todos os códigos podem conter erros. Se você identificar um, por favor, corrija e suba a versão certa. Obrigado s2.  

## OUTRO AVISO

Dependendo da versão do seu MatLab, pode ser que algumas funções estejam mais velhas do que a estrutura curricular da engenharia elétrica. Recomenda-se utilizar sempre a versão mais atual do MatLab, de preferência, rodando a versão gratuita (que expira em 30 dias ou em 300 anos :parrot: )

## MAIS UM AVISO

Existem códigos nas outras pastas de atividades, por exemplo, que não estão compiladas aqui.

## Leitura de Audio

Pega um sinal de áudio e plota ele na frequência e no tempo. Nada mais.

## Comandos Basicos

Código feito pelo Ricardo Silva para auxiliar o entendimento da matéria e na tradução para coisas inteligíveis.  Não se sabe se o código está completo.

## Trabalhando com Analisador de Espectro

Novamente feito pelo Deus Ricardo Silva. Código que faz chamada das funções do **FFT_pot2, AWGN, SSBMOD**. Código feito durante as aulas de qualidade duvidosa.

## Filtragem de Sinal

Acredito que esse código foi feito pelo Gustavo Martins. Parecido com a analisador de espctro acima, ela envolve filtragem de sinais e alteração das frequências de corte.

## Trabalhando com audio

Código para gravar um audio utilizando o MatLab. Logo em seguida, o audio é tocado.

## Trabalhando com imagens

Com uma imagem, passamos um filtro de *grayscale* para transmitir a imagem futuramente.

## am_dsb_sc, am_dsb_tc e am_SSB_sc

Códigos feitos durante a aula para ver o efeito das modulações no sinal.

# Analisador_de_espectro

Também conhecida como FFT_pot2.m. Faz exatamente a mesma merda, mas alguns códigos fazem a chamada da função analisador_de_espectro ao invés de FFT_pot2.m. **Tenha cuidado na hora de importar as funções.**

## Embaralhador de audio do GustaGol

Análogo ao arquivo **Embaralhador_Audio.m**, ele joga um audio e vai fazendo mudanças em algumas variáveis e vendo o efeito dela ao passar do código.

## Embaralhador Audio (Do Jair)

Arquivo necessário para realização de alguns laboratórios. Ele aplica **AWGN** e **SSBMOD** nos sinais.

## FFT_pot2.m

Serve para fazer a FFT de um sinal 'contínuo'. Você passa o sinal x(t) e o ts (período de amostragem, eu acho). Ele te retorna 4 variáveis, conforme o código explica internamente. É análoga ao arquivo **Analisador_de_Espectro.m**.

## filtromodulador.m

Não tenho ideia do que esse arquivo faz ou para que ele presta. Quem souber, favor mudar essa linha.

## lab4_senoides_QAM_SSB.m

Zero ideia também, mas acredito que seja utilizado em alguma das atividades. Feito pelo Jair.

## Multiplexacao_TDM_ver_aluno.m

Multiplexação TDM. É, eu não estudei e não se o que é. Quando eu descobrir, te aviso.

## sistema_pam_awgn.m

Transmissão PAM com ruído branco feito pelo JAIR.