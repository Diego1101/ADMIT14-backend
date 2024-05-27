function vehicleList = vehicleRead(jsonSring,vehicleList)
%TRAFFICLIGHTLOGIC Summary of this function goes here

%Decode from ascci
ascciArray = str2double(split(jsonSring));
ascciArray = ascciArray(find(ascciArray~=0));
ascciArray = ascciArray(1:end-1);

jsonSring = convertCharsToStrings(char(ascciArray));

vehicleData = struct2table(jsondecode(jsonSring), AsArray=true);

if isempty(vehicleList)
    %If the list is empty initialice
    vehicleList = [vehicleList ; vehicleData];
elseif ~ismember(vehicleList.Id, vehicleData.Id)
    %If the vehicle doesnt exists in the list add
    vehicleList = [vehicleList ; vehicleData];
else
    % If vehicle already exists update data
    [~, index] = ismember(vehicleList.Id, vehicleData.Id);
    vehicleList(find(index, 1, 'first'),:) = table2cell(vehicleData);
end
end

% mosquitto_pub -t vehicle/info -m '123 34 73 100 34 58 49 44 34 80 111 115 105 116 105 111 110 34 58 91 49 48 44 50 48 93 125 0 0 0 0
