import ballerina/log;
import ballerina/websocket;
import ballerina/http;
service /ws on new websocket:Listener(8080) {

    resource function get .(http:Request req) returns websocket:Service|websocket:Error {
        return new WsService();
    }

}

service class WsService {
    *websocket:Service;

    remote function onTextMessage(websocket:Caller caller, string text) returns error? {
        string stringResult = check _weatherAgent->run(text);
        log:printInfo("Output : " + stringResult);      
        check caller->writeTextMessage(stringResult);
    }
}
