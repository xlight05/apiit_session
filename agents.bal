import ballerina/log;
import ballerinax/ai;
import ballerinax/openweathermap;

final ai:AzureOpenAiProvider _weatherModel = check new (url, apiKey, deploymentId, version);
final ai:Agent _weatherAgent = check new (
    systemPrompt = {role: "Weather Assistant", instructions: string ``}, memory = new ai:MessageWindowChatMemory(10), model = _weatherModel, tools = [getCurrentWeather, getRecommendationsForWeatherCondition]
);

# Access current weather data for any location.
# + cityName - City name
# + return - weather data of the given city
@ai:AgentTool
@display {label: "", iconPath: "https://bcentral-packageicons.azureedge.net/images/ballerinax_openweathermap_1.5.1.png"}
isolated function getCurrentWeather(string cityName) returns openweathermap:CurrentWeatherData|error {
    log:printInfo("getCurrentWeather tool called: "+ cityName);
    openweathermap:CurrentWeatherData|error openweathermapCurrentweatherdata = openweathermapClient->getCurretWeatherData(cityName, units = "metric");
    if openweathermapCurrentweatherdata is error {
        log:printError("Error in getting current weather data", 'error = openweathermapCurrentweatherdata);
        return error("Error in getting current weather data");
    }
    return openweathermapCurrentweatherdata;
}

# Gives recommendations based on weather
# + weatherCondition - weather condition
# + return - recommendation based on weather condition
@ai:AgentTool
isolated function getRecommendationsForWeatherCondition("rainy"|"sunny"|"cloudy" weatherCondition) returns string|error {
    log:printInfo("getRecommendationsForWeatherCondition tool called: " + weatherCondition);
    if weatherCondition == "rainy" {
        return "Take an umbrella and wear waterproof shoes.";
    } else if weatherCondition == "sunny" {
        return "Wear sunglasses and apply sunscreen.";
    } else {
        return "Its cloudy, It might rain, so take an umbrella just in case.";
    }
}
