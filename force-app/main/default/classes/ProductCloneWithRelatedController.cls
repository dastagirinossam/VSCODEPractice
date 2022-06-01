public class ProductCloneWithRelatedController {
    
    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
    // add the instance for the variables being passed by id on the url
    private Product2 prodrec {get;set;}
    // set the id of the record that is created -- ONLY USED BY THE TEST CLASS
    public ID newRecordId {get;set;}
    
    // initialize the controller
    public ProductCloneWithRelatedController(ApexPages.StandardController controller) {
        
        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        prodrec = (Product2)controller.getRecord();
        
    }
    
    // method called from the VF's action attribute to clone the po
    public PageReference cloneWithItems() {
        
        List<SBQQ__ProductOption__c> prodOpts = new List<SBQQ__ProductOption__c>();
        List<SBQQ__ProductFeature__c> prodFtrs = new List<SBQQ__ProductFeature__c>();
        List<SBQQ__Cost__c> prodCosts = new List<SBQQ__Cost__c>();
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        List<PricebookEntry> pbeListStanderd = new List<PricebookEntry>();

        
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        Product2 newProdRec;
        
        try {
            
            //copy the product record - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
            prodrec = [SELECT   StockKeepingUnit, Engine_Models__c, Picture__c, Facility_Capability__c, Facility_Certification__c, MFG_Warranty_Period_Months__c, Rating_Domestic__c, Related_Product_Engines__c, TSM__c, Airworthiness_Directives_ADs__c, MST_Capable__c, Rating_EMEA__c, Rating_MEX__c, Rating_APAC__c, Rating_LATAM__c, Notes_Certification_and_Capability__c, X1st_Inspection_Calendar_Sm__c, X1st_Inspection_Calendar_Lg__c, X1st_Inspection_Hourly_Sm__c, X1st_Inspection_Hourly_Lg__c, Ratings_Rider__c, Rider_Rating__c, X18_Character_Product_ID__c, Sub_Type_2_Required__c, Value_Proposition__c, Serial_Number_Range__c, Interval_Information__c, ATA_Code__c, Aircraft_Delivered__c, Amtoss_Number__c, Bid_Master__c, CPQ_Sandbox_ID__c, Chapter__c, Condition__c, Detail_Description__c, ExcludeFromExecutiveSummary__c, Executive_Summary_Group__c, Facility_Pricing_Labor_Type__c, Family_Type__c, Labor_Descriptor__c, Last_Modified_Date__c, Make_Model_Old__c, Make_Model__c, Material_Descriptor__c, Part_Description_Identifier__c, Part_Description__c, Product_Owned_by_Current_User__c, Product_Owner__c, TSM_Notes__c, Test_Long_Test_Area__c, Vendor_Contact__c, Vendor_Name__c, Vendor_Number__c, Vendor_Phone__c, Unit_Cost_Last_Updated__c, Sell_Last_Updated__c, List_Price_Last_Updated__c, List_Price_c__c, Unit_Cost_c__c, SBQQ__AssetAmendmentBehavior__c, SBQQ__AssetConversion__c, SBQQ__BatchQuantity__c, SBQQ__BillingFrequency__c, SBQQ__BillingType__c, SBQQ__BlockPricingField__c, SBQQ__ChargeType__c, SBQQ__Component__c, SBQQ__CompoundDiscountRate__c, SBQQ__ConfigurationEvent__c, SBQQ__ConfigurationFieldSet__c, SBQQ__ConfigurationFields__c, SBQQ__ConfigurationFormTitle__c, SBQQ__ConfigurationType__c, SBQQ__ConfigurationValidator__c, SBQQ__ConfiguredCodePattern__c, SBQQ__ConfiguredDescriptionPattern__c, SBQQ__CostEditable__c, SBQQ__CostSchedule__c, SBQQ__CustomConfigurationPage__c, SBQQ__CustomConfigurationRequired__c, SBQQ__CustomerCommunityAvailability__c, SBQQ__DefaultPricingTable__c, SBQQ__DefaultQuantity__c, SBQQ__DescriptionLocked__c, SBQQ__DiscountCategory__c, SBQQ__DiscountSchedule__c, SBQQ__DynamicPricingConstraint__c, SBQQ__ExcludeFromMaintenance__c, SBQQ__ExcludeFromOpportunity__c, SBQQ__ExternallyConfigurable__c, SBQQ__GenerateContractedPrice__c, SBQQ__HasConfigurationAttributes__c, SBQQ__Hidden__c, SBQQ__HidePriceInSearchResults__c, SBQQ__IncludeInMaintenance__c, SBQQ__NewQuoteGroup__c, SBQQ__NonDiscountable__c, SBQQ__NonPartnerDiscountable__c, SBQQ__OptionLayout__c, SBQQ__OptionSelectionMethod__c, SBQQ__Optional__c, SBQQ__PriceEditable__c, SBQQ__PricingMethodEditable__c, SBQQ__PricingMethod__c, SBQQ__ProductPictureID__c, SBQQ__QuantityEditable__c, SBQQ__QuantityScale__c, SBQQ__ReconfigurationDisabled__c, SBQQ__RenewalProduct__c, SBQQ__SortOrder__c, SBQQ__Specifications__c, SBQQ__SubscriptionBase__c, SBQQ__SubscriptionCategory__c, SBQQ__SubscriptionPercent__c, SBQQ__SubscriptionPricing__c, SBQQ__SubscriptionTarget__c, SBQQ__SubscriptionTerm__c, SBQQ__SubscriptionType__c, SBQQ__TaxCode__c, SBQQ__Taxable__c, SBQQ__TermDiscountLevel__c, SBQQ__TermDiscountSchedule__c, SBQQ__UpgradeCredit__c, SBQQ__UpgradeRatio__c, SBQQ__UpgradeSource__c, SBQQ__UpgradeTarget__c, ProductNameURL__c, QuantityUnitOfMeasure, Family, IsActive, CanUseRevenueSchedule, NumberOfRevenueInstallments, RevenueInstallmentPeriod, RevenueScheduleType, Description, ProductCode, Name, Id, DisplayUrl FROM Product2 where id = :prodrec.id];
            newProdRec = prodrec.clone(false);
            newProdRec.Name='Copy of '+ newProdRec.Name;
            insert newProdRec;
            
            // set the id of the new po created for testing
            newRecordId = newProdRec.id;
            
            //Clone Features
            List<SBQQ__ProductFeature__c> prodFtr = [SELECT ID, NAME, SBQQ__CATEGORY__C, SBQQ__CONFIGURATIONFIELDSET__C, SBQQ__CONFIGUREDSKU__C, SBQQ__DISCOUNTSCHEDULE__C, SBQQ__DYNAMICPRODUCTFILTERFIELDSET__C, SBQQ__DYNAMICPRODUCTLOOKUPFIELDSET__C, SBQQ__MAXOPTIONCOUNT__C, SBQQ__MINOPTIONCOUNT__C, SBQQ__NUMBER__C, SBQQ__OPTIONSELECTIONMETHOD__C, CPQ_SANDBOX_ID__C FROM SBQQ__ProductFeature__c WHERE SBQQ__CONFIGUREDSKU__r.Id = : prodrec.Id];       
            for(SBQQ__ProductFeature__c pf : prodFtr){
                SBQQ__ProductFeature__c pfCopy = pf.clone(false,true);
                pfCopy.SBQQ__CONFIGUREDSKU__c = newProdRec.Id;
                prodFtrs.add(pfCopy);
            }
            
            insert prodFtrs;
            
            List<SBQQ__ProductFeature__c> newProdFtrs = [Select Id, Name From SBQQ__ProductFeature__c where SBQQ__CONFIGUREDSKU__r.Id =: newProdRec.Id];
            System.debug('newProdFtrs'+newProdFtrs);
            
            //Product Options      
            List<SBQQ__ProductOption__c> prodOpt = [SELECT ID, NAME, TSM_Notes__c, SBQQ__APPLIEDIMMEDIATELYCONTEXT__C, SBQQ__APPLIEDIMMEDIATELY__C, SBQQ__BUNDLED__C, SBQQ__COMPONENTCODEPOSITION__C, SBQQ__COMPONENTCODE__C, SBQQ__COMPONENTDESCRIPTIONPOSITION__C, SBQQ__COMPONENTDESCRIPTION__C, SBQQ__CONFIGUREDSKU__C, SBQQ__DEFAULTPRICINGTABLE__C, SBQQ__DISCOUNTAMOUNT__C, SBQQ__DISCOUNTSCHEDULE__C, SBQQ__DISCOUNT__C, SBQQ__DISCOUNTEDBYPACKAGE__C, SBQQ__EXISTINGQUANTITY__C, SBQQ__Feature__c, SBQQ__Feature__r.Name, SBQQ__MAXQUANTITY__C, SBQQ__MINQUANTITY__C, SBQQ__NUMBER__C, SBQQ__OPTIONALSKU__C, SBQQ__PRICEEDITABLE__C, SBQQ__PRODUCTCODE__C, SBQQ__PRODUCTCONFIGURATIONTYPE__C, Product_Description__c, SBQQ__PRODUCTFAMILY__C, SBQQ__PRODUCTNAME__C, SBQQ__PRODUCTQUANTITYSCALE__C, SBQQ__PRODUCTSUBSCRIPTIONPRICING__C, SBQQ__QUANTITYEDITABLE__C, SBQQ__QUANTITY__C, SBQQ__QUOTELINEVISIBILITY__C, SBQQ__RENEWALPRODUCTOPTION__C, SBQQ__REQUIRED__C, SBQQ__SELECTED__C, SBQQ__SUBSCRIPTIONSCOPE__C, SBQQ__SYSTEM__C, SBQQ__TYPE__C, SBQQ__UNITPRICE__C, SBQQ__UPLIFTEDBYPACKAGE__C, JOB_CARD__C, LABOR_CODE__C, RTS__C, LABOR_AMOUNT__C, MATERIAL_AMOUNT__C, FIRM_PRICE_LABOR__C, FIRM_PRICE_MATERIALS__C, CPQ_SANDBOX_ID__C, PRODUCT_18_DIGIT_ID__C, LABOR_TYPE__C, JOB_CARD_DESCRIPTION__C, SPECIFICATION__C, SBQQ_SPECIFICATION__C, MATERIAL_TYPE__C, ADD_WORK_LABOR_TYPE__C FROM SBQQ__ProductOption__c WHERE SBQQ__CONFIGUREDSKU__r.Id = : prodrec.Id];            
            System.debug('Product options'+prodOpt);
            for(SBQQ__ProductOption__c p : prodOpt){
                
                //Insert New Features Into Product Options
                for(SBQQ__ProductFeature__c f : newProdFtrs){
                    if(p.SBQQ__Feature__r.Name == f.Name){
                        SBQQ__ProductOption__c poCopy = p.clone(false,true);
                        
                        poCopy.SBQQ__Feature__c = f.Id;
                        poCopy.SBQQ__CONFIGUREDSKU__c = newProdRec.Id;
                        pocopy.OwnerId = UserInfo.getUserId();
                        prodOpts.add(poCopy);
                    }
                }
            }
            System.debug('Product options'+prodOpts);
            insert prodOpts;
            
            //Clone Cost
            List<SBQQ__Cost__c> prodCost = [SELECT Id, SBQQ__Active__c, CPQ_Sandbox_ID__c, SBQQ__Product__c, SBQQ__UnitCost__c FROM SBQQ__Cost__c WHERE SBQQ__Product__r.Id = : prodrec.Id];
            for(SBQQ__Cost__c pc : prodCost){
                SBQQ__Cost__c pcCopy = pc.clone(false,true);
                pcCopy.SBQQ__Product__c = newProdRec.Id;
                prodCosts.add(pcCopy);
            }
            
            insert prodCosts;
            
            //Add To Price Book
            List<PricebookEntry> pbe = [SELECT Id, UnitPrice, Product2Id, Pricebook2Id, Name, IsActive, ProductCode ,Pricebook2.IsStandard  FROM PricebookEntry where Product2Id =: prodrec.Id];      
            for(PricebookEntry pb : pbe){  
                // place you PriceBook2Id below
                if(pb.Pricebook2.IsStandard == true){
                
                pbeListStanderd.add(new PricebookEntry(UnitPrice=pb.UnitPrice, Pricebook2Id = pb.Pricebook2Id, product2Id = newProdRec.Id, isActive = pb.IsActive));
            }else{
                pbeList.add(new PricebookEntry(UnitPrice = pb.UnitPrice, Pricebook2Id = pb.Pricebook2Id, product2Id = newProdRec.Id, isActive = pb.IsActive));
                }
            }
            insert pbeListStanderd;
            insert pbeList;
            
            
        } catch (Exception e){
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }
        
        return new PageReference('/' + newProdRec.id);
    }
    
    public pageReference onCancel(){
        return new PageReference('/' + prodrec.id);
    }
}