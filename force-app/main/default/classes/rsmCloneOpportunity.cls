public class rsmCloneOpportunity {
    
    @AuraEnabled  
    public static Opportunity getDetailsFromOpp(string recordId){
        Opportunity opp = [select Id, 
                           Name, 
                           StageName, 
                           CloseDate, 
                           AccountId,
                           Type, 
                           SubType__c, 
                           SubType2__c, 
                           Facility__c, 
                           Tier_Level__c,
                           InputDate__c, 
                           OutputDate__c, 
                           Amount, 
                           AFSM_Lookup__c,
                           RSM__c, 
                           Opportunity_Name_Details__c,
                           Opportunity_Name_Override__c,
                           Lead_Sales_Manager__c, 
                           Product_Line__c, 
                           Product_Line__r.Sub_Type_2_Required__c,
                           OwnerId,
                           Operator__c,Contact__c, 
                           Aircraft__r.Product_Line__c,
                           Aircraft__r.Product_Line__r.Sub_Type_2_Required__c,
                           Aircraft__c,
                           Equipment__r.Product_Line__c,
                           Equipment__r.Product_Line__r.Sub_Type_2_Required__c,
                           Equipment__c,
                           Probability_Grouping_Override__c, 
                           Probability,
                           RecordTypeId,
                           Hot_List__c,
                           WasCloned__c,
                           Input_Date_Accuracy__c
                           from Opportunity Where Id =: recordId];
        return opp ;
    }
    
    @AuraEnabled  
    public static Map<String, Id> getOppRecordTypes(){
        Map<String, Id> oppRecTypes = new Map<String, Id>();
        for(RecordType rt : [SELECT Name, Id FROM RecordType where SobjectType = 'Opportunity' and IsActive = true]){
            oppRecTypes.put(rt.Name, rt.Id);
        }
        
        return oppRecTypes;
    }
    
    @AuraEnabled
    public static Aircraft__c getOppAircraft(String oppId) {
        Opportunity opp = [Select Id, Aircraft__c from Opportunity where Id =: oppId];
        Aircraft__c a = [Select Id, Name, Account__c, Account__r.Name, Product_Line__c, Product_Line__r.Sub_Type_2_Required__c from Aircraft__c where Id =: opp.Aircraft__c];
        
        return a;
    }
    
    @AuraEnabled
    public static Equipment__c getOppEquipment(String oppId) {
        Opportunity opp = [Select Id, Equipment__c from Opportunity where Id =: oppId];
        Equipment__c e = [Select Id, Name, Aircraft__c, Aircraft__r.Name, Account__c, Account__r.Name, Product_Line__c, Product_Line__r.Sub_Type_2_Required__c from Equipment__c where Id =: opp.Equipment__c];
            
        return e;
    }
            
    @AuraEnabled
    public static Sub_Type_2__c getOppSubType2(String oppId) {
        Opportunity opp = [Select Id, Product_Line__c, SubType2__c from Opportunity where Id =: oppId];
        Sub_Type_2__c st2 = [Select Id, Name, Product_Line__c FROM Sub_Type_2__c WHERE Id =: opp.SubType2__c];
    
        return st2;
    }
    
    @AuraEnabled
    public static List<sObjectPicklistResult> getFacility() {
        List<sObjectPicklistResult> sObjectResultList = new List<sObjectPicklistResult>();
        FieldDefinition dId = [Select DurableId from FieldDefinition where EntityDefinition.QualifiedApiName =: 'Opportunity' AND DeveloperName = 'Facility'];
        for(PicklistValueInfo f : [SELECT EntityParticleId,Id,Label,Value FROM PicklistValueInfo where EntityParticleId =: dId.DurableId]) {
            sObjectResultList.add(new sObjectPicklistResult(f.Label, f.Value));
        }
        
        return sObjectResultList;
    }
    
    @AuraEnabled
    public static List<Sub_Type_2__c> getSubType2(String productLine, String SubType) {
        List<Sub_Type_2__c> st2 = [Select Id, Name, Product_Line__c FROM Sub_Type_2__c WHERE Generic__c = TRUE AND Product_Line__c =: productLine And Opportunity_Sub_Type__c =: SubType];

        return st2;
    }
    
    
    @AuraEnabled
    public static List<Aircraft__c> fetchAircraft(String searchKeyWord){
        String searchKey = '%' + searchKeyWord + '%';
        List <Aircraft__c> returnList = [select id, Name, Account__c, Account__r.Name, Product_Line__c, Product_Line__r.Sub_Type_2_Required__c from Aircraft__c where Name LIKE: searchKey limit 25];
        
        return returnList;
    }
    
    @AuraEnabled
    public static List<Equipment__c> fetchEquipment(String searchKeyWord) {
        String searchKey = '%' + searchKeyWord + '%';
        List <Equipment__c> returnList = [select id, Name, Aircraft__c, Aircraft__r.Name, Account__c, Account__r.Name, Product_Line__c, Product_Line__r.Sub_Type_2_Required__c from Equipment__c where Name LIKE: searchKey limit 25];
        
        return returnList;
    }

    @AuraEnabled
    public static List<Sub_Type_2__c> fetchSubType2(String searchKeyWord, String ProductLine, String SubType) {
        String searchKey = '%' + searchKeyWord + '%';
        List <Sub_Type_2__c> returnList = [select id, Name from Sub_Type_2__c 
                                           where Name LIKE: searchKey 
                                           and Product_Line__c =: ProductLine 
                                           and Opportunity_Sub_Type__c =: SubType 
                                           and Generic__c = True limit 25];
        
        return returnList;
    }
    
    @AuraEnabled
    public static List<Aircraft__c> accountAircraft(String oppId) {
        Opportunity o = [Select AccountId from Opportunity where Id =: oppId];
        List <Aircraft__c> acList = [select id, Name, Account__c, Account__r.Name, Product_Line__c, Product_Line__r.Sub_Type_2_Required__c from Aircraft__c where Account__c =: o.AccountId];
        
        return acList;
    }
    
    @AuraEnabled
    public static List<Equipment__c> aircraftEquipment(String oppId) {
        Opportunity o = [Select Aircraft__c from Opportunity where Id =: oppId];
        List<Equipment__c> engList = [select id, Name, Aircraft__c, Aircraft__r.Name, Account__c, Account__r.Name, Product_Line__c, Product_Line__r.Sub_Type_2_Required__c from Equipment__c where Aircraft__c =: o.Aircraft__c or Name =: 'NA'];
        
        return engList;
    }
    
    @AuraEnabled
    public static List<Equipment__c> aircraftEquipmentChange(String acId) {
        List<Equipment__c> engList = [select id, Name, Aircraft__c, Aircraft__r.Name, Account__c, Account__r.Name, Product_Line__c, Product_Line__r.Sub_Type_2_Required__c from Equipment__c where Aircraft__c =: acId or Name =: 'NA'];
        
        return engList;
    }
    
    @AuraEnabled
    public static List<Sub_Type_2__c> SubType2List(String oppId) {
        Opportunity o = [Select SubType__c, Product_Line__c from Opportunity where Id =: oppId];
        List<Sub_Type_2__c> st2List = [select id, Name, Product_Line__c from Sub_Type_2__c 
                                       where Product_Line__c =: o.Product_Line__c
                                           and Opportunity_Sub_Type__c =: o.SubType__c 
                                           and Generic__c = True];
        
        return st2List;
    }
      
    public class sObjectPicklistResult {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
        
        public sObjectPicklistResult(String recNameTemp, String recValueTemp) {
            label = recNameTemp;
            value = recValueTemp;
        }
    }  
}