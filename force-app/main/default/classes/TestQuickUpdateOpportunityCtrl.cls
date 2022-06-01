@isTest
public class TestQuickUpdateOpportunityCtrl {
    
    static testMethod void testupdateOpp(){
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
        //Opportunity opp = new Opportunity(Name='testOpp1',RecordTypeId=oppRecordTypeId,stageName='New Opportunity',closeDate=Date.Today(),Opportunity_Name_Details__c='testdetails',Master_Opportunity__c=true,Amount=100,Oppty_Trigger_Update__c=false,Facility__c='AGS');
        Account a = new Account();
        a.Name= 'testAccount';
        a.BillingState='CA';
        insert a;
        Opportunity opp2 = new Opportunity(Name='testOpp2',RecordTypeId=oppRecordTypeId,stageName='New Opportunity',closeDate=Date.Today(),Opportunity_Name_Details__c='testdetails',Master_Opportunity__c=false,Amount=200,AccountId=a.id,Facility__c='AGS',Oppty_Trigger_Update__c=false);
		
        try{        insert opp2;
           }
        catch(DMLException de){
            System.debug(de.getMessage());
        }
        test.startTest();
        QuickUpdateOpportunityCtrl.updateOpp(opp2.id);
        test.stopTest();
        Opportunity oppTest = [select Oppty_Trigger_Update__c from Opportunity where id =:opp2.id ];
        System.assertEquals(true, oppTest.Oppty_Trigger_Update__c);
        
    }
    
    @isTest 
    static void testupdateOppException()
    {
        try{
            QuickUpdateOpportunityCtrl.updateOpp('EXCEP');
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
        
    }
    
}