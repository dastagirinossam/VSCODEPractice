@isTest
public class UnitCostLastModifiedTest {
    
    @testSetup 
    static void setup(){ 
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Other Administrator'];
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        User u2 = new User(
            Alias = 'nUser21',
            UserRoleId = r.Id,
            Email='newuser21@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Cogley', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com');
        
        System.runAs(u2) {
            // create new product record
            Product2 prod = new Product2();
            prod.Family = 'Bundle';
            prod.Name = 'Bid Master Avionics';
            prod.Family_Type__c = 'Avionics';
            prod.Make_Model__c = 'Master Template For All Models';
            prod.IsActive = True;
            prod.SBQQ__QuantityEditable__c = True;
            prod.SBQQ__DefaultQuantity__c = 1;
            prod.SBQQ__ConfigurationType__c = 'Allowed';
            prod.SBQQ__ConfigurationEvent__c = 'Always';
            prod.SBQQ__BlockPricingField__c = 'Quantity';
            prod.SBQQ__OptionLayout__c = 'Sections';
            prod.SBQQ__OptionSelectionMethod__c = 'Click';
            prod.SBQQ__AssetAmendmentBehavior__c = 'One per quote line';
            prod.SBQQ__PricingMethod__c = 'List';
            prod.SBQQ__PricingMethodEditable__c = True;
            prod.SBQQ__CostEditable__c = True;
            prod.SBQQ__PriceEditable__c = True;
            prod.Bid_Master__c = True;                       
            insert prod;
            
            // create new product record
            Product2 prod2 = new Product2();
            prod2.Family = 'Materials';
            prod2.Name = 'Avionics Material';
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
            prodFeature.name = 'Materials';
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
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPbId, Product2Id = prod2.Id, UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
            
            PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod2.Id, UnitPrice = 12000, IsActive = true);
            insert customPrice;
        }
    }
    
    static testMethod void ProductScheduleJobBatch() {
        
        User u2 = [Select Id from User where Alias = 'nUser21'];
        
        System.runAs(u2) {
            
            Test.startTest();
            ProductUpdateBatchJobscheduled obj = new ProductUpdateBatchJobscheduled();
            obj.execute(null);
            Test.stopTest();
        }
    }
    
    static testMethod void ProductScheduleUpdate() {
        User u2 = [Select Id from User where Alias = 'nUser21'];
        
        System.runAs(u2) {
            Test.startTest();
            ProductUpdateBatchJob obj = new ProductUpdateBatchJob();
            DataBase.executeBatch(obj);           
            Test.stopTest();
        }
    }  
}