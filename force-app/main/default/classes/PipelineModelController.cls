public with sharing class PipelineModelController {
           
    //Mx Maintenance Progams Until We Are Able To Group Formulas in Aggregate Queries;
    public Set<String> MSP = new Set<String>{'MSP', 'MSP EEOL', 'MSP Gold', 'MSP GNLS', 'MSP GNLI', 'MSP Gold NRL', 'MSP MSPW', 'MSP MPIO', 'CSP', 'CSP Gold', 'CFE', 'CFEG', 'FMPG', 'FMP', 'GNLA', 'GNLI', 'GNLT', 'SECO', 'SEM6', 'SMA2', 'SMA3', 'STAV'};    
    public Set<String> JSSI = new Set<String>{'JSSI', 'JSSI - Choice', 'JSSI - Customer Choice', 'JSSI - Platinum', 'JSSI - Plus Option', 'JSSI - Premium', 'JSSI - Low Utilization Inspection (LUI)', 'JSSI - LUI Option', 'JSSI - Select', 'JSSI - StandardAero', 'JSSI - R&R Option', 'JSSI - R&F Option', 'JSSI - Unscheduled'};
    public Set<String> Retail = new Set<String>{'No Contract'};
    public Map<String, Set<String>> mxPrgmsMap = new Map<String, Set<String>>{};
    public Boolean enableXL {get;set;}
       
    public PipelineModelController(){
        enableXL = true;
        mxPrgmsMap.put('MSP', MSP);
        mxPrgmsMap.put('JSSI', JSSI);
        mxPrgmsMap.put('Retail', Retail);
            
        leftselected = new List<String>();
        rightselected = new List<String>();
        leftStageValues.addAll(stageValues); 
		leftFacilityValues.addAll(facilityValues);
        leftMxPrgmValues.addAll(mxPrgmValues);
        leftModelValues.addAll(modelValues);         
    }
    
    public List<AggregateResult> opps {get;set;}
    public List<Opportunity> oppsList {get;set;}
    
    private String soql {get;set;}
    private String soqlOpps {get;set;} 
    public String facility = null;
    public String model = null;
    public String mxPrgm = null;
   
    public Set<String> Stage = new Set<String>();
    public Set<String> selected_Facility = new Set<String>();
    public Set<String> selected_MxPrgm = new Set<String>();
    public Set<String> selected_Model = new Set<String>();
    public Set<String> mxPrgms = new Set<String>();
    
    public Map<String, Map<String, Decimal>> facilityMap {get;set;}
    public Map<String, Map<String, Decimal>> modelMap {get;set;}
    public Map<String, Map<String, Decimal>> mxPrgmMap {get;set;} 
    
    public Decimal newTotalCount {get;set;}
    public Decimal newTotalAmount {get;set;}
    public Decimal newSaTotalCount {get;set;}
    public Decimal newSaTotalAmount {get;set;}
    public Decimal newtotalRevenuePerEvent {get;set;}
    
    public Decimal totalCount {get;set;}
    public Decimal totalRevenue {get;set;}
    public Decimal totalRevenuePerEvent{get;set;}    
    public Decimal saTotalCount {get;set;}
    public Decimal saTotalRevenue {get;set;}
     
    public Decimal mpiTotalCount {get;set;}
    public Decimal mpiTotalRevenue {get;set;}
    public Decimal mpiTotalRevenuePerEvent{get;set;}  
    public Decimal saMPI_TotalCount {get;set;}
    public Decimal saMPI_TotalRevenue {get;set;}
       
    public Decimal cziTotalCount {get;set;}
    public Decimal cziTotalRevenue {get;set;}
    public Decimal cziTotalRevenuePerEvent{get;set;}  
    public Decimal saCZI_TotalCount {get;set;}
    public Decimal saCZI_TotalRevenue {get;set;}
       
    public List<string> leftselected{get;set;}
    public List<string> rightselected{get;set;}
    
    public List<string> leftselected_FAC{get;set;}
    public List<string> rightselected_FAC{get;set;}
    
    public List<string> leftselected_mx{get;set;}
    public List<string> rightselected_mx{get;set;}
    
    public List<string> leftselected_mod{get;set;}
    public List<string> rightselected_mod{get;set;}
    
    Set<string> leftStageValues = new Set<string>();
    Set<string> rightStageValues = new Set<string>();
    
    Set<string> leftFacilityValues = new Set<string>();
    Set<string> rightFacilityValues = new Set<string>();
    
    Set<string> leftMxPrgmValues = new Set<string>();
    Set<string> rightMxPrgmValues = new Set<string>();
    
    Set<string> leftModelValues = new Set<string>();
    Set<string> rightModelValues = new Set<string>();

    public void runQuery() {
       	facilityMap = new Map<String, Map<String, Decimal>>();
        modelMap = new Map<String, Map<String, Decimal>>();
        mxPrgmMap = new Map<String, Map<String, Decimal>>();
        
        String strWinRate = Apexpages.currentPage().getParameters().get('winRate');      
        Decimal winRate = 1;
        
        if(strWinRate != '')
            winRate = Decimal.valueOf(strWinRate)*.01;
                              
        mpiTotalCount = 0;
        mpiTotalRevenue = 0;
                
        cziTotalCount = 0;
    	cziTotalRevenue = 0;
                 
        totalCount = 0;
        totalRevenue = 0;
        
        try { 
        	opps = Database.query(soql);
            //oppsList = Database.query(soqlOpps);
            for (AggregateResult result : opps){
                totalCount += Decimal.valueof(String.valueOf(result.get('totalCount'))); 
                totalRevenue += Decimal.valueOf(String.valueOf(result.get('totalAmount')));
                
                facility = String.valueOf(result.get('facility__c'));
                model = String.valueOf(result.get('Model__c'));
                
                if(String.valueOf(result.get('MaintenancePrgmType__c')) == 'No Contract' || String.valueOf(result.get('MaintenancePrgmType__c')) == null){
                    mxPrgm = 'Retail';
                }else{
                    mxPrgm = String.valueOf(result.get('MaintenancePrgmType__c'));
                }
                
                //Populates mxPrgm Map
                if(!mxPrgmMap.containsKey(mxPrgm)){
                    mxPrgmMap.put(mxPrgm, new Map<String, Decimal>{'totalCount' => 0, 'saTotalCount' => 0,'totalAmount' => 0, 'saTotalAmount' => 0, 'totalRevenuePerEvent' => 0});
                }
                
                newTotalCount = mxPrgmMap.get(mxPrgm).get('totalCount') + Decimal.valueof(String.valueOf(result.get('totalCount')));
                newTotalAmount = mxPrgmMap.get(mxPrgm).get('totalAmount') + Decimal.valueof(String.valueOf(result.get('totalAmount')));
                newSaTotalCount = newTotalCount * winRate;
                newSaTotalAmount = newTotalAmount * winRate;
                
                if(newTotalAmount != 0 && newTotalCount != 0){
                    newtotalRevenuePerEvent = newTotalAmount / newTotalCount;
                }else{
                    newtotalRevenuePerEvent =  0;                          
                }
                                                   
                mxPrgmMap.put(mxPrgm,new Map<String, Decimal>{
                    'totalCount' => newTotalCount, 
                    'saTotalCount' => newSaTotalCount,
                    'totalAmount' => newTotalAmount,
                    'saTotalAmount' => newSaTotalAmount,
                    'totalRevenuePerEvent' => newtotalRevenuePerEvent});
                
                //Populates Model Map
                if(!modelMap.containsKey(model)){               
                    modelMap.put(model, new Map<String, Decimal>{'totalCount' => 0, 'saTotalCount' => 0,'totalAmount' => 0, 'saTotalAmount' => 0, 'totalRevenuePerEvent' => 0});
                }
                
                newTotalCount = modelMap.get(model).get('totalCount') + Decimal.valueof(String.valueOf(result.get('totalCount')));
                newTotalAmount = modelMap.get(model).get('totalAmount') + Decimal.valueof(String.valueOf(result.get('totalAmount')));
                newSaTotalCount = newTotalCount * winRate;
                newSaTotalAmount = newTotalAmount * winRate;
                            
                if(newTotalAmount != 0 && newTotalCount != 0){
                    newtotalRevenuePerEvent = newTotalAmount / newTotalCount;
                }else{
                    newtotalRevenuePerEvent =  0;                          
                }
                
                modelMap.put(model, new Map<String, Decimal>{
                    'totalCount' => newTotalCount, 
                    'saTotalCount' => newSaTotalCount,
                    'totalAmount' => newTotalAmount,
                    'saTotalAmount' => newSaTotalAmount,
                    'totalRevenuePerEvent' => newtotalRevenuePerEvent});
                          
                //populates facility map
                if(!facilityMap.containsKey(facility)){            
                    facilityMap.put(facility, new Map<String, Decimal>{'totalCount' => 0, 'saTotalCount' => 0,'totalAmount' => 0, 'saTotalAmount' => 0, 'totalRevenuePerEvent' => 0});
                }
                
                newTotalCount = facilityMap.get(facility).get('totalCount') + Decimal.valueof(String.valueOf(result.get('totalCount')));
                newTotalAmount = facilityMap.get(facility).get('totalAmount') + Decimal.valueof(String.valueOf(result.get('totalAmount')));
                newSaTotalCount = newTotalCount * winRate;
                newSaTotalAmount = newTotalAmount * winRate;
                        
                if(newTotalAmount != 0 && newTotalCount != 0){
                    newtotalRevenuePerEvent = newTotalAmount / newTotalCount;
                }else{
                    newtotalRevenuePerEvent =  0;                          
                }
                                                       
                facilityMap.put(facility,new Map<String, Decimal>{
                    'totalCount' => newTotalCount, 
                    'saTotalCount' => newSaTotalCount,
                    'totalAmount' => newTotalAmount,
                    'saTotalAmount' => newSaTotalAmount,
                    'totalRevenuePerEvent' => newtotalRevenuePerEvent});
             
                if(String.valueOf(result.get('SubType__c'))=='TFE731 - MPI'){
                   mpiTotalRevenue += Decimal.valueof(String.valueOf(result.get('totalAmount')));
                   mpiTotalCount += Decimal.valueof(String.valueOf(result.get('totalCount')));
                }
                
                if(String.valueOf(result.get('SubType__c'))=='TFE731 - CZI'){
                   cziTotalRevenue += Decimal.valueof(String.valueOf(result.get('totalAmount')));
                   cziTotalCount += Decimal.valueof(String.valueOf(result.get('totalCount')));
                }          
            }
             
            if(totalRevenue != 0 && totalCount != 0){
                totalRevenuePerEvent = totalRevenue / totalCount;
            }else{
                totalRevenuePerEvent = 0;
            }
            
            if(mpiTotalRevenue != 0 && mpiTotalCount != 0){
                mpiTotalRevenuePerEvent = mpiTotalRevenue / mpiTotalCount;
            }else{
                mpiTotalRevenue = 0;        
            }
            
            if(cziTotalRevenue != 0 && cziTotalCount != 0){
                cziTotalRevenuePerEvent = cziTotalRevenue / cziTotalCount;
            }else{
                cziTotalRevenuePerEvent = 0;        
            }
           
            saTotalCount = totalCount * winRate; 
            saTotalRevenue = totalRevenue * winRate;
            
            saMPI_TotalCount = mpiTotalCount * winRate;
            saMPI_TotalRevenue = mpiTotalRevenue * winRate;
            
            saCZI_TotalCount = cziTotalCount * winRate;
            saCZI_TotalRevenue = cziTotalRevenue * winRate;
            
            enableXL = false;        
        
            if(opps.Size() == 0 )
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Opportunities Found'));
        
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Opportunities Found'));
        }
    }
     
    // runs the search with parameters passed via Javascript
    public PageReference runSearch() {

        String inputDate = Apexpages.currentPage().getParameters().get('inputDate');
        String outputDate = Apexpages.currentPage().getParameters().get('outputDate');
        String viabilityRating = Apexpages.currentPage().getParameters().get('viabilityRating');
        String confidenceRating = Apexpages.currentPage().getParameters().get('confidenceRating');
        
        String MPI = 'TFE731 - MPI';
        String CZI = 'TFE731 - CZI';
        
        soql = 'Select Name, Equipment__r.Model__c, Equipment__r.MaintenancePrgmType__c ,facility__c, SubType__c, Count(Id) totalCount, Sum(Amount) totalAmount From Opportunity where InputDate__c >= ' + inputDate + ' And OutputDate__c <= ' + outputDate;    
        soqlOpps = 'Select Name, Equipment__c, Type, SubType2__r.Name, StageName, InputDate__c, OutputDate__c, Probability, SubType__c, Owner.Name, Amount, Facility__c, Next_Step_Dialogue__c, ';
        soqlOpps += ' Equipment__r.LastHours__c, Equipment__r.LastHoursDate__c, Equipment__r.Average_Monthly_Hours__c, Equipment__r.MPIInterval__c, Equipment__r.CZIINTVL__c, ';
        soqlOpps += ' Equipment__r.Model__c, Equipment__r.LastMPI__c, Equipment__r.LASTCZI__c, Aircraft_Area__c From Opportunity where (OutputDate__c >= ' + inputDate + ' And OutputDate__c <= ' + outputDate + ')'; 
        
        if (!stage.IsEmpty() && stage != null){
            soql += ' and StageName In: stage';
        	soqlOpps += ' and StageName In: stage';
        }
        
        if(viabilityRating != null && viabilityRating != ''){
            soql += ' and Equipment__r.Opportunity_Viability_Rating__c >= ' + viabilityRating;
            soqlOpps += ' and Equipment__r.Opportunity_Viability_Rating__c >= ' + viabilityRating;
        }
        
        if(confidenceRating != null && confidenceRating != ''){
        	soql += ' and Equipment__r.Opportunity_Confidence_Rating__c >= ' + confidenceRating;
            soqlOpps += ' and Equipment__r.Opportunity_Confidence_Rating__c >= ' + confidenceRating;
        }
               
        if (!selected_Facility.IsEmpty() && selected_Facility != null){
            soql += ' and Facility__c In: selected_Facility';
        	soqlOpps += ' and Facility__c In: selected_Facility';
        }
        
        if (!selected_MxPrgm.IsEmpty() && selected_MxPrgm != null){
            
            for(String s : selected_MxPrgm){ 
                for(String mxp : mxPrgmsMap.get(s)){
                	mxPrgms.add(mxp);
                }
            }

            soql += ' and Equipment__r.MaintenancePrgmType__c In: mxPrgms';
            soqlOpps +=' and Equipment__r.MaintenancePrgmType__c In: mxPrgms';
        }
        
        if (!selected_Model.IsEmpty() && selected_Model != null){
            soql += ' and Equipment__r.Model__c In: selected_Model';
        	soqlOpps +=' and Equipment__r.Model__c In: selected_Model';
        }
        
        soql += ' and (SubType__c = \'' + MPI + '\' or SubType__c = \'' + CZI + '\') GROUP BY Facility__c, SubType__c, Name, Equipment__r.Model__c, Equipment__r.MaintenancePrgmType__c';
        soqlOpps += ' and (SubType__c = \'' + MPI + '\' or SubType__c = \'' + CZI + '\')';
        
        runQuery();
  
        return null;
    }
               
    public Set<String> stageValues {
    	get {
      		if (stageValues == null){
        		stageValues = new Set<String>();
        		Schema.DescribeFieldResult field = Opportunity.StageName.getDescribe();

        		for (Schema.PicklistEntry s : field.getPicklistValues())
          			stageValues.add(s.getLabel());
      		}
      		return stageValues;          
    	}
    	set;
  	}
    
	public List<String> facilityValues {
    	get {
      		if (facilityValues == null){
        		facilityValues = new List<String>();
        		Schema.DescribeFieldResult field = Opportunity.facility__c.getDescribe();

        		for (Schema.PicklistEntry f : field.getPicklistValues())
          			facilityValues.add(f.getLabel());
      		}
      		return facilityValues;          
    	}
    	set;
  	}
    
	public Set<String> mxPrgmValues = new Set<String>{'MSP','JSSI','Retail'};
    
	public List<String> modelValues {
    	get {
      		if (modelValues == null){
        		modelValues = new List<String>();
        		Schema.DescribeFieldResult field = Equipment__c.Model__c.getDescribe();

                for (Schema.PicklistEntry f : field.getPicklistValues()){
          				modelValues.add(f.getLabel());
                }
      		}
      		return modelValues;          
    	}
    	set;
  	}
     
    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftStageValues.remove(s);
            rightStageValues.add(s);
        }
        return null;
    }
     
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightStageValues.remove(s);
            leftStageValues.add(s);
        }
        return null;
    }
    
	public PageReference selectclick_FAC(){
        rightselected.clear();
        for(String s : leftselected_FAC){
            leftFacilityValues.remove(s);
            rightFacilityValues.add(s);
        }
        return null;
    }
     
    public PageReference unselectclick_FAC(){
        leftselected.clear();
        for(String s : rightselected_FAC){
            rightFacilityValues.remove(s);
            leftFacilityValues.add(s);
        }
        return null;
    }
    
	public PageReference selectclick_mx(){
        rightselected.clear();
        for(String s : leftselected_mx){
            leftMxPrgmValues.remove(s);
            rightMxPrgmValues.add(s);
        }
        return null;
    }
     
    public PageReference unselectclick_mx(){
        leftselected.clear();
        for(String s : rightselected_mx){
            rightMxPrgmValues.remove(s);
            leftMxPrgmValues.add(s);
        }
        return null;
    }
    
	public PageReference selectclick_mod(){
        rightselected.clear();
        for(String s : leftselected_mod){
            leftModelValues.remove(s);
            rightModelValues.add(s);
        }
        return null;
    }
     
    public PageReference unselectclick_mod(){
        leftselected.clear();
        for(String s : rightselected_mod){
            rightModelValues.remove(s);
            leftModelValues.add(s);
        }
        return null;
    }
 
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftStageValues);
        tempList.sort();
        for(string s : tempList){
            options.add(new SelectOption(s,s));
        	stage.remove(s);
        }
        
        return options;
    }
    
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightStageValues);
        tempList.sort();
        for(String s : tempList){
            options.add(new SelectOption(s,s));
            stage.add(s);
        }       
        return options;
    }
    
	public List<SelectOption> getunSelectedValues_FAC(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftFacilityValues);
        tempList.sort();
        for(string s : tempList){
            options.add(new SelectOption(s,s));
        	selected_Facility.remove(s);
        }
        return options;
    }
    
	public List<SelectOption> getSelectedValues_FAC(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightFacilityValues);
        tempList.sort();
        for(String s : tempList){
            options.add(new SelectOption(s,s));
            selected_Facility.add(s);
        }       
        return options;
    }
    
	public List<SelectOption> getunSelectedValues_mx(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftMxPrgmValues);
        tempList.sort();
        for(string s : tempList){
            options.add(new SelectOption(s,s));
        	selected_MxPrgm.remove(s);
        }
        return options;
    }
    
	public List<SelectOption> getSelectedValues_mx(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightMxPrgmValues);
        tempList.sort();
        for(String s : tempList){
            options.add(new SelectOption(s,s));
            selected_MxPrgm.add(s);
        }   
        return options;
    }
    
	public List<SelectOption> getunSelectedValues_mod(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftModelValues);
        tempList.sort();
        for(string s : tempList){
            options.add(new SelectOption(s,s));
        	selected_Model.remove(s);
        }
        return options;
    }
    
	public List<SelectOption> getSelectedValues_mod(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightModelValues);
        tempList.sort();
        for(String s : tempList){
            options.add(new SelectOption(s,s));
            selected_Model.add(s);
        }   
        return options;
    }
    
	public PageReference csv(){
        PageReference pr = new PageReference('/apex/exportOpportunities');
		return pr;
    }
    
    public string header{get;set;}
    public List<wrapper> lstwrapper {get;set;}
    public class wrapper{
    	public string Name{get; set;}
        public string Stage{get; set;}
        public string Input_Date{get; set;}
        public string Output_Date{get; set;}
        public decimal Probability{get; set;} 
        public string SubType{get; set;} 
        public string Owner{get; set;} 
        public decimal Amount{get; set;} 
        public string Facility{get; set;} 
        public decimal Last_Hours{get; set;} 
        public string Last_Hours_Date{get; set;} 
        public decimal AMH{get; set;} 
        public decimal MPI_Int{get; set;}
        public decimal CZI_Int{get; set;} 
        public string Model{get; set;} 
        public decimal Last_MPI{get; set;} 
        public decimal Last_CZI{get; set;} 
        public string Account_Area{get; set;} 
    }
   
    public string Filetype{get;set;}
  
    public void exportToExcel(){
        try{
            lstwrapper = new List<wrapper>();
            header = 'Name,Stage,Input Date,Output Date,Probability,SubType,Owner,Amount,Facility,Last Hours,Last Hours Date,AMH,MPI Intv,CZI Intv,Model,Last MPI,Last CZI,Account Aera\r'; 
            Filetype = '';
            List<Opportunity> lstOpps = DataBase.Query(soqlOpps);
            if(lstOpps.size() > 0){
                for(Opportunity o : lstOpps){
                    wrapper w = new wrapper();
                    w.Name = '"' + o.Name + '"';
                    w.Stage = o.StageName;
                    w.Input_Date = '"' + string.valueof(o.InputDate__c) + '"';
                    w.Output_Date = '"' + string.valueof(o.OutputDate__c) + '"';
                    w.Probability = o.Probability;
                    w.SubType = o.SubType__c;
                    w.Owner = o.Owner.Name;
                    w.Amount = o.Amount;
                    w.Facility = o.Facility__c;
                    w.Last_Hours = o.Equipment__r.LastHours__c;
                    w.Last_Hours_Date = string.valueof(o.Equipment__r.LastHoursDate__c);
                    w.AMH = o.Equipment__r.Average_Monthly_Hours__c;
                    w.MPI_Int = o.Equipment__r.MPIInterval__c;
                    w.CZI_Int = o.Equipment__r.CZIINTVL__c;
                    w.Model = o.Equipment__r.Model__c;
                    w.Last_MPI = o.Equipment__r.LastMPI__c;
                    w.Last_CZI = o.Equipment__r.LASTCZI__c;
                    w.Account_Area = o.Aircraft_Area__c;
                    lstwrapper.add(w);               
                }             
            }
        }catch (Exception e){
            system.debug(e.getMessage());
        }
    }
}