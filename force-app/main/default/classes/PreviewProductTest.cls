@isTest
public class PreviewProductTest {

   @testSetup 
   static void setup(){
       
       Profile p = [SELECT Id FROM Profile WHERE Name='Other Administrator'];
       
       User u2 = new User(
           Alias = 'nUser21',
           Email='newuser21@testorg.com', 
           EmailEncodingKey='UTF-8', 
           LastName='Cogley', 
           LanguageLocaleKey='en_US', 
           LocaleSidKey='en_US', 
           ProfileId = p.Id, 
           TimeZoneSidKey='America/Los_Angeles', 
           UserName='newuser21@testorg.com'
       );
       
       System.runAs(u2) {
           
           //Insert Product
           Product2 prodChild1 = new Product2(
               Name = 'Perform Task 5750068',
               Make_Model__c = 'Lear-Lear 45',
               Family = 'Bundle',
               Family_Type__c = 'Airframe',
               SBQQ__Specifications__c = 'Flap front Spar Rib support structure - NDI (Eddy Current)',
               Executive_Summary_Group__c = 'Airframe',
               isActive = true);
           
           insert prodChild1;
           
           Product2 prodChild2 = new Product2(
               Name = 'Inspection Labor',
               Family = 'Labor',
               QuantityUnitOfMeasure = 'Hours',
               Executive_Summary_Group__c = 'Airframe',
               ProductCode = 'InspectionLabor',
               Facility_Pricing_Labor_Type__c = 'Inspection',            
               isActive = true
           );
           insert prodChild2;
           
           Product2 prodChild3 = new Product2(
               Name = 'Airframe Service Labor',
               Family = 'Labor',
               QuantityUnitOfMeasure = 'Hours',
               Executive_Summary_Group__c='Airframe',
               ProductCode = 'AirframeServiceLabor',
               Facility_Pricing_Labor_Type__c = 'Airframe Service',            
               isActive = true
           );
           insert prodChild3;
           
           //Insert Product feature
           SBQQ__ProductFeature__c feature = new SBQQ__ProductFeature__c(
               Name = 'Labor',
               SBQQ__MinOptionCount__c = decimal.valueOf('1'),
               SBQQ__Number__c = decimal.valueof('1'),
               SBQQ__ConfiguredSKU__c = prodChild1.id
           );
           insert feature;
           
           // Create Product Options
           List<SBQQ__ProductOption__c> productOptList = new List<SBQQ__ProductOption__c>();
           
           SBQQ__ProductOption__c po1 = new SBQQ__ProductOption__c(
               SBQQ__Number__c = decimal.valueOf('2'),
               SBQQ__Quantity__c = decimal.valueOf('.4'),
               SBQQ__Selected__c = true, 
               SBQQ__ConfiguredSKU__c = prodChild1.id,
               SBQQ__OptionalSKU__c = prodChild2.Id,
               SBQQ__Feature__c = feature.Id,
               SBQQ__Type__c = 'Component'      
           );
           
           productOptList.add(po1);
           
           SBQQ__ProductOption__c po2 = new SBQQ__ProductOption__c(
               SBQQ__Number__c = decimal.valueOf('1'),
               SBQQ__Selected__c = true, 
               SBQQ__Quantity__c = decimal.valueOf('3.6'),
               SBQQ__ConfiguredSKU__c = prodChild1.id,
               SBQQ__OptionalSKU__c = prodChild3.Id,
               SBQQ__Feature__c = feature.Id,
               SBQQ__Type__c = 'Component'      
           );
           
           productOptList.add(po2);
           
           insert productOptList;
           
           // Get standard price book ID.
           Id pricebookId = Test.getStandardPricebookId();
           
           List<PricebookEntry> pbentryStandard = new List<PricebookEntry>();
           
           //Insert Pricebook
           PricebookEntry standardPrice = new PricebookEntry(
               Pricebook2Id = pricebookId, 
               Product2Id = prodChild1.Id,
               UnitPrice = 10000, 
               IsActive = true
           );
           pbentryStandard.add(standardPrice);
           
           PricebookEntry standardPrice2 = new PricebookEntry(
               Pricebook2Id = pricebookId, 
               Product2Id = prodChild2.Id,
               UnitPrice = 10000, 
               IsActive = true
           );
           pbentryStandard.add(standardPrice2);
           
           PricebookEntry standardPrice3 = new PricebookEntry(
               Pricebook2Id = pricebookId, 
               Product2Id = prodChild3.Id,
               UnitPrice = 10000, 
               IsActive = true
           );
           pbentryStandard.add(standardPrice3);
           
           //Cost Record 
           List<SBQQ__Cost__c> cost = new List<SBQQ__Cost__c>();     
           for(Product2 pc : [Select Id from Product2]){
               SBQQ__Cost__c c = new SBQQ__Cost__c();
               c.SBQQ__UnitCost__c = 1000;
               c.SBQQ__Product__c = pc.Id;
               cost.add(c);
           }
           insert cost;
           
           insert pbentryStandard;
           
           // Custom Price Book
           PriceBook2 pb2=new PriceBook2();
           pb2.Name = 'CPQ Price Book';
           pb2.IsActive = true;
           
           insert pb2;
           
           List<PricebookEntry> pbentrys = new List<PricebookEntry>();
           
           PricebookEntry one = new PricebookEntry(
               pricebook2Id = pb2.id,
               product2id = prodChild1.id,
               unitprice = 1249.0,
               isactive = true
           );
           pbentrys.add(one);
           
           PricebookEntry two = new PricebookEntry(
               pricebook2Id = pb2.id,
               product2id = prodChild2.id,
               unitprice = 1.0,
               isactive = true
           );
           pbentrys.add(two);
           
           PricebookEntry three = new PricebookEntry(
               pricebook2Id = pb2.id,
               product2id = prodChild3.id,
               unitprice = 1.0,
               isactive = true
           );
           pbentrys.add(three);
           
           insert pbentrys;
           
           //Insert Template
           SBQQ__QuoteTemplate__c tempId = new SBQQ__QuoteTemplate__c();
           tempId.name = 'Products Preview';
           tempId.SBQQ__DeploymentStatus__c = 'Deployed';
           tempId.SBQQ__PageWidth__c = decimal.valueOf('8.50');
           tempId.SBQQ__PageHeight__c = decimal.valueOf('11');
           tempId.SBQQ__TopMargin__c = decimal.valueOf('.50');
           tempId.SBQQ__BottomMargin__c = decimal.valueOf('.50');
           tempId.SBQQ__LeftMargin__c = decimal.valueOf('.5');
           tempId.SBQQ__RightMargin__c = decimal.valueOf('.5');
           tempId.SBQQ__FontFamily__c = 'Helvetica';
           tempId.SBQQ__ShadingColor__c = 'FFFFFF';
           tempId.SBQQ__FontSize__c = decimal.valueOf('9');
           tempId.SBQQ__BorderColor__c = '000000';
           insert tempId;
           
           //Create Quote    
           SBQQ__Quote__c quote = new SBQQ__Quote__c( 
               RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId(),
               Labor_Type1__c = 'Airframe',
               SBQQ__Status__c = 'Presented'
           );  
           insert quote;  
       }
    }

	static testMethod void PreviewProductController(){
     
    	Product2 prod = [Select Id from Product2 where Family = 'Bundle'];
        system.debug('Product: ' + prod.Id);
    
        Test.startTest();
       
        ApexPages.StandardController sc = new ApexPages.StandardController(prod);
		PreviewProduct testPreview = new PreviewProduct(sc);
       
        PageReference pageRef = Page.PreviewProduct;
        pageRef.getParameters().put('id', String.valueOf(prod.id));
        Test.setCurrentPage(pageRef);
         
        testPreview.autoRun();
         
        Test.stopTest();                            
   }

    static testMethod void DeleteQuote(){
        List<SBQQ__Quote__c> quote = [Select Id from SBQQ__Quote__c];
        List<Id> quoteIds = new List<Id>();
        
        For(SBQQ__Quote__c q : quote){
            quoteIds.add(q.Id);
        }
                
        PreviewProduct.QuoteDelete(quoteIds);        
    }
    
}