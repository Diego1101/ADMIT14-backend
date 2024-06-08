function weatherRead(jsonString,mqttClient)

% Define the API key and URL for OpenWeatherMap
api_key = 'd9552b33a16f392700f0cac80d7d7c05';
city = 'Esslingen, DE';
url = sprintf('http://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s', city, api_key);

% Make API call to retrieve weather data
weather_data = webread(url);

% Parse the retrieved data to extract relevant information
weather_cond = string(weather_data.weather.main); % Weather Condition
temp_K = weather_data.main.temp; % Temperature in Kelvin
temp_C = round(temp_K - 273.15, 2); % Temperature in Celcius
humidity = weather_data.main.humidity; % Humidity percentage

% Broadcast the weather information to MQTT
mqttMessage = table(weather_cond,temp_C, humidity);

write(mqttClient,'weather/info/response', jsonencode(mqttMessage));
end

