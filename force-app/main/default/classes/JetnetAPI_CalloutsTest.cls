@isTest
public class JetnetAPI_CalloutsTest {
      
    Static testMethod void testPostCallout() {
        Product_Line__c pl = TestDataGenerator.createProductLine();
        Account a = TestDataGenerator.createAccount();
        Aircraft__c ac = TestDataGenerator.createAircraft(pl.Id, a.Id);
        
        ac.Jetnet_Id__c = 'JN00001';
        update ac;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new JetnetAPI_CalloutMock());        
        String strResp = JetnetAPI_Callouts.getToken();
         
        Test.setMock(HttpCalloutMock.class, new JetAPIMockCallOut()); 
        JetnetAPI_Callouts.getIdentification(strResp,ac.id);
        JetnetAPI_Callouts.getAPU(strResp,ac.id);
        JetnetAPI_Callouts.getAirframe(strResp,ac.id);
        JetnetAPI_Callouts.getContacts(strResp,ac.id);
        JetnetAPI_Callouts.getStatus(strResp,ac.id);
        JetnetAPI_Callouts.getEngine(strResp,ac.id);
        JetnetAPI_Callouts.getCompanyrelationships(strResp, ac.Jetnet_Id__c);
        JetnetAPI_Callouts.getAircraftCompanyRelationships(strResp, ac.Jetnet_Id__c);
        JetnetAPI_Callouts.buildResponse();
        JetnetAPI_Callouts.serviceContacts(strResp,ac.id);
        JetnetAPI_Callouts.serviceAPU(strResp,ac.id);
        JetnetAPI_Callouts.serviceCompany(strResp,ac.id);
        JetnetAPI_Callouts.serviceCompanyRelationships(strResp,ac.id);
        JetnetAPI_Callouts.serviceEngine(strResp,ac.id);
        JetnetAPI_Callouts.service(strResp,ac.id);
        Test.stopTest();
    } 
}