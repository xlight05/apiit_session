import ballerinax/openweathermap;

final openweathermap:Client openweathermapClient = check new ({
    appid: openWeatherMapAppId
});
