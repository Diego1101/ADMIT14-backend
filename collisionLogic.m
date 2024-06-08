function collisionLogic(vehicleList, vehicleThreshold, mqClient)
    
    if isempty(vehicleList)
        return
    end
    vehicleCords = cat(2, vehicleList.Position{:});
    
    % Calculate distances
    distances = zeros(size(vehicleCords, 2),size(vehicleCords, 2));
    for i=1: size(vehicleCords, 2)
        for j=i: size(vehicleCords, 2)
            %sqrt(sum((traficLigtCords(:,i) - vehicleCords(:,j)) .^ 2))
            distances(i,j) = norm(vehicleCords(:,i)-vehicleCords(:,j));
        end
    end

    distances = distances + distances';

    % Get ids where distance is less that threshold
    [firstVehicle, secondVehicle] = find(distances < vehicleThreshold & distances ~= 0);
    result = [firstVehicle, secondVehicle];

    %Send mqtt messages
    for i=1: size(result, 1)
    %for i=1: 1

        diff = vehicleCords(:,result(i,1)) - vehicleCords(:,result(i,2));
        direction = atan2(diff(1), diff(2));

        mqttMessage = table2struct(vehicleList(result(i, 2), :));
        mqttMessage = setfield(mqttMessage, 'Warning', 1);
        mqttMessage = setfield(mqttMessage, 'Distance', distances(result(i,1),result(i,2)));
        mqttMessage = setfield(mqttMessage, 'Direction', direction);

        % UNCOMMENT
        write(mqClient, ...
            strcat('vehicle/trafficLight/',num2str(vehicleList(result(i, 1), :).Id)), ...
            jsonencode(mqttMessage));
    end

end
