public class SB_QuoteController {
    
    public SBQQ__Quote__c quoteObj {get;set;}
    public String userId {get;set;}
    public static SB_Metatype__mdt sbMetatype {get;set;}
    
    public SB_QuoteController(ApexPages.StandardController stdcontroller) {
        
        quoteObj = (SBQQ__Quote__c)stdcontroller.getRecord();
        userId = UserInfo.getUserId();
        
        system.debug(quoteObj.id);
        
        String quoteObjSoql = SB_ApexUtility.getInstance().queryBuilder('SBQQ__Quote__c');
        List<SBQQ__Quote__c> quoteList = 
            Database.query(quoteObjSoql + ' where id = ' + String.valueOf('\'')+ quoteObj.id+String.valueOf('\'')); 
        
        quoteObj = quoteList.get(0);
    }
    
    public void checkAndUpdate(){
        updateQuoteLines(quoteObj.id, userId); 
    }
    
    public static void updateQuoteLines(Id quoteId, String userId){
                
        String quoteObjSoql = SB_ApexUtility.getInstance().queryBuilder('SBQQ__Quote__c');
        List<SBQQ__Quote__c> quoteList = 
            Database.query(quoteObjSoql + ' where id = ' + String.valueOf('\'') + quoteId + String.valueOf('\'')); 
        
        SBQQ__Quote__c quote = quoteList.get(0);
        
        Map<Id, SBQQ__QuoteLine__c> childLinesMap = new Map<Id,SBQQ__QuoteLine__c>([Select Id,SBQQ__RequiredBy__c,
                                                                                    SBQQ__RequiredBy__r.ExcludeFromExecutiveSummary__c,
                                                                                    SBQQ__Product__c,Specification__c,
                                                                                    SBQQ__Product__r.SBQQ__Specifications__c,
                                                                                    ExcludeFromExecutiveSummary__c,SBQQ__Existing__c,
                                                                                    SBQQ__BundledQuantity__c,OriginalSpecification__c,
                                                                                    SBQQ__PriorQuantity__c,SBQQ__Quantity__c
                                                                                    
                                                                                    From SBQQ__QuoteLine__c
                                                                                    Where SBQQ__Quote__c = :quoteId
                                                                                    and SBQQ__Bundle__c = false
                                                                                    Order by SBQQ__RequiredBy__c]);
        
        boolean updateRequired = false;
        
        if(childLinesMap != null && !childLinesMap.isEmpty()){
            
            for(SBQQ__QuoteLine__c qlines : childLinesMap.values()){
                
                if(qlines.SBQQ__RequiredBy__r.ExcludeFromExecutiveSummary__c != qlines.ExcludeFromExecutiveSummary__c){            
                    updateRequired = true;
                    break;
                }
            }       
        }
        else{          
            return;
        }

        Map<Id, SBQQ__QuoteLine__c> requiredByMap = null;
        
        if(updateRequired){
            
            requiredByMap = new Map<Id,SBQQ__QuoteLine__c>([Select Id, ExcludeFromExecutiveSummary__c,Specification__c,
                                                            SBQQ__Product__c,SBQQ__Product__r.SBQQ__Specifications__c,
                                                            SBQQ__Existing__c,SBQQ__BundledQuantity__c,
                                                            OriginalSpecification__c,SBQQ__PriorQuantity__c,SBQQ__Quantity__c
                                                            From SBQQ__QuoteLine__c
                                                            Where SBQQ__Quote__c =: quoteId
                                                            and SBQQ__Bundle__c = true
                                                           ]);
        }
        
        if((requiredByMap != null && childLinesMap != null && 
            !requiredByMap.isEmpty() && !childLinesMap.isEmpty()) || updateRequired  
          ){
              
              
              system.debug('requiredByMap --'+requiredByMap.keySet());
              system.debug('childLinesMap --'+childLinesMap.keySet());
              system.debug('requiredByMap --'+requiredByMap.size());
              system.debug('childLinesMap --'+childLinesMap.size());
              
              sbMetatype = [Select OpportunityStageToSync__c,DescriptionforOptionalProducts__c
                            from SB_Metatype__mdt 
                            where DeveloperName='custom_settings'];
              
              system.debug('-check metatype-controller-'+sbMetatype.DescriptionforOptionalProducts__c);
              
              
              List<SBQQ__QuoteLine__c> quoteLinesToUpdate = new List<SBQQ__QuoteLine__c>();
              
              for(SBQQ__QuoteLine__c qlines : childLinesMap.values()){
                  
                  qlines.ExcludeFromExecutiveSummary__c = requiredByMap.get(qlines.SBQQ__RequiredBy__c).ExcludeFromExecutiveSummary__c;
                  
                  setSpecification(qlines);
              }
              
              for(SBQQ__QuoteLine__c qlines : requiredByMap.values()){
                  
                  setSpecification(qlines);
                  
              }
              
              quoteLinesToUpdate.addAll(childLinesMap.values()); 
              quoteLinesToUpdate.addAll(requiredByMap.values());
              
              update quoteLinesToUpdate;
              
          }
        
        processQuoteLineRecords(quoteId);
        updateLastQuotedDate(quoteId, userId);
    } 
    
    private static void setSpecification(SBQQ__QuoteLine__c qlines){
        
        system.debug('--qlines --id --'+qlines.id);
        
        if(qlines.ExcludeFromExecutiveSummary__c){
            
            if(qlines.Specification__c == null){
                
                qlines.Specification__c = sbMetatype.DescriptionforOptionalProducts__c.trim();
                
            }
            else{
                
                if(!qlines.Specification__c.containsIgnoreCase(sbMetatype.DescriptionforOptionalProducts__c)){
                    
                    qlines.Specification__c = String.format('{0}<br><br>{1}',
                                                            new List<String>{qlines.Specification__c.trim(),sbMetatype.DescriptionforOptionalProducts__c.trim()});  
                }
            }   
        }else{
            
            if(qlines.Specification__c == null && 
               qlines.SBQQ__Product__r.SBQQ__Specifications__c !=null ){
                   
                   qlines.Specification__c = qlines.SBQQ__Product__r.SBQQ__Specifications__c.trim();
                   
               }
            else{
                
                if(qlines.Specification__c!= null ){
                    if(qlines.Specification__c.containsIgnoreCase('<br><br>'+sbMetatype.DescriptionforOptionalProducts__c)){
                        qlines.Specification__c = qlines.Specification__c.remove('<br><br>'+sbMetatype.DescriptionforOptionalProducts__c).trim();
                    }else if (qlines.Specification__c.containsIgnoreCase(sbMetatype.DescriptionforOptionalProducts__c)) {
                        qlines.Specification__c = qlines.Specification__c.remove(sbMetatype.DescriptionforOptionalProducts__c).trim();    
                    } 
                }                   
            }
        }
    }
    
    //Updates Cost and Pricebook Records
    public static void processQuoteLineRecords(Id quoteId){
        
        Triggers.OpportunityTrigger_Disabled = True;
        Triggers.AddWorkStatusTrigger_Disabled = True;
        Triggers.SB_QuoteTrigger = True;
        
        SBQQ.TriggerControl.disable();
        
        List<SBQQ__QuoteLine__c> ql = [Select Id, SBQQ__ProductFamily__c, Sync_To_Product__c, SBQQ__UnitCost__c, SBQQ__ListPrice__c, SBQQ__Product__c 
                                       from SBQQ__QuoteLine__c 
                                       where SBQQ__Quote__c =: quoteId and Sync_To_Product__c = true];
        
        List<SBQQ__QuoteLine__c> qlList = new List<SBQQ__QuoteLine__c>();
        
        List<SBQQ__Cost__c> prodCost = new List<SBQQ__Cost__c>();
        List<PricebookEntry> prodPrice = new List<PricebookEntry>();
        
        Map<Id, Decimal> prodCostMap = new Map<Id, Decimal>();
        Map<Id, Decimal> prodPriceMap = new Map<Id, Decimal>();
        
        for(SBQQ__QuoteLine__c q : ql){
            
            if(q.Sync_To_Product__c){
                q.Sync_To_Product__c = false;
                qlList.add(q);
                
                if(q.SBQQ__ProductFamily__c == 'Materials'){                
                    prodCostMap.put(q.SBQQ__Product__c, q.SBQQ__UnitCost__c); 
                    prodPriceMap.put(q.SBQQ__Product__c, q.SBQQ__ListPrice__c);
                }
            }
            
            /*if(q.Add_Material__c && q.SBQQ__ProductFamily__c == 'Materials'){
                q.Add_Material__c = false;
                qlList.add(q);         
            }*/
        } 
        
        if(prodCostMap.Size() > 0){
            for(SBQQ__Cost__c c : [Select Id, SBQQ__Product__c, SBQQ__UnitCost__c from SBQQ__Cost__c where SBQQ__Product__c In: prodCostMap.keyset()]){
                c.SBQQ__UnitCost__c = prodCostMap.get(c.SBQQ__Product__c);
                prodCost.add(c);      
            }                   
        }
        
        if(prodPriceMap.Size() > 0){
            for(PricebookEntry pb : [Select Id, Product2Id, Pricebook2Id, UnitPrice from PricebookEntry where Product2Id In : prodPriceMap.keyset()]){
                pb.UnitPrice = prodPriceMap.get(pb.Product2Id);
                prodPrice.add(pb);
            }
        }
        
        if(prodCost.Size() > 0)
            update prodCost;
        
        if(prodPrice.Size() > 0)
            update prodPrice; 
        
        if(qlList.Size()>0)
            update qlList;
    }
    
    //Updates Last Quoted Date
    public static void updateLastQuotedDate(Id quoteId, String userId){
		Product_Process_Setting__c pps = [Select Active__c from Product_Process_Setting__c];
        pps.Active__c = false;
      
        List<Id> prodIds = new List<Id>();
        List<Product2> prodList = new List<Product2>();
        Map<Id, Id> qlProdMap = new Map<Id, Id>();
        
        for(SBQQ__QuoteLine__c ql : [Select Id, SBQQ__Product__c, SBQQ__Product__r.Last_Quoted_Date__c, Create_New_Product__c from SBQQ__QuoteLine__c where SBQQ__Quote__c =: quoteId and SBQQ__Product__c != null]){
            prodIds.add(ql.SBQQ__Product__c);
           	
            //Get products to create
            /*if(ql.Create_New_Product__c)
                qlProdMap.put(ql.Id, ql.SBQQ__Product__c);*/            
        }
        
        for(Product2 p : [Select Id, Name, Last_Quoted_Date__c from Product2 where Id In: prodIds]){
        	p.Last_Quoted_Date__c = Date.today();
            prodList.add(p);
        }
        
        if(prodList.Size() > 0){
            //Deactivate Process
            update pps; 
            
            //Update Products
            update prodList;
            
            //Activate Process
            pps.Active__c = true;
            update pps;
        }
        
        /*if(qlProdMap.Size() > 0)
            ProductRecord(qlProdMap, userId);*/
            
    }
    
    //Create Products   
    /*public static void ProductRecord(Map<Id, Id> qlProdMap, String userId){
        
        Map<Id, SBQQ__QuoteLine__c> qlMap = new Map<Id, SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c ql : [Select Id, SBQQ__Product__c, Product_Name__c, Specification__c, 	
                                     SBQQ__ProductFamily__c, Family_Type__c, QuantityUnitOfMeasure__c, TSM_Notes__c,
                                     Executive_Summary_Group__c, Sort_Order__c
                                     from SBQQ__QuoteLine__c 
                                     where Id in: qlProdMap.keyset()]){
                                         qlMap.put(ql.SBQQ__Product__c, ql);
                                     }
        
        List<Product2> newProductList = new List<Product2>();
        List<SBQQ__ProductFeature__c> newProdFtrs = new List<SBQQ__ProductFeature__c>();
        
        List<SBQQ__ProductOption__c> prodOpts = new List<SBQQ__ProductOption__c>();
        
        List<SBQQ__Cost__c> prodCosts = new List<SBQQ__Cost__c>();
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
       	List<PricebookEntry> pbeListStanderd = new List<PricebookEntry>();
        
        //Get All Product Fields
        List<Product2> ProductList = [Select Product_Owner__c, 
                                      Name, Family, SBQQ__Specifications__c, 
                                      Family_Type__c, QuantityUnitOfMeasure, TSM_Notes__c, 
                                      Executive_Summary_Group__c, IsActive, Last_Quoted_Date__c, 
                                      Sort_Order__c, SBQQ__SortOrder__c, SBQQ__QuantityEditable__c, Make_Model__c, 
                                      SBQQ__DefaultQuantity__c, SBQQ__ConfigurationType__c, SBQQ__ConfigurationEvent__c, 
                                      SBQQ__OptionLayout__c, SBQQ__OptionSelectionMethod__c, SBQQ__BlockPricingField__c, 
                                      SBQQ__AssetAmendmentBehavior__c, SBQQ__AssetConversion__c, SBQQ__SubscriptionPricing__c, 
                                      SBQQ__SubscriptionType__c, SBQQ__PricingMethod__c, SBQQ__PricingMethodEditable__c, 
                                      SBQQ__CostEditable__c, SBQQ__PriceEditable__c, OriginalProductId__c
                                      from Product2
                                      where id in: qlProdMap.Values()];
        
        system.debug('Product List: ' + ProductList);
        
        system.debug('Quote Line Map: ' + qlMap);
        
        //Loop thru Products
        for(Product2 p : productList){
            Product2 np = new Product2();
            np.Product_Owner__c = userId;
            np.Name = qlMap.get(p.Id).Product_Name__c;
            np.Family = qlMap.get(p.Id).SBQQ__ProductFamily__c;
            np.SBQQ__Specifications__c = qlMap.get(p.Id).Specification__c;
            np.Family_Type__c = qlMap.get(p.Id).Family_Type__c;
            np.QuantityUnitOfMeasure = qlMap.get(p.Id).QuantityUnitOfMeasure__c;
            np.TSM_Notes__c = qlMap.get(p.Id).TSM_Notes__c;
            np.Executive_Summary_Group__c = qlMap.get(p.Id).Executive_Summary_Group__c;
            np.IsActive = true;
            np.Last_Quoted_Date__c = date.today();
            np.Make_Model__c = p.Make_Model__c;
            np.Sort_Order__c = qlMap.get(p.Id).Sort_Order__c;
            np.SBQQ__SortOrder__c = qlMap.get(p.Id).Sort_Order__c;  
            np.SBQQ__QuantityEditable__c = true;
            np.SBQQ__DefaultQuantity__c = 1;
            np.SBQQ__ConfigurationType__c = 'Allowed';
            np.SBQQ__ConfigurationEvent__c = 'Always';
            np.SBQQ__OptionLayout__c = 'Sections';
            np.SBQQ__OptionSelectionMethod__c = 'Click';
            np.SBQQ__BlockPricingField__c = 'Quantity';
            np.SBQQ__AssetAmendmentBehavior__c = 'Allow Refund';
            np.SBQQ__AssetConversion__c = 'One per quote line';
            np.SBQQ__SubscriptionPricing__c = 'Fixed Price';
            np.SBQQ__SubscriptionType__c = 'Renewable';
            np.SBQQ__PricingMethod__c = 'List';
            np.SBQQ__PricingMethodEditable__c = true;
            np.SBQQ__CostEditable__c = true;
            np.SBQQ__PriceEditable__c = true;
            np.OriginalProductId__c = p.Id;
            
            newProductList.add(np);
        }
        
        insert newProductList;
        
        Map<Id, Product2> newProductMap = new Map<Id, Product2>();
        for(Product2 p : newProductList){
            newProductMap.put(p.OriginalProductId__c, p);
        }
        
        //Clone Features
        List<SBQQ__ProductFeature__c> prodFtr = [SELECT ID, NAME, SBQQ__CATEGORY__C, 
                                                 SBQQ__CONFIGURATIONFIELDSET__C, SBQQ__CONFIGUREDSKU__C, 
                                                 SBQQ__DISCOUNTSCHEDULE__C, SBQQ__DYNAMICPRODUCTFILTERFIELDSET__C, 
                                                 SBQQ__DYNAMICPRODUCTLOOKUPFIELDSET__C, SBQQ__MAXOPTIONCOUNT__C, 
                                                 SBQQ__MINOPTIONCOUNT__C, SBQQ__NUMBER__C, SBQQ__OPTIONSELECTIONMETHOD__C
                                                 from SBQQ__ProductFeature__c
                                                 WHERE SBQQ__CONFIGUREDSKU__c in: qlProdMap.Values()]; 
        
        for(SBQQ__ProductFeature__c pf : prodFtr){
            SBQQ__ProductFeature__c pfCopy = pf.clone(false, true);
            pfCopy.SBQQ__CONFIGUREDSKU__c = newProductMap.get(pf.SBQQ__CONFIGUREDSKU__c).Id;
            newProdFtrs.add(pfCopy);
        }
        
        insert newProdFtrs;
        
        //Product Options 		
        List<SBQQ__ProductOption__c> prodOpt = [SELECT ID, NAME, SBQQ__APPLIEDIMMEDIATELYCONTEXT__C, 
                                                SBQQ__APPLIEDIMMEDIATELY__C, SBQQ__BUNDLED__C, SBQQ__COMPONENTCODEPOSITION__C, 
                                                SBQQ__COMPONENTCODE__C, SBQQ__COMPONENTDESCRIPTIONPOSITION__C, 
                                                SBQQ__COMPONENTDESCRIPTION__C, SBQQ__CONFIGUREDSKU__C, SBQQ__DEFAULTPRICINGTABLE__C, 
                                                SBQQ__DISCOUNTAMOUNT__C, SBQQ__DISCOUNTSCHEDULE__C, SBQQ__DISCOUNT__C, 
                                                SBQQ__DISCOUNTEDBYPACKAGE__C, SBQQ__EXISTINGQUANTITY__C, SBQQ__Feature__c, 
                                                SBQQ__Feature__r.Name, SBQQ__MAXQUANTITY__C, SBQQ__MINQUANTITY__C, 
                                                SBQQ__NUMBER__C, SBQQ__OPTIONALSKU__C, SBQQ__PRICEEDITABLE__C, 
                                                SBQQ__PRODUCTCODE__C, SBQQ__PRODUCTCONFIGURATIONTYPE__C, 
                                                SBQQ__PRODUCTDESCRIPTION__C, SBQQ__PRODUCTFAMILY__C, SBQQ__PRODUCTNAME__C, 
                                                SBQQ__PRODUCTQUANTITYSCALE__C, SBQQ__PRODUCTSUBSCRIPTIONPRICING__C, 
                                                SBQQ__QUANTITYEDITABLE__C, SBQQ__QUANTITY__C, SBQQ__QUOTELINEVISIBILITY__C, 
                                                SBQQ__RENEWALPRODUCTOPTION__C, SBQQ__REQUIRED__C, SBQQ__SELECTED__C, 
                                                SBQQ__SUBSCRIPTIONSCOPE__C, SBQQ__SYSTEM__C, SBQQ__TYPE__C, SBQQ__UNITPRICE__C, 
                                                SBQQ__UPLIFTEDBYPACKAGE__C, JOB_CARD__C, LABOR_CODE__C, RTS__C, LABOR_AMOUNT__C, 
                                                MATERIAL_AMOUNT__C, FIRM_PRICE_LABOR__C, FIRM_PRICE_MATERIALS__C,
                                                PRODUCT_18_DIGIT_ID__C, LABOR_TYPE__C, JOB_CARD_DESCRIPTION__C, 
                                                SPECIFICATION__C, SBQQ_SPECIFICATION__C, MATERIAL_TYPE__C, ADD_WORK_LABOR_TYPE__C  
                                                from SBQQ__ProductOption__c 
                                                where SBQQ__CONFIGUREDSKU__c in: qlProdMap.Values()]; 
		
        for(SBQQ__ProductOption__c p : prodOpt){
            
            //Insert New Features Into Product Options
            for(SBQQ__ProductFeature__c f : newProdFtrs){
                if(p.SBQQ__Feature__r.Name == f.Name){
                    SBQQ__ProductOption__c poCopy = p.clone(false,true);
                    
                    poCopy.SBQQ__Feature__c = f.Id;
                    poCopy.SBQQ__CONFIGUREDSKU__c = f.SBQQ__CONFIGUREDSKU__c;
                    pocopy.OwnerId = userId;
                    prodOpts.add(poCopy);
                }
            }
        }
        
        insert prodOpts;
        
        //Clone Cost
        List<SBQQ__Cost__c> prodCost = [SELECT Id, SBQQ__Active__c, SBQQ__Product__c, SBQQ__UnitCost__c 
                                        FROM SBQQ__Cost__c 
                                        WHERE SBQQ__Product__c In: qlProdMap.Values()];
        
        for(SBQQ__Cost__c pc : prodCost){
            SBQQ__Cost__c pcCopy = pc.clone(false,true);
            //Bundled 
            pcCopy.SBQQ__Product__c = newProductMap.get(pc.SBQQ__Product__c).Id;
            prodCosts.add(pcCopy);
        }
        
        insert prodCosts;
        
        //Add To Price Book
        List<PricebookEntry> pbe = [SELECT Id, UnitPrice, Product2Id, Pricebook2Id, 
                                    Name, IsActive, ProductCode , Pricebook2.IsStandard 
                                    FROM PricebookEntry 
                                    where Product2Id In: qlProdMap.Values()];
        
        for(PricebookEntry pb : pbe){ 
            if(pb.Pricebook2.IsStandard == true){
                pbeListStanderd.add(
                    new PricebookEntry(
                        UnitPrice = pb.UnitPrice, 
                        Pricebook2Id = pb.Pricebook2Id, 
                        product2Id = newProductMap.get(pb.Product2Id).Id, 
                        isActive = pb.IsActive
                    )
                );
            }else {
                pbeList.add(
                    new PricebookEntry(
                        UnitPrice=pb.UnitPrice, 
                        Pricebook2Id = pb.Pricebook2Id, 
                        product2Id = newProductMap.get(pb.Product2Id).Id,
                        isActive = pb.IsActive,
                        UseStandardPrice = True
                    )
                );
            }
        }
                    
        if(!Test.isRunningTest()){
            insert pbeListStanderd;
            insert pbeList;
        }   
    }*/   
}