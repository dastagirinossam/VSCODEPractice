public class LM_NewQuoteListButtonCtrl {
    //Input Parameters - Object Name of type String
    //Method to return the whether the object is Updateable , Createable and Accessible
    @AuraEnabled( cacheable = true )
    public static Map<String, Object> getFieldDescribeMap( String objectName) {
        Map<String, Object> fieldDescribeMap = new Map<String, Object>();
        Type reflector = Type.forName( objectName );
        SObject obj = (SObject) reflector.newInstance();
        SObjectType objType = obj.getSObjectType();
        DescribeSObjectResult describe = objType.getDescribe();
        fieldDescribeMap.put(objectName, describe.isCreateable()) ;
        Map<String, SObjectField> fieldsMap = describe.fields.getMap();
        for ( String fieldName : fieldsMap.keySet() ) {
            DescribeFieldResult fieldDescribe = fieldsMap.get( fieldName ).getDescribe();
            fieldDescribeMap.put( fieldDescribe.getName(), new Map<String, Object>{
                'accessible' => fieldDescribe.isAccessible(),
                    'createable' => fieldDescribe.isCreateable(),
                    'updateable' => fieldDescribe.isUpdateable()
                    });
        }
        return fieldDescribeMap;
    }
    
    //Input Parameters - Record Id of type String
    //Method to fetch the Opportunity Record based on the opportunities record id passed.
    @AuraEnabled
    public static Opportunity  OppRec(String Rid){
        try{
            Opportunity Opp=[select id,RecordTypeId,Master_Opportunity__c,Aircraft__c,AccountId,Facility__c from Opportunity where id =:Rid];           
            return Opp; 
        }
        catch(QueryException e) {
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    //Input Parameters - Record Id of type String
    //Method to return the record type id
    @AuraEnabled
    public static String getRecTypeId(String RecId){
        try{
            Opportunity Opprtu=[select id,RecordTypeId,Master_Opportunity__c from Opportunity where id =:RecId];   
            if(Opprtu.Master_Opportunity__c){
                return Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Master Proposal').getRecordTypeId();
            }
            else{
                return Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Standard Proposal').getRecordTypeId();
            } 
        }
        catch(QueryException e) {
            throw new AuraHandledException(e.getMessage()); 
        }        
    }     
}