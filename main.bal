import ballerina/log;

public function main() returns error? {
    string question = "What should i bring today in colombo?";
    string stringResult = check _weatherAgent->run(question);
    log:printInfo("Output : " + stringResult);    
}
