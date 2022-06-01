@isTest
public class TestLM_NewQuoteListButtonCtrl {
    
    @testSetup static void setUp() {
        Account a = new Account();
        a.Name= 'testAccount';
        a.BillingState='CA';
        insert a;
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opp1 = new Opportunity(Name='testOpp1',RecordTypeId=oppRecordTypeId,stageName='New Opportunity',closeDate=Date.Today(),Opportunity_Name_Details__c='testdetails',Master_Opportunity__c=true,Amount=100,AccountId=a.id,Facility__c='AGS');
        opps.add(opp1);
        Opportunity opp2 = new Opportunity(Name='testOpp2',RecordTypeId=oppRecordTypeId,stageName='New Opportunity',closeDate=Date.Today(),Opportunity_Name_Details__c='testdetails',Master_Opportunity__c=false,Amount=200,AccountId=a.id,Facility__c='AGS');
		opps.add(opp2);
        insert opps;
    }
    
    static testMethod void testGetFieldDescribeMap(){
        Map<String, Object> fieldDescribe;
        test.startTest();
        fieldDescribe = LM_NewQuoteListButtonCtrl.getFieldDescribeMap('Opportunity');
        test.stopTest();
       	System.debug('tester'+fieldDescribe.get('AccountId'));
        System.assertNotEquals(0, fieldDescribe.size());
        
    }
    
    static testMethod void testOppRec(){
        List<Opportunity> testOpp = [select Id from Opportunity Limit 2];
        List<Opportunity> retrievetestOpps = new List<Opportunity>();
        test.startTest();
        for(Opportunity o:testOpp){
        	retrievetestOpps.add(LM_NewQuoteListButtonCtrl.OppRec(o.Id));
                }
        test.stopTest();
        System.assertEquals(2, retrievetestOpps.size());
        System.assertEquals(true,retrievetestOpps[0].Master_Opportunity__c);
        
    }
    
    static testMethod void testGetRecTypeId(){
        List<Opportunity> testOpp = [select Id from Opportunity Limit 2];
        List<String> recTypeIds = new List<String>();
        test.startTest();
        for(Opportunity o:testOpp){
        	recTypeIds.add(LM_NewQuoteListButtonCtrl.getRecTypeId(o.Id));
                }
        test.stopTest();
        String recName =[Select Name from RecordType where id=:recTypeIds[0]][0].name;
        System.assertEquals('Master Proposal', recName);
        String recName1 =[Select Name from RecordType where id=:recTypeIds[1]][0].name;
        System.assertEquals('Standard Proposal', recName1);
    }
    @isTest 
    static void testOppRecException()
    {
        try{
        LM_NewQuoteListButtonCtrl.oppRec('abcd');
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage());
        }
    }
    @isTest 
    static void testgetRecTypeIdException()
    {
        try{
        LM_NewQuoteListButtonCtrl.getRecTypeId('abcd');
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage());
        }

    }

}