function trafficLightList = trafficLightRead(jsonSring,trafficLightList)
%TRAFFICLIGHTLOGIC Summary of this function goes here
tlData = struct2table(jsondecode(jsonSring), AsArray=true);

if isempty(trafficLightList)
    %If the list is empty initialice
    trafficLightList = [trafficLightList ; tlData];
elseif ~ismember(trafficLightList.Id, tlData.Id)
    %If the traffic light if doesnt exists in the list add
    trafficLightList = [trafficLightList ; tlData];
else
    % If traffic light already exists update data
    [~, index] = ismember(trafficLightList.Id, tlData.Id);
    trafficLightList(find(index, 1, 'first'),:) = tlData;
end

end

