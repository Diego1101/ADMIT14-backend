function parkingLogic(jsonString,mqttClient, building_coordinates, building_names, vacantParking)
    disp(jsonString);
    data = jsondecode(jsonString);
    destination = data.Destination;

    % Calculate distances to each building
    distances = sqrt((destination(1) - building_coordinates(:,1)).^2 + (destination(2) - building_coordinates(:,2)).^2);
    
    % Find the index of the closest building
    [~, idx] = min(distances);
    
    % The coordinates of the closest building
    closest_building = building_coordinates(idx,:);

    % Return the name of the closest building
    closest_building_idx = idx;

    % Check number of parking spaces vacant in the closest building
    vacant_parking_spaces = vacantParking(closest_building_idx);

    % Send MQTT Messages (Closest PArking Building to Destination and Number of available Parking Spaces)
    mqttMessage = struct("available",0);
    mqttMessage.building = building_names(closest_building_idx);

    if vacant_parking_spaces > 0
        mqttMessage.available = vacant_parking_spaces;
    else
        mqttMessage.available = -1;
    end

    write(mqttClient,'parking/info/response', jsonencode(mqttMessage));

end

