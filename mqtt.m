%% Constants
brokerAddress = "mqtt://192.168.0.104";
port = 1883;
clientID = "matlab";
%userName = "Your Username";
%password = "Your Password";

% UNCOMMENT
trafficLightList = table();
vehicleList = table();

%% Environment variables
tlThreshold = 10;
delayTime = 1;

%% MQTT connection and subscriptions
% mqClient = mqttclient(brokerAddress, Port = port, ClientID = clientID, ...
%    Username = userName, Password = password);

mqClient = mqttclient(brokerAddress, Port = port, ClientID = clientID);

trafficLightTopic = "trafficLight/info";
vehicleTopic = "vehicle/info";
subscribe(mqClient, trafficLightTopic+"/+");
subscribe(mqClient, vehicleTopic+"/+");

%% Create button to stop execution
ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop back-end', ...
                         'Callback', 'delete(gcbf)');
ButtonHandle.Position = [100 200 300 40];

%% Main program loop, Interrupt and clear memory
while 1
    pause(delayTime);
    if ~ishandle(ButtonHandle)
        % Stop the if cancel button was pressed
        clear mqClient
        %clear
        disp('Back-end stopped');
        break;
    end

    %% Read data in mqtt buffer, add elseif for each topic to handle
    mqttData = read(mqClient);
    if ~isempty(mqttData)
        for i=1: size(mqttData, 1)
            if startsWith(mqttData.Topic(i), trafficLightTopic)
                trafficLightList = trafficLightRead(mqttData(i,:).Data, trafficLightList);
            elseif startsWith(mqttData.Topic(i), vehicleTopic)
                vehicleList = vehicleRead(mqttData(i,:).Data, vehicleList);
            elseif startsWith(mqttData.Topic(1), "other topic")
                %call other function
            end
        end

    end

    %% LogicFunctions
    trafficLightLogic(trafficLightList, vehicleList, tlThreshold, mqClient);
end
