public class icUpdate {
	@InvocableMethod
    public static void updateIC(List<Id> varPerformanceUser) {
        
        String soql = 'Select ';
        Boolean HTF = False;
        
        //Gets the schema from the project object
        Schema.DescribeSObjectResult objSchema = Performance__c.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objSchema.fields.getmap();
        List<Schema.Picklistentry>sd = fieldmap.get('Short_Dept__c').getDescribe().getpicklistValues();        
        List<String> pickList = new List<String>();
        
        //gets the picklist values to create dynamic query
        //from the Short Dept field picklist options
        for(Schema.Picklistentry pl : sd){
            String fieldValue = pl.getValue();
            if(fieldValue.startsWith('HTF')){                
                if(!HTF){
                    soql += 'Actual_Margin_HTF__c, ';
                    soql += 'Actual_Revenue_HTF__c, ';
                    HTF = True;
                }
            }else{
                soql += 'Actual_Margin_' + fieldValue.replace(' ','_') + '__c, ';
                soql += 'Actual_Revenue_' + fieldValue.replace(' ','_') + '__c, ';            
            }
            picklist.add(fieldValue);            
		}
       
        //complete the soql query
        soql += 'Short_Dept__c, Leader__c, Region_RollUp__c, Role__c, Year__c, Quarter__c, Exclude_Splits__c From Performance__c where Id In: varPerformanceUser';        
        
        //query soql string
        List<Performance__c> perf = Database.query(soql);
       	
        //pass results to new method
        if(perf.Size() > 0)
            refreshIC(perf, pickList);            
    } 
    
	public static void refreshIC(List<Performance__c> perf, List<String> pickList){
    	
        Set<Id> perfPerLeader = new Set<Id>();
        Set<Id> perfPerRegion = new Set<Id>();
        List<String> queriedShortDept = new List<String>();
        
        List<String> shortDept = new List<String>();
        List<String> leaders = new List<String>();    
        List<String> regions = new List<String>(); 
        List<AggregateResult> wod2 = new List<AggregateResult>();
        List<AggregateResult> fmu2 = new List<AggregateResult>();
        
		//if leaders are selected        
        if(perf[0].Leader__c != null){
            
            //split them up into leaders list
            leaders = perf[0].Leader__c.split(';');
            
            //get all leaders performance employees
            for(Performance__c p : [Select Id from Performance__c where Quota_Sales_Employee__r.Leader__c In: leaders and Role__c = 'RSM' and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c]){
                perfPerLeader.add(p.Id);
            }
            system.debug('Performance Leader: ' + perfPerLeader);
        }
        
        //if Regions are Selected       
        if(perf[0].Region_RollUp__c != null){
            
            //split them up into regions list
            regions = perf[0].Region_RollUp__c.split(';');
            
            //get all leaders performance employees
            for(Performance__c p : [Select Id from Performance__c where Quota_Sales_Employee__r.Quota_Sales_Region__r.Region__c In: regions and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c]){
                perfPerRegion.add(p.Id);
            }
        }
        
        //if short dept are selected split them up into shortDept list
        if(perf[0].Short_Dept__c != null)
            shortDept = perf[0].Short_Dept__c.split(';');        
        
        List<AggregateResult> wod = [Select Short_Dept__c, sum(GL_Sale__c) Revenue, sum(GL_Margin__c) Margin from WO_Detail__c where Short_Dept__c Not In: shortDept and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Consensus_RSM__c =: perf[0].Id and Exclude__c = False Group By Short_Dept__c];
             
        //Funnel Management Eligable
    	AggregateResult[] fmu = [Select sum(GL_Sale__c) Revenue From WO_Detail__c where Short_Dept__c Not In: shortDept and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Consensus_RSM__c =: perf[0].Id and Exclude__c = False and Funnel_Management__c = 'Yes']; 
                
        //Short Dept & Leaders & Regions
        if(perf[0].Short_Dept__c != null && perf[0].Leader__c != null && perf[0].Region_RollUp__c != null){
            wod2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue, sum(GL_Margin__c) Margin from WO_Detail__c where (Consensus_RSM__c In: perfPerLeader and consensus_RSM__c In: perfPerRegion) and Short_Dept__c In: shortDept and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False Group By Short_Dept__c];
            fmu2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue from WO_Detail__c where (Consensus_RSM__c In: perfPerLeader and consensus_RSM__c In: perfPerRegion) and Short_Dept__c In: shortDept and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False and Funnel_Management__c = 'Yes' Group By Short_Dept__c];                    
        }
        
        //Short Dept & Leaders
        else if (perf[0].Short_Dept__c != null && perf[0].Leader__c != null && perf[0].Region_RollUp__c == null){
            wod2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue, sum(GL_Margin__c) Margin from WO_Detail__c where Consensus_RSM__c In: perfPerLeader and Short_Dept__c In: shortDept and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False Group By Short_Dept__c];
            fmu2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue from WO_Detail__c where Consensus_RSM__c In: perfPerLeader and Short_Dept__c In: shortDept and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False and Funnel_Management__c = 'Yes' Group By Short_Dept__c];
        }
        
        //Short Dept & Regions
        else if (perf[0].Short_Dept__c != null && perf[0].Leader__c == null && perf[0].Region_RollUp__c != null){
            wod2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue, sum(GL_Margin__c) Margin from WO_Detail__c where Short_Dept__c In: shortDept and consensus_RSM__c In: perfPerRegion and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False Group By Short_Dept__c];
            fmu2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue from WO_Detail__c where Short_Dept__c In: shortDept and consensus_RSM__c In: perfPerRegion and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False and Funnel_Management__c = 'Yes' Group By Short_Dept__c];
        }
        
        //Short Dept Only
        else if (perf[0].Short_Dept__c != null && perf[0].Leader__c == null && perf[0].Region_RollUp__c == null){
            wod2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue, sum(GL_Margin__c) Margin from WO_Detail__c where Short_Dept__c In: shortDept and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False Group By Short_Dept__c];
            fmu2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue from WO_Detail__c where Short_Dept__c In: shortDept and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False and Funnel_Management__c = 'Yes' Group By Short_Dept__c];
        }
        
        //Leaders & Region
        else if (perf[0].Short_Dept__c == null && perf[0].Leader__c != null && perf[0].Region_RollUp__c != null){
            wod2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue, sum(GL_Margin__c) Margin from WO_Detail__c where (Consensus_RSM__c In: perfPerLeader and consensus_RSM__c In: perfPerRegion) and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False Group By Short_Dept__c];
            fmu2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue from WO_Detail__c where (Consensus_RSM__c In: perfPerLeader and consensus_RSM__c In: perfPerRegion) and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False and Funnel_Management__c = 'Yes' Group By Short_Dept__c];
        }
        
        //Leaders Only
        else if (perf[0].Short_Dept__c == null && perf[0].Leader__c != null && perf[0].Region_RollUp__c == null){
            wod2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue, sum(GL_Margin__c) Margin from WO_Detail__c where Consensus_RSM__c In: perfPerLeader and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False Group By Short_Dept__c];
            fmu2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue from WO_Detail__c where Consensus_RSM__c In: perfPerLeader and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False and Funnel_Management__c = 'Yes' Group By Short_Dept__c];
        }
        
        //Region Only
        else if (perf[0].Short_Dept__c == null && perf[0].Leader__c == null && perf[0].Region_RollUp__c != null){
            wod2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue, sum(GL_Margin__c) Margin from WO_Detail__c where consensus_RSM__c In: perfPerRegion and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False Group By Short_Dept__c];
            fmu2 = [Select Short_Dept__c, sum(GL_Sale__c) Revenue from WO_Detail__c where consensus_RSM__c In: perfPerRegion and Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False and Funnel_Management__c = 'Yes' Group By Short_Dept__c];
        }
                       
        //combine all list together
        wod.addAll(wod2);
        fmu.addAll(fmu2);
        
        Decimal htfMargin = 0;
        Decimal htfRevenue = 0;
        
        //update Performance Record
        for(Performance__c p : perf){
            
            //loop through aggregate results
            for (AggregateResult ar : wod){
                
                //determine if Short Dept Starts with HTF
                String sd = String.valueOf(ar.get('Short_Dept__c'));
                queriedShortDept.add(sd);
                
                //if short dept is does begin with HTF, Add Margin and Revenues to HTF Variable
                if(sd.startsWith('HTF')){
                    htfMargin += (Decimal)ar.get('Margin');
                    htfRevenue += (Decimal)ar.get('Revenue');                
                }else{
                    
                    //Creates field names to match Performance field names
                    //Based on what is returned in the aggreate queries short departments
                    String shortDeptRevenue = 'Actual_Revenue_' + ar.get('Short_Dept__c') + '__c';
                    String shortDeptMargin = 'Actual_Margin_' + ar.get('Short_Dept__c') + '__c';
                    
                    system.debug('shortDeptRev: ' + shortDeptRevenue);
                    system.debug('shortDeptMar: ' + shortDeptMargin);
                    
                    p.put(shortDeptRevenue.replace(' ','_'), (Decimal)ar.get('Revenue'));
                    p.put(shortDeptMargin.replace(' ','_'), (Decimal)ar.get('Margin'));    
                }
            }
            
            //Funnel Management
            for (AggregateResult ar : fmu){
            	p.put('Actual_Revenue_Funnel_Management__c', (Decimal)ar.get('Revenue'));
            }
                
            p.put('Actual_Revenue_HTF__c', htfRevenue);
            p.put('Actual_Margin_HTF__c', htfMargin);            
        
            for(String pl : picklist){
                if(!queriedShortDept.contains(pl) && !pl.startsWith('HTF')){
                    String shortDeptRevenue = 'Actual_Revenue_' + pl + '__c';
                    String shortDeptMargin = 'Actual_Margin_' + pl + '__c';
                    
                    p.put(shortDeptRevenue.replace(' ','_'), 0);
                    p.put(shortDeptMargin.replace(' ','_'), 0);               
                }            
            }          
        }
     	
        if(perf[0].Role__c == 'RSM'){
        	rsmUpdateSplits(perf);           
        } else if(perf[0].Role__c == 'RSD' || perf[0].Role__c == 'ESM' && perfPerLeader.Size() > 0 && !perf[0].Exclude_Splits__c){            
        	rsdUpdateSplits(perf, pickList, perfPerLeader);              
        } else if (perf[0].Role__c == 'Other') {           
        	update perf;           
        } else {
        	perf[0].put('Actual_Revenue_Non_Engine_Splits__c', 0);
			perf[0].put('Actual_Margin_Non_Engine_Splits__c', 0); 
			perf[0].put('Actual_Revenue_Engines_Split__c', 0);
            perf[0].put('Actual_Margin_Engines_Splits__c', 0);

            update perf;
        }                       
    } 
    
	public static void rsmUpdateSplits(List<Performance__c> perf){
        
        String Year = perf[0].Year__c;
        String Qtr = perf[0].Quarter__c;
        String Role = 'RSM';
        String soql = 'Select Count() from Performance__c where Role__c =: Role and Year__c =: Year and Quarter__c =: Qtr';
        String perfAirlineName = perf[0].Year__c + ' ' + perf[0].Quarter__c + ' - Airline';
        String perfRentalName = perf[0].Year__c + ' ' + perf[0].Quarter__c + ' - Rental';
        
        Integer rsmCount = database.countQuery(soql);
        
        Performance__c Airline = [Select Id from Performance__c where Name =: perfAirlineName];
        Performance__c Rental = [Select Id from Performance__c where Name =: perfRentalName];
       
        For(AggregateResult w : [Select Consensus_RSM__c, sum(GL_Margin__c) Margin, sum(GL_Sale__c) Revenue from WO_Detail__c where Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False and (Consensus_RSM__c =: Airline.Id or Consensus_RSM__c =: Rental.Id) Group By Consensus_RSM__c]){
            
            String conRSM = String.valueOf(w.get('Consensus_RSM__c'));
            
            if(conRSM == Airline.Id){
            	perf[0].put('Actual_Revenue_Non_Engine_Splits__c', ((Decimal)w.get('Revenue')/rsmCount));
            	perf[0].put('Actual_Margin_Non_Engine_Splits__c', ((Decimal)w.get('Margin')/rsmCount)); 
            } else if (conRSM == Rental.Id){
            	perf[0].put('Actual_Revenue_Engines_Split__c', ((Decimal)w.get('Revenue')/rsmCount));
            	perf[0].put('Actual_Margin_Engines_Splits__c', ((Decimal)w.get('Margin')/rsmCount));
            }
        }
        
        update perf;         
    }
    
 	public static void rsdUpdateSplits(List<Performance__c> perf, List<String> pickList, Set<Id> perfPerLeader){
       
        String Year = perf[0].Year__c;
        String Qtr = perf[0].Quarter__c;
        String Role = 'RSM';
        String soql = 'Select Count() from Performance__c where Role__c =: Role and Year__c =: Year and Quarter__c =: Qtr';        
        
        String perfAirlineName = perf[0].Year__c + ' ' + perf[0].Quarter__c + ' - Airline';
        String perfRentalName = perf[0].Year__c + ' ' + perf[0].Quarter__c + ' - Rental';
        
        Integer rsmCount = database.countQuery(soql);
        Integer rsdRsmCount = perfPerLeader.Size();
               
        Performance__c Airline = [Select Id from Performance__c where Name =: perfAirlineName];
        Performance__c Rental = [Select Id from Performance__c where Name =: perfRentalName];
    
        For(AggregateResult w : [Select Consensus_RSM__c, sum(GL_Margin__c) Margin, sum(GL_Sale__c) Revenue from WO_Detail__c where Year__c =: perf[0].Year__c and Quarter__c =: perf[0].Quarter__c and Exclude__c = False and (Consensus_RSM__c =: Airline.Id or Consensus_RSM__c =: Rental.Id) Group By Consensus_RSM__c]){
            
            String conRSM = String.valueOf(w.get('Consensus_RSM__c'));
            
            if(conRSM == Airline.Id){
            	perf[0].put('Actual_Revenue_Non_Engine_Splits__c', ((Decimal)w.get('Revenue')/rsmCount)*rsdRsmCount);
                system.debug('Non Engine Revenue Split: ' + (Decimal)w.get('Revenue'));
            	perf[0].put('Actual_Margin_Non_Engine_Splits__c', ((Decimal)w.get('Margin')/rsmCount)*rsdRsmCount); 
                system.debug('Non Engine Margin Split: ' + (Decimal)w.get('Margin'));
            } else if (conRSM == Rental.Id){
            	perf[0].put('Actual_Revenue_Engines_Split__c', ((Decimal)w.get('Revenue')/rsmCount)*rsdRsmCount);
                system.debug('Engine Revenue Split: ' + (Decimal)w.get('Revenue'));
            	perf[0].put('Actual_Margin_Engines_Splits__c', ((Decimal)w.get('Margin')/rsmCount)*rsdRsmCount);
                system.debug('Engine Margin Split: ' + (Decimal)w.get('Margin'));
            }
        }
        
    	update perf;              
    }           
}