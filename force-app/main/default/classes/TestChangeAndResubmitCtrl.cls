@isTest
public class TestChangeAndResubmitCtrl {
    
    static testMethod void testMethod1() 
    {
        Account acc = TestDataGenerator.createAccount();
        Product_Line__c  proline = TestDataGenerator.createProductLine();
        Aircraft__c craft = TestDataGenerator.createAircraft(proline.Id);
        Equipment__c eq = TestDataGenerator.createEquipment(proline.Id, acc.Id);
        Opportunity opp = TestDataGenerator.instantiateOpportunity();
        opp.AccountId= acc.Id;
        opp.Equipment__c=eq.Id;
        opp.Aircraft__c= craft.Id;
        opp.Product_Line__c=proline.ID;
        insert opp;
        //Create contact
        Contact portalcontact = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = acc.Id
        );
        insert portalContact;
        //Create User
        User portalUser = new User(
            ProfileId = [Select Id from profile where name = 'Customer Community Plus - Custom'].Id,
            PortalRole = 'Executive',
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='demo@wilcosource.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago',
            CommunityNickname = 'testUser123',
            IsActive = true,
            ContactId = portalContact.id
        );
        insert portalUser;
        
        //Create Product
        Product2 prod = new Product2(
            Name = 'Unscheduled Product',
            ProductCode = 'Code1',
            isActive = True
        );
        insert prod;
        
        //Create Project
        MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c();
        proj.Name = 'Project Test';
        proj.MPM4_BASE__Account__c = acc.Id;
        proj.Opportunity__c = opp.Id;
        proj.Aircraft__c = craft.Id;
        proj.Engine__c = eq.Id;
        proj.Input_Date__c = opp.InputDate__c;
        proj.Delivery_Date__c = opp.OutputDate__c;
        proj.MPM4_BASE__Kickoff__c = opp.InputDate__c;
        proj.MPM4_BASE__Deadline__c = opp.OutputDate__c;
        proj.Crew_Chief__c = 'Spoon Man';
        proj.CPM__c = userInfo.getUserId();
        proj.Designated_Approver__c = portalUser.Id;
        proj.MPM4_BASE__Status__c = 'Active';             
        insert proj;
        SBQQ__Quote__c quote = TestDataGenerator.instantiateQuote();
        quote.SBQQ__Opportunity2__c=opp.Id;
        quote.SBQQ__Account__c=acc.Id;
        quote.Aircraft__c=craft.Id;
        quote.Project__c = proj.Id;
        try{
            insert quote;
        }catch(DMLException e){
            System.debug('==DMLException=='+e.getDmlMessage(0));
        }
        SBQQ__QuoteLine__c quoteline = TestDataGenerator.instantiateQuoteline();
        quoteline.SBQQ__Quote__c = quote.Id;
        quoteline.Project__c = proj.Id;
        quoteline.SBQQ__Product__c = prod.Id;
        quoteline.Job_Card_Description__c = 'Test Squawk1';
        quoteline.Designated_Approver__c = portalUser.Id;
        try{
            Database.SaveResult srList = Database.insert(quoteline, false);
        }catch(DMLException e){
            System.debug('==DMLException2=='+e.getDmlMessage(0));
        }
        //Database.insert(quoteline);
        //system.debug('========='+srList);        
        Test.startTest(); 
        try{
            ChangeAndResubmitCtrl.getQuoteLine(quoteline.Id);
        }catch(Exception e){
            System.debug('==='+e.getMessage());
        }
        Test.stopTest();
    }
}