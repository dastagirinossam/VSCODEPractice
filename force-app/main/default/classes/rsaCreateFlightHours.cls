public class rsaCreateFlightHours {

    @AuraEnabled
    public static Aircraft__c acFlightHours(String acId){
        
        String soqlAircraftQuery = SB_ApexUtility.getInstance().queryBuilder('Aircraft__c');
        String queryAircraftIdstr = String.valueOf('\'') + acId + String.valueOf('\'');
        queryAircraftIdstr = '(' + queryAircraftIdstr + ')';

        Aircraft__c ac = Database.query(soqlAircraftQuery + ' where Id in ' + queryAircraftIdstr);   
        
        return ac;
    }
    
    @AuraEnabled    
    public static Equipment__c eqFlightHours(String eqId){
        
        String soqlEquipmentQuery = SB_ApexUtility.getInstance().queryBuilder('Equipment__c');
        String queryEquipmentIdstr = String.valueOf('\'') + eqId + String.valueOf('\'');
        queryEquipmentIdstr = '(' + queryEquipmentIdstr + ')';

        Equipment__c eq = Database.query(soqlEquipmentQuery + ' where Id in ' + queryEquipmentIdstr);   
        
        return eq;
    }
  
}