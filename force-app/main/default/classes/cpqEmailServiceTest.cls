@isTest()
public class cpqEmailServiceTest {

	public static testMethod void approveTest(){
        
        // setup controller object
        cpqEmailService objconfirm = new cpqEmailService();
        
        sbaa__ApprovalChain__c cpqAC = TestDataGenerator.createApprovalChain();
        Product_Line__c prodLine = TestDataGenerator.createProductLine();
        Account portalAccount = TestDataGenerator.createAccount();
        Contact c = TestDataGenerator.createContact(portalAccount.Id);
        Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
        Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
        Facility__c fac1 = TestDataGenerator.createFacility();
        Contact createContact = TestDataGenerator.createContact(portalAccount.Id);
        Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
        Opportunity oppty = TestDataGenerator.instantiateOpportunity(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
        SBQQ__Quote__c quote = TestDataGenerator.createQuote(ac, portalAccount, oppty);
        sbaa__Approver__c sa = TestDataGenerator.createQuoteApprovers(string.valueof(userinfo.getUserId()));
        sbaa__ApprovalRule__c ar = TestDataGenerator.createApprovalRule(cpqAC.Id, sa.Id);
        sbaa__ApprovalCondition__c aCon = TestDataGenerator.createApprovalCondition(ar.Id, quote.Id);
        sbaa__Approval__c qa = TestDataGenerator.createApprovalRequest(ar.Id, cpqAC.Id, sa.Id, quote.Id);
                             
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        String fa = userinfo.getUserEmail();
        
        system.debug('From Address: ' + fa);
        
        email.subject = 'Approved ' + quote.Name;
        email.plainTextBody = 'Add comments by editing the text between the Comments brackets.\r\n\r\n' +
            'Comments: [   ---Insert Comments Here---   ]\r\n\r\n' +
            '-----Do not edit below this line-----\r\n' +
            'Approved|' + qa.Id;
        email.fromAddress = fa;

        objconfirm.handleInboundEmail(email, envelope);
        Test.startTest();
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
        System.assertEquals( result.success, true);
        Test.stopTest();
    }
    
    public static testMethod void rejectedTest(){
        
        // setup controller object
        cpqEmailService objconfirm = new cpqEmailService();
        
        sbaa__ApprovalChain__c cpqAC = TestDataGenerator.createApprovalChain();
        Product_Line__c prodLine = TestDataGenerator.createProductLine();
        Account portalAccount = TestDataGenerator.createAccount();
        Contact c = TestDataGenerator.createContact(portalAccount.Id);
        Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
        Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
        Facility__c fac1 = TestDataGenerator.createFacility();
        Contact createContact = TestDataGenerator.createContact(portalAccount.Id);
        Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
        Opportunity oppty = TestDataGenerator.instantiateOpportunity(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
        SBQQ__Quote__c quote = TestDataGenerator.createQuote(ac, portalAccount, oppty);
        sbaa__Approver__c sa = TestDataGenerator.createQuoteApprovers(string.valueof(userinfo.getUserId()));
        sbaa__ApprovalRule__c ar = TestDataGenerator.createApprovalRule(cpqAC.Id, sa.Id);
        sbaa__ApprovalCondition__c aCon = TestDataGenerator.createApprovalCondition(ar.Id, quote.Id);
        sbaa__Approval__c qa = TestDataGenerator.createApprovalRequest(ar.Id, cpqAC.Id, sa.Id, quote.Id);
                             
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        String fa = userinfo.getUserEmail();
        
        system.debug('From Address: ' + fa);
        
        email.subject = 'Rejected ' + quote.Name;
        email.plainTextBody = 'Add comments by editing the text between the Comments brackets.\r\n\r\n' +
            'Comments: [   ---Insert Comments Here---   ]\r\n\r\n' +
            '-----Do not edit below this line-----\r\n' +
            'Rejected|' + qa.Id;        
        email.fromAddress = fa;

        objconfirm.handleInboundEmail(email, envelope);
        Test.startTest();
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
        System.assertEquals( result.success, true);
        test.stopTest();
    }
}