public class cpqProductValidation {
    
    @AuraEnabled
    public static boolean showNotification(Id ids){
        User u = [Select Id, Profile.Name, Product_Family_Manager__c from User where Id =: userinfo.getUserId()];
        
        String ft;       
        String pfm = u.Product_Family_Manager__c;       
        
        Boolean notificationFlag = false;
        Boolean pfmResult = false;
        
        system.debug('*****' + ids);
        system.debug('***** PFM: ' + pfm);
        
        Product2 prod = [select id, Product_Owner__c, Family, Family_Type__c from Product2 where id =: ids];
        
        ft = prod.Family_Type__c;
        system.debug('***** Field Type: ' + ft);
              
        if(pfm != null && ft != null)
            pfmResult = pfm.contains(ft);
        
        system.debug('***** PFM Result: ' + pfmResult);
        
        if( 
            u.Id != prod.Product_Owner__c &&
            !pfmResult &&
            u.Profile.Name != 'Other Administrator' && 
            u.Profile.Name != 'System Administrator'               
        ){
            notificationFlag = true;
        }
               
        return notificationFlag;
    }    
}