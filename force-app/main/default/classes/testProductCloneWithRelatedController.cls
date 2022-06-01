@isTest
public class testProductCloneWithRelatedController {
    @isTest
    static void testcloneWithItems(){
         Product2 prod = new Product2();
            prod.Name = 'Test Product';
            prod.Family_Type__c = 'Avionics';
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
        
        test.startTest();
        Product2 prod1 = [Select Id from Product2 Limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(prod1);
        ProductCloneWithRelatedController pcrc = new ProductCloneWithRelatedController(sc);
        pcrc.cloneWithItems();
        pcrc.onCancel();
        test.stopTest();
    }

}