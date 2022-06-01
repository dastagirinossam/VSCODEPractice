public with sharing class tsmQuoteRoutingController {
    
    @AuraEnabled
    public static List<String> getPicklistvalues(){
        List<String> optionlist = new List<String>();       
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get('Facility__c').getDescribe().fields.getMap();        
        List<Schema.PicklistEntry> picklistValues = field_map.get('Credit_Analyst__c').getDescribe().getPickListValues();       
        
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getValue());
        }
        
        return optionlist;
    }
    
    @AuraEnabled
    public static User getQuoteCreditAnalyst(String so) {
        return [Select id, Name, Email from User where Credit_Analyst_State_Account__c includes (:so)];
    }
    
    @AuraEnabled
    public static User getMST(String lead){
        return [Select id, Name, Email from User where MST_Team_Leader__c =: lead];
    }
    
    @AuraEnabled
    public static wrapperClass getMargins(String quoteId){
        wrapperClass wc = new wrapperClass();
        
        Map<String, Decimal> ec_per_type = new Map<String, Decimal>();
        Map<String, Decimal> esa_per_type = new Map<String, Decimal>();
        Map<String, Decimal> qdt_per_type = new Map<String, Decimal>();
        Map<String, Decimal> emh_per_type = new Map<String, Decimal>();
        
        List<String> Types = new List<String>();
        SBQQ__Quote__c q = [Select Id, 
                            SBQQ__Opportunity2__c,
                            Downtime_Days__c,
                            SBQQ__Primary__c, 
                            Facility1__c,
                            SBQQ__NetAmount__c,
                            Total_Margin__c
                            from SBQQ__Quote__c where Id =: quoteId];
        
        String oppId = q.SBQQ__Opportunity2__c;
        
        Opportunity o = [SELECT Type,
                         OwnerId,
                         Owner.Email,
                         Owner.ManagerId,
                         Owner.Manager.Email,
                         Competitor__c, 
                         Quoted_Downtime__c,    
                         InputDate__c,
                         Facility__c, 
                         Master_Opportunity__c, 
                         Back_Sheet_Category__c,
                         Trade_Compliance__c,
                         Trade_Compliance_Approval_Status__c,
                         RSM__c,
                         Estimated_Sell_Amount__c,
                         Estimated_Margin_Percent__c,
                         EstimatedHours__c,
                         Amount FROM Opportunity where Id =: q.SBQQ__Opportunity2__c];
        
        //Get Delegate Here
        Map<Id, String> rsdMap = new Map<Id, String>();
        rsdMap.put(o.Owner.ManagerId, o.Owner.Manager.Email);
        wc.oppRSD = rsdMap;
        
        
        //Get Delegate here
        Map<Id, String> ownerMap = new Map<Id, String>();
        ownerMap.put(o.OwnerId, o.Owner.Email);
        wc.oppOwner = ownerMap;  
        
        wc.Facility = q.Facility1__c;
        wc.quoteId = q.Id;
        wc.Competitor = o.Competitor__c;
        wc.Quoted_Downtime = q.Downtime_Days__c;        
        wc.InputDate = o.InputDate__c;
        
        Map<String, Facility__c> facMap = new Map<String, Facility__c>();
        for(Facility__c f :[Select Id, 
                            Name, 
                            Airframe_Director__r.Email, 
                            Airframe_Margin_Threshold_President__c, 
                            Airframe_Margin_Threshold_RSD__c, 
                            Airframe_Margin_Threshold_RSM__c, 
                            Airframe_Margin_Threshold_VP_Sales__c, 
                            Airframe_Master_Scheduler__r.Email, 
                            Airframe_Plan_Margin__c, 
                            Anti_Corruption__r.Id, 
                            Anti_Corruption__r.Email, 
                            MST__r.Id,
                            MST__r.Email,
                            APU_Margin_Threshold_President__c, 
                            APU_Margin_Threshold_RSD__c, 
                            APU_Margin_Threshold_RSM__c, 
                            APU_Margin_Threshold_VP_Sales__c, 
                            APU_Plan_Margin__c, 
                            Avionics_Margin_Threshold_President__c, 
                            Avionics_Margin_Threshold_RSD__c, 
                            Avionics_Margin_Threshold_RSM__c, 
                            Avionics_Margin_Threshold_VP_Sales__c, 
                            Avionics_Master_Scheduler__r.Email, 
                            Avionics_Plan_Margin__c, 
                            CFE_Margin_Threshold_President__c, 
                            CFE_Margin_Threshold_RSD__c, 
                            CFE_Margin_Threshold_RSM__c, 
                            CFE_Margin_Threshold_VP_Sales__c, 
                            CFE_Plan_Margin__c, 
                            Credit_Analyst__c, 
                            Director_of_Quoting_Sales__r.Email, 
                            Engine_Director__r.Email, 
                            Engine_Master_Scheduler__r.Email, 
                            Flatrate_Material_Labor__r.Id, 
                            Flatrate_Material_Labor__r.Email, 
                            GM__r.Email, 
                            Government__r.Id, 
                            Government__r.Email, 
                            HTF_Margin_Threshold_President__c, 
                            HTF_Margin_Threshold_RSD__c, 
                            HTF_Margin_Threshold_RSM__c, 
                            HTF_Margin_Threshold_VP_Sales__c, 
                            HTF_Plan_Marign__c, 
                            Interior_Margin_Threshold_President__c, 
                            Interior_Margin_Threshold_RSD__c, 
                            Interior_Margin_Threshold_RSM__c, 
                            Interior_Margin_Threshold_VP_Sales__c, 
                            Interior_Plan_Margin__c, 
                            International_RSD__r.Email, 
                            Legal__r.Id, 
                            Legal__r.Email,
                            Other_Margin_Threshold_President__c, 
                            Other_Margin_Threshold_RSD__c, 
                            Other_Margin_Threshold_RSM__c, 
                            Other_Margin_Threshold_VP_Sales__c, 
                            Other_Plan_Margin__c, 
                            Paint_Margin_Threshold_President__c, 
                            Paint_Margin_Threshold_RSD__c, 
                            Paint_Margin_Threshold_RSM__c, 
                            Paint_Margin_Threshold_VP_Sales__c, 
                            Paint_Plan_Margin__c,
                            President__r.Id,
                            President__r.Email, 
                            TFE_Margin_Threshold_President__c, 
                            TFE_Margin_Threshold_RSD__c, 
                            TFE_Margin_Threshold_RSM__c, 
                            TFE_Margin_Threshold_VP_Sales__c, 
                            TFE_Plan_Margin__c, 
                            Trade_Compliance__r.Id, 
                            Trade_Compliance__r.Email, 
                            VP_of_Finance__r.Email,
                            VP_Sales__r.Id,
                            VP_Sales__r.Email from Facility__c where Name =: o.Facility__c]){
                                facMap.put(f.Name, f);
                            }
        
        //facility Staff
        wc.vpgm = facMap.get(o.Facility__c).GM__r.Email;
        
        //Pres Map
        Map<Id, String> presMap = new Map<Id, String>();
        presMap.put(facMap.get(o.Facility__c).President__r.Id, facMap.get(o.Facility__c).President__r.Email);
        wc.president = presMap;
        
        //VP Map
        Map<Id, String> vpMap = new Map<Id, String>();
        vpMap.put(facMap.get(o.Facility__c).VP_Sales__r.Id, facMap.get(o.Facility__c).VP_Sales__r.Email);
        wc.vp = vpMap;
        
        //Trade Compliance Map
        Map<Id, String> tcMap = new Map<Id, String>();    
        tcMap.put(facMap.get(o.Facility__c).Trade_Compliance__r.Id, facMap.get(o.Facility__c).Trade_Compliance__r.Email);
        wc.tradecompliance = tcMap;
        
        //Trade Complaince Approval
        Boolean tcReq = false;
        if(o.Trade_Compliance_Approval_Status__c != 'Approved')
            wc.tcReq = true;
        
        //Anti Corruption Map
        Map<Id, String> acMap = new Map<Id, String>();    
        acMap.put(facMap.get(o.Facility__c).Anti_Corruption__r.Id, facMap.get(o.Facility__c).Anti_Corruption__r.Email);
        wc.antiCorruption = acMap;     
        
        //Government Map
        Map<Id, String> govMap = new Map<Id, String>();    
        govMap.put(facMap.get(o.Facility__c).Government__r.Id, facMap.get(o.Facility__c).Government__r.Email);
        wc.government = govMap;     
        
        //Legal Map
        Map<Id, String> legalMap = new Map<Id, String>();    
        legalMap.put(facMap.get(o.Facility__c).Legal__r.Id, facMap.get(o.Facility__c).Legal__r.Email);
        wc.legal = legalMap;
        
        //FRML Map
        Map<Id, String> frMatLabMap = new Map<Id, String>();    
        frMatLabMap.put(facMap.get(o.Facility__c).Flatrate_Material_Labor__r.Id, facMap.get(o.Facility__c).Flatrate_Material_Labor__r.Email);
        wc.frMatLab = frMatLabMap;
        
        //MST Map
        Map<Id, String> mstMap = new Map<Id, String>();
        mstMap.put(facMap.get(o.Facility__c).MST__r.Id, facMap.get(o.Facility__c).MST__r.Email);
        wc.mstApprover = mstMap;        
        
        wc.vpf = facMap.get(o.Facility__c).VP_of_Finance__r.Email;
        wc.doqs = facMap.get(o.Facility__c).Director_of_Quoting_Sales__r.Email;
        
        wc.airframeShopDirector = facMap.get(o.Facility__c).Airframe_Director__r.Email;
        wc.engineShopDirector = facMap.get(o.Facility__c).Engine_Director__r.Email;
        
        //Airframe Map
        Map<Id, String> airframeSchedulerMap = new Map<Id, String>();
        airframeSchedulerMap.put(facMap.get(o.Facility__c).Airframe_Master_Scheduler__r.Id, facMap.get(o.Facility__c).Airframe_Master_Scheduler__r.Email);
        wc.airframeScheduler = airframeSchedulerMap;
        
        //Avionics Map
        Map<Id, String> avionicsSchedulerMap = new Map<Id, String>();
        avionicsSchedulerMap.put(facMap.get(o.Facility__c).Avionics_Master_Scheduler__r.Id, facMap.get(o.Facility__c).Avionics_Master_Scheduler__r.Email);
        wc.avionicsScheduler = avionicsSchedulerMap; 
        
        //Engine Map
        Map<Id, String> engineSchedulerMap = new Map<Id, String>();
        engineSchedulerMap.put(facMap.get(o.Facility__c).Engine_Master_Scheduler__r.Id, facMap.get(o.Facility__c).Engine_Master_Scheduler__r.Email);
        wc.engineScheduler = engineSchedulerMap;
        
        if(!o.Master_Opportunity__c){           
            wc.Amount = o.Amount;
            
            for(AggregateResult ar : [SELECT Type, Sum(EstimatedHours__c) emh, SUM(Estimated_Cost__c) ec, SUM(Amount) esa FROM Opportunity where Id =: oppId GROUP BY Type]){
                system.debug('>>>'+(Decimal)ar.get('esa'));
                ec_per_type.put((String)ar.get('Type'), (Decimal)ar.get('ec'));
                esa_per_type.put((String)ar.get('Type'), (Decimal)ar.get('esa'));
                emh_per_type.put((String)ar.get('Type'), (Decimal)ar.get('emh'));                
            }
        }else{
            wc.Amount = 0; 
            for(AggregateResult ar : [SELECT Type, Sum(EstimatedHours__c) emh, SUM(Estimated_Cost__c) ec, SUM(Amount) esa FROM Opportunity where MasterOpportunitylookup__c =: oppId GROUP BY Type]){
                ec_per_type.put((String)ar.get('Type'), (Decimal)ar.get('ec'));
                esa_per_type.put((String)ar.get('Type'), (Decimal)ar.get('esa'));
                emh_per_type.put((String)ar.get('Type'), (Decimal)ar.get('emh'));
                wc.Amount += (Decimal)ar.get('esa');
            }            
        }
        
        system.debug('Amount: ' + wc.Amount);
        
        Decimal AirframeCost = 0;
        Decimal AirframeSellAmount= 0;
        Decimal getAirframeMargin = 0;
        
        Decimal HtfCost = 0;
        Decimal HtfSellAmount = 0;
        Decimal getHtfMargin = 0;
        
        Decimal Tfe731Cost = 0;
        Decimal Tfe731SellAmount = 0;
        Decimal getTfeMargin = 0;
        
        Decimal Cfe738Cost = 0;
        Decimal Cfe738SellAmount = 0;
        Decimal getCfeMargin = 0;
        
        Decimal ApuCost = 0;
        Decimal ApuSellAmount = 0;
        Decimal getApuMargin = 0;
        
        Decimal AvionicsCost = 0;
        Decimal AvionicsSellAmount= 0;
        Decimal getAvionicsMargin = 0;
        
        Decimal InteriorCost = 0;
        Decimal InteriorSellAmount = 0;
        Decimal getInteriorMargin = 0;
        
        Decimal PaintCost = 0;
        Decimal PaintSellAmount = 0;
        Decimal getPaintMargin = 0;
        
        Decimal OtherCost = 0;
        Decimal OtherSellAmount = 0;
        Decimal getOtherMargin = 0;
        
        Decimal EstCost = 0;
        Decimal EstSellAmount = 0;
        Decimal EstManHrs = 0;
        Decimal EstDownTime = 0;
        
        Boolean OtherType = false;
        
        for(String s : esa_per_type.keyset()){
            if(s == 'Airframe'){      
                if(ec_per_type.get('Airframe') != null)
                    EstCost += ec_per_type.get('Airframe');
                
                if(esa_per_type.get('Airframe') != null)
                    EstSellAmount += esa_per_type.get('Airframe');
                
                if(ec_per_type.get('Airframe') != null)
                    AirframeCost += ec_per_type.get('Airframe');                              
                
                if(esa_per_type.get('Airframe') != null)
                    AirframeSellAmount += esa_per_type.get('Airframe'); 
                
                Types.add('Airframe');
                
                if(emh_per_type.get('Airframe') != null)
                    EstManHrs += emh_per_type.get('Airframe');
                
            }else if(s == 'Aircraft Purchase'){  
                if(ec_per_type.get('Aircraft Purchase') != null)
                    EstCost += ec_per_type.get('Aircraft Purchase');
                
                if(esa_per_type.get('Aircraft Purchase') != null)
                    EstSellAmount += esa_per_type.get('Aircraft Purchase');
                
                if(ec_per_type.get('Aircraft Purchase') != null)
                    AirframeCost += ec_per_type.get('Aircraft Purchase');
                
                if(esa_per_type.get('Aircraft Purchase') != null)
                    AirframeSellAmount += esa_per_type.get('Aircraft Purchase'); 
                
                Types.add('Airframe');
                
                if(emh_per_type.get('Aircraft Purchase') != null)
                    EstManHrs += emh_per_type.get('Aircraft Purchase');
                
            }else if(s == 'HTF'){
                if(ec_per_type.get('HTF') != null)
                    EstCost += ec_per_type.get('HTF');
                
                if(esa_per_type.get('HTF') != null)
                    EstSellAmount += esa_per_type.get('HTF');
                
                if(ec_per_type.get('HTF') != null)
                    HtfCost += ec_per_type.get('HTF');
                
                if(esa_per_type.get('HTF') != null)
                    HtfSellAmount += esa_per_type.get('HTF');
                
                Types.add('HTF');
                
                if(emh_per_type.get('HTF') != null)
                    EstManHrs += emh_per_type.get('HTF');
                
            }else if(s == 'TFE731'){
                if(ec_per_type.get('TFE731') != null)
                    EstCost += ec_per_type.get('TFE731');
                
                if(esa_per_type.get('TFE731') != null)
                    EstSellAmount += esa_per_type.get('TFE731');
                
                if(ec_per_type.get('TFE731') != null)
                    Tfe731Cost += ec_per_type.get('TFE731');
                
                if(esa_per_type.get('TFE731') != null)
                    Tfe731SellAmount += esa_per_type.get('TFE731');
                
                Types.add('TFE731');
                
                if(emh_per_type.get('TFE731') != null)
                    EstManHrs += emh_per_type.get('TFE731');
                
            }else if(s == 'CFE738'){
                if(ec_per_type.get('CFE738') != null)
                    EstCost += ec_per_type.get('CFE738');
                
                if(esa_per_type.get('CFE738') != null)
                    EstSellAmount += esa_per_type.get('CFE738');
                
                if(ec_per_type.get('CFE738') != null)
                    Cfe738Cost += ec_per_type.get('CFE738');
                
                if(esa_per_type.get('CFE738') != null)
                    Cfe738SellAmount += esa_per_type.get('CFE738'); 
                Types.add('CFE738');
                
                if(emh_per_type.get('CFE738') != null)
                    EstManHrs += emh_per_type.get('CFE738');
                
            }else if(s == 'APU'){
                if(ec_per_type.get('APU') != null)
                    EstCost += ec_per_type.get('APU');
                
                if(esa_per_type.get('APU') != null)
                    EstSellAmount += esa_per_type.get('APU');
                
                if(ec_per_type.get('APU') != null)
                    ApuCost += ec_per_type.get('APU');
                
                if(esa_per_type.get('APU') != null)
                    ApuSellAmount += esa_per_type.get('APU');
                
                Types.add('APU'); 
                
                if(emh_per_type.get('APU') != null)
                    EstManHrs += emh_per_type.get('APU');
                
            }else if(s == 'Avionics'){
                if(ec_per_type.get('Avionics') != null)
                    EstCost += ec_per_type.get('Avionics');
                
                if(esa_per_type.get('Avionics') != null)
                    EstSellAmount += esa_per_type.get('Avionics');
                
                if(ec_per_type.get('Avionics') != null)
                    AvionicsCost += ec_per_type.get('Avionics');
                
                if(esa_per_type.get('Avionics') != null)
                    AvionicsSellAmount += esa_per_type.get('Avionics');
                
                Types.add('Avionics');
                
                if(emh_per_type.get('Avionics') != null)
                    EstManHrs += emh_per_type.get('Avionics');
                
            }else if(s == 'Interior'){
                if(ec_per_type.get('Interior') != null)
                    EstCost += ec_per_type.get('Interior');
                
                if(esa_per_type.get('Interior') != null)
                    EstSellAmount += esa_per_type.get('Interior');
                
                if(ec_per_type.get('Interior') != null)
                    InteriorCost += ec_per_type.get('Interior');
                
                if(esa_per_type.get('Interior') != null)
                    InteriorSellAmount += esa_per_type.get('Interior');
                
                Types.add('Interior');
                
                if(emh_per_type.get('Interior') != null)
                    EstManHrs += emh_per_type.get('Interior');
                
            }else if(s == 'Paint'){  
                if(ec_per_type.get('Paint') != null)
                    EstCost += ec_per_type.get('Paint');
                
                if(esa_per_type.get('Paint') != null)
                    EstSellAmount += esa_per_type.get('Paint');
                
                if(ec_per_type.get('Paint') != null)
                    PaintCost += ec_per_type.get('Paint');
                
                if(esa_per_type.get('Paint') != null)
                    PaintSellAmount += esa_per_type.get('Paint');
                
                Types.add('Paint');
                
                if(emh_per_type.get('Paint') != null)
                    EstManHrs += emh_per_type.get('Paint');
                
            }else{
                if(ec_per_type.get(s) != null)
                    EstCost += ec_per_type.get(s);
                
                if(esa_per_type.get(s) != null)
                    EstSellAmount += esa_per_type.get(s);
                
                Types.add('Other');
                
                if(ec_per_type.get(s) != null)
                    OtherCost += ec_per_type.get(s);
                
                if(esa_per_type.get(s) != null)
                    OtherSellAmount += esa_per_type.get(s);
                
                if(!OtherType)
                    OtherType = true;
                
                if(emh_per_type.get(s) != null)
                    EstManHrs += emh_per_type.get(s);
            }
        }
        
        wc.ExpectedRevenue = q.SBQQ__NetAmount__c;
        wc.EstimatedMarginPercent = q.Total_Margin__c;
        wc.EstimatedHours = EstManHrs;
        
        if(esa_per_type.get('TFE731') != null){
            if(Tfe731SellAmount != 0){
                getTfeMargin = ((Tfe731SellAmount - Tfe731Cost)/Tfe731SellAmount);
            }else{
                getTfeMargin = 0;
            }
            
            tfeApprover(getTfeMargin, wc, facMap);
        }
        
        if(esa_per_type.get('CFE738') != null){
            if(Cfe738SellAmount != 0){
                getCfeMargin = ((Cfe738SellAmount - Cfe738Cost)/Cfe738SellAmount);
            }else{
                getCfeMargin = 0;
            }
            
            cfeApprover(getCfeMargin, wc, facMap);
        }
        
        if(esa_per_type.get('HTF') != null){
            if(HtfSellAmount != 0){
                getHtfMargin = ((HtfSellAmount - HtfCost)/HtfSellAmount);
            }else{
                getHtfMargin = 0;
            }
            
            htfApprover(getHtfMargin, wc, facMap);
        }
        
        if(esa_per_type.get('Airframe') != null){
            if(AirframeSellAmount != 0){
                getAirframeMargin = ((AirframeSellAmount - AirframeCost)/AirframeSellAmount);
            }else{
                getAirframeMargin = 0;
            }
            
            airframeApprover(getAirframeMargin, wc, facMap);
        }
        
        if(esa_per_type.get('Aircraft Purchase') != null){
            if(AirframeSellAmount != 0){
                getAirframeMargin = ((AirframeSellAmount - AirframeCost)/AirframeSellAmount);
            }else{
                getAirframeMargin = 0;
            }
            
            airframeApprover(getAirframeMargin, wc, facMap);
        }
        
        if(esa_per_type.get('APU') != null){
            if(ApuSellAmount != 0){
                getApuMargin = ((ApuSellAmount - ApuCost)/ApuSellAmount);
            }else{
                getApuMargin = 0;
            }
            
            apuApprover(getApuMargin, wc, facMap);
        }
        
        if(esa_per_type.get('Avionics') != null){
            if(AvionicsSellAmount != 0){
                getAvionicsMargin = ((AvionicsSellAmount - AvionicsCost)/AvionicsSellAmount);
            }else{
                getAvionicsMargin = 0; 
            }
            
            avionicsApprover(getAvionicsMargin, wc, facMap);
        }
        
        if(esa_per_type.get('Interior') != null){
            if(InteriorSellAmount != 0){
                getInteriorMargin = ((InteriorSellAmount - InteriorCost)/InteriorSellAmount);
            }else{
                getInteriorMargin = 0; 
            }
            interiorApprover(getInteriorMargin, wc, facMap);
        }
        
        if(esa_per_type.get('Paint') != null){
            if(PaintSellAmount != 0){
                getPaintMargin = ((PaintSellAmount - PaintCost)/PaintSellAmount);
            }else{
                getPaintMargin = 0; 
            }
            paintApprover(getPaintMargin, wc, facMap);
        }
        
        if(OtherType){
            if(OtherSellAmount != 0){
                getOtherMargin = ((OtherSellAmount - OtherCost)/OtherSellAmount);
            }else{
                getOtherMargin = 0;
            }
            otherApprover(getOtherMargin, wc, facMap);
        }
        
        if(Types.Size() > 0){
            String queryString = 'Select Email from User where Product_Directors__c Includes (';
            List<User> directors ;
            for(String includeValue : Types){
                system.debug(includeValue);
                queryString += '\'' + includeValue + '\',';
            }
            
            queryString = queryString.removeEnd(',') +')';
            system.debug('Query String: ' + queryString);
            directors  = (List<User>)Database.query(queryString);  
            
            wc.Directors = directors; 
        }
        
        wc.tfeMargin = getTfeMargin.setScale(3);
        wc.cfeMargin = getCfeMargin.setScale(3);
        wc.htfMargin = getHtfMargin.setScale(3);
        wc.apuMargin = getApuMargin.setScale(3);
        wc.airframeMargin = getAirframeMargin.setScale(3);
        wc.avionicsMargin = getAvionicsMargin.setScale(3);
        wc.interiorMargin = getInteriorMargin.setScale(3);
        wc.paintMargin = getPaintMargin.setScale(3);
        wc.otherMargin = getOtherMargin.setScale(3);
        
        return wc;
    }
    
    @AuraEnabled
    public static void tfeApprover(Decimal tfeQuoteMargin, wrapperClass wc, Map<String, Facility__c> facMap){ 
        
        if((tfeQuoteMargin * 100) >= (facMap.get(wc.Facility).TFE_Plan_Margin__c)){
            wc.tfeApprover = wc.oppOwner;
        }else if(((((tfeQuoteMargin * 100)/facMap.get(wc.Facility).TFE_Plan_Margin__c) * 100) >= facMap.get(wc.Facility).TFE_Margin_Threshold_RSD__c) && ((tfeQuoteMargin * 100 ) < facMap.get(wc.Facility).TFE_Plan_Margin__c)){
            wc.tfeApprover = wc.oppRSD;
        }else if((((tfeQuoteMargin * 100)/facMap.get(wc.Facility).TFE_Plan_Margin__c) * 100) < facMap.get(wc.Facility).TFE_Margin_Threshold_VP_Sales__c && wc.Amount > 100000){
            wc.tfeApprover = wc.president;
        }else{
            wc.tfeApprover = wc.vp;
        } 
    }
    
    @AuraEnabled
    public static void htfApprover(Decimal htfQuoteMargin, wrapperClass wc, Map<String, Facility__c> facMap){ 
        
        if((htfQuoteMargin * 100) >= (facMap.get(wc.Facility).HTF_Plan_Marign__c)){
            wc.htfApprover = wc.oppOwner;
        }else if(((((htfQuoteMargin * 100)/facMap.get(wc.Facility).HTF_Plan_Marign__c) * 100) >= facMap.get(wc.Facility).HTF_Margin_Threshold_RSD__c) && ((htfQuoteMargin * 100 ) < facMap.get(wc.Facility).HTF_Plan_Marign__c)){
            wc.htfApprover = wc.oppRSD;
        }else if((((htfQuoteMargin * 100)/facMap.get(wc.Facility).HTF_Plan_Marign__c) * 100) < facMap.get(wc.Facility).HTF_Margin_Threshold_VP_Sales__c && wc.Amount > 100000){
            wc.htfApprover = wc.president;
        }else{
            wc.htfApprover = wc.vp;
        } 
    }
    
    @AuraEnabled
    public static void cfeApprover(Decimal cfeQuoteMargin, wrapperClass wc, Map<String, Facility__c> facMap){ 
        
        if((cfeQuoteMargin * 100) >= (facMap.get(wc.Facility).CFE_Plan_Margin__c)){
            wc.cfeApprover = wc.oppOwner;
        }else if(((((cfeQuoteMargin * 100)/facMap.get(wc.Facility).CFE_Plan_Margin__c) * 100) >= facMap.get(wc.Facility).CFE_Margin_Threshold_RSD__c) && ((cfeQuoteMargin * 100 ) < facMap.get(wc.Facility).CFE_Plan_Margin__c)){
            wc.cfeApprover = wc.oppRSD;
        }else if((((cfeQuoteMargin * 100)/facMap.get(wc.Facility).CFE_Plan_Margin__c) * 100) < facMap.get(wc.Facility).CFE_Margin_Threshold_VP_Sales__c && wc.Amount > 100000){
            wc.cfeApprover = wc.president;
        }else{
            wc.cfeApprover = wc.vp;
        }  
    }
    
    @AuraEnabled
    public static void apuApprover(Decimal apuQuoteMargin, wrapperClass wc, Map<String, Facility__c> facMap){ 
        
        if((apuQuoteMargin * 100) >= (facMap.get(wc.Facility).APU_Plan_Margin__c)){
            wc.apuApprover = wc.oppOwner;
        }else if(((((apuQuoteMargin * 100)/facMap.get(wc.Facility).APU_Plan_Margin__c) * 100) >= facMap.get(wc.Facility).APU_Margin_Threshold_RSD__c) && ((apuQuoteMargin * 100 ) < facMap.get(wc.Facility).APU_Plan_Margin__c)){
            wc.apuApprover = wc.oppRSD;
        }else if((((apuQuoteMargin * 100)/facMap.get(wc.Facility).APU_Plan_Margin__c) * 100) < facMap.get(wc.Facility).APU_Margin_Threshold_VP_Sales__c && wc.Amount > 100000){
            wc.apuApprover = wc.president;
        }else{
            wc.apuApprover = wc.vp;
        }        
    }
    
    @AuraEnabled
    public static void airframeApprover(Decimal airframeQuoteMargin, wrapperClass wc, Map<String, Facility__c> facMap){ 
        
        if((airframeQuoteMargin * 100) >= (facMap.get(wc.Facility).Airframe_Plan_Margin__c)){
            wc.airframeApprover = wc.oppOwner;
        }else if(((((airframeQuoteMargin * 100)/facMap.get(wc.Facility).Airframe_Plan_Margin__c) * 100) >= facMap.get(wc.Facility).Airframe_Margin_Threshold_RSD__c) && ((airframeQuoteMargin * 100 ) < facMap.get(wc.Facility).Airframe_Plan_Margin__c)){
            wc.airframeApprover = wc.oppRSD;
        }else if((((airframeQuoteMargin * 100)/facMap.get(wc.Facility).Airframe_Plan_Margin__c) * 100) < facMap.get(wc.Facility).Airframe_Margin_Threshold_VP_Sales__c && wc.Amount > 100000){
            wc.airframeApprover = wc.president;
        }else{
            wc.airframeApprover = wc.vp;
        }          
    }
    
    @AuraEnabled
    public static void avionicsApprover(Decimal avionicsQuoteMargin, wrapperClass wc, Map<String, Facility__c> facMap){ 
        
        if((avionicsQuoteMargin * 100) >= (facMap.get(wc.Facility).Avionics_Plan_Margin__c)){
            wc.avionicsApprover = wc.oppOwner;
        }else if(((((avionicsQuoteMargin * 100)/facMap.get(wc.Facility).Avionics_Plan_Margin__c) * 100) >= facMap.get(wc.Facility).Avionics_Margin_Threshold_RSD__c) && ((avionicsQuoteMargin * 100 ) < facMap.get(wc.Facility).Avionics_Plan_Margin__c)){
            wc.avionicsApprover = wc.oppRSD;
        }else if((((avionicsQuoteMargin * 100)/facMap.get(wc.Facility).Avionics_Plan_Margin__c) * 100) < facMap.get(wc.Facility).Avionics_Margin_Threshold_VP_Sales__c && wc.Amount > 100000){
            wc.avionicsApprover = wc.president;
        }else{
            wc.avionicsApprover = wc.vp;
        }       
    }
    
    @AuraEnabled
    public static void interiorApprover(Decimal interiorQuoteMargin, wrapperClass wc, Map<String, Facility__c> facMap){ 
        
        if((interiorQuoteMargin * 100) >= (facMap.get(wc.Facility).Interior_Plan_Margin__c)){
            wc.interiorApprover = wc.oppOwner;
        }else if(((((interiorQuoteMargin * 100)/facMap.get(wc.Facility).Interior_Plan_Margin__c) * 100) >= facMap.get(wc.Facility).Interior_Margin_Threshold_RSD__c) && ((interiorQuoteMargin * 100 ) < facMap.get(wc.Facility).Interior_Plan_Margin__c)){
            wc.interiorApprover = wc.oppRSD;
        }else if((((interiorQuoteMargin * 100)/facMap.get(wc.Facility).Interior_Plan_Margin__c) * 100) < facMap.get(wc.Facility).Interior_Margin_Threshold_VP_Sales__c && wc.Amount > 100000){
            wc.interiorApprover = wc.president;
        }else{
            wc.interiorApprover = wc.vp;
        }        
    }
    
    @AuraEnabled
    public static void paintApprover(Decimal paintQuoteMargin, wrapperClass wc, Map<String, Facility__c> facMap){ 
        
        if((paintQuoteMargin * 100) >= (facMap.get(wc.Facility).Paint_Plan_Margin__c)){
            wc.paintApprover = wc.oppOwner;
        }else if(((((paintQuoteMargin * 100)/facMap.get(wc.Facility).Paint_Plan_Margin__c) * 100) >= facMap.get(wc.Facility).Paint_Margin_Threshold_RSD__c) && ((paintQuoteMargin * 100 ) < facMap.get(wc.Facility).Paint_Plan_Margin__c)){
            wc.paintApprover = wc.oppRSD;
        }else if((((paintQuoteMargin * 100)/facMap.get(wc.Facility).Paint_Plan_Margin__c) * 100) < facMap.get(wc.Facility).Paint_Margin_Threshold_VP_Sales__c && wc.Amount > 100000){
            wc.paintApprover = wc.president;
        }else{
            wc.paintApprover = wc.vp;
        }        
    }
    
    @AuraEnabled
    public static void otherApprover(Decimal otherQuoteMargin, wrapperClass wc, Map<String, Facility__c> facMap){ 
        
        if((otherQuoteMargin * 100) >= (facMap.get(wc.Facility).Other_Plan_Margin__c)){
            wc.otherApprover = wc.oppOwner;
        }else if(((((otherQuoteMargin * 100)/facMap.get(wc.Facility).Other_Plan_Margin__c) * 100) >= facMap.get(wc.Facility).Other_Margin_Threshold_RSD__c) && ((otherQuoteMargin * 100 ) < facMap.get(wc.Facility).Other_Plan_Margin__c)){
            wc.otherApprover = wc.oppRSD;
        }else if((((otherQuoteMargin * 100)/facMap.get(wc.Facility).Other_Plan_Margin__c) * 100) < facMap.get(wc.Facility).Other_Margin_Threshold_VP_Sales__c && wc.Amount > 100000){
            wc.otherApprover = wc.president;
        }else{
            wc.otherApprover = wc.vp;
        }        
    }
    
    @AuraEnabled
    public static Facility__c getFacility(String quoteId){  
        SBQQ__Quote__c q = [Select Id, Facility1__c from SBQQ__Quote__c where Id =: quoteId];
        return [Select Id, Airframe_Director__c, 
                Airframe_Margin_Threshold_President__c, 
                Airframe_Margin_Threshold_RSD__c, 
                Airframe_Margin_Threshold_RSM__c, 
                Airframe_Margin_Threshold_VP_Sales__c, 
                Airframe_Master_Scheduler__c, 
                Airframe_Plan_Margin__c, 
                Anti_Corruption__c, 
                APU_Margin_Threshold_President__c, 
                APU_Margin_Threshold_RSD__c, 
                APU_Margin_Threshold_RSM__c, 
                APU_Margin_Threshold_VP_Sales__c, 
                APU_Plan_Margin__c, 
                Avionics_Margin_Threshold_President__c, 
                Avionics_Margin_Threshold_RSD__c, 
                Avionics_Margin_Threshold_RSM__c, 
                Avionics_Margin_Threshold_VP_Sales__c, 
                Avionics_Master_Scheduler__c, 
                Avionics_Plan_Margin__c, 
                CFE_Margin_Threshold_President__c, 
                CFE_Margin_Threshold_RSD__c, 
                CFE_Margin_Threshold_RSM__c, 
                CFE_Margin_Threshold_VP_Sales__c, 
                CFE_Plan_Margin__c, 
                Credit_Analyst__c, 
                Director_of_Quoting_Sales__c, 
                Engine_Director__c, 
                Engine_Master_Scheduler__c, 
                Flatrate_Material_Labor__c, 
                GM__c, 
                GM__r.Email,
                Government__c, 
                HTF_Margin_Threshold_President__c, 
                HTF_Margin_Threshold_RSD__c, 
                HTF_Margin_Threshold_RSM__c, 
                HTF_Margin_Threshold_VP_Sales__c, 
                HTF_Plan_Marign__c, 
                Interior_Margin_Threshold_President__c, 
                Interior_Margin_Threshold_RSD__c, 
                Interior_Margin_Threshold_RSM__c, 
                Interior_Margin_Threshold_VP_Sales__c, 
                Interior_Plan_Margin__c, 
                International_RSD__c, 
                Legal__c, 
                Name, 
                Other_Margin_Threshold_President__c, 
                Other_Margin_Threshold_RSD__c, 
                Other_Margin_Threshold_RSM__c, 
                Other_Margin_Threshold_VP_Sales__c, 
                Other_Plan_Margin__c, 
                Paint_Margin_Threshold_President__c, 
                Paint_Margin_Threshold_RSD__c, 
                Paint_Margin_Threshold_RSM__c, 
                Paint_Margin_Threshold_VP_Sales__c, 
                Paint_Plan_Margin__c, 
                President__c,
                President__r.Email,
                TFE_Margin_Threshold_President__c, 
                TFE_Margin_Threshold_RSD__c, 
                TFE_Margin_Threshold_RSM__c, 
                TFE_Margin_Threshold_VP_Sales__c, 
                TFE_Plan_Margin__c, 
                Trade_Compliance__c, 
                VP_of_Finance__c,
                VP_of_Finance__r.Email,
                VP_Sales__c,
                VP_Sales__r.Email from Facility__c where Name =: q.Facility1__c];        
    }
    
    public class wrapperClass{
        @AuraEnabled public Map<Id, String> oppOwner {get;set;}        
        @AuraEnabled public Map<Id, String> oppRSD {get;set;}
        
        @AuraEnabled public String facility;
        @AuraEnabled public String quoteId;
        
        @AuraEnabled public Map<Id, String> tfeApprover {get;set;}
        @AuraEnabled public String tfeDirector;
        
        @AuraEnabled public Map<Id, String> cfeApprover {get;set;}
        @AuraEnabled public String cfeDirector;
        
        @AuraEnabled public Map<Id, String> htfApprover {get;set;}
        @AuraEnabled public String htfDirector;
        
        @AuraEnabled public Map<Id, String> apuApprover {get;set;}
        @AuraEnabled public String apuDirector;
              
        @AuraEnabled public Map<Id, String> interiorApprover {get;set;}
        @AuraEnabled public String interiorDirector;
        
        @AuraEnabled public Map<Id, String> airframeApprover {get;set;}
        @AuraEnabled public Map<Id, String> airframeScheduler {get;set;}
        @AuraEnabled public String airframeShopDirector;
        @AuraEnabled public String airframeDirector;
        
        @AuraEnabled public Map<Id, String> avionicsApprover {get;set;}
        @AuraEnabled public Map<Id, String> avionicsScheduler {get;set;}
        @AuraEnabled public String avionicsDirector;
        
        @AuraEnabled public Map<Id, String> engineScheduler {get;set;}
        @AuraEnabled public String engineShopDirector;
        
        @AuraEnabled public Boolean tcReq {get;set;}
        @AuraEnabled public String vpgm;
        @AuraEnabled public Map<Id, String> president {get;set;}       
        @AuraEnabled public Map<Id, String> vp {get;set;}
        @AuraEnabled public Map<Id, String> tradecompliance {get;set;}
        @AuraEnabled public Map<Id, String> antiCorruption {get;set;}
        @AuraEnabled public Map<Id, String> government {get;set;}
        @AuraEnabled public Map<Id, String> legal {get;set;}
        @AuraEnabled public Map<Id, String> frMatLab {get;set;}
        @AuraEnabled public Map<Id, String> mstApprover {get;set;}
        
        @AuraEnabled public String vpf;
        @AuraEnabled public String doqs;
        
        @AuraEnabled public Map<Id, String> paintApprover {get;set;}
        @AuraEnabled public Map<Id, String> otherApprover {get;set;}
        @AuraEnabled public String oppOwnerId;
        @AuraEnabled public List<User> Directors;
        
        @AuraEnabled public Decimal amount;
        @AuraEnabled public Decimal tfeMargin;
        @AuraEnabled public Decimal cfeMargin;
        @AuraEnabled public Decimal htfMargin;
        @AuraEnabled public Decimal apuMargin;
        @AuraEnabled public Decimal airframeMargin;
        @AuraEnabled public Decimal avionicsMargin;
        @AuraEnabled public Decimal interiorMargin;
        @AuraEnabled public Decimal paintMargin;
        @AuraEnabled public Decimal otherMargin;  
        
        @AuraEnabled public String Competitor;
        @AuraEnabled public Decimal Quoted_Downtime;
        @AuraEnabled public Date InputDate;
        @AuraEnabled public Decimal ExpectedRevenue;
        @AuraEnabled public Decimal EstimatedMarginPercent;
        @AuraEnabled public Decimal EstimatedHours;
    }
    
    @AuraEnabled
    public static void EmailQuoteDetails(String email, 
                                         String cc, 
                                         String approvers,
                                         String quoteId,
                                         String prodTypes,
                                         String eRev,
                                         String eMP,
                                         String eHrs,
                                         String inputDate,
                                         String qDownTime,
                                         String competitor,
                                         String notes,
                                         String fileMap) { 
                                             system.debug('FileMap:' + fileMap);
                                             String htmlBody = '';
                                             
                                             Organization instance = [SELECT InstanceName FROM Organization];                                           
                                             SBQQ__Quote__c quote = [Select Id, 
                                                                     Name,
                                                                     SBQQ__Account__r.Name, 
                                                                     Aircraft__c,
                                                                     Aircraft__r.Aircraft_Model_2011__c,
                                                                     Aircraft__r.Aircraft_SN__c,
                                                                     Facility1__c,
                                                                     SBQQ__SalesRep__r.Name,
                                                                     Labor_Type1__c,
                                                                     Total_Labor_Hours__c,
                                                                     Total_Margin__c,
                                                                     SBQQ__Opportunity2__r.Name,
                                                                     SBQQ__Opportunity2__r.Owner.Email,
                                                                     SBQQ__Opportunity2__r.Owner.Manager.Email,
                                                                     SBQQ__Opportunity2__r.Id,
                                                                     SBQQ__Opportunity2__r.MasterOpportunitylookup__c,
                                                                     SBQQ__Opportunity2__r.InputDate__c,
                                                                     SBQQ__NetAmount__c,
                                                                     Downtime_Days__c,
                                                                     SBQQ__Opportunity2__r.Competitor__c
                                                                     from SBQQ__Quote__c where Id =: quoteId];
                                             
                                             //Query Facility to get VPGM an President
                                             Facility__c fac = getFacility(quoteId);
                                             
                                             List<String> quoteDoc = new List<String>();
                                             
                                             List<String> emailDistribution = email.split(',');
                                             List<String> ccEmailDistribution = cc.split(',');
                                             
                                             //cc User On Email
                                             ccEmailDistribution.add(userinfo.getUserEmail());
                                             
                                             //Copy Previous Quoters on Email
                                             for(SBQQ__Quote__c q : [Select Owner.Email from SBQQ__Quote__c where SBQQ__Opportunity2__r.MasterOpportunitylookup__c =: quote.SBQQ__Opportunity2__r.Id and SBQQ__Primary__c = true]){
                                                 if(!emailDistribution.contains(q.Owner.Email) && !ccEmailDistribution.contains(q.Owner.Email))
                                                     ccEmailDistribution.add(q.Owner.Email);
                                             }
                                             
                                             //Add Vice President on Copy if VPGM is Approver
                                             if(emailDistribution.contains(fac.GM__r.Email) && !ccEmailDistribution.contains(fac.VP_Sales__r.Email))
                                                 ccEmailDistribution.add(fac.VP_Sales__r.Email);
                                             
                                             //Add Vice President on Copy if President is Approver
                                             if(emailDistribution.contains(fac.President__r.Email) && !ccEmailDistribution.contains(fac.VP_Sales__r.Email))
                                                 ccEmailDistribution.add(fac.VP_Sales__r.Email);  
                                             
                                             //Add VP Finance
                                              if(emailDistribution.contains(fac.President__r.Email) && !ccEmailDistribution.contains(fac.VP_of_Finance__r.Email))
                                                 ccEmailDistribution.add(fac.VP_of_Finance__r.Email);                                             
                                             
                                             //cc RSD On Email if not an approver
                                             if(!emailDistribution.contains(quote.SBQQ__Opportunity2__r.Owner.Manager.Email) && quote.SBQQ__Opportunity2__r.Owner.Manager.Email != null)
                                                 ccEmailDistribution.add(quote.SBQQ__Opportunity2__r.Owner.Manager.Email);
                                             
                                             //cc RSM if not an approver
                                             if(!emailDistribution.contains(quote.SBQQ__Opportunity2__r.Owner.Email) && !ccEmailDistribution.contains(quote.SBQQ__Opportunity2__r.Owner.Email))
                                                 ccEmailDistribution.add(quote.SBQQ__Opportunity2__r.Owner.Email);
                                             
                                             String rsm = quote.SBQQ__SalesRep__r.Name;
                                             String facility = quote.Facility1__c;
                                             
                                             String manHours = (decimal.valueof(eHrs).setScale(0)).format(); 
                                             if(eHrs == null)
                                                 manHours = null;
                                             
                                             String revenue =  (decimal.valueof(eRev).setScale(2) + 0.001).format();
                                             revenue = revenue.substring(0, revenue.length()-1);
                                             
                                             Decimal margin = decimal.valueof(eMP).setScale(2); 
                                             if(eMP == null)
                                                 margin = null;
                                             
                                             String downTime = '0'; 
                                             if(qDownTime != null)
                                                 downTime = qDownTime;
                                             
                                             Date d = date.valueOf(inputDate);                                             
                                             String dateFormatString = 'MMM dd yyyy';
                                             
                                             Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
                                             String dateString = dt.format(dateFormatString);                                           
                                             
                                             String additionalNotes = notes;
                                             
                                             List<String> approverIds = new List<String>();
                                             
                                             List<String> removeApprovers = new List<String>();
                                             
                                             //Check For Delegated Approvers
                                            for(sbaa__Approver__c da : [Select Id, sbaa__User__r.Email, sbaa__DelegatedApprover__r.sbaa__User__r.Email 
                                                                        from sbaa__Approver__c 
                                                                        where sbaa__DelegationStart__c <=: System.today() and sbaa__DelegationEnd__c >=: System.today() and sbaa__User__r.Email In: emailDistribution]){
                                                 system.debug('Delegate Approver: ' + da.sbaa__DelegatedApprover__r.sbaa__User__r.Email);
                                                 //Add Delegated Approver to Email Distribution
                                                 if(!emailDistribution.contains(da.sbaa__DelegatedApprover__r.sbaa__User__r.Email))
                                                     emailDistribution.add(da.sbaa__DelegatedApprover__r.sbaa__User__r.Email);
                                                                                                 
                                                 //Add Approver to CC Email Distribution
                                                 if(!ccEmailDistribution.contains(da.sbaa__User__r.Email))
                                                     ccEmailDistribution.add(da.sbaa__User__r.Email);
                                                 
                                                 removeApprovers.add(da.sbaa__User__r.Email);
                                             }
                                             
                                             //Remove Approver Emails from Distribution
                                             if(removeApprovers.Size() > 0){
                                                 for (Integer i = 0; i < emailDistribution.size(); i++){
                                                     String e = emailDistribution[i];
 
                                                     for(String ra : removeApprovers){        
                                                         if(e.equals(ra))
                                                             emailDistribution.remove(i);
                                                     }
                                                 }                                               
                                             }
                                             
                                             //Check For Delegated Approvers in CC List
                                             for(sbaa__Approver__c da : [Select Id, sbaa__User__r.Email, sbaa__DelegatedApprover__r.sbaa__User__r.Email 
                                                                         from sbaa__Approver__c 
                                                                         where sbaa__DelegationStart__c <=: System.today() and sbaa__DelegationEnd__c >=: System.today() and sbaa__User__r.Email In: ccEmailDistribution]){
                                                                             //Add Delegated Approver to Email Distribution
                                                                             if(!ccEmailDistribution.contains(da.sbaa__DelegatedApprover__r.sbaa__User__r.Email))
                                                                                 ccEmailDistribution.add(da.sbaa__DelegatedApprover__r.sbaa__User__r.Email);
                                                                         }
                                                                                
                                             Map<String, User> edMap = new Map<String, User>();
                                             for(User u : [Select Id, FirstName, Email, IsActive from User where Email In: emailDistribution and IsActive =: true]){
                                                 edMap.put(u.Email, u);
                                                 approverIds.add(u.Id);      
                                             }
                                             
                                             List<String> fileIds = new List<String>();
                                             if(fileMap != null){ 
                                                 List<Object> selectedFileList = (List<Object>)JSON.deserializeUntyped(fileMap);                   
                                                 for(Object sfl : selectedFileList){
                                                     Map<String, Object> mpSFL = (Map<string, Object>)sfl;
                                                     
                                                     fileIds.add(string.valueof(mpSFL.get('Id')));
                                                 }
                                             }
                                             
                                             EmailServicesAddress esa = [SELECT Id, DeveloperName, EmailDomainName, functionId, localPart FROM EmailServicesAddress where DeveloperName =: 'tsmQuoteRouting'];
                                             
                                             String returnESA = esa.LocalPart + '@' + esa.EmailDomainName;
                                             
                                             //Quote Process
                                             QuoteApprovals(quote.Id, approverIds);
                                             
                                             Map<String, sbaa__Approval__c> approvalMap = new Map<String, sbaa__Approval__c>();
                                             for(sbaa__Approval__c a : [Select Id, sbaa__AssignedTo__c, sbaa__Rule__c
                                                                        from sbaa__Approval__c
                                                                        where sbaa__Status__c =: 'Requested' and 
                                                                        sbaa__ApprovalStep__c =: 1 and 
                                                                        Quote__c =: quoteId]){
                                                                            approvalMap.put(a.sbaa__AssignedTo__c, a);
                                                                        }
                                             
                                             //Send Emails
                                             List<Messaging.SingleEmailMessage> emailList = new  List<Messaging.SingleEmailMessage>();
                                             
                                             //New Section End
                                             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                                             
                                             //Add Selected Files
                                             if(fileIds.Size() > 0)
                                                 message.setEntityAttachments(fileIds);
                                             
                                             message.setToAddresses(emailDistribution);
                                             
                                             if(ccEmailDistribution.Size() > 0)
                                                 message.setCcAddresses(ccEmailDistribution); 
                                             
                                             message.optOutPolicy = 'FILTER'; 
                                             message.subject = 'Request Quote Approval: ' + quote.SBQQ__Account__r.Name + ' ' + quote.Name + ' (' + quote.Aircraft__r.Aircraft_Model_2011__c + ' ' + quote.Aircraft__r.Aircraft_SN__c + ')';          
                                             message.HTMLBody = 'All:' + 
                                                 '<br/><br/>Your approval has been requested on Quote: ' + quote.Name + ' for Opportunity: <a href="https://standardaero.lightning.force.com/lightning/r/Opportunity/' + quote.SBQQ__Opportunity2__r.Id + '/view">' + quote.SBQQ__Opportunity2__r.Name + '</a>.</b><br/><br/>' +
                                                 'Review and approval needs to be completed within 24 hours. After 24 hours, low risk quotes may be delivered at the discretion of the TSM if time is of the essence. Most quotes will be allowed additional time for review as needed.<br/><br/>';
                                             
                                             if(notes != ''){
                                                 message.HTMLBody += '<b><u>TSM Notes: </u></b><br/>' + additionalNotes + '<br/><br/>';
                                                 system.debug('Additional Notes: ' + additionalNotes);
                                             }
                                             
                                             //Approver Tabel in Email
                                             message.HTMLBody += 'The required approvers for this quote are:<br/>';
                                             message.HTMLBody += '<table style="border-collapse: collapse"><tr>';
                                             for(sbaa__Approval__c a : [Select Id, sbaa__AssignedTo__r.fxName__c, sbaa__Rule__c
                                                                        from sbaa__Approval__c
                                                                        where sbaa__Status__c =: 'Requested' and 
                                                                        sbaa__ApprovalStep__c =: 1 and 
                                                                        Quote__c =: quoteId]){
                                                                            message.HTMLBody += '<tr>'+ 
                                                                                '<td style="margin-left: 30px"><b>' + a.sbaa__AssignedTo__r.fxName__c + ': </b></td>' +
                                                                                '<td style="margin-left: 5px; width:60px">' +
                                                                                '<a href="mailto:' + returnESA + 
                                                                                '?cc=' + userinfo.getUserEmail() +
                                                                                '&subject=' + quote.Name + ' Approved'+
                                                                                '&body=' + 
                                                                                'Add comments by editing the text between the Comments brackets.%0d%0a%0d%0a' +
                                                                                'Comments: [   ---Insert Comments Here---   ] %0d%0a%0d%0a-----Do not edit below this line-----%0d%0a' +
                                                                                'Approved|' + a.Id +'"> Approve</a>' +
                                                                                '</td>' + 
                                                                                '<td style="margin-left: 5px">' +
                                                                                '<a href="mailto:' + returnESA +
                                                                                '?cc=' + userinfo.getUserEmail() +
                                                                                '&subject=' + quote.Name + ' Rejected' +
                                                                                '&body=' + 
                                                                                'Add comments by editing the text between the Comments brackets.%0d%0a%0d%0a' +
                                                                                'Comments: [   ---Insert Comments Here---   ] %0d%0a%0d%0a-----Do not edit below this line-----%0d%0a' +
                                                                                'Rejected|' + a.Id +'"> Reject</a></br>' +
                                                                                '</td>' +
                                                                                '</tr>';                                                                           
                                                                        } 
                                             message.HTMLBody += '</table><br/>';
                                             
                                             message.HTMLBody += 'If you are not an "Approver" listed above we still very much value your input. ' + 
                                                 'Please direct your input to the appropriate approver listed above with at least the TSM and RSM on copy.<br/>';
                                             
                                             message.HTMLBody += 
                                                 '<br/><table border="1" style="border-collapse: collapse" cellpadding="10">'+            
                                                 '<tr>'+
                                                 '<td style="background-color: rgb(252, 213, 180);">Regional Sales Manager</td>' +
                                                 '<td style="background-color: rgb(252, 255, 153);">' + rsm + '</td>' +
                                                 '</tr>'+                
                                                 '<tr>'+
                                                 '<td style="background-color: rgb(252, 213, 180);">Product Type(s)</td>'+
                                                 '<td style="background-color: rgb(252, 255, 153);">' + prodTypes + '</td>'+
                                                 '</tr>'+               
                                                 '<tr>'+
                                                 '<td style="background-color: rgb(252, 213, 180);">Facility</td>'+
                                                 '<td style="background-color: rgb(252, 255, 153);">' + facility + '</td>'+
                                                 '</tr>'+
                                                 '<tr>'+
                                                 '<td style="background-color: rgb(252, 213, 180);">Total Revenue</td>'+
                                                 '<td style="background-color: rgb(252, 255, 153);">&#36&nbsp' + revenue + '</td>'+
                                                 '</tr>'+
                                                 '<tr>'+
                                                 '<td style="background-color: rgb(252, 213, 180);">Total OM&#37</td>'+
                                                 '<td style="currency; background-color: rgb(252, 255, 153);">' + margin + '&#37</td>'+
                                                 '</tr>'+    
                                                 '<tr>'+
                                                 '<td style="background-color: rgb(252, 213, 180);">Total Man Hours</td>'+
                                                 '<td style="background-color: rgb(252, 255, 153);">' + manHours + '</td>'+
                                                 '</tr>'+            
                                                 '<tr>'+
                                                 '<td style="background-color: rgb(252, 213, 180);">Input Date</td>'+
                                                 '<td style="currency; background-color: rgb(252, 255, 153);">' + dateString + '</td>'+
                                                 '</tr>'+
                                                 '<tr>'+
                                                 '<td style="background-color: rgb(252, 213, 180);">Quote Downtime</td>'+
                                                 '<td style="currency; background-color: rgb(252, 255, 153);">' + downTime + ' Days</td>'+
                                                 '</tr>'+
                                                 '<tr>'+
                                                 '<td style="background-color: rgb(252, 213, 180);">Competitor</td>'+
                                                 '<td style="currency; background-color: rgb(252, 255, 153);">' + competitor + '</td>'+
                                                 '</tr>'+            
                                                 '</table><br/><br/>';                
                                             
                                             message.HTMLBody += 'Best Regards,';
                                             
                                             emailList.add(message);                                          
                                             
                                             try{
                                                 Messaging.sendEmail(emailList);
                                             }catch(DmlException e){
                                                 
                                                 String errorMessage = '{\n' +
                                                     ' "errorMsg" : "Please check the following in the Quote: ",\n' +
                                                     ' "errorMsgTitle" : "Quote does not have any Quote Line Items to Sync"\n' +      
                                                     '}';
                                                 
                                                 AuraHandledException ex = new AuraHandledException(errorMessage);
                                                 ex.setMessage(errorMessage);
                                                 throw ex;
                                             } 
                                         }
    
    
    @AuraEnabled
    public static List<ContentVersion> getAttachments(String conId){
        
        List<ContentDocumentLink> CDLs = [Select ContentDocumentId 
                                          from ContentDocumentLink 
                                          where LinkedEntityId = : conId];
        
        if(CDLs != NULL && CDLs.size() > 0){
            Set<Id> CDIdList = new Set<Id>();
            for (ContentDocumentLink nextCDL : CDLs) {
                CDIdList.add(nextCDL.ContentDocumentId); 
            }   
            
            List<ContentDocument> entries = [SELECT Id, Title, FileType FROM ContentDocument WHERE ContentDocument.Id IN :CDIdList];
            
            List<ContentVersion> CVmainList = new List<ContentVersion>();  
            List<ContentVersion> CVList = [SELECT Id, ContentDocumentId, isLatest, Title, FileType 
                                           FROM ContentVersion 
                                           WHERE ContentDocumentId = :CDIdList AND isLatest = true];
            
            return CVList;
        }
        else{
            List<ContentVersion> CV = new List<ContentVersion>();
            CV = NULL;
            return CV;
        }
    }
    
    @AuraEnabled
    public static Map<Id, sObject> getRecordValues(String recordId){
        
        Id rId = Id.valueof(recordId);
        String sObjectType = rId.getSObjectType().getDescribe().getName();
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sObjectType).getDescribe().fields.getMap();
        
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');                     
        String  oquery = 'Select ' + joinedString + ' from ' + sObjectType + ' where ID =: rId';
        Map<Id, sObject> sObjectMap = new Map<Id, sObject>((List<sObject>)Database.query(oquery));
        
        return sObjectMap;               
    }
    
    public static List<sbaa__Approver__c> sa = new List<sbaa__Approver__c>();   
    public static Map<Id, sbaa__ApprovalRule__c> arMap = new Map<Id, sbaa__ApprovalRule__c>();
    public static sbaa__ApprovalChain__c ac = [Select Id from sbaa__ApprovalChain__c where Name =: 'Quote'];
    
    public static void QuoteApprovals(Id quoteId, List<String> approverIds){        
        
       
        Set<Id> auApprovers = new Set<Id>();
        Set<Id> arApprovers = new Set<Id>();
        
        //Approvers Users
        Set<Id> createAU = new Set<Id>();
        
        //Approval Rules
        Set<Id> createAR = new Set<Id>();
        
        //Add Approver Records to List
        //Adds User to Set
        for(sbaa__Approver__c sau : [Select Id, Name, sbaa__User__c from sbaa__Approver__c where sbaa__User__c In: approverIds]){
            sa.add(sau);
            auApprovers.add(sau.sbaa__User__c);
        }
        
        //Checks to see if User Id Exists in Set
        //If It Does Not, It's Added to List To Create CPQ Approver
        for(String a : approverIds){
            if(!auApprovers.contains(a))
                createAU.add(a);            
        }
        
        system.debug('Before Approver List: ' + sa);
        
        //Create Quote Approvers if Needed
        if(createAU.Size() > 0)
            createQuoteApprovers(createAU);
        
        //Finds Quote Approvals and Creates them if necessary
        findQuoteApprovals(sa);
        
        //Create Approval Request
        //Create Approval Condition
        createApprovals(quoteId, arMap, approverIds); 
        
        updateQuote(quoteId);
    }
    
    //Creates CPQ Approvers
    public static void createQuoteApprovers(Set<Id> createAU){
        List<sbaa__Approver__c> saApprover = new List<sbaa__Approver__c>();
        Map<Id, User> uMap = new Map<Id, User>([Select Id, FirstName, LastName from user where Id in: createAU]);
        
        for(Id u :createAU){
            sbaa__Approver__c s = new sbaa__Approver__c();
            s.Name = uMap.get(u).FirstName + ' ' + uMap.get(u).LastName;
            s.sbaa__User__c = u;
            saApprover.add(s);          
        }
        
        insert saApprover;        
        sa.addAll(saApprover);
        
        system.debug('Updated Approver List: ' + sa);
    }
    
    //Clear Existing Approvals
    /*public static void ClearApprovals(Id quoteId, List<String> approverIds){
        SBQQ__Quote__c quote = [Select Id, Name from SBQQ__QUote__c where Id =: quoteId];
        List<sbaa__Approval__c> qaList = new List<sbaa__Approval__c>();
        List<sbaa__ApprovalCondition__c> qaConditionList = [Select Id from sbaa__ApprovalCondition__c where sbaa__FilterValue__c =: quote.Name];
        
        if(qaConditionList.Size() > 0)
            delete qaConditionList;
        
        for(sbaa__Approval__c sa : [Select Id, sbaa__Status__c from sbaa__Approval__c where Quote__c =: quoteId and sbaa__AssignedTo__c In: approverIds]){
            sa.sbaa__Status__c = 'Requested';
            sa.sbaa__CommentsLong__c = '';
            
            qaList.add(sa);
        }       
        
        if(qaList.Size() > 0)
            update qaList;
    }*/
    
    //Create CPQ Approver Rule
    public static void findQuoteApprovals(List<sbaa__Approver__c> sa){
        Set<Id> arApprovers = new Set<Id>();
        
        //populate Approver Map with Values
        Map<Id, sbaa__Approver__c> saMap = new Map<Id, sbaa__Approver__c>();    
        for(sbaa__Approver__c s : sa){
            saMap.put(s.Id, s);
        }
        
        for(sbaa__ApprovalRule__c ar : [Select Id, name, sbaa__Active__c, sbaa__Approver__c, sbaa__Approver__r.sbaa__User__c, sbaa__ApprovalChain__c 
                                        from sbaa__ApprovalRule__c 
                                        where sbaa__Approver__c in: saMap.keySet() 
                                        and sbaa__ApprovalChain__c =: ac.Id 
                                        and sbaa__TargetObject__c =: 'SBQQ__Quote__c']){
                                            
            arMap.put(ar.sbaa__Approver__c, ar);           
        }
        
        List<sbaa__ApprovalRule__c> newAR = new List<sbaa__ApprovalRule__c>();
        for(sbaa__Approver__c a : sa){
            if(!arMap.containsKey(a.Id)){
                sbaa__ApprovalRule__c sar = new sbaa__ApprovalRule__c();
                sar.Name = a.Name + ' Quote Approval';
                sar.sbaa__TargetObject__c = 'SBQQ__Quote__c';
                sar.sbaa__ApprovalChain__c = ac.Id;
                sar.sbaa__Active__c = true;
                sar.sbaa__Approver__c = a.Id;
                sar.sbaa__ApprovalStep__c = 1;
                sar.sbaa__ConditionsMet__c = 'Any';
                
                newAR.add(sar);
            }                       
        }
        
        if(newAR.Size() > 0){
            insert newAR;
            
            for(sbaa__ApprovalRule__c nar : newAR){
                arMap.put(nar.sbaa__Approver__c, nar);  
            }                       
        }
    }
    
    //Create Approval
    public static void createApprovals(Id quoteId, Map<Id, sbaa__ApprovalRule__c> arMap, List<String> approverIds){
        
        SBQQ__Quote__c q = [Select Id, Name from SBQQ__Quote__C where Id =: quoteId];
        
        //Get CPQ Approver Record
        Map<Id, sbaa__Approver__c> approverMap = new Map<Id, sbaa__Approver__c>([Select Id, sbaa__User__c from sbaa__Approver__c where Id In: arMap.keyset()]);
        
        List<sbaa__Approval__c> aList = new List<sbaa__Approval__c>();
        List<sbaa__ApprovalCondition__c> acList = new List<sbaa__ApprovalCondition__c>();
        
        Set<Id> saSet = new Set<Id>();
        for(sbaa__Approval__c sa : [Select Id, Quote__c, sbaa__Rule__c, sbaa__Status__c,
                                    sbaa__ApprovalStep__c, sbaa__RecordField__c, sbaa__ApprovalChain__c,
                                    sbaa__Approver__c, sbaa__AssignedTo__c, OwnerId 
                                    from sbaa__Approval__c
                                    where Quote__c =: quoteId]){
                                        if(approverIds.contains(sa.sbaa__AssignedTo__c)){
                                        	sa.sbaa__Status__c = 'Requested';
                                        	sa.sbaa__CommentsLong__c = '';
                                            sa.Approval_Date__c = null;
                                            sa.sbaa__ApprovedBy__c = null;
                                        }else{
                                            sa.sbaa__Status__c = 'Recalled';
                                            sa.sbaa__Rule__c = null;
                                        }
                                        
                                        aList.add(sa);
                                        saSet.add(sa.sbaa__Approver__c);
                                    }
        
        for(Id s : arMap.keyset()){
            
            if(!saSet.contains(s)){
                //Create Approval
                sbaa__Approval__c newA = new sbaa__Approval__c(
                    Quote__c = quoteId,
                    sbaa__Rule__c = arMap.get(s).Id,
                    sbaa__Status__c = 'Requested',
                    sbaa__ApprovalStep__c = 1,
                    sbaa__RecordField__c = 'Quote__c',
                    sbaa__ApprovalChain__c = ac.Id,
                    sbaa__Approver__c = s,
                    sbaa__AssignedTo__c = approverMap.get(s).sbaa__User__c,
                    OwnerId = userinfo.getUserId()
                );
                aList.add(newA);
                
                //Create Approval Condition
                sbaa__ApprovalCondition__c ac = new sbaa__ApprovalCondition__c(
                    sbaa__ApprovalRule__c = arMap.get(s).Id,
                    sbaa__TestedField__c = 'Name',
                    sbaa__Operator__c = 'equals',
                    sbaa__FilterType__c = 'Value',
                    sbaa__FilterValue__c = q.Name
                );
                acList.add(ac); 
            }
        } 
        
        upsert aList;
        
        if(acList.Size() > 0)
        	insert acList; 
    }
    
    //Update Quote
    public static void updateQuote(Id quoteId){
        for(Sbqq__Quote__c q : [Select Id, ApprovalStatus__c, Submitted_Date__c, Submitted_User__c from Sbqq__Quote__c where Id =: quoteId]){
            q.ApprovalStatus__c = 'Pending';
            q.Send_Approval_Notification__c = false;
            q.Submitted_User__c = userinfo.getUserId();
            q.Submitted_Date__c = System.today();
            
            update q;
        }
    }
}