Public Class CloneProductWithRelatedList{
    
    public CloneProductWithRelatedList(ApexPages.StandardController controller) {
    }
    
    // Instanciate the Flow for use from the Controller
    public Flow.Interview.CloneProductBundle myflow {get;set;}
    
    // Factor your PageReference as a full GET/SET
    public PageReference GotoProductOptions {
        get {
            PageReference ref = new PageReference('/apex/AdjustCPQMaterials?Id=' + strOutputVariable);
            ref.setRedirect(true);
            return ref;
        }
        set { GotoProductOptions = value; }
    }
    
    // Factor output variable pull in as a full GET / SET
    public String strOutputVariable {
        get {
            String strTemp = '';
            if(myflow != null) {
                strTemp = string.valueOf(myflow.getVariableValue('varNewProductId'));
            }
            return strTemp;
        }
        
        set { strOutputVariable = value; }
    }
    
    @InvocableMethod
    public static void ProductRecord(List<Id> prodId){
        
        List<SBQQ__ProductOption__c> prodOpts = new List<SBQQ__ProductOption__c>();
        List<SBQQ__ProductFeature__c> prodFtrs = new List<SBQQ__ProductFeature__c>();
        List<SBQQ__Cost__c> prodCosts = new List<SBQQ__Cost__c>();
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
       	List<PricebookEntry> pbeListStanderd = new List<PricebookEntry>();
        
        //Clone Products
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
                            FROM Product2 WHERE Id =: prodId];
        
        system.debug('Product Id: ' + newProd.Id);
        System.debug('family type of product '+newProd.Family_Type__c);
        List<Product2> prod;
        if(newProd.Family_Type__c != Null || newProd.Family_Type__c != ''){
       prod = [SELECT ID, NAME, PRODUCTCODE, DESCRIPTION, 
                         REVENUESCHEDULETYPE, REVENUEINSTALLMENTPERIOD, NUMBEROFREVENUEINSTALLMENTS, 
                         CANUSEREVENUESCHEDULE, ISACTIVE, FAMILY, ISDELETED, ENGINE_MODELS__C, 
                         PICTURE__C, FACILITY_CAPABILITY__C, FACILITY_CERTIFICATION__C, MFG_WARRANTY_PERIOD_MONTHS__C, 
                         RATING_DOMESTIC__C, RELATED_PRODUCT_ENGINES__C, TSM__C, AIRWORTHINESS_DIRECTIVES_ADS__C, 
                         NOTES_CERTIFICATION_AND_CAPABILITY__C, X1ST_INSPECTION_CALENDAR_SM__C, X1ST_INSPECTION_CALENDAR_LG__C, 
                         VALUE_PROPOSITION__C, INTERVAL_INFORMATION__C, SBQQ__ASSETAMENDMENTBEHAVIOR__C, SBQQ__ASSETCONVERSION__C, 
                         SBQQ__BATCHQUANTITY__C, SBQQ__BILLINGFREQUENCY__C, SBQQ__BILLINGTYPE__C, SBQQ__BLOCKPRICINGFIELD__C, 
                         SBQQ__CHARGETYPE__C, SBQQ__COMPONENT__C, SBQQ__COMPOUNDDISCOUNTRATE__C, SBQQ__CONFIGURATIONEVENT__C, 
                         SBQQ__CONFIGURATIONFIELDSET__C, SBQQ__CONFIGURATIONFIELDS__C, SBQQ__CONFIGURATIONFORMTITLE__C, 
                         SBQQ__CONFIGURATIONTYPE__C, SBQQ__CONFIGURATIONVALIDATOR__C, SBQQ__CONFIGUREDCODEPATTERN__C, 
                         SBQQ__CONFIGUREDDESCRIPTIONPATTERN__C, SBQQ__COSTEDITABLE__C, SBQQ__COSTSCHEDULE__C, 
                         SBQQ__CUSTOMCONFIGURATIONPAGE__C, SBQQ__CUSTOMCONFIGURATIONREQUIRED__C, SBQQ__CUSTOMERCOMMUNITYAVAILABILITY__C, 
                         SBQQ__DEFAULTPRICINGTABLE__C, SBQQ__DEFAULTQUANTITY__C, SBQQ__DESCRIPTIONLOCKED__C, 
                         SBQQ__DISCOUNTCATEGORY__C, SBQQ__DISCOUNTSCHEDULE__C, SBQQ__DYNAMICPRICINGCONSTRAINT__C, 
                         SBQQ__EXCLUDEFROMMAINTENANCE__C, SBQQ__EXCLUDEFROMOPPORTUNITY__C, SBQQ__EXTERNALLYCONFIGURABLE__C, 
                         SBQQ__GENERATECONTRACTEDPRICE__C, SBQQ__HASCONFIGURATIONATTRIBUTES__C, SBQQ__HIDDEN__C, 
                         SBQQ__HIDEPRICEINSEARCHRESULTS__C, SBQQ__INCLUDEINMAINTENANCE__C, SBQQ__NEWQUOTEGROUP__C, 
                         SBQQ__NONDISCOUNTABLE__C, SBQQ__NONPARTNERDISCOUNTABLE__C, SBQQ__OPTIONLAYOUT__C, 
                         SBQQ__OPTIONSELECTIONMETHOD__C, SBQQ__OPTIONAL__C, SBQQ__PRICEEDITABLE__C, 
                         SBQQ__PRICINGMETHODEDITABLE__C, SBQQ__PRICINGMETHOD__C, SBQQ__PRODUCTPICTUREID__C, 
                         SBQQ__QUANTITYEDITABLE__C, SBQQ__QUANTITYSCALE__C, SBQQ__RECONFIGURATIONDISABLED__C, 
                         SBQQ__RENEWALPRODUCT__C, SBQQ__SORTORDER__C, SBQQ__SPECIFICATIONS__C, SBQQ__SUBSCRIPTIONBASE__C, 
                         SBQQ__SUBSCRIPTIONCATEGORY__C, SBQQ__SUBSCRIPTIONPERCENT__C, 
                         SBQQ__SUBSCRIPTIONPRICING__C, SBQQ__SUBSCRIPTIONTARGET__C, SBQQ__SUBSCRIPTIONTERM__C, 
                         SBQQ__SUBSCRIPTIONTYPE__C, SBQQ__TAXCODE__C, SBQQ__TAXABLE__C, SBQQ__TERMDISCOUNTLEVEL__C, 
                         SBQQ__TERMDISCOUNTSCHEDULE__C, SBQQ__UPGRADECREDIT__C, SBQQ__UPGRADERATIO__C, SBQQ__UPGRADESOURCE__C, 
                         SBQQ__UPGRADETARGET__C, ATA_CODE__C, AMTOSS_NUMBER__C, CHAPTER__C, CONDITION__C, DETAIL_DESCRIPTION__C, 
                         EXECUTIVE_SUMMARY_GROUP__C, FAMILY_TYPE__C, MAKE_MODEL_OLD__C, VENDOR_CONTACT__C, VENDOR_NAME__C, 
                         VENDOR_NUMBER__C, VENDOR_PHONE__C, PRODUCT_OWNER__C, LAST_MODIFIED_DATE__C, CPQ_SANDBOX_ID__C, 
                         TSM_NOTES__C, FACILITY_PRICING_LABOR_TYPE__C, MAKE_MODEL__C, LABOR_DESCRIPTOR__C, 
                         MATERIAL_DESCRIPTOR__C, PART_DESCRIPTION_IDENTIFIER__C, PART_DESCRIPTION__C, TEST_LONG_TEST_AREA__C 
                         FROM Product2 WHERE Family_Type__c =: newProd.Family_Type__c and Bid_Master__c = True LIMIT 1];
            System.debug(prod);
                
        system.debug('Old Product Id: ' + prod[0].Id);
        } 
        
        
        //Clone Features
        List<SBQQ__ProductFeature__c> prodFtr = [SELECT ID, NAME, SBQQ__CATEGORY__C, SBQQ__CONFIGURATIONFIELDSET__C, SBQQ__CONFIGUREDSKU__C, SBQQ__DISCOUNTSCHEDULE__C, SBQQ__DYNAMICPRODUCTFILTERFIELDSET__C, SBQQ__DYNAMICPRODUCTLOOKUPFIELDSET__C, SBQQ__MAXOPTIONCOUNT__C, SBQQ__MINOPTIONCOUNT__C, SBQQ__NUMBER__C, SBQQ__OPTIONSELECTIONMETHOD__C, CPQ_SANDBOX_ID__C FROM SBQQ__ProductFeature__c WHERE SBQQ__CONFIGUREDSKU__r.Id = : prod[0].Id];       
        for(SBQQ__ProductFeature__c pf : prodFtr){
            SBQQ__ProductFeature__c pfCopy = pf.clone(false,true);
            pfCopy.SBQQ__CONFIGUREDSKU__c = newProd.Id;
            prodFtrs.add(pfCopy);
        }
        
        insert prodFtrs;
        
        List<SBQQ__ProductFeature__c> newProdFtrs = [Select Id, Name From SBQQ__ProductFeature__c where SBQQ__CONFIGUREDSKU__r.Id =: prodId];
        
        //Product Options      
        List<SBQQ__ProductOption__c> prodOpt = [SELECT ID, NAME, SBQQ__APPLIEDIMMEDIATELYCONTEXT__C, SBQQ__APPLIEDIMMEDIATELY__C, SBQQ__BUNDLED__C, SBQQ__COMPONENTCODEPOSITION__C, SBQQ__COMPONENTCODE__C, SBQQ__COMPONENTDESCRIPTIONPOSITION__C, SBQQ__COMPONENTDESCRIPTION__C, SBQQ__CONFIGUREDSKU__C, SBQQ__DEFAULTPRICINGTABLE__C, SBQQ__DISCOUNTAMOUNT__C, SBQQ__DISCOUNTSCHEDULE__C, SBQQ__DISCOUNT__C, SBQQ__DISCOUNTEDBYPACKAGE__C, SBQQ__EXISTINGQUANTITY__C, SBQQ__Feature__c, SBQQ__Feature__r.Name, SBQQ__MAXQUANTITY__C, SBQQ__MINQUANTITY__C, SBQQ__NUMBER__C, SBQQ__OPTIONALSKU__C, SBQQ__PRICEEDITABLE__C, SBQQ__PRODUCTCODE__C, SBQQ__PRODUCTCONFIGURATIONTYPE__C, SBQQ__PRODUCTDESCRIPTION__C, SBQQ__PRODUCTFAMILY__C, SBQQ__PRODUCTNAME__C, SBQQ__PRODUCTQUANTITYSCALE__C, SBQQ__PRODUCTSUBSCRIPTIONPRICING__C, SBQQ__QUANTITYEDITABLE__C, SBQQ__QUANTITY__C, SBQQ__QUOTELINEVISIBILITY__C, SBQQ__RENEWALPRODUCTOPTION__C, SBQQ__REQUIRED__C, SBQQ__SELECTED__C, SBQQ__SUBSCRIPTIONSCOPE__C, SBQQ__SYSTEM__C, SBQQ__TYPE__C, SBQQ__UNITPRICE__C, SBQQ__UPLIFTEDBYPACKAGE__C, JOB_CARD__C, LABOR_CODE__C, RTS__C, LABOR_AMOUNT__C, MATERIAL_AMOUNT__C, FIRM_PRICE_LABOR__C, FIRM_PRICE_MATERIALS__C, CPQ_SANDBOX_ID__C, PRODUCT_18_DIGIT_ID__C, LABOR_TYPE__C, JOB_CARD_DESCRIPTION__C, SPECIFICATION__C, SBQQ_SPECIFICATION__C, 
                                                MATERIAL_TYPE__C, ADD_WORK_LABOR_TYPE__C FROM SBQQ__ProductOption__c WHERE SBQQ__CONFIGUREDSKU__r.Id = : prod[0].Id];       
        for(SBQQ__ProductOption__c p : prodOpt){
            
            //Insert New Features Into Product Options
            for(SBQQ__ProductFeature__c f : newProdFtrs){
                if(p.SBQQ__Feature__r.Name == f.Name){
                    SBQQ__ProductOption__c poCopy = p.clone(false,true);
                    
                    poCopy.SBQQ__Feature__c = f.Id;
                    poCopy.SBQQ__CONFIGUREDSKU__c = newProd.Id;
                    pocopy.OwnerId = UserInfo.getUserId();
                    prodOpts.add(poCopy);
                }
            }
        }
        
        insert prodOpts;
        
        //Clone Cost
        List<SBQQ__Cost__c> prodCost = [SELECT Id, SBQQ__Active__c, CPQ_Sandbox_ID__c, SBQQ__Product__c, SBQQ__UnitCost__c FROM SBQQ__Cost__c WHERE SBQQ__Product__r.Id = : prod[0].Id];
        for(SBQQ__Cost__c pc : prodCost){
            SBQQ__Cost__c pcCopy = pc.clone(false,true);
            pcCopy.SBQQ__Product__c = newProd.Id;
            prodCosts.add(pcCopy);
        }
        
        insert prodCosts;
        
        //Add To Price Book
        List<PricebookEntry> pbe = [SELECT Id, UnitPrice, Product2Id, Pricebook2Id, Name, IsActive, ProductCode , Pricebook2.IsStandard FROM PricebookEntry where Product2Id =: prod[0].Id];
        for(PricebookEntry pb : pbe){ 
            if(pb.Pricebook2.IsStandard == true){
                
                pbeListStanderd.add(new PricebookEntry(UnitPrice=pb.UnitPrice, Pricebook2Id = pb.Pricebook2Id, product2Id = newProd.Id, isActive = pb.IsActive));
            }else {
            // place you PriceBook2Id below
            
                pbeList.add(
                    new PricebookEntry(
                        UnitPrice=pb.UnitPrice, 
                        Pricebook2Id = pb.Pricebook2Id, 
                        product2Id = newProd.Id, 
                        isActive = pb.IsActive,
                        UseStandardPrice = True
                    )
                );
            }
        }
             
        System.debug('list of pbe'+pbe);
        System.debug('standard price book '+pbeListStanderd);
        System.debug('custom pb'+pbeList);
        if( ! Test.isRunningTest()){
            insert pbeListStanderd;
            insert pbeList;
          }
        
    }
    
    public static string customCancel(){
        
        return URL.getSalesforceBaseUrl().toExternalForm().substringbeforelast('--') +'.lightning.force.com/lightning/page/home?0.source=alohaHeader';

    }
    
}