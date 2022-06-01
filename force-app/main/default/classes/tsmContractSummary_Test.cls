@IsTest
public class tsmContractSummary_Test{
    
    @isTest static void method1(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        User u2 = new User(
            Alias = 'nUser21',
            UserRoleId = r.Id,
            Email='newuser21@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            Credit_Analyst_State_Account__c='SD',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com',
        	Product_Directors__c = 'Airframe;Interior;Paint;Other');
        insert u2;

        System.runAs(u2) {
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
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                SBQQ__Opportunity2__c = oppty.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Downtime_Days__c=50,                
                SBQQ__SalesRep__c=u2.id,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS',
                SBQQ__Primary__c = True);  
            insert quote;
            
            test.startTest();
            tsmContractSummaryInit.tsmContractSummaryInit(oppty.Id);
            
            test.stopTest();
        }
    }
    
    /*@isTest(SeeAllData='true')
    public static void method2(){
        SBQQ__Quote__c quote = [Select Id, Name from SBQQ__Quote__c limit 1];
        
        test.startTest();
        
        tsmContractSummary.getRemoteCSV(quote.Name);
        
        test.stopTest();
    }*/
}