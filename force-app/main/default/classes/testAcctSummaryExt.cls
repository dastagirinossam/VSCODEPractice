@isTest
public class testAcctSummaryExt {

    @testSetup()
    static void setup(){
    
        //Create Product Line
        Product_Line__c prodLine = new Product_Line__c(
            Product_Line_Family__c = 'Aircraft',
            Name = 'new'
        );
        insert prodLine;
        
        //Create Account
        Account acnt = new Account();
        acnt.Name = 'test name';
        acnt.BillingStreet = '1600 Amphitheatre Parkway';
        acnt.BillingCity = 'Mountain View';
        acnt.BillingState = 'CA';
        acnt.BillingPostalCode = '94043';
        acnt.BillingCountry = 'United States';
        insert acnt;
        
        //Create Engine
        Equipment__c equip = new Equipment__c(
            Product_Line__c = prodLine.Id,
            Account__c = acnt.id,
            Equipment_Prefix__c = 'TFE',
            EngineorAPUSN__c = 'ABC',
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'HTF7000'
        );
        insert equip;
        
        //Create Aircraft
        Aircraft__c ac = new Aircraft__c();
        ac.Product_Line__c = prodLine.Id;
        ac.Aircraft_Make__c = 'CASA';
        ac.Aircraft_SN__c = '213';
        ac.name = 'new';
        ac.Aircraft_Type__c = 'Aircraft';
        ac.OwnerId = UserInfo.getUserId();
        insert ac;
        
        //Create contact
        Contact con = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = acnt.Id
        );
        insert con;
        
        //Create Opportunity
        Opportunity oppty = new Opportunity();
        oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
        oppty.RSM__c = 'Campbell,Tom';
        oppty.Name = 'trigger test';
        oppty.Opportunity_Name_Details__c = 'trigger test';
        oppty.StageName = 'Cust Submitted Quote';
        oppty.AccountId = acnt.Id;
        oppty.Aircraft__c = ac.Id;
        oppty.Amount = decimal.valueof('1471620');
        oppty.Equipment__c = equip.Id;
        oppty.CustomerName__c = 'World Jet, Inc.';
        oppty.Facility__c = 'AGS';
        oppty.Tier_Level__c = '1';
        oppty.CloseDate =Date.today();
        oppty.InputDate__c =Date.today();
        oppty.OutputDate__c =Date.today();
        oppty.Product_Line__c = ac.Product_Line__c;
        oppty.Type = 'Airframe';
        oppty.SubType__c = 'Airframe - Inspection';
        oppty.LeadSource = 'CPM';
        oppty.QuoteDelivery__c = 'Hand Delivery';
        oppty.QuoteRequiredBy__c =Date.today();
        oppty.Base_Quote_Number__c = '1';
        oppty.QuotedDate__c =Date.today();
        oppty.Concession1__c = 'None';
        oppty.Agent_Representative__c = 'Not Applicable'; 
        insert oppty;     
     }
     
     static testMethod void accntSum(){
     
         Account acnt = [Select Id from Account];
        
         Test.startTest();
              
         ApexPages.StandardController sc = new ApexPages.StandardController(acnt);
         AcctSummaryExt testAcctSummaryExt = new AcctSummaryExt(sc);
         
         PageReference pageRef = Page.AccountSummary; // Add your VF page Name here
         pageRef.getParameters().put('id', String.valueOf(acnt.id));
         Test.setCurrentPage(pageRef);
           
         testAcctSummaryExt.getAcctId();
         testAcctSummaryExt.getACSum();
         testAcctSummaryExt.getContactSum();
         testAcctSummaryExt.getEquipSum();
         testAcctSummaryExt.getOpptySum();
         testAcctSummaryExt.getCases();
         testAcctSummaryExt.getManagedAC();
         testAcctSummaryExt.getMST();
         testAcctSummaryExt.getManagedACEquipSum();
         testAcctSummaryExt.getManagedOpptySum();
         
                 
         Test.stopTest();       
                
	}
        
}