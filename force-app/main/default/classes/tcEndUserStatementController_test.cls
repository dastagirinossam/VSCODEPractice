@istest
public class tcEndUserStatementController_test {
  
    @testSetup
    public static void method1(){

        Product_Line__c prodLine = TestDataGenerator.createProductLine();
        Account acnt = TestDataGenerator.createAccount();
        Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, acnt.Id);
        Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, acnt.Id, ac.Id);           
        Contact c = TestDataGenerator.createContact(acnt.Id);
        Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
        Opportunity oppty = TestDataGenerator.instantiateOpportunity(acnt.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion; 
        
        ContentDocument documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acnt.id;
        cdl.ContentDocumentId = documents.Id;
        cdl.shareType = 'V';
        insert cdl;
        
    }
    
    static testMethod void rsmCloneOpportunity_opportunity() { 
        Test.startTest();
        
        Date ExpDate = System.today() + 5;
        
        Opportunity o = [Select Id from Opportunity];
        Account a = [Select Id from Account limit 1];
        Aircraft__c ac = [Select Id from Aircraft__c limit 1];
        ContentDocument doc = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        tcEndUserStatementController.getAccount(o.Id);
        tcEndUserStatementController.getAccount(a.Id);
        tcEndUserStatementController.getAccount(ac.Id);
        
        tcEndUserStatementController.getAttachments(o.Id);
        tcEndUserStatementController.getAttachments(a.Id);
        tcEndUserStatementController.getAttachments(ac.Id);
        
        tcEndUserStatementController.captureEUS(o.Id, doc.LatestPublishedVersionId, ExpDate);
        tcEndUserStatementController.captureEUS(a.Id, doc.LatestPublishedVersionId, ExpDate);
        tcEndUserStatementController.captureEUS(ac.Id, doc.LatestPublishedVersionId, ExpDate);
        
        Test.stopTest();
    }

}