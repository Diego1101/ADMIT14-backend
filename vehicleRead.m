function vehicleList = vehicleRead(jsonSring,vehicleList)
%TRAFFICLIGHTLOGIC Summary of this function goes here
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

