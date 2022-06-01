@isTest
public class EngineForSaleApex_Test {
    @isTest
    public static void mehtod1(){
        // Test.StartTest();
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
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com');
        
        System.runAs(u2){
            
            //Create Product Line
            Product_Line__c prodLine = new Product_Line__c(
                Product_Line_Family__c = 'Aircraft',
                Name = 'new'
            );
            insert prodLine;
            
            
            //Create Account
            Account portalAccount = new Account();
            portalAccount.Name = 'test name';
            portalAccount.BillingStreet = '1600 Amphitheatre Parkway';
            portalAccount.BillingCity = 'Mountain View';
            portalAccount.BillingState = 'CA';
            portalAccount.BillingPostalCode = '94043';
            portalAccount.BillingCountry = 'United States';
            insert portalAccount;
            
            
            //Create Aircraft
            Aircraft__c ac = new Aircraft__c();
            ac.Product_Line__c = prodLine.Id;
            ac.Aircraft_Make__c = 'CASA';
            ac.Aircraft_SN__c = '213';
            ac.name = 'NA';
            ac.Aircraft_Type__c = 'Aircraft';
            ac.OwnerId = UserInfo.getUserId();
            insert ac;
            
            //Model__c,Part_No__c,EngineorAPUSN__c,MPI_Remaining__c,CZI_Remaining__c,Engine_Manufacture__c = 'Honeywell'
            
            //Create Engine1
            Equipment__c equip1 = new Equipment__c(
                Product_Line__c = prodLine.Id,
                Name= 'ABC',
                Account__c = portalAccount.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                Model__c = 'HTF7000',
                Part_No__c= '3800498-1',
                MPI_Remaining__c=10,
                CZI_Remaining__c=20,
                Make_Available_in_myStandardAero__c = True,
                Aircraft__c=ac.id,
                Buy__c = True
            );
            insert equip1;
            
            EngineForSaleApex e = new EngineForSaleApex();
            //EngineForSaleApex.ListEquipWrap lew= new EngineForSaleApex.ListEquipWrap();
            
            List<Equipment__c> equpList1= new List<Equipment__c>();
            List<Equipment__c> equpList2= new List<Equipment__c>();
            
            List<Equipment__c> equpList3= new List<Equipment__c>();
            List<Equipment__c> equpList4= new List<Equipment__c>();
            List<Equipment__c> equpList5= new List<Equipment__c>();
            List<Equipment__c> equpList6= new List<Equipment__c>();
            List<Equipment__c> equpList7= new List<Equipment__c>();
            
            equpList1=   e.getEngines();
            equpList2=   e.getHON_Engines();
            equpList3=  e.getLeaseEngines();
            equpList3=  e.getPW_Engines();
            equpList4=  e.getAPU_Engines();
            equpList5= e.getBuyEngines();
            equpList6= e.getExchangeEngines();
            equpList7=  e.getConsignedEngines();
            EngineForSaleApex.ListEquipWrap engEquipWrap = new EngineForSaleApex.ListEquipWrap();
               equip1= engEquipWrap.equip;
                engEquipWrap.i=10;
            List<EngineForSaleApex.ListEquipWrap> lewList= new List<EngineForSaleApex.ListEquipWrap>();
            lewList= EngineForSaleApex.equipMethod();
            lewList= EngineForSaleApex.equipMethod1();
            lewList= EngineForSaleApex.equipMethod2();
            lewList= EngineForSaleApex.equipMethod3();
            
            
        }
    }
    
}