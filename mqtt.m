global status;
status = 1;

%% Constants
brokerAddress = "mqtt://broker.hivemq.com";
port = 1883;
clientID = "matlab2";

% UNCOMMENT
trafficLightList = table();
vehicleList = table();

%% Environment variables
global status;
tlThreshold = 10;
vehicleThreshold = 10;
delayTime = 1;

%% MQTT connection and subscriptions
% mqClient = mqttclient(brokerAddress, Port = port, ClientID = clientID, ...
%    Username = userName, Password = password);

mqClient = mqttclient(brokerAddress, Port = port, ClientID = clientID);

trafficLightTopic = "trafficLight/info";
vehicleTopic = "vehicle/info";
subscribe(mqClient, trafficLightTopic+"/+");
subscribe(mqClient, vehicleTopic);

%% Create button to stop execution
fig = uifigure;
p = uipanel(fig, "Title", "ADMIT14-BackEnd", "Position", [5 5 550 410]);
btnStop = uibutton(p, "Text", "Stop", "ButtonPushedFcn", @btnStop_Callback, ...
    "Position", [200, 15 100 25]);

%% Main program loop, Interrupt and clear memory
while 1
    pause(delayTime);
    drawnow
    if status == 0
        % Stop the if cancel button was pressed
        clear mqClient
        %clear
        disp('Back-end stopped');
        close(fig);
        break;
    end
    
    %% Read data in mqtt buffer, add elseif for each topic to handle
    mqttData = read(mqClient);
    if ~isempty(mqttData)
        %Only for testing and data view
        mqttData
        for i=1: size(mqttData, 1)
            if startsWith(mqttData.Topic(i), trafficLightTopic)
                trafficLightList = trafficLightRead(mqttData(i,:).Data, trafficLightList);
            elseif startsWith(mqttData.Topic(i), vehicleTopic)
                vehicleList = vehicleRead(mqttData(i,:).Data, vehicleList);
            elseif startsWith(mqttData.Topic(1), "other topic")
                % Add here function to handle other topics like weather and
                % parking
                %call other function
            end
        end

    end

    %% LogicFunctions
    trafficLightLogic(trafficLightList, vehicleList, tlThreshold, mqClient);
    collisionLogic(vehicleList, vehicleThreshold, mqClient);
    % Add here function to handle async logic

    % Add here code to draw a pretty map
    % drawABeautifulMapUiNoErrorsWorking100Free()
end
