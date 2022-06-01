public class DeepCloneQuoteService {
    // map<string,string> mapQuoteLine=new map<string,string>();
    //  Map<Integer, String> mapQouteLines = new Map<Integer, String>();
    //  List<String> quoteLineList = new List<String>();
    @AuraEnabled
    public static  Id doClone(String parentId) {
        Set<String> querySobject = new Set<String>();
        for(DeepCloneQuote__mdt m : [select Id, DeveloperName, Label, Object_API_Name__c 
                                     from DeepCloneQuote__mdt  ]){ 
                                         querySobject.add(m.Object_API_Name__c) ;  
                                         system.debug('DeepCloneQuote__mdt'+m);
                                     }
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();// to show the list of all Sobjects 
        
        String objectAPIName = '';
        String keyPrefix = parentId.substring(0,3);//compare with the first 3 digits of the id of an record and it will consider the 1st 3 digits of id
        system.debug('keyPrefix.Values'+keyPrefix);//shows the 1st 3 digits of  Qoute id
        system.debug('schemaMap.Values'+schemaMap.Values());
        /*  for( Schema.SObjectType obj : schemaMap.Values() ){            
system.debug('debug for obj'+obj);
String prefix = obj.getDescribe().getKeyPrefix();//it will check the prefix value for all the objects and assigned to prefix varaible
system.debug('prefix.Values'+prefix);
if(prefix == keyPrefix){//it will compare and if matches exactly then we are assigning an object API to an objectAPIName
objectAPIName = obj.getDescribe().getName();//objectAPIName=Quote 
system.debug('objectAPIName'+objectAPIName);
break;
}
}*/
        for(Schema.SObjectType objectInstance : schemaMap.Values())
        {
            if(objectInstance.getDescribe().getKeyPrefix() == keyPrefix && objectInstance.getDescribe().getName() == 'SBQQ__Quote__c' )
            {//do your processing with the API name what you want
                System.debug('Id is related to object: '+ objectInstance.getDescribe().getName());
                objectAPIName = objectInstance.getDescribe().getName();
            }
        }
        // objectAPIName
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();//get all the fields api name of quote.
        List<String> finalFields = new List<String>() ;
        finalFields.addAll(fieldMap);//adding to one list
        
        SObjectType objToken = Schema.getGlobalDescribe().get(objectAPIName); 
        system.debug('object Token'+objToken);
        DescribeSObjectResult objDef = objToken.getDescribe();
        system.debug('object def'+objDef);
        Map<String,String> so = new Map<String,String>();
        Map<String,String> so1 = new Map<String,String>();
        system.debug('querySobject : '+querySobject);//line no 7 we can see the Objects Has been Added To querySobject
        for (Schema.ChildRelationship cr: objDef.getChildRelationships()) 
        {
            system.debug('childrelatinship variable'+cr);
            system.debug('Relation ship  name : '+cr.getRelationshipName());
            system.debug('Child Object : '+cr.getChildSObject());
            
            if(cr.getField().getDescribe().isAccessible() && cr.getField().getDescribe().isCreateable() && cr.getField().getDescribe().isAccessible() && cr.getRelationshipName() != null){
                system.debug('--->');
                if(querySobject.contains(''+cr.getChildSObject())){
                    if(cr.getRelationshipName() != 'Attachments' && cr.getRelationshipName() != 'NetworkUserHistoryRecent' && cr.getRelationshipName() != 'NetworkUserHistoryRecent'){
                        so.put(''+cr.getChildSObject()  , ''+cr.getRelationshipName());
                        
                        so1.put(''+cr.getRelationshipName()  , ''+cr.getField()); 
                    }    
                }
            }
        } 
        system.debug('SO : '+so);
        system.debug('SO1 : '+so1);
        List<String> subqueries = prepareSubqueries(so, schemaMap);
        //system.debug('finalFields : '+finalFields);
        // system.debug('subqueries : '+subqueries[0]);
        // system.debug('subqueries : '+subqueries[1]);
        // system.debug('subqueries : '+subqueries[2]);
        
        
        String query =
            'SELECT ' + String.join(finalFields, ',');
        if(subqueries.size() >0){
            query = query + ','+String.join(subqueries, ',');
        }
        
        query = query + ' FROM ' +objectAPIName +
            ' WHERE Id = \''+parentId+'\'';
        
        
        
        system.debug('Query is : '+query);
        List<Sobject> parentObj = Database.query(query);
        system.debug('parentObj is : '+parentObj);
        Sobject parentRecordId = parentObj[0];
        Sobject clonedRecord = parentRecordId.clone();//to initialise the values at the time of clone for Quote
        
        system.debug('clonedRecord>>' +clonedRecord);
        clonedRecord.put('SBQQ__Primary__c', FALSE);
        insert clonedRecord;
        
        String Str= clonedRecord.Id;
        system.debug('clonedRecord>>' +clonedRecord); 
        system.debug('parentRecordId>>'+ parentRecordId);
        List<sObject> childObjects = cloneChildren(parentId,Str,parentRecordId,clonedRecord, so  ,so1,schemaMap,clonedRecord.Id);
        system.debug('child objects' +childObjects);
        
        insert childObjects;
        
        
        map<id,id> oldquotelinesReq = new map<id,id>();
        map<id,id> newquotelinesReq = new map<id,id>();
        Set <String> fieldMap_PC = schemaMap.get('SBQQ__QuoteLine__c').getDescribe().fields.getMap().keySet();
        List<String> finalFields_PC = new List<String>() ;
        finalFields_PC.addAll(fieldMap_PC);
        String query_PC = 'SELECT ' + String.join(finalFields_PC, ',');
        
        query_PC = query_PC + ' FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = \''+parentId+'\'';
        List<SBQQ__QuoteLine__c> oldqotlines = Database.query(query_PC);
        for(SBQQ__QuoteLine__c q:oldqotlines){
            if(q.SBQQ__Bundle__c == true){
                oldquotelinesReq.put(q.id,q.SBQQ__Product__c); 
            }
        }
        
     
        set<Id> proIdSet = new set<Id>(); 
        system.debug('childObjects>>>'+childObjects);
         Schema.SObjectType targetType = Schema.getGlobalDescribe().get('SBQQ__QuoteLine__c');
        List<SBQQ__QuoteLine__c> qolList = new List<SBQQ__QuoteLine__c>();
        for(Sobject coj :childObjects){
            if(coj.getSObjectType()== targetType ){
                qolList.add((SBQQ__QuoteLine__c)coj);
            }
            system.debug('check instance:' +coj.getSObjectType());
        }
        
        
        
        for(SBQQ__QuoteLine__c s: qolList){
            if(s.SBQQ__Bundle__c == true){
                newquotelinesReq.put(s.SBQQ__Product__c,s.id); 
            }
        }
        
        
        
        List<Product2> PC_Clonerecords = new List<Product2>();
        
        /*Set <String> fieldMap_PC = schemaMap.get('Product2').getDescribe().fields.getMap().keySet();
List<String> finalFields_PC = new List<String>() ;
finalFields_PC.addAll(fieldMap_PC);

String query_PC = 'SELECT' + String.join(finalFields_PC, ',');

query_PC = query_PC + ' FROM Product2 WHERE ID IN : \''+proIdSet+'\'';


system.debug('query_PC is : '+query_PC);
List<Product2> lstpodComponetns = Database.query(query_PC);
*/
        List<SBQQ__QuoteLine__c> quoteListToUpdate = new List<SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c p: qolList) {
            
            if(p.SBQQ__Bundle__c == false){
                Id idsr = oldquotelinesReq.get(p.SBQQ__RequiredBy__c);
                p.SBQQ__RequiredBy__c = newquotelinesReq.get(idsr);
            }
            quoteListToUpdate.add(p);  
        }
        
        /*  if(!PC_Clonerecords.isEmpty()) {
insert PC_Clonerecords;
}*/
        if(!quoteListToUpdate.isEmpty()){
            update quoteListToUpdate;
        }
        System.debug('clonedRecord'+clonedRecord.Id);
        return clonedRecord.Id ;
    }
    
    public static List<sObject> cloneChildren(
        string parent1,
        string id,
        Sobject parent,
        Sobject child,
        Map<String , String> childRelatedListObjects,
        Map<String , String> childRelatedListObjects1,
        Map <String, Schema.SObjectType> schemaMap,
        string parentId
    ){
        List<sObject> childObjects1 = new List<SObject>();
        List<sObject> parentRecords1 = new List<sObject>();
        for (String childObjectDefinition : childRelatedListObjects.keyset()) {
            if(childObjectDefinition == 'SBQQ__QuoteDocument__c' || childObjectDefinition == 'SBQQ__QuoteTerm__c' ||  childObjectDefinition == 'SBQQ__QuoteLine__c'){
                Set <String> fieldMap = schemaMap.get(childObjectDefinition).getDescribe().fields.getMap().keySet(); 
                list<string> flields = new list<string>();
                flields.addAll(fieldMap);
                system.debug('childObjectDefinition>>>'+childObjectDefinition);
                String query =
                    'SELECT ' + String.join(flields, ',');
                query = query.removeEnd(',');
                query = query + ' FROM ' + childObjectDefinition + ' Where SBQQ__Quote__c ='+ '\''+parent1+ '\'';
                system.debug('query>>>'+ query);
                List<Sobject> parentObj1 = Database.query(query);
                childObjects1.addAll(parentObj1); 
            }
        }  
        
        List<sObject> records = childObjects1.deepClone(); 
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('SBQQ__QuoteLine__c');
        if(!records.isEmpty()){
            for(sObject s:records){
                s.put('SBQQ__Quote__c',parentId);
                //  s.put('SBQQ__RequiredBy__c' , id );
                /* if(s.getSObjectType() ==  targetType){
s.put('SBQQ__Key__c',null);  
}*/     
                
            }  
        }
        parentRecords1.addAll(records);
        List<sObject> childObjects = new List<SObject>();
        list<id>  quoteLineId =new list<id>();
        /* for (String childObjectDefinition : childRelatedListObjects.values()) {
system.debug('---->'+childObjectDefinition);

List<sObject> parentRecords = new List<sObject>();
for(sObject ptrc :parent.getSObjects(childObjectDefinition))
{
parentRecords.add(ptrc);
}
System.debug('parentRecords'+parentRecords);

//system.debug('cds number-->'+parentRecords[0].get('CDS_Number__c'));

if (parentRecords != null) {
List<sObject> records = parentRecords.deepClone();
system.debug('sobject Records'+records);
system.debug('Child Obj Definition : '+childObjectDefinition);

System.debug('records'+records);
childObjects.addAll(records);
}
}*/
        
        return parentRecords1;
    }
    
    public static List<String> prepareSubqueries(
        Map<String , String> childrelatedListObjects,
        Map <String, Schema.SObjectType> schemaMap
    ){
        List<String> subqueries = new List<String>();
        for(String childObject : childrelatedListObjects.keySet()){
            List<String> childFields = new List<String>();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(childObject).getDescribe().fields.getMap();
            System.debug('fieldMap'+fieldMap);
            for(Schema.SObjectField sof : fieldMap.values()){
                DescribeFieldResult dfr = sof.getDescribe();
                if(dfr.isCreateable()){
                    childFields.add(dfr.getName());
                }
            }
            if(!childFields.isEmpty()){
                String query = '(SELECT ' + String.join(childFields, ',');
                query = query.removeEnd(',');
                query = query + ' FROM ' + childrelatedListObjects.get(childObject) + ')';
                system.debug('query>>>'+ query);
                subqueries.add(query);
            }
            
        }
        return subqueries;
    }
}