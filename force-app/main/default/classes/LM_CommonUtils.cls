public class LM_CommonUtils {
    public static boolean isCreatable(String sObjectName)
    {
        Map<String, Object> fieldDescribeMap = new Map<String, Object>();
        Type reflector = Type.forName( SObjectName );
        SObject obj = (SObject) reflector.newInstance();
        SObjectType objType = obj.getSObjectType();
        DescribeSObjectResult describe = objType.getDescribe();
        fieldDescribeMap.put(SObjectName, describe.isCreateable()) ;
        Map<String, SObjectField> fieldsMap = describe.fields.getMap();
        
        for ( String fieldName : fieldsMap.keySet() ) {
            DescribeFieldResult fieldDescribe = fieldsMap.get( fieldName ).getDescribe();
            fieldDescribeMap.put( fieldDescribe.getName(), new Map<String, Object>{
                'accessible' => fieldDescribe.isAccessible(),
                    'createable' => fieldDescribe.isCreateable(),
                    'updateable' => fieldDescribe.isUpdateable()
                    });
        }
        if(fieldDescribeMap.get(SObjectName)==true){
            return true;
        }
        else{
            return false;  
        }
    }
}