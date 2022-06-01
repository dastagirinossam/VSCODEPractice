@isTest
global class JetnetAPI_CalloutMock implements HttpCalloutMock {
    
  
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('"V0FQSS1NekV4WW1ObE5qRXROVGxtWWkwMFlUVTBMVGswWWpZdFpXUmxaams0TjJGbU5UQmk="');
        response.setStatusCode(200);
        return response; 
    }
    
    }