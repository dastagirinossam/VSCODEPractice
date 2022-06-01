@isTest
public class TestCloneProduct {
    
    static testMethod void method1() {

      
        Test.startTest();
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
            
            // create new product record
            Product2 prod = new Product2(
                Product_Owner__c = u2.id,                                           // Product Owner
                Family = 'Bundle',                                                                // Product Family
                Make_Model__c = 'Master Template For All Models',                                 // Make - Model
                Family_Type__c = 'Airframe',                                                      // Family Type
                Name = 'Bid Master Avionics',                                                     // Product Name
                SBQQ__Specifications__c = 'Bid Master Avionics - "Product Description"\n',        // Specifications
                Description = null,                                                               // Product Description
                Condition__c = null,                                                              // Condition
                Vendor_Name__c = null,                                                            // Vendor Name
                QuantityUnitOfMeasure = 'Each',                                                   // Quantity Unit Of Measure
               // TSM_Notes__c = null,                                                              // TSM Notes
                IsActive = true,                                                                  // Active
                List_Price_Last_Updated__c = null,                                                // List Price - Last Updated
                Unit_Cost_Last_Updated__c = null,                                                 // Unit Cost - Last Updated
                SBQQ__SortOrder__c = null,                                                        // Sort Order
                ProductCode = 'Bid Master Airframe Bid Master Airframe - "Product Description"',  // Product Code
                SBQQ__ExcludeFromOpportunity__c = false,                                          // Exclude From Opportunity
                SBQQ__DescriptionLocked__c = false,                                               // Lock Description
                SBQQ__QuantityEditable__c = true,                                                 // Quantity Editable
                ExcludeFromExecutiveSummary__c = false,                                           // Exclude From Executive Summary?
                SBQQ__DefaultQuantity__c = 1.00000,                                             // Default Quantity
                SBQQ__QuantityScale__c = null,                                                    // Quantity Scale
                SBQQ__ConfigurationType__c = 'Allowed',                                           // Configuration Type
                SBQQ__OptionLayout__c = 'Sections',                                               // Option Layout
                SBQQ__ConfigurationEvent__c = 'Always',                                           // Configuration Event
                SBQQ__OptionSelectionMethod__c = 'Click',                                         // Option Selection Method
                SBQQ__ReconfigurationDisabled__c = false,                                         // Disable Reconfiguration
                SBQQ__ConfiguredCodePattern__c = null,                                            // Configured Code Pattern
                SBQQ__Hidden__c = false,                                                          // Hidden
                SBQQ__CustomerCommunityAvailability__c = null,                                    // Customer Community Availability
                SBQQ__Component__c = false,                                                       // Component
                SBQQ__HidePriceInSearchResults__c = false,                                        // Hide Price in Search Results
                SBQQ__BlockPricingField__c = 'Quantity',                                          // Block Pricing Field
                SBQQ__AssetAmendmentBehavior__c = 'Default',                                      // Asset Amendment Behavior
                SBQQ__ConfigurationFieldSet__c = null,                                            // Configuration Field Set
                SBQQ__AssetConversion__c = 'One per quote line',                                  // Asset Conversion
                SBQQ__ConfigurationFields__c = null,                                              // Configuration Fields
                SBQQ__SubscriptionTerm__c = null,                                                 // Subscription Term
                SBQQ__SubscriptionPricing__c = null,                                              // Subscription Pricing
                SBQQ__SubscriptionType__c = 'Renewable',                                          // Subscription Type
                SBQQ__PricingMethod__c = 'List',                                                  // Pricing Method
                SBQQ__CostEditable__c = true,                                                     // Cost Editable
                SBQQ__PricingMethodEditable__c = true,                                            // Pricing Method Editable
                SBQQ__PriceEditable__c = true,                                                    // Price Editable
                SBQQ__NonDiscountable__c = false,                                                 // Non Discountable
                SBQQ__NonPartnerDiscountable__c = false,                                          // Non Partner Discountable
                SBQQ__CompoundDiscountRate__c = null,                                             // Compound Discount (%)
                SBQQ__BatchQuantity__c = null,                                                    // Batch Quantity
                SBQQ__IncludeInMaintenance__c = false,                                            // Include In Percent Of Total
                SBQQ__ExcludeFromMaintenance__c = false,                                          // Exclude From Percent Of Total
                SBQQ__TermDiscountSchedule__c = null,                                             // Term Discount Schedule
                SBQQ__TermDiscountLevel__c = null,                                                // Term Discount Level
                SBQQ__DiscountSchedule__c = null,                                                 // Discount Schedule
                SBQQ__DiscountCategory__c = null,                                                 // Discount Category
                SBQQ__DynamicPricingConstraint__c = null,                                         // Percent Of Total Constraint
                RevenueScheduleType = null,                                                       // Revenue Schedule Type
                NumberOfRevenueInstallments = null,                                               // Number Of Revenue Installments
                RevenueInstallmentPeriod = null ,                                                 // Revenue Installment Period
                bid_master__c = true
            );
            insert prod;
            Product2 prt =[Select id,name from product2 where id =: prod.Id];
            System.debug('limit product'+prt);
            
            system.debug(prod.Id);
            
            // create new product record
            Product2 prod2 = new Product2();
            prod2.Family = 'Labor';
            prod2.Name = 'Avionics Labor';
            prod2.IsActive = True;
            prod2.Family_Type__c = 'Avionics';
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
            try{
                insert prod2;
            }catch(exception e){System.debug('setup exception'+e);}
            
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
            try{
                insert prodFeature;
            }catch(exception e){System.debug('setup exception'+e);}
            
            //insert features
            SBQQ__ProductFeature__c prodFeature2 = new SBQQ__ProductFeature__c();
            prodFeature2.name = 'Materials';
            prodFeature2.SBQQ__MinOptionCount__c = 1;
            prodFeature2.SBQQ__Number__c = 1;
            prodFeature2.SBQQ__ConfiguredSKU__c = prod.id;
            
            try{
                insert prodFeature2;
            }catch(exception e){System.debug('setup exception'+e);}
            
            //Insert Cost
            SBQQ__Cost__c prodCost = new SBQQ__Cost__c ();
            prodCost.SBQQ__Active__c = True;
            prodCost.SBQQ__UnitCost__c = 100;
            prodCost.SBQQ__Product__c = prod.Id;
            try{
                insert prodCost;
            }catch(exception e){System.debug('setup exception'+e);}
            
            Id standardPbId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPbId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
            try{insert standardPrice;
               }catch(exception e){System.debug('setup exception'+e);}
                       
            Pricebook2 stndPB = new Pricebook2(Name='Standard Price Book', isActive=true);
            try{
                insert stndPB;
            }catch(exception e){
                System.debug('setup exception'+e);
            }
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            try{insert customPB;
               }catch(exception e){System.debug('setup exception'+e);}
            
            PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
            try{
                insert customPrice;
            }catch(exception e){System.debug('setup exception'+e);}
            
            List<Id> prodId= new List<Id>();
    prodId.add(prod.Id);
            
    ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            
            CloneProductWithRelatedList cpwr = new CloneProductWithRelatedList(sc);
            
        pageReference p1 = cpwr.GotoProductOptions;
       
        String S = '/SBQQ__ProductOption__c';
        pageReference p2 = new pageReference(S);
        cpwr.GotoProductOptions = p2;
        cpwr.strOutputVariable = S;
           List<Id> pdlist= new  List<Id>();
            pdlist.add(prt.id);
            CloneProductWithRelatedList.ProductRecord(pdlist);
            String str= CloneProductWithRelatedList.customCancel();
       Test.stopTest();                
     
        
}
   }
}