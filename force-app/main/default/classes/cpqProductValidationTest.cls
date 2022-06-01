@isTest
public class cpqProductValidationTest {
    
    @testSetup 
    static void setup(){
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.Family_Type__c = 'Avionics';
        prod.Family = 'Bundle';
        Insert prod;
        
        Product2 prod2 = new Product2();
        prod2.Family = 'Labor';
        prod2.Name = 'Avionics Labor';
        prod2.IsActive = True;
        prod2.SBQQ__QuantityEditable__c = True;
        prod2.SBQQ__DefaultQuantity__c = 1;
        prod2.SBQQ__ConfigurationType__c = 'Allowed';
        prod2.SBQQ__ConfigurationEvent__c = 'Always';
        prod2.SBQQ__BlockPricingField__c = 'Quantity';
        prod2.SBQQ__OptionLayout__c = 'Sections';
        prod2.SBQQ__OptionSelectionMethod__c = 'Click';
        prod2.SBQQ__AssetAmendmentBehavior__c = 'One per quote line';
        prod2.SBQQ__PricingMethod__c = 'List';
        prod2.SBQQ__PricingMethodEditable__c = True;
        prod2.SBQQ__CostEditable__c = True;
        prod2.SBQQ__PriceEditable__c = True;                        
        insert prod2;
        
        //insert Option
        SBQQ__ProductOption__c prodOption = new SBQQ__ProductOption__c ();
        prodOption.SBQQ__ConfiguredSKU__c = prod.Id;
        prodOption.SBQQ__OptionalSKU__c = prod2.Id;
        prodOption.SBQQ__Number__c = 1;
        insert prodOption;
        
        //insert features
        SBQQ__ProductFeature__c prodFeature = new SBQQ__ProductFeature__c();
        prodFeature.name = 'Labor';
        prodFeature.SBQQ__MinOptionCount__c = 1;
        prodFeature.SBQQ__Number__c = 1;
        prodFeature.SBQQ__ConfiguredSKU__c = prod.id;
        insert prodFeature;
        
        //insert features
        SBQQ__ProductFeature__c prodFeature2 = new SBQQ__ProductFeature__c();
        prodFeature2.name = 'Materials';
        prodFeature2.SBQQ__MinOptionCount__c = 1;
        prodFeature2.SBQQ__Number__c = 1;
        prodFeature2.SBQQ__ConfiguredSKU__c = prod.id;
        insert prodFeature2;
        
        //Insert Cost
        SBQQ__Cost__c prodCost = new SBQQ__Cost__c ();
        prodCost.SBQQ__Active__c = True;
        prodCost.SBQQ__UnitCost__c = 100;
        prodCost.SBQQ__Product__c = prod.Id;
        insert prodCost;
        Id standardPbId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPbId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;        
    }
    
    //Test Edit Product
    @isTest
    static void adminRunResult(){ 
        
        Test.startTest();
        
        Product2 prod = [Select Id from Product2 where Family = 'Bundle'];     
        Boolean result = cpqProductValidation.showNotification(prod.Id);
        
        System.assertEquals(result, false);
        
        test.stopTest();
    }
    
    @isTest
    static void invalidUser(){ 
        Test.startTest();
        
        Boolean result;
          
		Product2 prod = [Select Id from Product2 where Family = 'Bundle']; 
        Profile p = [SELECT Id FROM Profile WHERE Name='Gatekeeper-CPQ'];
      	
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
      	insert r;
                
        User u = new User(
            Alias = 'nUser21',
            UserRoleId = r.Id,
            Email='newuser21@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com'
        );       
        insert u;

        system.RunAs(u){
            result = cpqProductValidation.showNotification(prod.Id);
        }
                    
        System.assertEquals(result, true);
        
        test.stopTest();
    }
    
    @isTest
    static void validUser(){ 
        Test.startTest();
        
        Boolean result;
          
		Product2 prod = [Select Id from Product2 where Family = 'Bundle']; 
        Profile p = [SELECT Id FROM Profile WHERE Name='Gatekeeper-CPQ'];
      	
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
      	insert r;
                
        User u = new User(
            Alias = 'nUser21',
            UserRoleId = r.Id,
            Email='newuser21@testorg.com', 
            EmailEncodingKey='UTF-8',
            Product_Family_Manager__c = 'Avionics',
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com'
        );       
        insert u;

        system.RunAs(u){
            result = cpqProductValidation.showNotification(prod.Id);
        }
                    
        System.assertEquals(result, false);
        
        test.stopTest();
    }

}