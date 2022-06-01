public class fslServiceAppointment{
    
    @AuraEnabled
    public static ServiceAppointment getSA(String saID) {
        system.debug('Service Authorization: ' + saID);
        
        /*String soqlSaQuery = SB_ApexUtility.getInstance().queryBuilder('ServiceAppointment'); 
        system.debug('Service Authorization: ' + soqlSaQuery);
        String querySaIdstr = String.valueOf('\'') + saId + String.valueOf('\'');
        querySaIdstr = '(' + querySaIdstr + ')';
       
        ServiceAppointment sa = Database.query(soqlSaQuery + ' where id in ' + querySaIdstr); */
        ServiceAppointment sa = [Select Id, Active_Time_Card__c from ServiceAppointment where Id =: saId];
        system.debug('Results: ' + sa);
        return sa;
    }
    
}