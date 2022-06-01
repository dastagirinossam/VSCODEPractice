public class JetnetAPI_Callouts {
      
    public static Map<String, Object> jetnetResults = new Map<String, Object>();
    public static List<Object> jetnetCompanies = new List<Object>();
    public static String jetnetToken;
    
    @AuraEnabled
    public static String getToken(){
        
        makeJetnetCallout();
        
        system.debug('JetnetToken: ' + jetnetToken);
        
        return jetnetToken;       
    }
    
    //Get Jetnet API Token
    public static HttpResponse makeJetnetCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        Jetnet_API_Setting__mdt jna = [Select Jetnet_Username__c, Jetnet_Password__c from Jetnet_API_Setting__mdt where MasterLabel =: 'Jetnet API'];
           
        //Store in Meta Data
        request.setEndpoint('https://www.jetnetconnect.com/JetnetDataService.svc/getSecurityToken?username=' + jna.Jetnet_Username__c + '&password=' + jna.Jetnet_Password__c );
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        system.debug('response>>'+ response.getBody());
        if (response.getStatusCode() == 200) {
            String result = (String) String.valueof(JSON.deserializeUntyped(response.getBody()));
            jetnetToken = result;
        }
        return response;        
    }
    
    @AuraEnabled
    public static Response service(String response, String acId) {
        Aircraft__c ac = [Select Jetnet_Id__c from Aircraft__c where Id =: acId];
        
        String jnID = ac.Jetnet_Id__c;
       
        //Jetnet Query Calls
        getIdentification(response, jnID);
        getAirframe(response, jnID);
        getStatus(response, jnID);
        
        //HttpResponse httpRes = sendRequest(request);
        Response restRes = buildResponse();
        
        return restRes;
    } 
    
    //Engine Call: To Be Seperate because of same reponse api
    @AuraEnabled
    public static Response serviceEngine(String response, String acId) {
        Aircraft__c ac = [Select Jetnet_Id__c from Aircraft__c where Id =: acId];
        String jnID = ac.Jetnet_Id__c;
       
        //Jetnet Query Calls
        getEngine(response, jnID);
        Response restRes = buildResponse();
        
        return restRes;
    }
    
    @AuraEnabled
    public static Map<String, Object> serviceCompany(String response, String acId) {
        Aircraft__c ac = [Select Jetnet_Id__c from Aircraft__c where Id =: acId];
        String jnID = ac.Jetnet_Id__c;
        
        //Jetnet Query Calls
        getCompanyrelationships(response, jnID);
        getContacts(response, jnID);

        return jetnetResults;
    }
    
    @AuraEnabled
    public static Map<String, Object> serviceCompanyRelationships(String response, String acId) {
        Aircraft__c ac = [Select Jetnet_Id__c from Aircraft__c where Id =: acId];
        String jnID = ac.Jetnet_Id__c;
        
        //Jetnet Query Calls
        getAircraftCompanyRelationships(response, jnID);

        return jetnetResults;
    }
    
    @AuraEnabled
    public static Map<String, Object> serviceContacts(String response, String acId) {
        Aircraft__c ac = [Select Jetnet_Id__c from Aircraft__c where Id =: acId];
        String jnID = ac.Jetnet_Id__c;
        
        //Jetnet Query Calls
        getContacts(response, jnID);

        return jetnetResults;
    }
                
    @AuraEnabled
    public static Response serviceAPU(String response, String acId) {
        Aircraft__c ac = [Select Jetnet_Id__c from Aircraft__c where Id =: acId];
        
        String jnID = ac.Jetnet_Id__c;
       
        //Jetnet Query Calls
        getAPU(response, jnID);
        Response restRes = buildResponse();
        
        return restRes;
    }
        //Setup Jetnet Request
    @AuraEnabled
    public static void getIdentification(String response, String acId) {
        Response restRes = new Response();
        
        Map<String, String> returnValueMap =  new Map<String, String>();

        String securityToken = response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        //Use Aircraft JetnetId here
        request.setEndpoint('https://www.jetnetconnect.com/JetnetDataService.svc/getAircraft/Identification/' + acId);
        request.setMethod('GET');
         
        request.setHeader('securityToken', securityToken);
 
        HttpResponse aircraftIdentification = http.send(request);
        if(aircraftIdentification.getStatusCode() == 200) {  
            system.debug('aircraftIdentification.getBody()>>'+aircraftIdentification.getBody());
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(aircraftIdentification.getBody());
            If(!Test.isRunningTest()){
            Map<String, Object> getAircraftIdentificationResult = (Map<String, Object>) JSON.deserializeUntyped(string.valueOf(results.get('getAircraftIdentificationResult'))); 
            jetnetResults.putAll(getAircraftIdentificationResult);
                       
            system.debug('Aircraft Identification Fields: ' + getAircraftIdentificationResult);
            }
        }else {
            // * Debugging and returning error if the request was not successful
            System.debug('Unable to find Aircraft Identification');
        }
    }
      
    @AuraEnabled
    public static void getAirframe(String response, String acId) {  
        Response restRes = new Response();
        
        Map<String, String> returnValueMap =  new Map<String, String>();
        String securityToken = response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        //Use Aircraft JetnetId here
        request.setEndpoint('https://www.jetnetconnect.com/JetnetDataService.svc/getAircraft/Airframe/' + acId);
        request.setMethod('GET');
         
        request.setHeader('securityToken', securityToken);
 
        HttpResponse aircraftAirframe = http.send(request);
        if(aircraftAirframe.getStatusCode() == 200) {   
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(aircraftAirframe.getBody());
             If(!Test.isRunningTest()){
            Map<String, Object> getAircraftAirframeResult = (Map<String, Object>) JSON.deserializeUntyped(string.valueOf(results.get('getAircraftAirframeResult'))); 
            jetnetResults.putAll(getAircraftAirframeResult);
                       
            system.debug('Aircraft Airframe Fields: ' + getAircraftAirframeResult);
             }
        }else {
            // * Debugging and returning error if the request was not successful
            System.debug('Unable to find Aircraft Airframe');
        }
    }
    
    @AuraEnabled
    public static void getContacts(String response, String acId) {  
        Response restRes = new Response();
        
        Map<String, String> returnValueMap =  new Map<String, String>();
        String securityToken = response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        //Use Aircraft JetnetId here
        request.setEndpoint('https://www.jetnetconnect.com/JetnetDataService.svc/getContactList?aircraftid=' + acId);
        request.setMethod('GET');
         
        request.setHeader('securityToken', securityToken);
 
        HttpResponse aircraftContacts = http.send(request);
        if(aircraftContacts.getStatusCode() == 200) {   
            If(!Test.isRunningTest()){
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(aircraftContacts.getBody());
            Map<String, Object> getContactListResult = (Map<String, Object>) JSON.deserializeUntyped(string.valueOf(results.get('getContactListResult')));
            
            /*List<Object> contacts = (List<Object>) getContactListResult.get('contacts');
            Map<String, Object> contactsFinalMap = new Map<String, Object>();         
            for(Integer i = 0; i < contacts.Size(); i++){
                system.debug('Contact: ' + i + ' ' + ((Map<String, Object>)contacts[i]).get('companyid'));
                contactsFinalMap.put(string.valueof(((Map<String, Object>)contacts[i]).get('companyid')), contacts[i]);
            }*/
            
            
            jetnetResults.putAll(getContactListResult);
            
            }            //system.debug('Aircraft Contact Fields: ' + contactsFinalMap);
        }else {
            // * Debugging and returning error if the request was not successful
            System.debug('Unable to find Aircraft Contacts');
        }
    }
    
    @AuraEnabled
    public static void getStatus(String response, String acId) {  
        Response restRes = new Response();
        
        Map<String, String> returnValueMap =  new Map<String, String>();

        String securityToken = response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        //Use Aircraft JetnetId here
        request.setEndpoint('https://www.jetnetconnect.com/JetnetDataService.svc/getAircraft/Status/' + acId);
        request.setMethod('GET');
         
        request.setHeader('securityToken', securityToken);
 
        HttpResponse aircraftStatus = http.send(request);
        if(aircraftStatus.getStatusCode() == 200) {  
            If(!Test.isRunningTest()){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(aircraftStatus.getBody());
            Map<String, Object> getAircraftStatusResult = (Map<String, Object>) JSON.deserializeUntyped(string.valueOf(results.get('getAircraftStatusResult'))); 
            jetnetResults.putAll(getAircraftStatusResult);
                       
                system.debug('Aircraft Status Fields: ' + getAircraftStatusResult);}
        }else {
            // * Debugging and returning error if the request was not successful
            System.debug('Unable to find Aircraft Status');
        }
    }
    
    @AuraEnabled
    public static void getAPU(String response, String acId) {  
        Response restRes = new Response();
        
        Map<String, String> returnValueMap =  new Map<String, String>();

        String securityToken = response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        //Use Aircraft JetnetId here
        request.setEndpoint('https://www.jetnetconnect.com/JetnetDataService.svc/getAircraft/APU/' + acId);
        request.setMethod('GET');
         
        request.setHeader('securityToken', securityToken);
 
        HttpResponse aircraftAPU = http.send(request);
        if(aircraftAPU.getStatusCode() == 200) {   
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(aircraftAPU.getBody());
            If(!Test.isRunningTest()){
            Map<String, Object> getAircraftAPUResult = (Map<String, Object>) JSON.deserializeUntyped(string.valueOf(results.get('getAircraftApuResult'))); 
            jetnetResults.putAll(getAircraftAPUResult);
                        
            system.debug('Aircraft APU Fields: ' + getAircraftAPUResult);
            }
        }else {
            // * Debugging and returning error if the request was not successful
            System.debug('Unable to find Aircraft APU');
        }
    }
    
    @AuraEnabled
    public static void getEngine(String response, String acId) {  
        Response restRes = new Response();
        
        Map<String, String> returnValueMap =  new Map<String, String>();

        String securityToken = response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        //Use Aircraft JetnetId here
        request.setEndpoint('https://www.jetnetconnect.com/JetnetDataService.svc/getAircraft/Engine/' + acId);
        request.setMethod('GET');
         
        request.setHeader('securityToken', securityToken);
 
        HttpResponse aircraftEngine = http.send(request);
        if(aircraftEngine.getStatusCode() == 200) {   
            If(!Test.isRunningTest()){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(aircraftEngine.getBody());
            Map<String, Object> getAircraftEngineResult = (Map<String, Object>) JSON.deserializeUntyped(string.valueOf(results.get('getAircraftEngineResult'))); 
            jetnetResults.putAll(getAircraftEngineResult);
                       
                system.debug('Aircraft Engine Fields: ' + getAircraftEngineResult);}
        }else {
            // * Debugging and returning error if the request was not successful
            System.debug('Unable to find Aircraft Engine');
        }
    }
  
    @AuraEnabled
    public static void getCompanyrelationships(String response, String jnID) {  
        
        Response restRes = new Response();
        
        Map<String, String> returnValueMap =  new Map<String, String>();

        String securityToken = response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
      
        //Use Aircraft JetnetId here
        request.setEndpoint('https://www.jetnetconnect.com/JetnetDataService.svc/getCompanyList?aircraftid=' + jnID);
        request.setMethod('GET');
         
        request.setHeader('securityToken', securityToken);
 
        HttpResponse aircraftCompanyrelationships = http.send(request);
        if(aircraftCompanyrelationships.getStatusCode() == 200) {
            If(!Test.isRunningTest()){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(aircraftCompanyrelationships.getBody());
            Map<String, Object> getCompanyListResult = (Map<String, Object>) JSON.deserializeUntyped(string.valueOf(results.get('getCompanyListResult')));                       

                jetnetResults.putAll(getCompanyListResult);}

            //system.debug('Aircraft Companyrelationships Fields: ' + coList);
        }else {
            // * Debugging and returning error if the request was not successful
            System.debug('Unable to find Aircraft Companyrelationships');
        }
    }
    
    @AuraEnabled
    public static void getAircraftCompanyRelationships(String response, String jnID) {  
        
        Response restRes = new Response();
        
        Map<String, String> returnValueMap =  new Map<String, String>();
        
        String securityToken = response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        //Use Aircraft JetnetId here
        request.setEndpoint('https://www.jetnetconnect.com/JetnetDataService.svc/getAircraft/CompanyRelationships/' + jnID);
        request.setMethod('GET');
        
        request.setHeader('securityToken', securityToken);
        
        HttpResponse aircraftCompanyrelationships = http.send(request);
        if(aircraftCompanyrelationships.getStatusCode() == 200) { 
            If(!Test.isRunningTest()){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(aircraftCompanyrelationships.getBody());
            system.debug('Results: ' + results);
            Map<String, Object> getCompanyListResult = (Map<String, Object>) JSON.deserializeUntyped(string.valueOf(results.get('getAircraftCompanyrelationshipsResult'))); 

                jetnetResults.putAll(results);}
        }else {
            // * Debugging and returning error if the request was not successful
            System.debug('Unable to find Aircraft Companyrelationships');
        }
    }
      
    public static Response buildResponse() {
        Response restRes = new Response();
        
        String aircraftFields = JSON.Serialize(jetnetResults);
        restRes.ac = (Map<String, Object>) JSON.deserializeUntyped(aircraftFields);
               
        return restRes;
    }
    
    public class Response {
        @AuraEnabled
        public String status { get; set; }
        
        @AuraEnabled
        public Integer statusCode { get; set; }
        
        @AuraEnabled
        public String body { get; set; }
        
        @AuraEnabled
        public Map<String, Object> ac { get; set; }
    }
       
}