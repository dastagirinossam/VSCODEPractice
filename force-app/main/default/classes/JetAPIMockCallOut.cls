Global class JetAPIMockCallOut implements HttpCalloutMock{
     // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        Map<string,Object> jsonBody = new Map<string,Object>{};
            string jsonRep = '{"getAircraftIdentificationResult":"{"responseid":"48580870","responsestatus":"SUCCESS"}"}';
        String jsonInput = '{"responseid":"48580870","responsestatus":"SUCCESS","aircraftid":"7158","modelid":"32"}';
        // Create a fake response
       
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(jsonInput);
        response.setStatusCode(200);
        return response; 
    }

}