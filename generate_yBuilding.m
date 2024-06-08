function y = generate_yBuilding(x)
% Generate y-coordinate of parking building

if (x == 7) || ( x == 37) || (x == 47) || (x == 77)
    % Randomly select one of the two ranges
    selected_range = randi([1, 2]);

    if selected_range == 1
        % Generate a random number between 7 to 51
        y = randi([7, 51]);
    else
        % Generate a random number between 61 to 105
        y = randi([61, 105]);
    end
else
    % Set of possible coordinate if x not in [7, 37, 47, 77]
    numbers = [7, 51, 61, 105];

    % Generate a random index to select from the set
    random_index = randi([1, numel(numbers)]);

    % Select the number at the randomly generated index
    y = numbers(random_index);
end




