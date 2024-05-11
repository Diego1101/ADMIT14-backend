function [traficLightIds, vehicleIds] = trafficLightLogic(traficLigtList,vehicleList, tlThreshold, mqttClient)

if ~isempty(vehicleList) & ~isempty(traficLigtList)

    vehicleCords = cat(2, vehicleList.Position{:});
    traficLigtCords = cat(2, traficLigtList.Position{:});
    
   distances = zeros(size(traficLigtCords, 2),size(vehicleCords, 2));

    for i=1: size(traficLigtCords, 2)
        for j=1: size(vehicleCords, 2)
            %sqrt(sum((traficLigtCords(:,i) - vehicleCords(:,j)) .^ 2))
            distances(i,j) = norm(traficLigtCords(:,i)-vehicleCords(:,j));
        end
    end

    % Get ids where distance is less that threshold
    [traficLightIds, vehicleIds] = find(distances < tlThreshold);

    % Filter repeated vehicles, only closest traffic light to vehicle
    result = [traficLightIds, vehicleIds];
    [~, b] = unique(result(:,2));
    filteredResult = result(b, :);

    %Send mqtt messages
    for i=1: size(filteredResult, 1)
        mqttMessage = table2struct(traficLigtList(filteredResult(i, 1), :));
        
        mqttMessage = setfield(mqttMessage, 'Distance', distances(filteredResult(i,1),filteredResult(i,2)));
        write(mqttClient, ...
            strcat('vehicle/trafficLight/',num2str(vehicleList(filteredResult(i, 2), :).Id)), ...
            jsonencode(mqttMessage));
    end

end
