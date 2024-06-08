function drawMap(ax)
% This function draws the ma

% Define map size
map_width = 6 * 14; % in meters
map_height = 8 * 14; % in meters

% Plot the map boundaries
plot(ax,[0 map_width], [0 0], 'k'); % plot horizontal boundary
plot(ax,[0 map_width], [map_height map_height], 'k'); % plot horizontal boundary
plot(ax,[0 0], [0 map_height], 'k'); % plot vertical boundary
plot(ax,[map_width map_width], [0 map_height], 'k'); % plot vertical boundary

% Plot the road
road_width = 4 ; % width of the road
rectangle(ax, 'Position', [0, 0, map_width, map_height],'LineWidth', 2); % map boundaries
rectangle(ax, 'Position', [road_width, road_width, (map_width - 3 * road_width) / 2, (map_height - 3 * road_width) / 2], 'LineWidth', 2); % left bottom square
rectangle(ax, 'Position', [road_width, 2 * road_width + (map_height - 3 * road_width) / 2 , (map_width - 3 * road_width) / 2, (map_height - 3 * road_width) / 2], 'LineWidth', 2); % left upper square
rectangle(ax, 'Position', [2 * road_width + (map_width - 3 * road_width) / 2 , 2 * road_width + (map_height - 3 * road_width) / 2 , (map_width - 3 * road_width) / 2, (map_height - 3 * road_width) / 2], 'LineWidth', 2); % right upper square
rectangle(ax, 'Position', [2 * road_width + (map_width - 3 * road_width) / 2 , road_width, (map_width - 3 * road_width) / 2, (map_height - 3 * road_width) / 2], 'LineWidth', 2); % right bottom square


end