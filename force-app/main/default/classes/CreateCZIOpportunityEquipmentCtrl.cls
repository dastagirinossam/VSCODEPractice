public class CreateCZIOpportunityEquipmentCtrl {
    public static List<String> recordtypeList {get;set;}
    
    //Method to fetch all of the opportunity record type values
    //Returns the List of Opportunity Record Type Values.
    @AuraEnabled
    public static List<String> fetchRecordTypeValues(){
        recordtypeList = new List<String>(); 
        for(RecordTypeInfo info: Opportunity.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(info.getName() != 'Master'){
                if(info.isAvailable() && info.isActive()) 
                    recordtypeList.add(info.getName());
            }
        }
        return recordtypeList;        
    }
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        return recid;
    }    
    //Input Parameter -Equipment Id of type String
    //This Method fetches Equipment, user records and assigns the values to Wrapper instance variable
    //Returns Wrapper variable which holds equipment and user record
    @AuraEnabled
    public static wrapper eqpOpportunity(String eqpID){
        Equipment__c eqpment = [SELECT ID, Name, Account__c,Account__r.Name, Account_ID__c, X18_Character_Equipment_ID__c, RecordType.Name, RSM__c, 
                                Product_Line__c, CZI_Sub_Type_2__c, Aircraft__c, Next_CZI_Date__c, CZI_Oppty_Output_Date__c, 
                                CZI_Oppty_Close_Date__c FROM Equipment__c WHERE ID=:eqpID];
        wrapper wrap = new wrapper();
        wrap.userRec =[select ID, Alias from user where Id = :UserInfo.getUserID()];
        wrap.euipRec = eqpment;
        return wrap;
        
    }
    
    @AuraEnabled
    public static  wrapper OppRecord(String OppId){
         Opportunity Opprec = [SELECT ID, Name, AccountId,Next_Step_Dialogue__c, Product__c, Equipment__c, Aircraft__c, RSM__c, 
                                SubType__c, Type, SubType2__c, Sub_Type_3__c, OutputDate__c,InputDate__c,CloseDate,Amount, 
                                Opportunity_Name_Override__c,Opportunity_Name_Details__c,Operator__c,
                               Facility__c,CustomerName__c,LeadSource,StageName,Base_Quote_Number__c,
                               Quote_Amendment__c,QuoteNum__c,Quote_Revision_Number__c FROM Opportunity WHERE ID=:OppId];
       
        wrapper wrap = new wrapper();
        wrap.Opp = Opprec;
        return wrap;
        
    } 
    //Inner class which used to store equipment and user records.
    public class wrapper{
       
        @AuraEnabled public Equipment__c euipRec;
        @AuraEnabled public User userRec;
        @AuraEnabled public Opportunity Opp;
    }
}