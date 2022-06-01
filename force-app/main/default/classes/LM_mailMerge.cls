public class LM_mailMerge {
    
    @AuraEnabled
    public static List<String> sfdcURL(String recId ,String objectName){
        List<String> listMailMerge = new List<String>();
        /*String query = 'Select Name from '+ objectName +' where id =\''+ recId + '\' Limit 1';
        System.debug(Database.query(query));*/
        listMailMerge.add(URL.getSalesforceBaseUrl().toExternalForm());
        //list<sobject> rec1 = Database.query(query);
        listMailMerge.add(URL.getSalesforceBaseUrl().toExternalForm().removeEndIgnoreCase('.my.salesforce.com').split('\\.')[0] +'.lightning.force.com');
        return listMailMerge;
    }
    
}