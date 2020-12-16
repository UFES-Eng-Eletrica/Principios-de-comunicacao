% Creation of configuration object for Identify cluster
identifyConfigTx = zigbee.IdentifyFrameConfig('CommandType', 'Identify','IdentifyTime', 4);

% Frame generation (ZCL payload) for Identify cluster
identifyPayload = zigbee.IdentifyFrameGenerator(identifyConfigTx);

identifyConfigRx = zigbee.IdentifyFrameDecoder('Identify', identifyPayload)

bulb = plotBulb('white');
zigbeeIdentifyBulb(bulb, identifyConfigRx.IdentifyTime);
close(bulb);

bulb = plotBulb('red');

% Creation of configuration object for Color Control cluster
colorCtrlConfigTx = zigbee.ColorControlFrameConfig('CommandType', 'Move to Color', ...
                                                   'ColorX', 16384, 'ColorY', 39322, 'Time', 50);

% Frame generation (ZCL payload) for Color Control cluster
colorControlPayload = zigbee.ColorControlFrameGenerator(colorCtrlConfigTx);

colorCtrlConfigRx = zigbee.ColorControlFrameDecoder('Move to Color', colorControlPayload)

zigbeeMoveBulbColor(bulb, colorCtrlConfigRx.ColorX, colorCtrlConfigRx.ColorY, colorCtrlConfigRx.Time);

colorCtrlConfigTx2 = zigbee.ColorControlFrameConfig('CommandType', 'Move to Color', ...
                                                   'ColorX',  19661, 'ColorY', 6554, 'Time', 50);
colorControlPayload2 = zigbee.ColorControlFrameGenerator(colorCtrlConfigTx2);
colorCtrlConfigRx2 = zigbee.ColorControlFrameDecoder('Move to Color', colorControlPayload2);
zigbeeMoveBulbColor(bulb, colorCtrlConfigRx2.ColorX, colorCtrlConfigRx2.ColorY, colorCtrlConfigRx2.Time);

pause(1.5);

% Creation of Level Control cluster configuration object
levelCtrlConfigTx = zigbee.LevelControlFrameConfig('CommandType', 'Move to Level', ...
                                                   'Level', 20, 'TransitionTime', 1);

% Level Control cluster frame generation (ZCL payload)
levelControlPayload = zigbee.LevelControlFrameGenerator(levelCtrlConfigTx);

levelCtrlConfigRx = zigbee.LevelControlFrameDecoder('Move to Level', levelControlPayload)

zigbeeMoveBulbColor(bulb, colorCtrlConfigRx2.ColorX, colorCtrlConfigRx2.ColorY, 1, levelCtrlConfigRx.Level);

% Creation of Scenes cluster configuration object
scenesConfigTx = zigbee.ScenesFrameConfig('CommandType', 'View Scene', ...
                                          'GroupID', '1234', 'SceneID', '56');

% Scenes cluster frame generation (ZCL payload)
scenesPayload = zigbee.ScenesFrameGenerator(scenesConfigTx);

scenesConfigRx = zigbee.ScenesFrameDecoder('View Scene', scenesPayload)

% Creation of Groups cluster configuration object
groupsConfigTx = zigbee.GroupsFrameConfig('CommandType', 'Add group', ...
                        'GroupName', 'Dining Hall', 'GroupID', '1234');

% Groups cluster frame generation (ZCL payload)
groupsPayload = zigbee.GroupsFrameGenerator(groupsConfigTx);

groupsConfigRx = zigbee.GroupsFrameDecoder('Add group', groupsPayload)

% ZLL profile ID
zllProfileID = zigbee.profileID('Light Link');

payloadsWithInfo(1) = struct('Payload',   identifyPayload,       'ProfileID',   zllProfileID, ...
                             'ClusterSpecific', true,            'ClusterID',   zigbee.clusterID('Identify'),       'CommandType', 'Identify',      'Direction', 'Uplink');
payloadsWithInfo(2) = struct('Payload',   colorControlPayload,   'ProfileID',   zllProfileID, ...
                             'ClusterSpecific', true,            'ClusterID',   zigbee.clusterID('Color Control'),  'CommandType', 'Move to Color', 'Direction', 'Uplink');
payloadsWithInfo(3) = struct('Payload',   levelControlPayload,   'ProfileID',   zllProfileID, ...
                             'ClusterSpecific', true,            'ClusterID',   zigbee.clusterID('Level Control'),  'CommandType', 'Move to Level', 'Direction', 'Uplink');
payloadsWithInfo(4) = struct('Payload',   scenesPayload,         'ProfileID',   zllProfileID, ...
                             'ClusterSpecific', true,            'ClusterID',   zigbee.clusterID('Scenes'),         'CommandType', 'View Scene',    'Direction', 'Uplink');
payloadsWithInfo(5) = struct('Payload',   groupsPayload,         'ProfileID',   zllProfileID, ...
                             'ClusterSpecific', true,            'ClusterID',   zigbee.clusterID('Groups'),         'CommandType', 'Add group',     'Direction', 'Uplink');

% Add headers from other layers/sublayers:
MPDUs = zigbeeAddProtocolHeaders(payloadsWithInfo);

% Export MPDUs to a PCAP format
zigbeeExportToPcap(MPDUs, 'zigbeeLightLink.pcap');

% Open PCAP file with Wireshark