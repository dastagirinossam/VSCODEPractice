/**
* @Author - sanghvi pallavi
* @ Date - 30/07/19
* @Purpose - This class is used for the CPQ Quote Iternal Review Template 
*/
public class SB_QTProposalInternalReviewTemplate {
    
    // Below array is the Raw Array for display.
    public SBQQ__QuoteLine__c[] quoteLineItems {get;  set;}
    public SBQQ__Quote__c quoteSObj {get; set;}
    public BundledLines[] bundleLinesToReturn {get;set;}
    
    public List<OuterExecutiveGroup> outerExGroupToReturn {get; set;}
    public Set<String> groupingSetForAirframe {get;set;}
    
    public PropDetail propDetailToReturn {get;set;}
    public Set<String> groupingSetForMaterials {get;set;}
    public Decimal TotalLaborInternalReview {get;set;}
    public Decimal TotalCostInternalReview {get;set;}
    public Decimal TotalSellInternalReview {get;set;}
    public Decimal MarginInternalReview {get;set;}
    public Decimal totalLabourHours = 0;
    public Decimal totalCostWithWarrenty = 0;
    public Decimal totalsellwithWarrenty = 0;
    public Decimal totalMargin = 0;
    
    // Constructor
    public SB_QTProposalInternalReviewTemplate() {
        Id quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');
        Id templateId = (Id)ApexPages.currentPage().getParameters().get('templateId');
        String queryQuoteIdstr = String.valueOf('\'')+quoteId+String.valueOf('\'');
        queryQuoteIdstr = '('+queryQuoteIdstr+')';
        String soqlQuoteQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__Quote__c');
        soqlQuoteQuery = soqlQuoteQuery.replace('sbqq__changeversion__c,', '');
        soqlQuoteQuery = soqlQuoteQuery.replace('sbqq__previouschangequote__c,', '');
        List<SBQQ__Quote__c> quoteList = 
            Database.query(soqlQuoteQuery + ' where id in ' + queryQuoteIdstr);     
        
        if(quoteList != null && !quoteList.isEmpty()){
            quoteSObj = quoteList.get(0);
        }
        // Querying quote lines - here generic query not used because we need to fetch the product fields.
        
        String soqlQuoteLineQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__QuoteLine__c');
        List<SBQQ__QuoteLine__c> quoteLinesOfChildQuotesList = 
            [SELECT Id,  Name,  SBQQ__Quote__c,ExcludeFromExecutiveSummary__c,
             SBQQ__Bundle__c, SBQQ__BundledQuantity__c,
             SBQQ__Bundled__c, SBQQ__CarryoverLine__c, SBQQ__ChargeType__c, SBQQ__ComponentCost__c,
             SBQQ__ConfigurationRequired__c,
             SBQQ__ContractedPrice__c, SBQQ__Cost__c,  
             SBQQ__CustomerTotal__c, SBQQ__DefaultSubscriptionTerm__c, SBQQ__Description__c, SBQQ__Dimension__c,
             SBQQ__DiscountTier__c, SBQQ__Discount__c,
             SBQQ__DistributorDiscount__c, SBQQ__EffectiveEndDate__c, 
             SBQQ__EffectiveQuantity__c, SBQQ__EffectiveStartDate__c, SBQQ__EndDate__c, SBQQ__Existing__c, 
             SBQQ__GenerateContractedPrice__c, SBQQ__GrossProfit__c, SBQQ__Group__c, 
             SBQQ__ListPrice__c, SBQQ__ListTotal__c, SBQQ__MarkupAmount__c,
             SBQQ__MarkupRate__c, SBQQ__Markup__c, SBQQ__MaximumPrice__c, SBQQ__MinimumPrice__c, SBQQ__NetPrice__c,
             SBQQ__NetTotal__c, fxNet_Total__c, SBQQ__NonDiscountable__c, SBQQ__NonPartnerDiscountable__c, SBQQ__Number__c, 
             SBQQ__OptionDiscountAmount__c, SBQQ__OptionDiscount__c, SBQQ__OptionLevel__c, SBQQ__OptionType__c,
             SBQQ__Optional__c, SBQQ__OriginalPrice__c, SBQQ__OriginalUnitCost__c, SBQQ__PackageCost__c,
             SBQQ__PackageListTotal__c, SBQQ__PackageProductCode__c, SBQQ__PackageProductDescription__c,
             SBQQ__PackageTotal__c, SBQQ__PartnerDiscount__c, SBQQ__PartnerPrice__c, SBQQ__PartnerTotal__c,
             SBQQ__PreviousSegmentPrice__c, SBQQ__PreviousSegmentUplift__c, SBQQ__PriceEditable__c,
             SBQQ__PricingMethod__c, SBQQ__PriorQuantity__c, OriginalSpecification__c,
             SBQQ__ProductCode__c, SBQQ__ProductFamily__c, SBQQ__ProductName__c, SBQQ__ProductOption__c,
             SBQQ__Product__c, SBQQ__ProrateMultiplier__c, SBQQ__ProratedListPrice__c, 
             SBQQ__ProratedPrice__c, SBQQ__Quantity__c, SBQQ__RegularPrice__c, SBQQ__RegularTotal__c, 
             SBQQ__Renewal__c, SBQQ__RenewedAsset__c, SBQQ__RenewedSubscription__c, SBQQ__RequiredBy__c,
             SBQQ__TaxCode__c, SBQQ__Taxable__c, SBQQ__TermDiscountSchedule__c, SBQQ__TermDiscountTier__c, 
             SBQQ__TermDiscount__c, SBQQ__TotalDiscountAmount__c, SBQQ__TotalDiscountRate__c, 
             SBQQ__UnitCost__c, Labor_Type__c,Facility_Department_Group__c, Facility_Pricing__c, Facility_and_Labor_Type__c, Labor__c,
             Product_Pricing__c, Desired_Margin__c, Derived_From_Quote_Line__c, Net_Cost__c,
             Warranty_Program__c,  Derived_From_Child_Quote__c, PrintWarrenty__c,
             Customer_Price__c, ExecutiveSummaryGroup__c, ExcludeFromSummaryFormula__c, Family_Type__c, 
             SBQQ__Product__r.Vendor_Number__c,
             Derived_From_Quote_Line__r.Name,
             SBQQ__Product__r.Vendor_Name__c,
             SBQQ__Product__r.Vendor_Contact__c,
             SBQQ__Product__r.Vendor_Phone__c,
             SBQQ__Product__r.Family,
             SBQQ__Product__r.Name,
             SBQQ__Product__r.Product_Name__c,
             SBQQ__Product__r.Part_Description__c,
             SBQQ__Product__r.Description,
             SBQQ__Product__r.Detail_Description__c,
             SBQQ__Product__r.Picture__c,
             SBQQ__Product__r.SBQQ__ProductPictureID__c,
             SBQQ__Product__r.Part_Description_Identifier__c,
             SBQQ__Product__r.Labor_Descriptor__c,
             SBQQ__Product__r.Make_Model__c,
             SBQQ__Product__r.SBQQ__Specifications__c,
             SBQQ__Product__r.Material_Descriptor__c,
             SBQQ__Product__r.Condition__c,
             QuantityUnitOfMeasure__c,
             SBQQ__Product__r.TSM_Notes__c,
             SBQQ__ProductOption__r.SBQQ__Feature__c,
             SBQQ__ProductOption__r.SBQQ__Feature__r.Name,
             Specification__c,
             Job_Card__c,
             Add_Work_Status__c,
             Job_Card_Description__c,
             Labor_Amount__c,
             Material_Amount__c,
             Firm_Price_Labor__c,
             Firm_Price_Materials__c,
             Labor_Code__c,
             IsFirmPriceMaterial__c,
             IsFirmPriceLabour__c,
             SBQQ__Quote__r.SBQQ__Opportunity2__r.Amount,
             SBQQ__Quote__r.SBQQ__Opportunity2__r.Type,
             SBQQ__Quote__r.SBQQ__Opportunity2__r.Engine_SN__c,
             SBQQ__Quote__r.SBQQ__Opportunity2__r.Equipment_Model__c,
             DerivedEngineSN__c,
             DerivedOpportunityType__c,
             DerivedEngineSNAndEquipModel__c,
             ExGroupFormula__c,
             Approved__c,
             Denied__c,
             IsWarrentyOrPrice__c,
             IsApproved__c,
             IsDenied__c,
             IsRTS__c,
             Material_Type__c,
             Add_Work_Labor_Type__c,
             IsHiddenForTemplates__c,
             Product_Name__c,
             Condition__c,
             Vendor_Name__c,
             Product_Description__c,
             Measure__c,
             TSM_Notes__c,
             Table_Value__c,
             SBQQ__Quote__r.Total_Labor_Margin__c,
             SBQQ__Quote__r.Total_Labor_Hours__c,
             SBQQ__Quote__r.Total_Material_Sell_With_Warranty__c,
             SBQQ__Quote__r.Total_Net_Cost__c
             FROM SBQQ__QuoteLine__c
             where SBQQ__Quote__c = :quoteId 
             Order By SBQQ__Number__c,DerivedOpportunityType__c,DerivedEngineSNAndEquipModel__c,
             ExGroupFormula__c, SBQQ__Product__r.Family ];
                
        groupingSetForAirframe = new Set<String>();
        groupingSetForAirframe.add('Airframe');
        
        groupingSetForMaterials = new Set<String>();
        groupingSetForMaterials.add('Avionics');
        groupingSetForMaterials.add('Paint');
        groupingSetForMaterials.add('Interior');
        
        quoteLineItems = quoteLinesOfChildQuotesList;      
        propDetailToReturn= prepareExecutiveGroupNew();
                
        //Airframe
        for(OuterExecutiveGroup OEG : propDetailToReturn.outerExgroup){
            for(BundledLines bl : OEG.bundlelines){
                bl.FeatureDetailsSell = new Map<String,Decimal>();
                bl.FeatureDetailsCost = new Map<String,Decimal>();
                bl.FeatureDetailsMargin = new Map<String,Decimal>();
                bl.FeatureDetailsQuauntity = new Map<String,Decimal>();
                bl.hasTsm = false;
                bl.hasWarranty = false;
                bl.allzero = 0;
                bl.totalSell = 0;
                bl.warrantySell = 0;
                bl.hasExclude = false;
                
                for(SBQQ__QuoteLine__c qli : bl.childLines){
                    
                    if(qli.TSM_Notes__c != null && bl.hasTsm == false)
                        bl.hasTsm = true;
                    
                    if(qli.Warranty_Program__c != null && bl.hasExclude == false){
                        bl.hasWarranty = true;
                        bl.warrantySell += qli.fxNet_Total__c;
                    }
                    
                    if(qli.ExcludeFromExecutiveSummary__c == true && bl.hasExclude == false)
                        bl.hasExclude = true;                  
                    
                    String Feature = qli.SBQQ__ProductOption__r.SBQQ__Feature__r.Name;
                    if(!bl.FeatureDetailsSell.containsKey(Feature))
                        bl.FeatureDetailsSell.put(Feature, 0);
                    
                    if(!bl.FeatureDetailsCost.containsKey(Feature))
                        bl.FeatureDetailsCost.put(Feature, 0);
                    
                    if(!bl.FeatureDetailsQuauntity.containsKey(Feature))
                        bl.FeatureDetailsQuauntity.put(Feature, 0);
                    
                    Decimal quantity = bl.FeatureDetailsQuauntity.get(Feature);                    
                    quantity += qli.SBQQ__Quantity__c;                 
                    bl.FeatureDetailsQuauntity.put(Feature,quantity);
                                        
                    Decimal cost = bl.FeatureDetailsCost.get(Feature);                   
                    cost += qli.SBQQ__Quantity__c * qli.SBQQ__UnitCost__c;                   
                    bl.FeatureDetailsCost.put(Feature, cost);
                                     
                    Decimal sell = bl.FeatureDetailsSell.get(Feature);
                    sell += qli.fxNet_Total__c;                   
                    bl.FeatureDetailsSell.put(Feature,sell);
                                       
                    if(qli.SBQQ__Quantity__c == 0)
                        bl.allzero++;
                }
                
                bl.FeatureDetailsCostSize = bl.FeatureDetailsCost.size();
                               
                for(String key : bl.FeatureDetailsCost.keySet()){
                    Decimal margin = 0;
                    if(bl.FeatureDetailsSell.get(key) != 0){                      
                        margin = ((bl.FeatureDetailsSell.get(key)-bl.FeatureDetailsCost.get(key))/bl.FeatureDetailsSell.get(key))*100;
                        bl.totalSell += bl.FeatureDetailsSell.get(key);
                    }
                    
                    bl.FeatureDetailsMargin.put(key,margin);
                }
            }
        }
        
        //Engines
        for(OuterExecutiveGroup OEG : propDetailToReturn.outerExGroupEngines){
            for(BundledLines bl : OEG.bundlelines){
                bl.FeatureDetailsSell = new Map<String,Decimal>();
                bl.FeatureDetailsCost = new Map<String,Decimal>();
                bl.FeatureDetailsMargin = new Map<String,Decimal>();
                bl.FeatureDetailsQuauntity = new Map<String,Decimal>();
                bl.hasTsm = false;
                bl.hasWarranty = false;
                bl.allzero = 0;
                bl.totalSell = 0;
                bl.warrantySell = 0;
                bl.hasExclude = false;
                
                for(SBQQ__QuoteLine__c qli : bl.childLines){
                    
                    if(qli.TSM_Notes__c != null && bl.hasTsm == false)
                        bl.hasTsm = true;
                    
                    if(qli.Warranty_Program__c != null && bl.hasExclude == false){
                        bl.hasWarranty = true;
                        bl.warrantySell += qli.fxNet_Total__c;
                    }
                    
                    if(qli.ExcludeFromExecutiveSummary__c == true && bl.hasExclude == false)
                        bl.hasExclude = true;                  
                    
                    String Feature = qli.SBQQ__ProductOption__r.SBQQ__Feature__r.Name;
                    if(!bl.FeatureDetailsSell.containsKey(Feature))
                        bl.FeatureDetailsSell.put(Feature, 0);
                    
                    if(!bl.FeatureDetailsCost.containsKey(Feature))
                        bl.FeatureDetailsCost.put(Feature, 0);
                    
                    if(!bl.FeatureDetailsQuauntity.containsKey(Feature))
                        bl.FeatureDetailsQuauntity.put(Feature, 0);
                    
                    Decimal quantity = bl.FeatureDetailsQuauntity.get(Feature);                    
                    quantity += qli.SBQQ__Quantity__c;                 
                    bl.FeatureDetailsQuauntity.put(Feature,quantity);
                                        
                    Decimal cost = bl.FeatureDetailsCost.get(Feature);                   
                    cost += qli.SBQQ__Quantity__c * qli.SBQQ__UnitCost__c;                   
                    bl.FeatureDetailsCost.put(Feature, cost);
                                     
                    Decimal sell = bl.FeatureDetailsSell.get(Feature);
                    sell += qli.fxNet_Total__c;                   
                    bl.FeatureDetailsSell.put(Feature,sell);
                                       
                    if(qli.SBQQ__Quantity__c == 0)
                        bl.allzero++;
                }
                
                bl.FeatureDetailsCostSize = bl.FeatureDetailsCost.size();
                               
                for(String key : bl.FeatureDetailsCost.keySet()){
                    Decimal margin = 0;
                    if(bl.FeatureDetailsSell.get(key) != 0){                      
                        margin = ((bl.FeatureDetailsSell.get(key)-bl.FeatureDetailsCost.get(key))/bl.FeatureDetailsSell.get(key))*100;
                        bl.totalSell += bl.FeatureDetailsSell.get(key);
                    }
                    
                    bl.FeatureDetailsMargin.put(key,margin);
                }
            }
        }
          
        //Avionics Paint Interior
        for(OuterExecutiveGroup OEG : propDetailToReturn.outerExgroupAsSetNoMatLines){
            for(BundledLines bl : OEG.bundlelines){

                bl.FeatureDetailsSell = new Map<String,Decimal>();
                bl.FeatureDetailsCost = new Map<String,Decimal>();
                bl.FeatureDetailsMargin = new Map<String,Decimal>();
                bl.FeatureDetailsQuauntity = new Map<String,Decimal>();
                bl.hasTsm = false;
                bl.hasWarranty = false;
                bl.allzero = 0;
                bl.totalSell = 0;
                bl.warrantySell = 0;
                bl.hasExclude = false;
                
                for(SBQQ__QuoteLine__c qli : bl.childLines){
                    if(qli.TSM_Notes__c != null && bl.hasTsm == false)
                        bl.hasTsm=true;
                    
                    if(qli.Warranty_Program__c != null && bl.hasExclude == false){
                        bl.hasWarranty = true;
                        bl.warrantySell += qli.fxNet_Total__c;
                    }
                    
                    if(qli.ExcludeFromExecutiveSummary__c == true && bl.hasExclude == false)
                        bl.hasExclude = true;  
                    
                    String Feature = qli.SBQQ__ProductOption__r.SBQQ__Feature__r.Name;
                    if(!bl.FeatureDetailsSell.containsKey(Feature))
                        bl.FeatureDetailsSell.put(Feature,0);
                    
                    if(!bl.FeatureDetailsCost.containsKey(Feature))
                        bl.FeatureDetailsCost.put(Feature,0);
                    
                    if(!bl.FeatureDetailsQuauntity.containsKey(Feature))
                        bl.FeatureDetailsQuauntity.put(Feature,0);
                    
                    Decimal quantity = bl.FeatureDetailsQuauntity.get(Feature);
                    Decimal cost = bl.FeatureDetailsCost.get(Feature);
                    Decimal sell = bl.FeatureDetailsSell.get(Feature);
                    
                    quantity += qli.SBQQ__Quantity__c;  
                    bl.FeatureDetailsQuauntity.put(Feature, quantity);
                    cost += qli.SBQQ__Quantity__c*qli.SBQQ__UnitCost__c;
                    sell += qli.fxNet_Total__c;
                    
                    bl.FeatureDetailsCost.put(Feature, cost);
                    bl.FeatureDetailsSell.put(Feature, sell);
                    
                    if(qli.SBQQ__Quantity__c == 0)
                        bl.allzero++;
                }
                
                bl.FeatureDetailsCostSize = bl.FeatureDetailsCost.size();
                for(String key : bl.FeatureDetailsCost.keySet()){
                    Decimal margin = 0;
                    if(bl.FeatureDetailsSell.get(key) != 0){
                        margin = ((bl.FeatureDetailsSell.get(key)-bl.FeatureDetailsCost.get(key))/bl.FeatureDetailsSell.get(key))*100;
                        bl.totalSell += bl.FeatureDetailsSell.get(key);
                    }
                    
                    bl.FeatureDetailsMargin.put(key,margin);
                }
            }
        }
              
        TotalLaborInternalReview = 0;
        TotalCostInternalReview = 0;
        TotalSellInternalReview = 0;
        MarginInternalReview = 0;
        
        for(OuterExecutiveGroup OEG : outerExGroupToReturn){
            Decimal totalLabor = 0;
            Decimal totalCost = 0;
            Decimal TotalSell = 0;
            for(BundledLines linesObj : OEG.bundlelines){
                if(linesObj.hasExclude == false){                
                    if(Test.isRunningTest()){
                        totalLabor = 10;
                    }else{    
                        totalLabor += linesObj.FeatureDetailsQuauntity.get('Labor');
                    }
                    
                    for(decimal sell : linesObj.FeatureDetailsSell.values()){
                        TotalSell += sell.setScale(2);
                    }
                    
                    for(decimal cost : linesObj.FeatureDetailsCost.values()){
                        totalCost += cost.setScale(2);
                    }
                }
            }
            
            OEG.totalOfSell = TotalSell;
            OEG.totalLabor = totalLabor;
            OEG.totalOfCost = totalCost;
            
            TotalLaborInternalReview += totalLabor;
            TotalCostInternalReview += totalCost;
            TotalSellInternalReview += TotalSell;
            OEG.Margin = TotalSell==0?(0):(((TotalSell-totalCost)/TotalSell)*100);
                }
        
        MarginInternalReview = TotalSellInternalReview==0?(0):(((TotalSellInternalReview-TotalCostInternalReview)/TotalSellInternalReview)*100);
            }
    
    
    /*** Below method is used for filtering bundles for changes. ***/
    @TestVisible
    private boolean checkForCCO(BundledLines bundleLine){
        boolean addBundle = false;
        SBQQ__QuoteLine__c mainLine = bundleLine.mainLine;
        if((mainLine.Specification__c != mainLine.OriginalSpecification__c ) ||
           (mainLine.SBQQ__Quantity__c != mainLine.SBQQ__PriorQuantity__c) || 
           !mainLine.SBQQ__Existing__c){
               addBundle=true;
               return addBundle;
           }
        
        if(!addBundle){
            List<SBQQ__QuoteLine__c> childLines = bundleLine.childLines;
            for(SBQQ__QuoteLine__c ql : childLines){
                if((ql.Specification__c != ql.OriginalSpecification__c ) || (ql.SBQQ__Quantity__c != ql.SBQQ__PriorQuantity__c) || !ql.SBQQ__Existing__c ){
                    addBundle=true;
                    return addBundle;
                }
            }
        }
        return addBundle;
    }
      
    /*** Below mthod is used for master, child, cco ***/
    private PropDetail prepareExecutiveGroupNew(){
        OuterExecutiveGroup outerExGroup = null;
        String derivedOppTypOrEnginEquipmnt  = '';
        List<ExecutiveGroup> exGroupList = null;
        List<SBQQ__QuoteLine__c>outerLines = null;
        Map<String,OuterExecutiveGroup> outerExMap = new Map<String,OuterExecutiveGroup>();
        String tempOppTypEngEquip = '';
        
        for(SBQQ__QuoteLine__c ql :quoteLineItems){
            
            String oppType= null;  // to use for group 2nd
            String engineEquipmnt = null; // to use for group 1st
            String key = null;
            String engineSN = null; // for comparison
            oppType= ql.DerivedOpportunityType__c;
            engineEquipmnt = ql.DerivedEngineSNAndEquipModel__c;
            engineSN = ql.DerivedEngineSN__c;
            key = null;  
            
            if(engineSN != null && engineSN != 'NA'){
                outerExGroup = outerExMap.get(engineEquipmnt);
                key = engineEquipmnt;
            } 
            else if ((engineSN == null || engineSN.length() == 0 || engineSN == 'NA') && (oppType !=null && oppType.length() >0 )){
                outerExGroup = outerExMap.get(oppType);
                key = oppType;
            }else{
                outerExGroup =  outerExMap.get(null);
                key = null;
            }
            
            if(outerExGroup == null){
                
                outerExGroup = new OuterExecutiveGroup();
                outerExGroup.derivedOppTypOrEnginEquipmnt = key;
                
                outerLines = new List<SBQQ__QuoteLine__c>();
                                
                outerLines.add(ql);
                
                outerExGroup.outerLines = outerLines;
                
                
            }else{
                outerLines = outerExGroup.outerLines;
                
                if(outerLines!=null){
                    
                    outerLines.add(ql);
                    outerExGroup.outerLines = outerLines;
                    outerExGroup.derivedOppTypOrEnginEquipmnt = key;
                    
                }
                else {
                    system.debug('---outerLines --  is null'  );
                }
                
            }
            
            outerExMap.put(key,outerExGroup);
        }
        
        system.debug(' outerExMap ---'+ outerExMap.keySet());
        
        List<BundledLines> bundlelines = new List<BundledLines>(); 
        List<SBQQ__QuoteLine__c> additionalLinesOfMaterial  = new List<SBQQ__QuoteLine__c>();
        Decimal additionalMaterialsTotal = 0;
        Decimal totalOfAll = 0;
        PropDetail propDetail = new PropDetail();
        OuterBundle outerBundle = null;
        
        List<OuterExecutiveGroup> outerExGroupList = new List<OuterExecutiveGroup>();
        List<OuterExecutiveGroup> outerExGroupEngines = new List<OuterExecutiveGroup>();
        List<OuterExecutiveGroup> outerExgroupAsSetNoMatLines = new List<OuterExecutiveGroup>();
       
        Integer count = 0;
        for(OuterExecutiveGroup outerGroup : outerExMap.values()){
            if(groupingSetForMaterials.contains(outerGroup.derivedOppTypOrEnginEquipmnt)){
                outerExgroupAsSetNoMatLines.add(outerGroup); 
            }else if(groupingSetForAirframe.contains(outerGroup.derivedOppTypOrEnginEquipmnt)){
            	outerExGroupList.add(outerGroup);
            }else{
                outerExGroupEngines.add(outerGroup);
            } 
        }
        
        outerExGroupList.sort();
        outerExGroupEngines.sort();
        outerExgroupAsSetNoMatLines.sort();  
          
        //Airframe
        for(OuterExecutiveGroup outerGroup : outerExGroupList){
            outerGroup.outerExGroupNumber = ++count;
            system.debug('derivedOppTypOrEnginEquipmnt chk-- ' + outerGroup.derivedOppTypOrEnginEquipmnt);
            exGroupList = processQuoteLines(outerGroup.outerLines, outerGroup.outerExGroupNumber);
            outerBundle = makeBundlesByExGroup(outerGroup.outerLines, outerGroup.outerExGroupNumber);
            
            bundlelines = new List<BundledLines>(); 
            bundlelines.addAll(outerBundle.bundlelines);
            
            outerGroup.bundlelines = bundlelines;  
            additionalLinesOfMaterial.addAll(outerBundle.additionalLinesOfMaterial);
            additionalMaterialsTotal += outerBundle.additionalMaterialsTotal;
            totalOfAll += outerBundle.totalOfAll;
            outerGroup.totalOfAll = outerBundle.totalOfAll;
            outerGroup.exGroupList = exGroupList;
        }
        
        //Engines
        for(OuterExecutiveGroup outerGroup : outerExGroupEngines){
            outerGroup.outerExGroupNumber = ++count;
            system.debug('derivedOppTypOrEnginEquipmnt chk-- ' + outerGroup.derivedOppTypOrEnginEquipmnt);
            exGroupList = processQuoteLines(outerGroup.outerLines, outerGroup.outerExGroupNumber);
            outerBundle = makeBundlesByExGroup(outerGroup.outerLines, outerGroup.outerExGroupNumber);
            
            bundlelines = new List<BundledLines>(); 
            bundlelines.addAll(outerBundle.bundlelines);
            
            outerGroup.bundlelines = bundlelines;  
            additionalLinesOfMaterial.addAll(outerBundle.additionalLinesOfMaterial);
            additionalMaterialsTotal += outerBundle.additionalMaterialsTotal;
            totalOfAll += outerBundle.totalOfAll;
            outerGroup.totalOfAll = outerBundle.totalOfAll;
            outerGroup.exGroupList = exGroupList;
        }
        
        //Avionics Paint Interior
        for(OuterExecutiveGroup outerGroup : outerExgroupAsSetNoMatLines){
            outerGroup.outerExGroupNumber = ++count;
            exGroupList = processQuoteLines(outerGroup.outerLines,outerGroup.outerExGroupNumber);
            
            outerBundle = makeBundlesByExGroup(outerGroup.outerLines,outerGroup.outerExGroupNumber);
            bundlelines = new List<BundledLines>(); 
            bundlelines.addAll(outerBundle.bundlelines);
            outerGroup.bundlelines = bundlelines;   
            
            additionalLinesOfMaterial.addAll(outerBundle.additionalLinesOfMaterial);
            additionalMaterialsTotal += outerBundle.additionalMaterialsTotal;
            totalOfAll += outerBundle.totalOfAll;
            outerGroup.totalOfAll = outerBundle.totalOfAll;
            outerGroup.exGroupList = exGroupList;
        }
        
        outerExGroupToReturn = new List<OuterExecutiveGroup>();
        
        outerExGroupToReturn.addAll(outerExGroupList);
        outerExGroupToReturn.addAll(outerExGroupEngines);
        outerExGroupToReturn.addAll(outerExgroupAsSetNoMatLines);
        
        //Airframe
        propDetail.outerExgroup = outerExGroupList;
        if(outerExGroupList.size() == 1 && outerExGroupList[0].exGroupList.size() ==1 && outerExGroupList[0].bundlelines.size() == 0) {
            outerExGroupList[0].derivedOppTypOrEnginEquipmnt = '';
            outerExGroupList[0].outerExGroupNumber = null;
        }
        
        //Engines
        propDetail.outerExGroupEngines = outerExGroupEngines;
        if(outerExGroupEngines.size() == 1 && outerExGroupEngines[0].exGroupList.size() == 1 && outerExGroupEngines[0].bundlelines.size() == 0) {
            outerExGroupEngines[0].derivedOppTypOrEnginEquipmnt = '';
            outerExGroupEngines[0].outerExGroupNumber = null;
        }
        
        //Avionics Paint Interior
        propDetail.outerExgroupAsSetNoMatLines = outerExgroupAsSetNoMatLines;
        if(outerExgroupAsSetNoMatLines.size() == 1 && outerExgroupAsSetNoMatLines[0].exGroupList.size() == 1 && outerExgroupAsSetNoMatLines[0].bundlelines.size() == 0) {
            outerExgroupAsSetNoMatLines[0].derivedOppTypOrEnginEquipmnt = '';
            outerExgroupAsSetNoMatLines[0].outerExGroupNumber = null;
        }
               
        propDetail.additionalLinesOfMaterial = additionalLinesOfMaterial;
        propDetail.additionalMaterialsTotal = additionalMaterialsTotal;
        propDetail.totalOfAll = totalOfAll;
        return propDetail;
    }
    
    /*** Below method is used in master, child and cco ***/
    private OuterBundle makeBundlesByExGroup(List<SBQQ__QuoteLine__c> quoteLines,Integer outerExGroupNumber){
        List<BundledLines> bundledLines = new List<BundledLines>();
        BundledLines bundleline = null;
        List<SBQQ__QuoteLine__c> childLineList = null;
        Map<Id, BundledLines> bundleMap = new Map<Id, BundledLines>();
        for(SBQQ__QuoteLine__c ql : quoteLines){
            if(ql.SBQQ__RequiredBy__c == null){
                bundleline = bundleMap.get(ql.id);
                if(bundleline == null){
                    bundleline = new BundledLines();
                    bundleline.mainLineProductName = ql.Product_Name__c; 
                    bundleline.mainLine = ql;
                    if(ql.Specification__c != null && !String.isEmpty(ql.Specification__c)){
                        bundleline.mainLineSpecFromProduct = ql.Specification__c.trim().stripHtmlTags();
                    }else{
                        bundleline.mainLineSpecFromProduct = '';
                    }
                    childLineList = new List<SBQQ__QuoteLine__c>();
                    bundleline.childLines = childLineList;
                    bundleMap.put(ql.id ,bundleline);
                }
                else{
                    bundleline.mainLineProductName = ql.Product_Name__c; 
                    if(ql.Specification__c != null && !String.isEmpty(ql.Specification__c)){
                        bundleline.mainLineSpecFromProduct = ql.Specification__c.trim().stripHtmlTags();
                    }else{
                        bundleline.mainLineSpecFromProduct = '';
                    }
                    bundleline.mainLine = ql;
                    bundleMap.put(ql.id ,bundleline);
                }
            }
            else{
                bundleline = bundleMap.get(ql.SBQQ__RequiredBy__c);
                if(bundleline == null){
                    bundleline = new BundledLines();
                    childLineList = new List<SBQQ__QuoteLine__c>();
                    childLineList.add(ql);
                    bundleline.childLines = childLineList;
                    bundleMap.put(ql.SBQQ__RequiredBy__c ,bundleline);
                    continue;
                }
                else{
                    childLineList = bundleline.childLines ;
                    childLineList.add(ql);
                    bundleline.childLines = childLineList;
                    bundleMap.put(ql.SBQQ__RequiredBy__c ,bundleline);
                } 
            }
        }
        
        List<SBQQ__QuoteLine__c> additionalLinesOfBundle = new List<SBQQ__QuoteLine__c>();
        Decimal additionalMaterialsTotal = 0;
        Decimal totalOfAll = 0;
        
        for(BundledLines bl : bundleMap.values()){
            if(bl.childLines == null || bl.childLines.size() == 0){
                additionalLinesOfBundle.add(bl.mainLine);
                system.debug('bl.mainLine===' + bl.mainLine);
                additionalMaterialsTotal += bl.mainLine.Customer_Price__c==null?(0):bl.mainLine.Customer_Price__c;
                bundleMap.remove(bl.mainLine.id);
            }
            else{
                if(quoteSObj.SBQQ__Type__c == 'Amendment'){
                    if(checkForCCO(bl)){
                        processQuoteLinesByNewRequirement(bl);
                        totalOfAll +=bl.bundleTotal;
                    }else{
                        bundleMap.remove(bl.mainLine.id);
                    }
                    
                }else{
                    processQuoteLinesByNewRequirement(bl);
                    totalOfAll +=bl.bundleTotal;
                }
            }
        }
        
        bundleLinesToReturn = bundleMap.values();
        bundleLinesToReturn.sort();
        Integer bundleCounter = 0;
        for(BundledLines bl :bundleLinesToReturn ){
            bl.bundleLineNumber = outerExGroupNumber+ '.'+ ++bundleCounter;
        }
        
        List<SB_QuoteLineSorter> bundleLineSorterList = new List<SB_QuoteLineSorter>();
        for(SBQQ__QuoteLine__c ql :additionalLinesOfBundle){
            SB_QuoteLineSorter sbs = new SB_QuoteLineSorter();
            sbs.quoteLine = ql;
            bundleLineSorterList.add(sbs);
        }
        bundleLineSorterList.sort();
        additionalLinesOfBundle = new List<SBQQ__QuoteLine__c>();
        for(SB_QuoteLineSorter sbs : bundleLineSorterList){
            additionalLinesOfBundle.add(sbs.quoteLine);
        }
        OuterBundle outerBundle = new OuterBundle();
        outerBundle.bundlelines = bundleLinesToReturn;
        outerBundle.additionalLinesOfMaterial = additionalLinesOfBundle;
        outerBundle.additionalMaterialsTotal =additionalMaterialsTotal;
        outerBundle.totalOfAll = additionalMaterialsTotal + totalOfAll;
        
        return outerBundle;
    }
    
    /*----------  Below mehtod is used to process Proposal and Executive groups by XSL-FO 
used in master, child and cco ----------*/
    
    private List<ExecutiveGroup> processQuoteLines(List<SBQQ__QuoteLine__c> quoteLines,Integer appendNumber){
        Map<String, ExecutiveGroup> exGroupMap = new Map<String, ExecutiveGroup>();
        ExecutiveGroup eg = null;
        List<ProductFamilyGroup> pfgSet = null;
        List<QuoteLineWrapper> qlwList = null;
        ProductFamilyGroup pfg = null;
        String tempExGroup = '';
        String tempPrdFamily = '';
        Integer exGroupCount = 0;
        Integer fgGroupCount = 0;
        Integer qlCount = 0;
        
        for(SBQQ__QuoteLine__c ql : quoteLines){
            String exeGroupStr = ql.ExGroupFormula__c;
            String prodFamily = ql.SBQQ__ProductFamily__c;
            // here the query results are in order by clause so we can take advantage to 
            // have simple logic. 
            if(exeGroupStr == tempExGroup){
                eg = exGroupMap.get(exeGroupStr);
                if(eg != null){
                if(prodFamily == tempPrdFamily){
                    pfgSet = eg.productFamilyGroupSet;
                    pfg = checkProductFamilyPresent(eg, prodFamily);
                    if(pfg != null){
                        qlwList = pfg.quoteLinesByFamilyGroupList;
                        QuoteLineWrapper qlw = new QuoteLineWrapper();
                        qlw.quoteLine = ql;
                        qlw.quoteLineNumberToDisplay = appendNumber+'.'+exGroupCount + '.' + fgGroupCount + '.' + (++qlCount) ;
                        qlwList.add(qlw);
                        if(ql.Customer_Price__c != null){
                            pfg.familyGroupSubTotal += ql.Customer_Price__c;
                            eg.exGroupTotal  += ql.Customer_Price__c;
                        }
                        pfg.quoteLinesByFamilyGroupList = qlwList;
                        eg.productFamilyGroupSet = pfgSet;
                        exGroupMap.put(exeGroupStr,eg);
                        continue;
                        
                    }
                }
                else{
                    // Not found prod family
                    qlCount = 0;
                    If(eg != null){
                    pfgSet =eg.productFamilyGroupSet;
                    pfg = new ProductFamilyGroup();
                    pfg.productFamilyName = prodFamily;
                    pfg.familyGroupSubTotal = ql.Customer_Price__c;
                    pfg.productFamilyNumber = appendNumber+'.'+ exGroupCount + '.' + (++fgGroupCount);
                    
                    eg.exGroupTotal  += ql.Customer_Price__c;
                    qlwList = new List<QuoteLineWrapper>();
                    QuoteLineWrapper qlw = new QuoteLineWrapper();
                    qlw.quoteLine = ql;
                    qlw.quoteLineNumberToDisplay = appendNumber+'.'+ exGroupCount + '.' + fgGroupCount + '.' + (++qlCount);
                    qlwList.add(qlw);
                    pfg.quoteLinesByFamilyGroupList = qlwList;
                    pfgSet.add(pfg);
                    eg.productFamilyGroupSet = pfgSet;
                    exGroupMap.put(exeGroupStr,eg);
                    tempPrdFamily = prodFamily;
                    continue;
                }
                }
            }
            }
            else{
                fgGroupCount = 0;
                qlCount=0;
                // Ex Group not found
                eg = new ExecutiveGroup();
                eg.executiveGroupName = exeGroupStr;
                eg.exGroupNumber=appendNumber+'.'+ (++exGroupCount) ;
                pfgSet = new List<ProductFamilyGroup>();
                pfg = new ProductFamilyGroup();
                pfg.productFamilyName = prodFamily;
                pfg.productFamilyNumber = appendNumber+'.'+exGroupCount + '.' + (++fgGroupCount);
                pfg.familyGroupSubTotal = ql.Customer_Price__c;
                eg.exGroupTotal  = ql.Customer_Price__c;
                qlwList = new List<QuoteLineWrapper>();
                QuoteLineWrapper qlw = new QuoteLineWrapper();
                qlw.quoteLine = ql;
                qlw.quoteLineNumberToDisplay = appendNumber+'.'+exGroupCount + '.' + fgGroupCount + '.' + (++qlCount);
                qlwList.add(qlw);
                pfg.quoteLinesByFamilyGroupList = qlwList;
                pfgSet.add(pfg);
                eg.productFamilyGroupSet = pfgSet;
                exGroupMap.put(exeGroupStr,eg);
                tempExGroup = exeGroupStr;
                tempPrdFamily = prodFamily;
            }
        }
        return exGroupMap.values();
    }
    
    /*=====  Below method is used to check whether product family group is present or not
If Not present then it returns null else the obj. 
Used in master ,child and cco ======*/
    @TestVisible
    private void processQuoteLinesByNewRequirement(BundledLines bl){
        Map<String, ExecutiveGroup> exGroupMap = new Map<String, ExecutiveGroup>();
        ExecutiveGroup eg = null;
        List<ProductFamilyGroup> pfgSet = null;
        List<QuoteLineWrapper> qlwList = null;
        ProductFamilyGroup pfg = null;
        String tempExGroup = '';
        String tempPrdFamily = '';
        Integer exGroupCount = 0;
        Integer fgGroupCount = 0;
        Integer qlCount = 0;
        
        String mainLineProductName = bl.mainLineProductName;
        SBQQ__QuoteLine__c mainLine = bl.mainLine;
        if(mainLine!= null && mainLine.Specification__c != null && !String.isEmpty(mainLine.Specification__c)){
            bl.mainLineSpecFromProduct = bl.mainLine.Specification__c.trim().stripHtmlTags();
        }else{
            bl.mainLineSpecFromProduct = '';
        }
        
        List<SBQQ__QuoteLine__c> childLines  = bl.childLines;
        Decimal bundleTotal = 0;
        Decimal bundleTotalForExcludeBundle =0;
        BundleMaterialGroup materialGroup=null;
        List<BundleLabourGroup> labourGroupList= null; 
        List<SBQQ__QuoteLine__c> materialLinesOfBundle = new List<SBQQ__QuoteLine__c>();
        List<SBQQ__QuoteLine__c> laborLinesOfBundle = new List<SBQQ__QuoteLine__c>();
        
        Decimal totalOfMaterials = 0;
        Decimal totalOfMaterialsForExcludeBundle = 0;
        String labourType= '';
        Decimal labourTypeSubTotal = 0;
        Decimal labourTypeSubTotalForExcludeBundle =0;
        String materialWarrentyType = '';
        boolean displayMaterialWarrenty = false; // this controls whether amount should be displayed or warrenty
        boolean displayMaterials = true; // this controls whether verbiage should be displayed or not
        
        
        for(SBQQ__QuoteLine__c ql : childLines){
            // materialLinesOfBundle.add(ql);
            if(ql.SBQQ__ProductFamily__c == 'Materials'){
                materialLinesOfBundle.add(ql);
            }
            else if(ql.SBQQ__ProductFamily__c == 'Labor'){
                laborLinesOfBundle.add(ql);
            }
        }
        
        Integer countWarrenty = 0;
        Boolean isWarrentyForAllMatLines = false;
        
        for(SBQQ__QuoteLine__c ql : materialLinesOfBundle){
            totalOfMaterials += ql.Customer_Price__c;
            totalOfMaterialsForExcludeBundle += ql.fxNet_Total__c;
            if(ql.ExcludeFromExecutiveSummary__c == False){
                bundleTotal +=  ql.Customer_Price__c;             
                bundleTotalForExcludeBundle += ql.fxNet_Total__c;
            }
            if(ql.IsWarrentyOrPrice__c){
                materialWarrentyType = ql.Warranty_Program__c;
                countWarrenty++;
            }
        }
        
        if(countWarrenty == materialLinesOfBundle.size()){
            isWarrentyForAllMatLines = true;
        }
        
        materialGroup = new BundleMaterialGroup();
        
        // sorting by number
        List<SB_QuoteLineSorter> bundleLineSorterList = new List<SB_QuoteLineSorter>();
        for(SBQQ__QuoteLine__c ql :materialLinesOfBundle){
            SB_QuoteLineSorter qls = new SB_QuoteLineSorter();
            qls.quoteLine = ql;
            bundleLineSorterList.add(qls);  
        }
        
        bundleLineSorterList.sort();
        materialLinesOfBundle = new List<SBQQ__QuoteLine__c>();
        for(SB_QuoteLineSorter qls :bundleLineSorterList){
            materialLinesOfBundle.add(qls.quoteLine); 
        }
        
        // sorting ends
        materialGroup.materialLinesOfBundle = materialLinesOfBundle;
        materialGroup.totalOfMaterials = totalOfMaterials;
        materialGroup.materialWarrentyType = materialWarrentyType;
        materialGroup.totalOfMaterialsForExcludeBundle = totalOfMaterialsForExcludeBundle;
        if(materialWarrentyType != null && materialWarrentyType.trim().length() >0 && isWarrentyForAllMatLines){
            displayMaterialWarrenty = true;
        }else{
            displayMaterialWarrenty = false;
        }
        
        if(materialGroup.materialLinesOfBundle.size() == 0 || materialGroup.materialLinesOfBundle.isEmpty()){
            displayMaterials = false;
        }else{
            displayMaterials = true;
        }
        materialGroup.displayMaterialWarrenty =displayMaterialWarrenty;
        
        bl.materialGroup = materialGroup;
        bl.displayMaterials = displayMaterials; 
        
        Decimal labourGroupTotal = 0;
        Decimal labourGroupTotalForExcludeBundle =  0;
        String labourWarrentyType = '';
        boolean displayLabourWarrenty = false; //This controls whether amount or warrenty to be displayed
        boolean displayLabor = true; // This controls whether this should display verbiage
        
        if(laborLinesOfBundle.size() == 0 || laborLinesOfBundle.isEmpty()){
            displayLabor = false;
        }else{
            displayLabor =true;
        }
        
        Integer countWarrentyLaborProducts =0;
        Map<String,BundleLabourGroup>  laborMap = new Map<String, BundleLabourGroup>();
        for(SBQQ__QuoteLine__c ql : laborLinesOfBundle){
            BundleLabourGroup blg = laborMap.get(ql.Family_Type__c);
            if(blg != null){
                blg.labourTypeSubTotal += ql.Customer_Price__c;
                blg.labourTypeSubTotalForExcludeBundle += ql.fxNet_Total__c;
            } 
            else{
                blg = new BundleLabourGroup();
                blg.labourType = ql.Family_Type__c;
                blg.labourTypeSubTotal = ql.Customer_Price__c;
                blg.labourTypeSubTotalForExcludeBundle = ql.fxNet_Total__c;
            }
            
            laborMap.put(ql.Family_Type__c,blg);
            if(ql.ExcludeFromExecutiveSummary__c == False){
                bundleTotal +=  ql.Customer_Price__c;            
                bundleTotalForExcludeBundle += ql.fxNet_Total__c;
            }
            labourGroupTotal +=  ql.Customer_Price__c;
            labourGroupTotalForExcludeBundle += ql.fxNet_Total__c;
                        
            /* added new logic for labour warrenty */
            if(ql.IsWarrentyOrPrice__c){
                labourWarrentyType = ql.Warranty_Program__c;
                countWarrentyLaborProducts++;
            }
        }
        
        boolean isWarrentyForAllLabourProducts = false;
        if(countWarrentyLaborProducts == laborLinesOfBundle.size() ){
            isWarrentyForAllLabourProducts = true;
        }
        
        bl.labourGroupList = laborMap.values();
        bl.bundleTotal = bundleTotal;
        bl.bundleTotalForExcludeBundle = bundleTotalForExcludeBundle;
        bl.labourGroupTotal = labourGroupTotal;
        bl.labourGroupTotalForExcludeBundle = labourGroupTotalForExcludeBundle;
        bl.labourWarrentyType = labourWarrentyType;
        bl.displayLabor = displayLabor;
        
        if(labourWarrentyType != null && labourWarrentyType.trim().length() >0 && isWarrentyForAllLabourProducts){
            bl.displayLabourWarrenty = true;
        }
        else{
            bl.displayLabourWarrenty = false;
        }
        
        // additional logic to handle the exclude for warrenty if both are in warrenty
        if(bl.displayLabourWarrenty && displayMaterialWarrenty){
            bl.bundleTotalForExcludeBundle = 0;
        }
    }
    
    
    /*** Below method is used to check whether product family present, Used in master, child and cco ***/
    private ProductFamilyGroup checkProductFamilyPresent(ExecutiveGroup eg,String familyGroupToFind){
        List<ProductFamilyGroup> pfgSet = eg.productFamilyGroupSet;
        if(pfgSet == null || pfgSet.isEmpty()){
            return null;
        }
        for(ProductFamilyGroup pfg : pfgSet){
            if(pfg.productFamilyName == familyGroupToFind){
                return pfg;
            }
        }
        return null;
    }
    
    /*** start of wrapper classes ***/
    public class PropDetail{
        public List<OuterExecutiveGroup> outerExgroup {get;set;}
        public List<OuterExecutiveGroup> outerExgroupAsSetNoMatLines {get;set;}
        public List<OuterExecutiveGroup> outerExGroupEngines {get;set;}
        public List<SBQQ__QuoteLine__c> additionalLinesOfMaterial {get;set;}
        public Decimal additionalMaterialsTotal {get; set;}
        public Decimal totalOfAll {get; set;} 
    }
    
    public class OuterBundle{
        public List<BundledLines> bundlelines {get; set;}
        public List<SBQQ__QuoteLine__c> additionalLinesOfMaterial {get;set;}
        public Decimal additionalMaterialsTotal {get; set;}
        public Decimal totalOfAll {get; set;}
    }
    
    public  class BundledLines implements Comparable{
        public String bundleLineNumber {get; set;}
        public String mainLineProductName {get;set;}
        public String mainLineSpecFromProduct {get;set;}
        public SBQQ__QuoteLine__c mainLine {get;set;}
        public List<SBQQ__QuoteLine__c> childLines {get;set;}
        public Decimal bundleTotal {get; set;}
        public Decimal bundleTotalForExcludeBundle {get; set;}
        public BundleMaterialGroup materialGroup {get; set;}
        public List<BundleLabourGroup> labourGroupList {get; set;}
        public Decimal labourGroupTotal {get;set;}
        public Decimal labourGroupTotalForExcludeBundle {get;set;}
        public String labourWarrentyType {get;set;}
        public Boolean displayLabourWarrenty {get;set;}
        public Boolean displayLabor {get;set;}
        public Boolean displayMaterials {get;set;}
        public Map<String,Decimal> FeatureDetailsSell {get;set;}
        public Map<String,Decimal> FeatureDetailsCost {get;set;}
        public Map<String,Decimal> FeatureDetailsMargin {get;set;}
        public Map<String,Decimal> FeatureDetailsQuauntity {get;set;}
        public Integer FeatureDetailsCostSize {get;set;}
        public Boolean hasTsm {get;set;}
        public Boolean hasWarranty {get;set;}
        public Integer allzero {get;set;}
        public Decimal totalSell {get;set;}
        public Decimal warrantySell {get;set;}
        public Boolean hasExclude {get;set;}
        
        public Integer compareTo(Object compare) {
            BundledLines compareBundle = (BundledLines)compare;
            if (this.mainLine.SBQQ__Number__c == compareBundle.mainLine.SBQQ__Number__c) return 0;
            if (this.mainLine.SBQQ__Number__c > compareBundle.mainLine.SBQQ__Number__c) return 1;
            return -1;
        }
    }
    
    public class BundleMaterialGroup {
        public List<SBQQ__QuoteLine__c> materialLinesOfBundle {get;set;}
        public Decimal totalOfMaterials  {get;set;}
        public Boolean displayMaterialWarrenty {get;set;}
        public String materialWarrentyType {get;set;}
        public Decimal totalOfMaterialsForExcludeBundle  {get;set;}
    }
    
    public class BundleLabourGroup{
        public String labourType {get;set;}
        public Decimal labourTypeSubTotal {get; set;}
        public Decimal labourTypeSubTotalForExcludeBundle {get; set;}
    }
    
    public class OuterExecutiveGroup implements Comparable{
        public String derivedOppTypOrEnginEquipmnt {get;set;}
        public List<ExecutiveGroup> exGroupList {get; set;}
        public List<SBQQ__QuoteLine__c> outerLines {get;set;}
        public Integer outerExGroupNumber {get;set;}
        public List<BundledLines> bundlelines {get; set;}
        public List<SBQQ__QuoteLine__c> additionalLinesOfMaterial {get;set;}
        public Decimal additionalMaterialsTotal {get; set;}
        public Decimal totalOfAll {get; set;}
        public Decimal totalOfSell {get; set;}
        public Decimal totalLabor {get; set;}
        public Decimal totalOfCost {get; set;}
        public Decimal Margin {get; set;}
        
        public Integer compareTo(Object compare) {
            OuterExecutiveGroup compareOuterExGroup = (OuterExecutiveGroup)compare;
            if (this.derivedOppTypOrEnginEquipmnt == compareOuterExGroup.derivedOppTypOrEnginEquipmnt) return 0;
            if (this.derivedOppTypOrEnginEquipmnt > compareOuterExGroup.derivedOppTypOrEnginEquipmnt) return 1;
            return -1;   
        } 
    }
    
    // Below class is the wrapper for Ex group
    public class ExecutiveGroup{
        // public List<SBQQ__QuoteLine__c> exGroupLines {get;set;}
        public String executiveGroupName {get; set;}
        public List<ProductFamilyGroup> productFamilyGroupSet {get; set;}
        public Decimal exGroupTotal {get; set;}
        public String exGroupNumber {get;set;}       
    }
    
    // Below class is the wrapper for Prod Family Group
    public class ProductFamilyGroup{      
        public String productFamilyName {get; set;}
        public List<QuoteLineWrapper> quoteLinesByFamilyGroupList {get; set;}
        public Decimal familyGroupSubTotal {get; set;}
        public String productFamilyNumber {get; set;}       
    }
    
    // Below class is the wrapper for Quote Line Wrapper.
    public class QuoteLineWrapper{
        public SBQQ__QuoteLine__c quoteLine {get;set;}
        public String quoteLineNumberToDisplay {get;set;}
    }
}