# OpenWeatherApp
iOS Swift based sample app to play with openweather APIs

Built-in API request by city name
You can call by city name or city name, state code and country code. Please note that searching by states available only for the USA locations.
API call
https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key} https://api.openweathermap.org/data/2.5/weather?q={city name},{country code}&appid={API key} https://api.openweathermap.org/data/2.5/weather?q={city name},{state code},{country co de}&appid={API key}
You will also need icons from here:
http://openweathermap.org/weather-conditions

1. Create an application to serve as a basic weather app.
2. Search Screen
	a. AllowcustomerstoenteraUScity
	b. Call the openweathermap.org API and display the information.
3. Auto-load the last city searched upon app launch.
4. Ask the User for location access. If the User gives permission to access the location, then retrieve weather data by default.
