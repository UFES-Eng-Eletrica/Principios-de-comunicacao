[audio,Fs] = audioread('audio.wav'); % Carrega o audio padrao.
audio = audio(1:n)';
[voz,Fs2] = audioread('Voz.wav'); % Carrega voz padrao.
voz = voz(1:n)';
% Codificando voz
q_voz = max(abs(voz))/(2^7 - 1); % Quanta de voz.
voz_q = round(voz/q_voz); % Voz quantizada.
bit_sinal_voz = uint8((sign(voz)+1)/2); % 0 eh negativo, 1 eh positivo.
voz_cod = [bit_sinal_voz' de2bi(abs(voz_q'),7)];
voz_cod = reshape(voz_cod',1,[]);

% Codificando audio
q_audio = max(abs(audio))/(2^7 - 1); % Quanta de voz.
audio_q = round(audio/q_audio); % Voz quantizada.
bit_sinal_audio = uint8((sign(audio)+1)/2); % 0 eh negativo, 1 eh positivo.
audio_cod = [bit_sinal_audio' de2bi(abs(audio_q'),7)];
audio_cod = reshape(audio_cod',1,[]);
audio=audio_cod;

y_voz = reshape(y_voz,8,[]);
y_audio = reshape(y_audio,8,[]);
y_voz = bi2de(y_voz');
y_audio = bi2de(y_audio');

bit_sinal_voz = changem(double(bit_sinal_voz),-1,0); % Ajuste de sinal.
y_voz = bit_sinal_voz'.*y_voz; % Aplicando sinal.

bit_sinal_audio = changem(double(bit_sinal_audio),-1,0);
y_audio = bit_sinal_audio'.*y_audio;

%% Desquantizacao

y_voz = y_voz*q_voz/2;
y_audio = y_audio*q_audio/2;

audiofinal=y_audio;