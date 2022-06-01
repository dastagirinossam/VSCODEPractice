@isTest
public class test_CloneProductWithRelatedList {
    
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
        }
    }
    
   
    static testMethod void ProductWrapper() {
        User u2 = [Select Id from User where Alias = 'nUser21'];
        Test.StartTest();
        System.runAs(u2) {
            Product2 prod = [Select Id from Product2 where Name =: 'Bid Master Avionics' limit 1];
            
            ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            
            ProductOptions po = new ProductOptions(sc);
            
            if(po.listProductOptionsWrapper.size() > 0){
                po.searchRecord();
                po.listProductOptionsWrapper[0].selected = true;
                po.processSelected();
            }
            
            
        }
        
        Test.StopTest();
    }
    
    static testMethod void ProductSave() {
        User u2 = [Select Id from User where Alias = 'nUser21'];
        
        Test.StartTest();
        System.runAs(u2) {
            Product2 prod = [Select Id from Product2 where Name =: 'Bid Master Avionics' limit 1];
            ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            
            ProductOptions po = new ProductOptions(sc);
            
            if(po.listProductOptionsWrapper.size() > 0){
                po.saveProductOptions();
            }
            
            
        }Test.StopTest();
    }
    
    static testMethod void ProductSaveReturnToProduct() {
        
        User u2 = [Select Id from User where Alias = 'nUser21'];
        Test.StartTest(); 
        System.runAs(u2) {
            Product2 prod = [Select Id from Product2 where Name =: 'Bid Master Avionics' limit 1];
            ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            
            ProductOptions po = new ProductOptions(sc);
            
            if(po.listProductOptionsWrapper.size() > 0){
                po.saveReturnToProduct();
            }
            
            PageReference pageRef = new PageReference('/' + prod.id);
            Test.setCurrentPage(pageRef);
            
            
        }Test.stopTest(); 
    }
    
    static testMethod void ProductBackToProduct() {
        
        User u2 = [Select Id from User where Alias = 'nUser21'];
        Test.StartTest();
        System.runAs(u2) {
            Product2 prod = [Select Id from Product2 where Name =: 'Bid Master Avionics' limit 1];
            ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            
            ProductOptions po = new ProductOptions(sc);
            
            
            if(po.listProductOptionsWrapper.size() > 0){
                po.BackToProduct();
            }
            
            PageReference pageRef = new PageReference('/' + prod.id);
            Test.setCurrentPage(pageRef);
            
            
        }Test.stopTest(); 
    }
    
    static testMethod void CancelParameters() {
        
        User u2 = [Select Id from User where Alias = 'nUser21'];
        
        Test.StartTest(); 
        System.runAs(u2) {
            
            Product2 prod = [Select Id from Product2 where Name =: 'Bid Master Avionics' limit 1];
            PageReference pageRef = Page.AdjustCPQMaterials;    
            ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            
            pageRef.getParameters().put('id', Prod.id);
            pageRef.getParameters().put('retUrl', '/apex/AdjustCPQMaterials?Id=' + Prod.id);
            
            ProductOptions po = new ProductOptions(sc);
            Test.setCurrentPage(pageRef);
            
            String id = ApexPages.currentPage().getParameters().get('id');
            String retUrl = ApexPages.currentPage().getParameters().get('retUrl');        
            
            system.assertEquals(true,id!=null);
            system.assertEquals(true,retUrl!=null);
            
            po.cancel();
            po.cancelProductOption();
            
            
        }
        Test.stopTest(); 
    }
    
    static testMethod void AddProductOptions() {
        
        User u2 = [Select Id from User where Alias = 'nUser21'];
        test.startTest();
        
        System.runAs(u2) {
            Product2 prod = [Select Id from Product2 where Name =: 'Bid Master Avionics' limit 1];
            PageReference pageRef = Page.AdjustCPQMaterials; 
            ApexPages.StandardController sc = new ApexPages.StandardController(prod); 
            ApexPages.currentPage().getParameters().put('id', Prod.id);
            
            ProductOptions po = new ProductOptions(sc);
            po.AddProduct();
            po.AddProductOption();
            
            list<PricebookEntry> pbe = po.pbe;
            list<SBQQ__Cost__c> prodCost = po.prodCost;
            list<SBQQ__ProductOption__c> poList = po.productOptionsList;
            String cost = po.cost;  
            String pricebook = po.pricebook;
            PageReference ref = po.ref;
            
            system.debug('Pribebook Entry: ' + pbe);
            system.debug('Product Cost: ' + prodCost);
            system.debug('PO List: ' + poList);
            system.debug('Cost: ' + cost);
            system.debug('Pribebook: ' + pricebook);
            system.debug('Pribebook Entry: ' + pbe);
        }
        test.stopTest();
    }
    
    static testMethod void testCustomCancel(){
        test.startTest();
        CloneProductWithRelatedList.customCancel();
        Product2 prod = [Select Id from Product2 where Name =: 'Bid Master Avionics' limit 1];
         ApexPages.StandardController sc = new ApexPages.StandardController(prod);      	
        CloneProductWithRelatedList c = new CloneProductWithRelatedList(sc);
        pagereference p = c.GotoProductOptions;
 
        test.stopTest();
    }
    
    static testMethod void CloneRelatedList(){
        User u2 = [Select Id from User where Alias = 'nUser21'];
        
        System.runAs(u2) { 
            System.debug('test master product ');
            List<Product2> lps = [Select Id,Bid_Master__c from Product2];
      
            Product2 ptr = lps[0];
            ptr.Bid_Master__c = True;
            
            update ptr;
            
                 Product2 newProd = [SELECT ID, NAME, PRODUCTCODE, DESCRIPTION, REVENUESCHEDULETYPE, 
                            REVENUEINSTALLMENTPERIOD, NUMBEROFREVENUEINSTALLMENTS, CANUSEREVENUESCHEDULE, 
                            ISACTIVE, FAMILY, ISDELETED, ENGINE_MODELS__C, PICTURE__C, 
                            FACILITY_CAPABILITY__C, FACILITY_CERTIFICATION__C, 
                            MFG_WARRANTY_PERIOD_MONTHS__C, RATING_DOMESTIC__C, 
                            RELATED_PRODUCT_ENGINES__C, TSM__C, AIRWORTHINESS_DIRECTIVES_ADS__C, 
                            NOTES_CERTIFICATION_AND_CAPABILITY__C, X1ST_INSPECTION_CALENDAR_SM__C, 
                            X1ST_INSPECTION_CALENDAR_LG__C, VALUE_PROPOSITION__C, INTERVAL_INFORMATION__C, 
                            SBQQ__ASSETAMENDMENTBEHAVIOR__C, SBQQ__ASSETCONVERSION__C, SBQQ__BATCHQUANTITY__C, 
                            SBQQ__BILLINGFREQUENCY__C, SBQQ__BILLINGTYPE__C, SBQQ__BLOCKPRICINGFIELD__C, 
                            SBQQ__CHARGETYPE__C, SBQQ__COMPONENT__C, SBQQ__COMPOUNDDISCOUNTRATE__C, 
                            SBQQ__CONFIGURATIONEVENT__C, SBQQ__CONFIGURATIONFIELDSET__C, SBQQ__CONFIGURATIONFIELDS__C, 
                            SBQQ__CONFIGURATIONFORMTITLE__C, SBQQ__CONFIGURATIONTYPE__C, SBQQ__CONFIGURATIONVALIDATOR__C, 
                            SBQQ__CONFIGUREDCODEPATTERN__C, SBQQ__CONFIGUREDDESCRIPTIONPATTERN__C, SBQQ__COSTEDITABLE__C, 
                            SBQQ__COSTSCHEDULE__C, SBQQ__CUSTOMCONFIGURATIONPAGE__C, SBQQ__CUSTOMCONFIGURATIONREQUIRED__C, 
                            SBQQ__CUSTOMERCOMMUNITYAVAILABILITY__C, SBQQ__DEFAULTPRICINGTABLE__C, SBQQ__DEFAULTQUANTITY__C, 
                            SBQQ__DESCRIPTIONLOCKED__C, SBQQ__DISCOUNTCATEGORY__C, SBQQ__DISCOUNTSCHEDULE__C, 
                            SBQQ__DYNAMICPRICINGCONSTRAINT__C, SBQQ__EXCLUDEFROMMAINTENANCE__C, SBQQ__EXCLUDEFROMOPPORTUNITY__C, 
                            SBQQ__EXTERNALLYCONFIGURABLE__C, SBQQ__GENERATECONTRACTEDPRICE__C, SBQQ__HASCONFIGURATIONATTRIBUTES__C, 
                            SBQQ__HIDDEN__C, SBQQ__HIDEPRICEINSEARCHRESULTS__C, SBQQ__INCLUDEINMAINTENANCE__C, 
                            SBQQ__NEWQUOTEGROUP__C, SBQQ__NONDISCOUNTABLE__C, SBQQ__NONPARTNERDISCOUNTABLE__C, 
                            SBQQ__OPTIONLAYOUT__C, SBQQ__OPTIONSELECTIONMETHOD__C, SBQQ__OPTIONAL__C, 
                            SBQQ__PRICEEDITABLE__C, SBQQ__PRICINGMETHODEDITABLE__C, SBQQ__PRICINGMETHOD__C, 
                            SBQQ__PRODUCTPICTUREID__C, SBQQ__QUANTITYEDITABLE__C, SBQQ__QUANTITYSCALE__C, 
                            SBQQ__RECONFIGURATIONDISABLED__C, SBQQ__RENEWALPRODUCT__C, SBQQ__SORTORDER__C, 
                            SBQQ__SPECIFICATIONS__C, SBQQ__SUBSCRIPTIONBASE__C, SBQQ__SUBSCRIPTIONCATEGORY__C, 
                            SBQQ__SUBSCRIPTIONPERCENT__C, 
                            SBQQ__SUBSCRIPTIONPRICING__C, SBQQ__SUBSCRIPTIONTARGET__C, 
                            SBQQ__SUBSCRIPTIONTERM__C, SBQQ__SUBSCRIPTIONTYPE__C, 
                            SBQQ__TAXCODE__C, SBQQ__TAXABLE__C, SBQQ__TERMDISCOUNTLEVEL__C, 
                            SBQQ__TERMDISCOUNTSCHEDULE__C, SBQQ__UPGRADECREDIT__C, SBQQ__UPGRADERATIO__C, 
                            SBQQ__UPGRADESOURCE__C, SBQQ__UPGRADETARGET__C, ATA_CODE__C, 
                            AMTOSS_NUMBER__C, CHAPTER__C, CONDITION__C, DETAIL_DESCRIPTION__C, 
                            EXECUTIVE_SUMMARY_GROUP__C, FAMILY_TYPE__C, MAKE_MODEL_OLD__C, 
                            VENDOR_CONTACT__C, VENDOR_NAME__C, VENDOR_NUMBER__C, VENDOR_PHONE__C, 
                            PRODUCT_OWNER__C, LAST_MODIFIED_DATE__C, CPQ_SANDBOX_ID__C, TSM_NOTES__C, 
                            FACILITY_PRICING_LABOR_TYPE__C, MAKE_MODEL__C, LABOR_DESCRIPTOR__C, 
                            MATERIAL_DESCRIPTOR__C, PART_DESCRIPTION_IDENTIFIER__C, 
                            PART_DESCRIPTION__C, TEST_LONG_TEST_AREA__C 
                            FROM Product2 Limit 1];
            List<Id> prodId = new List<Id>();
            prodId.add(newProd.Id);
            
            System.debug('All products in test class' + [Select Id,Bid_Master__c,Name,Family_Type__c from Product2]);
            
         	CloneProductWithRelatedList.ProductRecord(prodId);            
        }    
    }
    
    //Product Options Test Class
    static testMethod void CloneProductOptions() {
        User u2 = [Select Id from User where Alias = 'nUser21'];
        
        Test.StartTest();
        System.runAs(u2) {
            Product2 prod = [Select Id from Product2 where Name =: 'Bid Master Avionics' limit 1];
            Product2 prod2 = [Select Id from Product2 where Name =: 'Avionics Labor' limit 1];
            
            PageReference pageRef = Page.AdjustCPQMaterials;    
            ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            
            pageRef.getParameters().put('id', Prod.id);
            pageRef.getParameters().put('retUrl', '/apex/AdjustCPQMaterials?Id=' + Prod.id);
            
            ProductOptions po = new ProductOptions(sc);
            Test.setCurrentPage(pageRef);
            
            String id = ApexPages.currentPage().getParameters().get('id');
            String retUrl = ApexPages.currentPage().getParameters().get('retUrl');  
            
            po.AddProductOption();
            po.saveProductOptions();
            po.cloneProductOptions();
        }
        
        Test.StopTest();
    }
    
    static testMethod void SaveProductOption() {
        User u2 = [Select Id from User where Alias = 'nUser21'];
        
        Test.StartTest();
        System.runAs(u2) {
            Product2 prod = [Select Id from Product2 where Name =: 'Bid Master Avionics' limit 1];
            Id pb = Test.getStandardPricebookId();
            SBQQ__Cost__c c = [Select Id from SBQQ__Cost__c limit 1];
            SBQQ__ProductFeature__c f = [Select Id from SBQQ__ProductFeature__c where name =: 'Labor'];
            
            PageReference pageRef = Page.AddMaterials;    
            ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            
            pageRef.getParameters().put('prodId', Prod.id);
            pageRef.getParameters().put('retUrl', '/apex/AdjustCPQMaterials?Id=' + Prod.id);
            pageRef.getParameters().put('number', '1');
            pageRef.getParameters().put('feature', f.id);
            pageRef.getParameters().put('pricebook', pb);
            pageRef.getParameters().put('cost', c.id);
            
            ProductOptions po = new ProductOptions(sc);
            Test.setCurrentPage(pageRef);
            
            String id = ApexPages.currentPage().getParameters().get('id');
            String retUrl = ApexPages.currentPage().getParameters().get('retUrl');
            
            po.saveProductOption();
            po.productOption();         
        }
        
        Test.StopTest();
    }
    
    static testMethod void CreateProductOption() {
        User u2 = [Select Id from User where Alias = 'nUser21'];
        
        Test.StartTest();
        System.runAs(u2) {
            Product2 prod = [Select Id from Product2 where Name =: 'Bid Master Avionics' limit 1];
            
            SBQQ__Cost__c c = [Select Id from SBQQ__Cost__c limit 1];
            SBQQ__ProductFeature__c f = [Select Id from SBQQ__ProductFeature__c where name =: 'Labor'];
            Pricebook2 pb = [Select Id, Name from Pricebook2 where Name =: 'Standard Price Book' Limit 1];
            system.debug('price Book: ' + pb.Name);
            PageReference pageRef = Page.CreateProductMaterial;    
            ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            
            pageRef.getParameters().put('prodId', Prod.id);
            pageRef.getParameters().put('retUrl', '/apex/AdjustCPQMaterials?Id=' + Prod.id);
            pageRef.getParameters().put('number', '1');
            pageRef.getParameters().put('feature', f.id);
            pageRef.getParameters().put('pricebook', pb.id);
            pageRef.getParameters().put('cost', c.id);
            
            ProductOptions po = new ProductOptions(sc);
            Test.setCurrentPage(pageRef);

            po.prod.Name = 'Test Product Option';
            po.prod.Description = 'testing';
            po.prod.Condition__c = 'New';
            po.prod.Vendor_Name__c = 'StandardAero';
            po.prod.QuantityUnitOfMeasure = 'Each';
            po.pCost = 1.00;
            po.pSellPrice = 1.00; 
            
            po.save();
        }
        
        Test.StopTest();
    }
    
    static testMethod void ProductOptionButtons() {
        User u2 = [Select Id from User where Alias = 'nUser21'];
        
        Test.StartTest();
        System.runAs(u2) {
            Product2 prod = [Select Id from Product2 where Name =: 'Bid Master Avionics' limit 1];
            Product2 prod2 = [Select Id from Product2 where Name =: 'Avionics Labor' limit 1];
            
            PageReference pageRef = Page.AdjustCPQMaterials;    
            ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            
            pageRef.getParameters().put('id', Prod.id);
            pageRef.getParameters().put('retUrl', '/apex/ProductVF?c__id=' + Prod.id);
            
            ProductOptions po = new ProductOptions(sc);
            Test.setCurrentPage(pageRef);
            
            po.cancel();
            test.stopTest();
        }        
    }   
}