global status;
status = 1;

%% Constants
brokerAddress = "mqtt://broker.hivemq.com";
port = 1883;
clientID = "matlab2";

trafficLightList = table();
vehicleList = table();

%% Environment variables
global status;
tlThreshold = 10;
vehicleThreshold = 10;
delayTime = 0.2;

%% MQTT connection and subscriptions
% mqClient = mqttclient(brokerAddress, Port = port, ClientID = clientID, ...
%    Username = userName, Password = password);

mqClient = mqttclient(brokerAddress, Port = port, ClientID = clientID);

trafficLightTopic = "trafficLight/info";
vehicleTopic = "vehicle/info";
weatherTopic = "weather/info";
parkingTopic = "parking/info";
subscribe(mqClient, trafficLightTopic+"/+");
subscribe(mqClient, vehicleTopic);
subscribe(mqClient, weatherTopic);
subscribe(mqClient, parkingTopic);

%% Create UI: close button, map & buildings
% Generate parking buildings
[building_names,building_coordinates,vacantParking] = generateBuildings();


fig = uifigure;
p = uipanel(fig, "Title", "ADMIT14-BackEnd", "Position", [5 5 550 410]);
btnStop = uibutton(p, "Text", "Stop", "ButtonPushedFcn", @btnStop_Callback, ...
    "Position", [200, 360 100 25]);

baseAx = axes(p);
hold(baseAx,'on');

dynamicAx = axes(p, "Color", "none");
hold(dynamicAx,'on');
xlim(dynamicAx, [0 90]);
ylim(dynamicAx, [0 120]);

drawMap(baseAx, building_coordinates);

%% Main program loop, Interrupt and clear memory
while 1
    drawnow
    pause(delayTime);
    if status == 0
        save("lastRun", "trafficLightList", "vehicleList");
        % Stop the if cancel button was pressed
        %clear
        disp('Back-end stopped');
        close(fig);
        clear
        break;
    end
    
    %% Read data in mqtt buffer, add elseif for each topic to handle
    mqttData = read(mqClient);
    if ~isempty(mqttData)
        %Only for testing and data view
        mqttData
        for i=1: size(mqttData, 1)
            % Function for data reading and SYNC logic
            if startsWith(mqttData.Topic(i), trafficLightTopic)
                trafficLightList = trafficLightRead(mqttData(i,:).Data, trafficLightList);
            elseif startsWith(mqttData.Topic(i), vehicleTopic)
                vehicleList = vehicleRead(mqttData(i,:).Data, vehicleList);
            elseif startsWith(mqttData.Topic(i), weatherTopic)
                weatherRead(mqttData(i,:).Data,mqClient);
            elseif startsWith(mqttData.Topic(i), parkingTopic)    
                parkingLogic(mqttData(i,:).Data,mqClient, building_coordinates,building_names, vacantParking);
            end
        end
    end

    %% ASYNC LogicFunctions
    trafficLightLogic(trafficLightList, vehicleList, tlThreshold, mqClient);
    collisionLogic(vehicleList, vehicleThreshold, mqClient);

    % Add here code to draw a pretty map
    updateUIElemetns(dynamicAx, vehicleList, trafficLightList);
end
