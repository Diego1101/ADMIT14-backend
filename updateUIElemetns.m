function updateUIElemetns(ax, vehicleList, trafficLightList)
%Update traffic lights and vehicle positions

if isempty(vehicleList) || isempty(trafficLightList)
    return
end

vehicleCoords = cat(2, vehicleList.Position{:});

delete( findobj(ax, 'type', 'Line') )
plot(ax, vehicleCoords(1,:), vehicleCoords(2,:)', 'o', ...
    'Color', 'Blue', 'Marker','x','LineWidth',2);

% Get current color of each traffic ligh and draw in map
idx = (trafficLightList.Status == 0);
trafficLightCoords = cat(2, trafficLightList(idx,:).Position{:});
if (size(trafficLightCoords) > 0)
    plot(ax, trafficLightCoords(1,:), trafficLightCoords(2,:)', 'o', ...
        'Color', 'Green', 'Marker','o','LineWidth',2);
end

idx = (trafficLightList.Status == 1);
trafficLightCoords = cat(2, trafficLightList(idx,:).Position{:});
if (size(trafficLightCoords) > 0)
    plot(ax, trafficLightCoords(1,:), trafficLightCoords(2,:)', 'o', ...
        'Color', 'Red', 'Marker','o','LineWidth',2);
end

idx = (trafficLightList.Status == 2);
trafficLightCoords = cat(2, trafficLightList(idx,:).Position{:});
if (size(trafficLightCoords) > 0)
    plot(ax, trafficLightCoords(1,:), trafficLightCoords(2,:)', 'o', ...
        'Color', 'Yellow', 'Marker','o','LineWidth',2);
end

idx = (trafficLightList.Status == 3);
trafficLightCoords = cat(2, trafficLightList(idx,:).Position{:});
if (size(trafficLightCoords) > 0)
    plot(ax, trafficLightCoords(1,:), trafficLightCoords(2,:)', 'o', ...
        'Color', 'Magenta', 'Marker','o','LineWidth',2);
end
end
