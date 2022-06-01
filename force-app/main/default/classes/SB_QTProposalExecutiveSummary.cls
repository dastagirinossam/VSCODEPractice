public class SB_QTProposalExecutiveSummary {
    
    // Below array is the Raw Array for display.
    public SBQQ__QuoteLine__c[] quoteLineItems {get;  set;}
    
    public SBQQ__Quote__c quoteSObj {get; set;}
    
    public Boolean hasOptions {get; set;}
    
    public BundledLines[] bundleLinesToReturn {get;set;}
    
    public List<OuterExecutiveGroup> outerExGroupToReturn {get; set;}
    
    public PropDetail propDetailToReturn {get;set;}
    
    public Set<String> groupingSetForMaterials {get;set;}
    
    public Set<String> groupingSetForAirframe {get;set;}
    
    // Constructor
    public SB_QTProposalExecutiveSummary() {
        
        Id quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');      
        Id templateId = (Id)ApexPages.currentPage().getParameters().get('templateId');
        
        String queryQuoteIdstr = String.valueOf('\'')+quoteId+String.valueOf('\'');
        queryQuoteIdstr = '('+queryQuoteIdstr+')';
        
        String soqlQuoteQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__Quote__c');
        List<SBQQ__Quote__c> quoteList = Database.query(soqlQuoteQuery + ' where id in ' + queryQuoteIdstr);     
        
        if(quoteList != null && !quoteList.isEmpty()){
            quoteSObj = quoteList.get(0);
        }
        
        hasOptions = false;
        
        // Querying quote lines - here generic query not used because we need to fetch the product fields.       
        List<SBQQ__QuoteLine__c> quoteLinesOfChildQuotesList = [SELECT Id,  Name,  SBQQ__Quote__c,ExcludeFromExecutiveSummary__c,
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
                                                                SBQQ__NetTotal__c, SBQQ__NonDiscountable__c, SBQQ__NonPartnerDiscountable__c, SBQQ__Number__c, 
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
                                                                Customer_Price__c, fxNet_Total__c, ExecutiveSummaryGroup__c, ExcludeFromSummaryFormula__c, Family_Type__c, 
                                                                SBQQ__Product__r.Vendor_Number__c,
                                                                Derived_From_Quote_Line__r.Name,
                                                                SBQQ__Product__r.Vendor_Name__c,
                                                                SBQQ__Product__r.Vendor_Contact__c,
                                                                SBQQ__Product__r.Vendor_Phone__c,
                                                                SBQQ__Product__r.Family,
                                                                SBQQ__Product__r.Name,
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
                                                                SBQQ__RequiredBy__r.Sort_Order__c,
                                                                Show_on_Customer_Quote__c, 
                                                                Specification__c,
                                                                fxJob_Card__c,
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
                                                                Table_Value__c         
                                                                FROM SBQQ__QuoteLine__c 
                                                                where SBQQ__Quote__c = :quoteId
                                                                and IsHiddenForTemplates__c= false
                                                                Order By DerivedOpportunityType__c,DerivedEngineSNAndEquipModel__c,
                                                                ExGroupFormula__c, SBQQ__Product__r.Family ];
        
        groupingSetForMaterials = new Set<String>();
        groupingSetForMaterials.add('Avionics');
        groupingSetForMaterials.add('Paint');
        groupingSetForMaterials.add('Interior');
        
        groupingSetForAirframe = new Set<String>();
        groupingSetForAirframe.add('Airframe');
        
        quoteLineItems = quoteLinesOfChildQuotesList;
        
        propDetailToReturn = prepareExecutiveGroupNew();
        
        //Airframe
        for(OuterExecutiveGroup OEG : propDetailToReturn.outerExgroup){
            OEG.bl_esgMapSortFinal = new Map<Decimal, Map<String, Map<String, Decimal>>>();
            OEG.bl_esgMapSort = new Map<String, Decimal>();
            OEG.bl_esgCategoryMap = new Map<String, Map<String, Decimal>>();
            
            for(BundledLines bl : OEG.bundlelines){
                bl.esgSell = new Map<String, Decimal>();
                bl.esgLabor = new Map<String, Decimal>();
                bl.esgCost = new Map<String, Decimal>();
                
                system.debug('BL Number: ' + bl.bundleLineNumber);
                for(SBQQ__QuoteLine__c qli : bl.childLines){
                    String esg;
                    String sortOrderNo = bl.bundleLineNumber;
                    
                    if(qli.ExcludeFromExecutiveSummary__c == true){
                        if(!hasOptions)
                            hasOptions = true;                        
                        esg = 'Option: ' + qli.ExGroupFormula__c;
                    }else{
                        esg = qli.ExGroupFormula__c;
                    }
                    
                    if(!OEG.bl_esgCategoryMap.containsKey(esg)){
                        Map<String, Decimal> blESG = new Map<String, Decimal>();
                        blESG.put('sell', 0);
                        blESG.put('labor', 0);
                        blESG.put('cost', 0);
                        OEG.bl_esgCategoryMap.put(esg, blESG);
                    }
                    
                    if(!OEG.bl_esgMapSort.containsKey(esg)){                     
                        OEG.bl_esgMapSort.put(esg, Decimal.valueof(sortOrderNo.replace('.', '0')));
                        
                    }else{
                        if(Decimal.valueof(sortOrderNo.replace('.', '0')) < OEG.bl_esgMapSort.get(esg))
                            OEG.bl_esgMapSort.put(esg, Decimal.valueof(sortOrderNo.replace('.', '0')));                       
                    }
                    
                    Map<String, Decimal> esgCatMap = OEG.bl_esgCategoryMap.get(esg);
                    
                    Decimal sell = esgCatMap.get('sell');
                    Decimal labor = esgCatMap.get('labor');
                    Decimal cost = esgCatMap.get('cost');
                    
                    if(!qli.IsWarrentyOrPrice__c)
                        sell += qli.fxNet_Total__c; 
                    
                    if(!qli.ExcludeFromExecutiveSummary__c && qli.Labor__c)
                        labor += qli.SBQQ__Quantity__c;
                    
                    cost += qli.Net_Cost__c;
                    
                    system.debug('QLI: ' + esgCatMap.keySet() + ' - Sell : ' + esgCatMap.get('sell'));
                    
                    esgCatMap.put('sell', sell);
                    esgCatMap.put('labor', labor);
                    esgCatMap.put('cost', cost);
                }
            }
            
            List<Decimal> so = new List<Decimal>(OEG.bl_esgMapSort.Values());
            so.sort();
            
            system.debug('Airframe Sort: ' + so);
            
            String newMap = '{';
            for(Decimal s : so){
                for(String key : OEG.bl_esgMapSort.Keyset()){ 
                    if(OEG.bl_esgMapSort.get(key) == s)
                        newMap += '"' + 
                        s + 
                        '": {"' + 
                        key + 
                        '": {"cost": ' + 
                        OEG.bl_esgCategoryMap.get(key).get('cost') +
                        ', "labor": ' + 
                        OEG.bl_esgCategoryMap.get(key).get('labor') +
                        ', "sell": ' + 
                        OEG.bl_esgCategoryMap.get(key).get('sell') + '}},';
                }
            }
            
            system.debug('New Map: >>>>>>>' + newMap);
            String newMap2 = newMap.removeEnd(',');
            newMap2 += '}';
            
            OEG.bl_esgMapSortFinal = (Map<Decimal, Map<String, Map<String, Decimal>>>)JSON.deserialize(newMap2, Map<Decimal, Map<String, Map<String, Decimal>>>.class);
            
        }
        
        //Engine
        for(OuterExecutiveGroup OEG : propDetailToReturn.outerExGroupEngines){
            OEG.bl_esgMapSortFinal = new Map<Decimal, Map<String, Map<String, Decimal>>>();
            OEG.bl_esgMapSort = new Map<String, Decimal>();
            OEG.bl_esgCategoryMap = new Map<String, Map<String, Decimal>>();
            
            for(BundledLines bl : OEG.bundlelines){
                bl.esgSell = new Map<String, Decimal>();
                bl.esgLabor = new Map<String, Decimal>();
                bl.esgCost = new Map<String, Decimal>();
                
                system.debug('BL Number: ' + bl.bundleLineNumber);
                for(SBQQ__QuoteLine__c qli : bl.childLines){
                    String esg;
                    String sortOrderNo = bl.bundleLineNumber;
                    
                    if(qli.ExcludeFromExecutiveSummary__c == true){
                        if(!hasOptions)
                            hasOptions = true;                        
                        esg = 'Option: ' + qli.ExGroupFormula__c;
                    }else{
                        esg = qli.ExGroupFormula__c;
                    }
                    
                    if(!OEG.bl_esgCategoryMap.containsKey(esg)){
                        Map<String, Decimal> blESG = new Map<String, Decimal>();
                        blESG.put('sell', 0);
                        blESG.put('labor', 0);
                        blESG.put('cost', 0);
                        OEG.bl_esgCategoryMap.put(esg, blESG);
                    }
                    
                    if(!OEG.bl_esgMapSort.containsKey(esg)){                     
                        OEG.bl_esgMapSort.put(esg, Decimal.valueof(sortOrderNo.replace('.', '0')));
                        
                    }else{
                        if(Decimal.valueof(sortOrderNo.replace('.', '0')) < OEG.bl_esgMapSort.get(esg))
                            OEG.bl_esgMapSort.put(esg, Decimal.valueof(sortOrderNo.replace('.', '0')));                       
                    }
                    
                    Map<String, Decimal> esgCatMap = OEG.bl_esgCategoryMap.get(esg);
                    
                    Decimal sell = esgCatMap.get('sell');
                    Decimal labor = esgCatMap.get('labor');
                    Decimal cost = esgCatMap.get('cost');
                    
                    if(!qli.IsWarrentyOrPrice__c)
                        sell += qli.fxNet_Total__c; 
                    
                    if(!qli.ExcludeFromExecutiveSummary__c && qli.Labor__c)
                        labor += qli.SBQQ__Quantity__c;
                    
                    cost += qli.Net_Cost__c;
                    
                    system.debug('QLI: ' + esgCatMap.keySet() + ' - Sell : ' + esgCatMap.get('sell'));
                    
                    esgCatMap.put('sell', sell);
                    esgCatMap.put('labor', labor);
                    esgCatMap.put('cost', cost);
                }
            }
            
            List<Decimal> so = new List<Decimal>(OEG.bl_esgMapSort.Values());
            so.sort();
            
            system.debug('Airframe Sort: ' + so);
            
            String newMap = '{';
            for(Decimal s : so){
                for(String key : OEG.bl_esgMapSort.Keyset()){ 
                    if(OEG.bl_esgMapSort.get(key) == s)
                        newMap += '"' + 
                        s + 
                        '": {"' + 
                        key + 
                        '": {"cost": ' + 
                        OEG.bl_esgCategoryMap.get(key).get('cost') +
                        ', "labor": ' + 
                        OEG.bl_esgCategoryMap.get(key).get('labor') +
                        ', "sell": ' + 
                        OEG.bl_esgCategoryMap.get(key).get('sell') + '}},';
                }
            }
            
            system.debug('New Map: >>>>>>>' + newMap);
            String newMap2 = newMap.removeEnd(',');
            newMap2 += '}';
            
            OEG.bl_esgMapSortFinal = (Map<Decimal, Map<String, Map<String, Decimal>>>)JSON.deserialize(newMap2, Map<Decimal, Map<String, Map<String, Decimal>>>.class);
            
        }
        
        //Avionics Paint Interior
        for(OuterExecutiveGroup OEG : propDetailToReturn.outerExgroupAsSetNoMatLines){
            OEG.bl_esgMapSortFinal = new Map<Decimal, Map<String, Map<String, Decimal>>>();
            OEG.bl_esgMapSort = new Map<String, Decimal>();
            OEG.bl_esgCategoryMap = new Map<String, Map<String, Decimal>>();
            
            for(BundledLines bl : OEG.bundlelines){
                bl.esgSell = new Map<String, Decimal>();
                bl.esgLabor = new Map<String, Decimal>();
                bl.esgCost = new Map<String, Decimal>();
                
                system.debug('BL Number: ' + bl.bundleLineNumber);
                for(SBQQ__QuoteLine__c qli : bl.childLines){
                    String esg;
                    String sortOrderNo = bl.bundleLineNumber;
                    
                    if(qli.ExcludeFromExecutiveSummary__c == true){
                        if(!hasOptions)
                            hasOptions = true;                        
                        esg = 'Option: ' + qli.ExGroupFormula__c;
                    }else{
                        esg = qli.ExGroupFormula__c;
                    }
                    
                    if(!OEG.bl_esgCategoryMap.containsKey(esg)){
                        Map<String, Decimal> blESG = new Map<String, Decimal>();
                        blESG.put('sell', 0);
                        blESG.put('labor', 0);
                        blESG.put('cost', 0);
                        OEG.bl_esgCategoryMap.put(esg, blESG);
                    }
                    
                    if(!OEG.bl_esgMapSort.containsKey(esg)){                     
                        OEG.bl_esgMapSort.put(esg, Decimal.valueof(sortOrderNo.replace('.', '0')));
                        
                    }else{
                        if(Decimal.valueof(sortOrderNo.replace('.', '0')) < OEG.bl_esgMapSort.get(esg))
                            OEG.bl_esgMapSort.put(esg, Decimal.valueof(sortOrderNo.replace('.', '0')));                       
                    }
                    
                    Map<String, Decimal> esgCatMap = OEG.bl_esgCategoryMap.get(esg);
                    
                    Decimal sell = esgCatMap.get('sell');
                    Decimal labor = esgCatMap.get('labor');
                    Decimal cost = esgCatMap.get('cost');
                    
                    if(!qli.IsWarrentyOrPrice__c)
                        sell += qli.fxNet_Total__c; 
                    
                    if(!qli.ExcludeFromExecutiveSummary__c && qli.Labor__c)
                        labor += qli.SBQQ__Quantity__c;
                    
                    cost += qli.Net_Cost__c;
                    
                    system.debug('QLI: ' + esgCatMap.keySet() + ' - Sell : ' + esgCatMap.get('sell'));
                    
                    esgCatMap.put('sell', sell);
                    esgCatMap.put('labor', labor);
                    esgCatMap.put('cost', cost);
                }
            }
            
            List<Decimal> so = new List<Decimal>(OEG.bl_esgMapSort.Values());
            so.sort();
            
            system.debug('Avionics Sort: ' + so);
            
            String newMap = '{';
            for(Decimal s : so){
                for(String key : OEG.bl_esgMapSort.Keyset()){ 
                    if(OEG.bl_esgMapSort.get(key) == s)
                        newMap += '"' + 
                        s + 
                        '": {"' + 
                        key + 
                        '": {"cost": ' + 
                        OEG.bl_esgCategoryMap.get(key).get('cost') +
                        ', "labor": ' + 
                        OEG.bl_esgCategoryMap.get(key).get('labor') +
                        ', "sell": ' + 
                        OEG.bl_esgCategoryMap.get(key).get('sell') + '}},';
                }
            }
            
            system.debug('New Map: >>>>>>>' + newMap);
            String newMap2 = newMap.removeEnd(',');
            newMap2 += '}';
            
            system.debug('newMap2>>>'+newMap2 ); 
            
            if(!Test.isRunningTest())      
                OEG.bl_esgMapSortFinal = (Map<Decimal, Map<String, Map<String, Decimal>>>)JSON.deserialize(newMap2, Map<Decimal, Map<String, Map<String, Decimal>>>.class);
            
            system.debug('Avionics Map: ' + newMap2);
        }
        
    }
    
    /**** Below mthod is used for master, child, cco**/
    private PropDetail prepareExecutiveGroupNew(){
        
        OuterExecutiveGroup outerExGroup = null;
        
        List<String> TableValueList = new  List<String>();
        String derivedOppTypOrEnginEquipmnt = '';
        
        List<ExecutiveGroup> exGroupList = null;
        List<SBQQ__QuoteLine__c> outerLines = null;
        
        Map<String,OuterExecutiveGroup> outerExMap = new Map<String, OuterExecutiveGroup>();
        String tempOppTypEngEquip = '';
        
        for(SBQQ__QuoteLine__c ql :quoteLineItems){
            TableValueList.add(ql.Table_Value__c);
            String oppType = null;  // to use for group 2nd
            String engineEquipmnt = null; // to use for group 1st
            String key = null;
            String engineSN = null; // for comparison
            
            oppType = ql.DerivedOpportunityType__c;
            engineEquipmnt = ql.DerivedEngineSNAndEquipModel__c;
            engineSN = ql.DerivedEngineSN__c;
            
            key = null;  
            
            if(engineSN != null && engineSN != 'NA'){
                outerExGroup = outerExMap.get(engineEquipmnt);
                key = engineEquipmnt;
            } else if ((engineSN == null || engineSN.length() == 0 || engineSN == 'NA') && (oppType !=null && oppType.length() >0 )) {
                outerExGroup = outerExMap.get(oppType);
                system.debug('OPP TYPE: ' + oppType);
                key = oppType;
            }else{
                outerExGroup =  outerExMap.get(null);
                key = null;
            }
            
            system.debug('---Key ---'+ key);
            
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
            
            outerExMap.put(key, outerExGroup);         
        }
        
        system.debug(' outerExMap ---' + outerExMap);
        
        List<BundledLines> bundlelines = new List<BundledLines>(); 
        List<SBQQ__QuoteLine__c> additionalLinesOfMaterial  = new List<SBQQ__QuoteLine__c>();
        Decimal additionalMaterialsTotal = 0;
        Decimal totalOfAll = 0;
        
        Decimal totalCost = 0;
        Decimal totalLabor = 0;
        
        PropDetail propDetail = new PropDetail();
        
        OuterBundle outerBundle = null;
        
        List<OuterExecutiveGroup> outerExGroupList = new List<OuterExecutiveGroup>();
        List<OuterExecutiveGroup> outerExgroupAsSetNoMatLines = new List<OuterExecutiveGroup>();
        List<OuterExecutiveGroup> outerExGroupEngines = new List<OuterExecutiveGroup>();
        
        Integer count = 0;
        for(OuterExecutiveGroup outerGroup : outerExMap.values()){   
            system.debug('derived Opp Engin Equip >>'+ outerGroup.derivedOppTypOrEnginEquipmnt );
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
        
        system.debug('--outerExGroupList-- ' + outerExGroupList.size() + ' --outerExgroupAsSetNoMatLines ' + outerExgroupAsSetNoMatLines.size());
        
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
            totalCost += outerBundle.totalCost;
            totalLabor += outerBundle.totalLabor;
            
            outerGroup.totalOfAll = outerBundle.totalOfAll;
            outerGroup.totalCost = outerBundle.totalCost;
            outerGroup.totalLabor = outerBundle.totalLabor;
            
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
            totalCost += outerBundle.totalCost;
            totalLabor += outerBundle.totalLabor;
            
            outerGroup.totalOfAll = outerBundle.totalOfAll;
            outerGroup.totalCost = outerBundle.totalCost;
            outerGroup.totalLabor = outerBundle.totalLabor;
            
            outerGroup.exGroupList = exGroupList;
            
        }
        
        //Avionics, Paint, Interior
        for(OuterExecutiveGroup outerGroup : outerExgroupAsSetNoMatLines){
            outerGroup.outerExGroupNumber = ++count;
            
            exGroupList = processQuoteLines(outerGroup.outerLines, outerGroup.outerExGroupNumber);
            system.debug('derivedOppTypOrEnginEquipmnt chk-- ' + outerGroup.derivedOppTypOrEnginEquipmnt);
            outerBundle = makeBundlesByExGroup(outerGroup.outerLines, outerGroup.outerExGroupNumber);
            bundlelines = new List<BundledLines>(); 
            bundlelines.addAll(outerBundle.bundlelines);
            outerGroup.bundlelines = bundlelines;   
            
            additionalLinesOfMaterial.addAll(outerBundle.additionalLinesOfMaterial);
            additionalMaterialsTotal += outerBundle.additionalMaterialsTotal;
            
            totalOfAll += outerBundle.totalOfAll;
            totalCost += outerBundle.totalCost;
            totalLabor += outerBundle.totalLabor;
            
            outerGroup.totalOfAll = outerBundle.totalOfAll;
            outerGroup.totalCost = outerBundle.totalCost;
            outerGroup.totalLabor = outerBundle.totalLabor;
            
            outerGroup.exGroupList = exGroupList;
        }
        
        outerExGroupToReturn = new List<OuterExecutiveGroup>();
        
        outerExGroupToReturn.addAll(outerExGroupList);
        outerExGroupToReturn.addAll(outerExGroupEngines);
        outerExGroupToReturn.addAll(outerExgroupAsSetNoMatLines);
        
        //Airframe
        propDetail.outerExgroup = outerExGroupList;
        
        if(outerExGroupList.size() == 1 && outerExGroupList[0].exGroupList.size() ==1 && outerExGroupList[0].bundlelines.size() ==0){
            
            system.debug('outerExGroupList -pp-exGroupList-' + outerExGroupList[0].exGroupList.size());
            system.debug('outerExGroupList -pp-bundlelines-' + outerExGroupList[0].bundlelines.size());
            system.debug('outerExGroupList -pp-outerLines-' + outerExGroupList[0].outerLines.size());
            
            outerExGroupList[0].derivedOppTypOrEnginEquipmnt = '';
            outerExGroupList[0].outerExGroupNumber = null;
        }
        
        //Engines
        propDetail.outerExGroupEngines = outerExGroupEngines;
        
        if(outerExGroupEngines.size() == 1 && outerExGroupEngines[0].exGroupList.size() ==1 && outerExGroupEngines[0].bundlelines.size() ==0){
            
            system.debug('outerExGroupEngines -pp-exGroupList-' + outerExGroupEngines[0].exGroupList.size());
            system.debug('outerExGroupEngines -pp-bundlelines-' + outerExGroupEngines[0].bundlelines.size());
            system.debug('outerExGroupEngines -pp-outerLines-' + outerExGroupEngines[0].outerLines.size());
            
            outerExGroupEngines[0].derivedOppTypOrEnginEquipmnt = '';
            outerExGroupEngines[0].outerExGroupNumber = null;
        }
        
        //Avionics, Paint, Interior
        propDetail.outerExgroupAsSetNoMatLines = outerExgroupAsSetNoMatLines;
        
        if(outerExgroupAsSetNoMatLines.size() == 1 && outerExgroupAsSetNoMatLines[0].exGroupList.size() ==1 && outerExgroupAsSetNoMatLines[0].bundlelines.size() ==0){
            
            system.debug('outerExgroupAsSetNoMatLines -pp-exGroupList-' + outerExgroupAsSetNoMatLines[0].exGroupList.size());
            system.debug('outerExgroupAsSetNoMatLines -pp-bundlelines-' + outerExgroupAsSetNoMatLines[0].bundlelines.size());
            system.debug('outerExgroupAsSetNoMatLines -pp-outerLines-' + outerExgroupAsSetNoMatLines[0].outerLines.size());
            
            outerExgroupAsSetNoMatLines[0].derivedOppTypOrEnginEquipmnt = '';
            outerExgroupAsSetNoMatLines[0].outerExGroupNumber = null;
        }
        
        propDetail.additionalLinesOfMaterial = additionalLinesOfMaterial;
        propDetail.additionalMaterialsTotal = additionalMaterialsTotal;
        propDetail.totalOfAll = totalOfAll;
        propDetail.totalCost = totalCost;
        propDetail.totalLabor = totalLabor;
        
        return propDetail;
    }
    
    /**** Below method is used in master, child and cco **/   
    private OuterBundle makeBundlesByExGroup(List<SBQQ__QuoteLine__c> quoteLines, Integer outerExGroupNumber){
        List<string>  tablestringList = new List<string>();
        
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
                    
                    childLineList = new List<SBQQ__QuoteLine__c>();
                    bundleline.childLines = childLineList;
                    bundleMap.put(ql.id, bundleline);
                }
                else{
                    bundleline.mainLineProductName = ql.Product_Name__c; 
                    
                    bundleline.mainLine = ql;
                    bundleMap.put(ql.id, bundleline);
                }
            }
            else{
                bundleline = bundleMap.get(ql.SBQQ__RequiredBy__c);
                if(bundleline == null){
                    bundleline = new BundledLines();
                    childLineList = new List<SBQQ__QuoteLine__c>();
                    childLineList.add(ql);
                    bundleline.childLines = childLineList;
                    bundleMap.put(ql.SBQQ__RequiredBy__c, bundleline);
                    continue;
                }
                else{
                    childLineList = bundleline.childLines ;
                    childLineList.add(ql);
                    bundleline.childLines = childLineList;
                    bundleMap.put(ql.SBQQ__RequiredBy__c, bundleline);
                } 
            }
        }
        
        List<SBQQ__QuoteLine__c> additionalLinesOfBundle = new List<SBQQ__QuoteLine__c>();
        Decimal additionalMaterialsTotal = 0;
        
        Decimal totalOfAll = 0;
        Decimal totalLabor = 0;
        Decimal totalCost = 0; 
        
        for(BundledLines bl : bundleMap.values()){
            
            system.debug(' -- bl --' + bl.mainLine.Name);
            system.debug('-- bl child list - '+ bl.childLines.size());
            if(bl.childLines == null || bl.childLines.size() == 0){
                
                additionalLinesOfBundle.add(bl.mainLine);
                additionalMaterialsTotal += bl.mainLine.fxNet_Total__c;
                bundleMap.remove(bl.mainLine.id);
            }else{
                
                if(quoteSObj.SBQQ__Type__c == 'Amendment'){
                    
                    if(checkForCCO(bl)){
                        processQuoteLinesByNewRequirement(bl);
                        system.debug(' -- ' + bl.mainLine.SBQQ__Product__r.Detail_Description__c);
                        
                        totalOfAll += bl.bundleTotal;
                        totalLabor += bl.bundleLabor;
                        totalCost += bl.bundleCost;
                        
                    }else{
                        bundleMap.remove(bl.mainLine.id);
                    }
                    
                }else{
                    
                    processQuoteLinesByNewRequirement(bl);
                    system.debug(' -- ' + bl.mainLine.SBQQ__Product__r.Detail_Description__c);
                    
                    totalOfAll += bl.bundleTotal;
                    totalLabor += bl.bundleLabor;
                    totalCost += bl.bundleCost;
                    
                }             
            }            
        }
        
        bundleLinesToReturn = bundleMap.values();
        bundleLinesToReturn.sort();
        Integer bundleCounter = 0;
        for(BundledLines bl : bundleLinesToReturn ){
            
            bl.bundleLineNumber = outerExGroupNumber + '.' + ++bundleCounter;
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
        outerBundle.additionalMaterialsTotal = additionalMaterialsTotal;
        outerBundle.totalOfAll = additionalMaterialsTotal + totalOfAll;
        outerBundle.totalLabor = totalLabor;
        outerBundle.totalCost = totalCost;
        
        system.debug('---outerBundle.totalOfAll --- '+ outerBundle.totalOfAll + '>>>>>>>>>>'+ outerBundle.bundlelines);
        
        return outerBundle;    
    }
    
    /*** Below method is used for filtering bundles for changes.*/
    @TestVisible
    private boolean checkForCCO(BundledLines bundleLine){
        
        boolean addBundle = false;      
        SBQQ__QuoteLine__c mainLine = bundleLine.mainLine;
        
        if((mainLine.Specification__c != mainLine.OriginalSpecification__c ) || (mainLine.SBQQ__Quantity__c != mainLine.SBQQ__PriorQuantity__c) || !mainLine.SBQQ__Existing__c) {
            addBundle=true;
            return addBundle;           
        }
        
        if(!addBundle){            
            List<SBQQ__QuoteLine__c> childLines = bundleLine.childLines;
            for(SBQQ__QuoteLine__c ql : childLines){         
                if((ql.Specification__c != ql.OriginalSpecification__c ) || (ql.SBQQ__Quantity__c != ql.SBQQ__PriorQuantity__c) || !ql.SBQQ__Existing__c){
                    addBundle = true;
                    return addBundle;
                }         
            }            
        }
        
        return addBundle;
    }
    
    /*** Below mehtod is used to process Proposal and Executive groups by XSL-FO used in master, child and cco ***/
    private List<ExecutiveGroup> processQuoteLines(List<SBQQ__QuoteLine__c> quoteLines, Integer appendNumber){
        
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
        
        system.debug('quoteLines --'+quoteLines.size());
        
        for(SBQQ__QuoteLine__c ql : quoteLines){
            
            String exeGroupStr = ql.ExGroupFormula__c;
            String prodFamily = ql.SBQQ__ProductFamily__c;
            
            system.debug('exeGroupStr--' +exeGroupStr + '  prodFamily--' +prodFamily);
            system.debug('tempExGroup' +tempExGroup + '  tempPrdFamily -' +tempPrdFamily);
            system.debug('--exGroupMap-- ' + exGroupMap.keySet());
            
            // here the query results are in order by clause so we can take advantage to 
            // have simple logic. 
            if(exeGroupStr == tempExGroup){
                
                system.debug('First if -  ');
                
                eg = exGroupMap.get(exeGroupStr);
                if(eg != null){
                    if(prodFamily == tempPrdFamily){
                        
                        system.debug(' Second if  ');
                        
                        pfgSet = eg.productFamilyGroupSet;
                        pfg = checkProductFamilyPresent(eg, prodFamily);
                        
                        if(pfg != null){
                            
                            system.debug(' 3 if  ');
                            
                            qlwList = pfg.quoteLinesByFamilyGroupList;
                            
                            QuoteLineWrapper qlw = new QuoteLineWrapper();
                            qlw.quoteLine = ql;
                            qlw.quoteLineNumberToDisplay = appendNumber + '.' + exGroupCount + '.' + fgGroupCount + '.' + (++qlCount) ;
                            qlwList.add(qlw);
                            if(ql.fxNet_Total__c != null){
                                pfg.familyGroupSubTotal += ql.fxNet_Total__c;
                                eg.exGroupTotal += ql.fxNet_Total__c;
                            }
                            
                            pfg.quoteLinesByFamilyGroupList = qlwList;
                            eg.productFamilyGroupSet = pfgSet;
                            
                            exGroupMap.put(exeGroupStr,eg);
                            
                            continue;
                            
                        }
                    }
                    else{
                        
                        system.debug(' Second if  else');
                        system.debug(' --eg -- '+eg);
                        // Not found prod family
                        qlCount = 0;
                        pfgSet =eg.productFamilyGroupSet;
                        
                        
                        pfg = new ProductFamilyGroup();
                        pfg.productFamilyName = prodFamily;
                        pfg.familyGroupSubTotal = ql.fxNet_Total__c;
                        pfg.productFamilyNumber = appendNumber+'.'+ exGroupCount + '.' + (++fgGroupCount);
                        
                        eg.exGroupTotal  += ql.fxNet_Total__c;
                        
                        qlwList = new List<QuoteLineWrapper>();
                        QuoteLineWrapper qlw = new QuoteLineWrapper();
                        qlw.quoteLine = ql;
                        qlw.quoteLineNumberToDisplay = appendNumber + '.'+ exGroupCount + '.' + fgGroupCount + '.' + (++qlCount);
                        qlwList.add(qlw);
                        
                        pfg.quoteLinesByFamilyGroupList = qlwList;
                        system.debug('--here 2--'+qlwList.size());
                        
                        pfgSet.add(pfg);
                        
                        system.debug('--here --'+pfgSet.size());
                        
                        eg.productFamilyGroupSet = pfgSet;
                        exGroupMap.put(exeGroupStr,eg);
                        
                        tempPrdFamily = prodFamily;
                        
                        continue;
                        
                    }
                }
            }
            else{
                
                system.debug(' last if  else');
                
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
                pfg.familyGroupSubTotal = ql.fxNet_Total__c;
                
                eg.exGroupTotal  = ql.fxNet_Total__c;
                
                qlwList = new List<QuoteLineWrapper>();
                QuoteLineWrapper qlw = new QuoteLineWrapper();
                qlw.quoteLine = ql;
                qlw.quoteLineNumberToDisplay = appendNumber + '.'+ exGroupCount + '.' + fgGroupCount + '.' + (++qlCount);
                qlwList.add(qlw);
                
                pfg.quoteLinesByFamilyGroupList = qlwList;
                
                pfgSet.add(pfg);
                eg.productFamilyGroupSet = pfgSet;
                
                exGroupMap.put(exeGroupStr,eg);
                
                tempExGroup = exeGroupStr;
                tempPrdFamily = prodFamily;
                
            }
            
        }
        
        system.debug('--end --' +exGroupMap.keySet());
        
        return exGroupMap.values();   
    }
    
    /*** Below method is used to check whether product family group is present or not If Not present then it returns null else the obj. Used in master ,child and cco ***/
    @TestVisible
    private void processQuoteLinesByNewRequirement(BundledLines bl){
        
        Map<String, ExecutiveGroup> exGroupMap = new Map<String, ExecutiveGroup>();
        List<String> TableValueList = new  List<String>();
        
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
        String mainLineProductGroupName = bl.mainLineProductGroupName;
        
        SBQQ__QuoteLine__c mainLine = bl.mainLine;
        
        if(mainLine!= null && mainLine.Specification__c != null && !String.isEmpty(mainLine.Specification__c)){
            bl.mainLineSpecFromProduct = bl.mainLine.Specification__c.trim().stripHtmlTags();
        }else{
            bl.mainLineSpecFromProduct = '';
        }
        
        List<SBQQ__QuoteLine__c> childLines  = bl.childLines;
        
        Decimal bundleTotal = 0;
        
        Decimal bundleLabor = 0;
        Decimal bundleCost = 0;
        
        Decimal bundleTotalForExcludeBundle = 0;
        
        BundleMaterialGroup materialGroup = null;
        
        List<BundleLabourGroup> labourGroupList = null;
        
        List<SBQQ__QuoteLine__c> materialLinesOfBundle = new List<SBQQ__QuoteLine__c>();
        List<SBQQ__QuoteLine__c> laborLinesOfBundle = new List<SBQQ__QuoteLine__c>();
        
        Decimal totalOfMaterials = 0;
        Decimal totalOfMaterialsForExcludeBundle = 0;
        String labourType = '';
        Decimal labourTypeSubTotal = 0;
        Decimal labourTypeSubTotalForExcludeBundle = 0;
        String materialWarrentyType = '';
        boolean displayMaterialWarrenty = false; // this controls whether amount should be displayed or warrenty
        boolean displayMaterials = true; // this controls whether verbiage should be displayed or not
        
        for(SBQQ__QuoteLine__c ql : childLines){
            
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
            TableValueList.add(ql.Table_Value__c);
            totalOfMaterials += ql.fxNet_Total__c;
            totalOfMaterialsForExcludeBundle += ql.fxNet_Total__c;
            
            if(!ql.Show_on_Customer_Quote__c)
                bundleTotal +=  ql.fxNet_Total__c;
            
            bundleTotalForExcludeBundle += ql.fxNet_Total__c;
            
            bundleCost += ql.Net_Cost__c;
            
            if(!ql.ExcludeFromExecutiveSummary__c && ql.Labor__c)
                bundleLabor += ql.SBQQ__Quantity__c;
            
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
        
        if(materialWarrentyType != null && materialWarrentyType.trim().length() >0 &&
           isWarrentyForAllMatLines){
               
               displayMaterialWarrenty = true;
               
           }else{
               
               displayMaterialWarrenty = false;
               
           }
        
        if(materialGroup.materialLinesOfBundle.size() == 0 || materialGroup.materialLinesOfBundle.isEmpty()){
            displayMaterials = false;
        }else{
            displayMaterials = true;
        }
        
        materialGroup.displayMaterialWarrenty = displayMaterialWarrenty;
        
        bl.materialGroup = materialGroup;
        bl.displayMaterials = displayMaterials; 
        
        Decimal labourGroupTotal = 0;
        Decimal labourGroupTotalForExcludeBundle =0;
        String labourWarrentyType = '';
        boolean displayLabourWarrenty = false; //This controls whether amount or warrenty to be displayed
        boolean displayLabor = true; // This controls whether this should display verbiage
        
        if(laborLinesOfBundle.size() == 0 || laborLinesOfBundle.isEmpty()){
            displayLabor = false;
        }else{
            displayLabor =true;
        }
        
        Integer countWarrentyLaborProducts = 0;
        Map<String,BundleLabourGroup>  laborMap = new Map<String, BundleLabourGroup>();
        for(SBQQ__QuoteLine__c ql : laborLinesOfBundle){
            
            BundleLabourGroup blg = laborMap.get(ql.Family_Type__c);
            if(blg != null){
                blg.labourTypeSubTotal += ql.fxNet_Total__c;
                blg.labourTypeSubTotalForExcludeBundle += ql.fxNet_Total__c;
            } 
            else{
                blg = new BundleLabourGroup();
                blg.labourType = ql.Family_Type__c;
                blg.labourTypeSubTotal = ql.fxNet_Total__c;
                blg.labourTypeSubTotalForExcludeBundle = ql.fxNet_Total__c;
            }
            
            laborMap.put(ql.Family_Type__c, blg);
            
            if(!ql.Show_on_Customer_Quote__c)
                bundleTotal +=  ql.fxNet_Total__c;
            
            bundleTotalForExcludeBundle += ql.fxNet_Total__c;
            labourGroupTotal +=  ql.fxNet_Total__c;
            labourGroupTotalForExcludeBundle += ql.fxNet_Total__c;
            
            bundleCost += ql.Net_Cost__c;
            
            if(!ql.ExcludeFromExecutiveSummary__c && ql.Labor__c)
                bundleLabor += ql.SBQQ__Quantity__c;
            
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
        
        bl.bundleCost = bundleCost;
        bl.bundleLabor = bundleLabor;
        
        bl.labourGroupTotal = labourGroupTotal;
        bl.labourGroupTotalForExcludeBundle = labourGroupTotalForExcludeBundle;
        bl.labourWarrentyType = labourWarrentyType;
        bl.displayLabor = displayLabor;
        
        if(labourWarrentyType != null && labourWarrentyType.trim().length() >0 &&
           isWarrentyForAllLabourProducts){
               bl.displayLabourWarrenty = true;
           }else{
               bl.displayLabourWarrenty = false;
           }
        
        // additional logic to handle the exclude for warrenty if both are in warrenty
        if(bl.displayLabourWarrenty && displayMaterialWarrenty){
            bl.bundleTotalForExcludeBundle = 0;
        }     
    }
    
    /**** Below method is used to check whether product family present, Used in master, child and cco **/
    private ProductFamilyGroup checkProductFamilyPresent(ExecutiveGroup eg,String familyGroupToFind){
        
        List<ProductFamilyGroup> pfgSet = eg.productFamilyGroupSet;
        
        if(pfgSet == null || pfgSet.isEmpty()){
            return null;
        }
        
        //boolean found = false;
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
        public Decimal totalLabor {get; set;} 
        public Decimal totalCost {get; set;}                        
    }
    
    public class OuterBundle{
        public List<BundledLines> bundlelines {get; set;}
        public Map<String, Decimal> bl_esgMap {get;set;}
        public Map<String, Map<String, Decimal>> bl_esgCategoryMap {get;set;}
        public Map<String, Decimal> bl_esgMapSort {get;set;}
        public Map<Decimal, Map<String, Map<String, Decimal>>> bl_esgMapSortFinal {get;set;}
        public List<SBQQ__QuoteLine__c> additionalLinesOfMaterial {get;set;}
        public Decimal additionalMaterialsTotal {get; set;}
        public Decimal totalOfAll {get; set;}
        public Decimal totalLabor {get; set;} 
        public Decimal totalCost {get; set;}                 
    }
    
    public  class BundledLines implements Comparable{    
        public String bundleLineNumber {get; set;}
        public List<String> TableValue {get;set;}
        public String mainLineProductName {get;set;}
        public String mainLineProductGroupName {get;set;}
        public String mainLineSpecFromProduct {get;set;}
        public SBQQ__QuoteLine__c mainLine {get;set;}
        public List<SBQQ__QuoteLine__c> childLines {get;set;}
        public Decimal bundleTotal {get; set;}
        public Decimal bundleTotalForExcludeBundle {get; set;}
        public Decimal bundleLabor {get;set;}
        public Decimal bundleCost {get;set;}
        public BundleMaterialGroup materialGroup {get; set;}
        public List<BundleLabourGroup> labourGroupList {get; set;}
        public Decimal labourGroupTotal {get;set;}
        public Decimal labourGroupTotalForExcludeBundle {get;set;}
        public String labourWarrentyType {get;set;}
        public Boolean displayLabourWarrenty {get;set;}
        public Boolean displayLabor {get;set;}
        public Boolean displayMaterials {get;set;}
        
        public Map<String, Decimal> esgSell {get;set;}        
        public Map<String, Decimal> esgLabor {get;set;}
        public Map<String, Decimal> esgCost {get;set;}
        
        public Integer compareTo(Object compare) {           
            
            BundledLines compareBundle = (BundledLines)compare;
            
            if (this.mainLine.SBQQ__Number__c == compareBundle.mainLine.SBQQ__Number__c) return 0;
            
            if (this.mainLine.SBQQ__Number__c > compareBundle.mainLine.SBQQ__Number__c) return 1;
            
            return -1;           
        }     
    }
    
    public class BundleMaterialGroup {        
        public List<SBQQ__QuoteLine__c> materialLinesOfBundle {get;set;}
        public Decimal totalOfMaterials {get;set;}
        public Boolean displayMaterialWarrenty {get;set;}
        public String materialWarrentyType {get;set;}
        public Decimal totalOfMaterialsForExcludeBundle {get;set;}       
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
        public Map<String, Decimal> bl_esgMap {get;set;}
        public Map<String, Decimal> bl_esgMapSort {get;set;}
        public Map<String, Map<String, Decimal>> bl_esgCategoryMap {get;set;}
        public Map<Decimal, Map<String, Map<String, Decimal>>> bl_esgMapSortFinal {get;set;}
        public List<BundledLines> bundlelines {get; set;}
        public List<SBQQ__QuoteLine__c> additionalLinesOfMaterial {get;set;}
        public Decimal additionalMaterialsTotal {get; set;}
        public Decimal totalOfAll {get; set;}
        public Decimal totalLabor {get; set;}
        public Decimal totalCost {get; set;}        
        
        public Integer compareTo(Object compare) {
            
            OuterExecutiveGroup compareOuterExGroup = (OuterExecutiveGroup)compare;
            
            if (this.derivedOppTypOrEnginEquipmnt == compareOuterExGroup.derivedOppTypOrEnginEquipmnt) return 0;
            
            if (this.derivedOppTypOrEnginEquipmnt > compareOuterExGroup.derivedOppTypOrEnginEquipmnt) return 1;
            
            return -1;       
            
        }       
    }
    
    // Below class is the wrapper for Ex group
    public class ExecutiveGroup{      
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