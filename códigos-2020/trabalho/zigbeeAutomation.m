load zigbeeAPPCaptures

%% Setup Inicial das variáveis ZigBee

% Configurando o Applications Support Sublayer (APS)
[apsConfig, apsPayload] = zigbee.APSFrameDecoder(motionDetectedFrame);
apsConfig

% Configura o zigBee Cluster Library (ZCL)

[zclConfig, zclPayload] = zigbee.ZCLFrameDecoder(apsPayload, apsConfig.ClusterID);
zclConfig

% Configura o Intruder Alert System ZoneConfig 
% Esse objeto é responsável por simular o Sensor de Movimento
iasZoneConfig = zigbee.IASZoneFrameDecoder(zclPayload)

% Roda o vídeo
helperPlaybackVideo('video.mp4', 2/5);

% objeto da Aplicação com essas variáveis de entrada
apsFrames = {motionDetectedFrame; turnOnFrame; motionStoppedFrame; turnOffFrame};


%% Analisando os frames

for idx = 1:length(apsFrames)
  % decodificação do APS :
  [apsConfig, apsPayload] = zigbee.APSFrameDecoder(apsFrames{idx});
  
  % decodificação do ZCL header:
  [zclConfig, zclPayload] = zigbee.ZCLFrameDecoder(apsPayload, apsConfig.ClusterID);
  zclConfig

  % Configurando a lâmpada (ON-OFF CLUSTER)
  % Não possui um ZCL Payload
  onOffClusterID = '0006';
  if strcmp(apsConfig.ClusterID, onOffClusterID) % SE
    fprintf(['Turn light bulb ' lower(zclConfig.CommandType) '.\n']);
  end

  % Coletando o "payload" de ZCL do Sensor de movimento
  % Sensor de Movimento
  iasZoneClusterID = '0500';
  if ~isempty(zclPayload) && strcmp(apsConfig.ClusterID, iasZoneClusterID)
    iasConfig = zigbee.IASZoneFrameDecoder(zclPayload)

    if any(strcmp('Alarmed', {iasConfig.Alarm1, iasConfig.Alarm2}))
      fprintf('Motion detected.\n');
    else
      fprintf('Motion stopped.\n');
    end
  end
end


% Configurando o PayLoad do Sensor de Movimento para o caso de algum movimento
iasConfigIntrusion = zigbee.IASZoneFrameConfig('Alarm2', 'Alarmed');
zclPayloadIntrusion = zigbee.IASZoneFrameGenerator(iasConfigIntrusion);

% Configurando o Payload do Sensor de Movimento para o caso de nenhum movimento
iasConfigNoIntrusion = zigbee.IASZoneFrameConfig('Alarm2', 'Not alarmed');
zclPayloadNoIntrusion = zigbee.IASZoneFrameGenerator(iasConfigNoIntrusion);

% IAS Zone Cluster = Sensor de Movimento
zclConfigIntrusion = zigbee.ZCLFrameConfig('FrameType', 'Cluster-specific', ...
                                           'CommandType', 'Zone Status Change Notification', ...
                                           'SequenceNumber', 1, 'Direction', 'Downlink');
zclFrameIntrusion = zigbee.ZCLFrameGenerator(zclConfigIntrusion, zclPayloadIntrusion);

% On/Off Cluster = Lâmpada
zclConfigOn = zigbee.ZCLFrameConfig('FrameType', 'Cluster-specific', ...
                                    'CommandType', 'On', ...
                                    'SequenceNumber', 2, 'Direction', 'Uplink');
zclFrameOn = zigbee.ZCLFrameGenerator(zclConfigOn);

% IAS Zone Cluster
apsConfigIntrusion = zigbee.APSFrameConfig('FrameType', 'Data', ...
                                           'ClusterID', iasZoneClusterID, ...
                                           'ProfileID', zigbee.profileID('Home Automation'), ...
                                           'APSCounter', 1, ...
                                           'AcknowledgmentRequest', true);
apsFrameIntrusion = zigbee.APSFrameGenerator(apsConfigIntrusion, zclFrameIntrusion);

% On/Off cluster
apsConfigOn = zigbee.APSFrameConfig('FrameType', 'Data', ...
                                    'ClusterID', onOffClusterID, ...
                                    'ProfileID', zigbee.profileID('Home Automation'), ...
                                    'APSCounter', 2, ...
                                    'AcknowledgmentRequest', true);

                                    
apsFrameOn = zigbee.APSFrameGenerator(apsConfigOn, zclFrameOn);