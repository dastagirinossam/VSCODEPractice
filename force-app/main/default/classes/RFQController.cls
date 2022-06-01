public class RFQController {
    
    @AuraEnabled
    Public static void createRFQRecord(string firstname,string lastName,string mail,string company,string phoneNum,string city,string state,string country,string description){
    
        Request_For_Quote__c rfq = new Request_For_Quote__c();
        rfq.First_Name__c = firstname;
        rfq.Last_Name__c = lastName;
        if(city != Null)
        rfq.City__c = city;
        if(company != Null)
        rfq.Company__c = company;
         if(country != Null)
        rfq.Country__c = country;
        rfq.Email_Address__c = mail;
        rfq.Question_Request__c = description;
        if(phoneNum != Null)
        rfq.Phone_Number__c = phoneNum;
        if(state != Null)
        rfq.State__c = state;
        
        insert rfq;
        
    }

}