function [building_names,building_coordinates,vacantParking] = generateBuildings()

%% Generate buildings coordinate
x_buildA = generate_xBuilding();
y_buildA = generate_yBuilding(x_buildA);

overlap = 1;
while (overlap == 1)
    x_buildB = generate_xBuilding();
    y_buildB = generate_yBuilding(x_buildB);
    build_dist = sqrt((x_buildA - x_buildB).^2 + (y_buildA-y_buildB).^2);
    if (build_dist <= 6)
        overlap = 1;
    else
        overlap = 0;
    end
end    

building_names = {'Building A', 'Building B'};
building_coordinates = [x_buildA, y_buildA; x_buildB, y_buildB];

%% Generate parking scpaces
% Number of parking spaces of Building A & B
numBuildings = 2 ; % number of buildings
numSpaces = [200; 150]; 

% Generate simulated data for parking space occupancy

    % Simulate occupancy (1 = occupied, 0 = vacant) for each parking space
    occupancy = zeros(numBuildings, max(numSpaces));
    for i = 1:numBuildings
        occupancy(i, 1:numSpaces(i)) = randi([0, 1], 1, numSpaces(i));
    end
    
    vacantParking = sum(occupancy == 0, 2)';

end

