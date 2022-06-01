public class QuickUpdateOpportunityCtrl {
    //Input Parameter -Opportunity Id of type String
    //This Method updates the Opportuntiy Record
    //Returns user Id.
    @AuraEnabled
    public static String updateOpp(String OppId){
        try { 
            Opportunity recd =[SELECT ID, Oppty_Trigger_Update__c  FROM Opportunity WHERE ID=:OppId];
            recd.Oppty_Trigger_Update__c = true;
            update recd;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        return userInfo.getUserId();
    }
}