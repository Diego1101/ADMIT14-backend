function x = generate_xBuilding()
% Generate x-coordinate of parking building

% Randomly select one of the two ranges
selected_range = randi([1, 2]);

if selected_range == 1
    % Generate a random number between 7 to 37
    x = randi([7, 37]);
else
    % Generate a random number between 47 to 77
    x = randi([47, 77]);
end


