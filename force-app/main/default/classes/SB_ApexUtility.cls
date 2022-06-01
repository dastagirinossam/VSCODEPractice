/**
*@author - Krunal Pala
*@Date - 24/2/2017
*Purpose - Utility methods used by SB CPQ 
*/

public with sharing class SB_ApexUtility {
    private static SB_ApexUtility classInstance;

    static {
        classInstance = new SB_ApexUtility();
    }

    private SB_ApexUtility() {
        
    }

    public static SB_ApexUtility getInstance() {
        return classInstance;
    }

    // generic method to get the select * from
	public String queryBuilder(String SobjectApiName){

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
       
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
             system.debug('fieldMap>>>>>>'+ fieldMap);
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            if(commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
 
       String  queryStr = 'select ' + commaSepratedFields + ' from ' + SobjectApiName ;
       
       return queryStr;
      
    }
}