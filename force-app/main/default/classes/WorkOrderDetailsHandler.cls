public class WorkOrderDetailsHandler{

    public void beforeInsertTrigger(List<WO_Detail__c> workOrders){
        
        Map<String, Id> woOppMap = new Map<String, Id>();
        Map<String, Id> performanceMap = new Map<String, Id>();
       
        Map<String, Performance__c> performanceAdminMap = new Map<String, Performance__c>();
        Map<String, Performance__c> performanceDefaultMap = new Map<String, Performance__c>();
        Map<String, Work_Order_Detail_Reference__c> wodRefMap = new Map<String, Work_Order_Detail_Reference__c>();    
        
        Map<String, List<String>> accountMap = new Map<String, List<String>>();    
        Map<String, List<String>> oppMap = new Map<String, List<String>>();  
        Map<String, List<String>> oppWonMap = new Map<String, List<String>>();
        Map<String, List<String>> mstMap = new Map<String, List<String>>();   
        
        Set<String> performanceOwner = new Set<String>();   
        Set<String> Date_Ref = new Set<String>();
        Set<String> quote = new Set<String>();
        Set<String> oppType = new Set<String>();
        //Set<Integer> inputYear = new Set<Integer>();
        //Set<String> aircraft = new Set<String>();
        //Set<String> equipment = new Set<String>();
        Set<Integer> won = new Set<Integer>();
        Set<String> cust = new Set<String>();
        Set<String> eventCode = new Set<String>();
        Set<String> mstDispatch = new Set<String>(); 
                
        for(WO_Detail__c wo : workOrders){ 
            
            if(!wo.Locked__c){
                
                //To look update Opportunity In date range
                /*if(wo.Start_Date__c != null)
                    inputYear.add(wo.Start_Date__c.month());
                
                system.debug('year: ' + inputYear);*/
                
                //Matches Opportunity With WO#
                if(wo.WO__c != null && wo.WO__c.isNumeric())
                    won.add(integer.valueOf(wo.WO__c));
                
                //To look up Opportunity
                if(wo.Quote__c != null && wo.Quote__c.length() >= 5) 
                    quote.add(wo.Quote__c.substring(0,5));
                
                //Looks up to Account
                if(wo.Customer__c != null)
                    cust.add(wo.Customer__c);
                               
                //Looks Up Short Dept
                if(wo.Event_Code__c != null){
                    eventCode.add(wo.Event_Code__c);
                    
                    //Gets Equipment SN
                    /*if(wo.TFE_S_N__c != null){
                        String eq = wo.TFE_S_N__c;
                        eq = eq.toUpperCase();
                        eq = eq.removeEnd('C');
                        
                        equipment.add(eq);           
                    }
                    
                    system.debug('Equipment: ' + equipment);
                    
                    //Get Aircraft SN
                    if(wo.A_C_S_N__c != null)
                        aircraft.add(wo.A_C_S_N__c);*/
                    
                    if(wo.Event_Code__c.substring(0,2) == 'BA' && wo.WO__c != null)
                        mstDispatch.add(wo.WO__c);
                }
                
                //Used to look up Performance Records
                if(wo.Dispatch_date__c != null)         
                    Date_Ref.add(wo.Dispatch_date__c.year() + ' Q' + Math.ceil(Decimal.valueOf(wo.Dispatch_date__c.Month())/3).intValue());
            }
        }
               
        if(!Date_Ref.IsEmpty()){
            perfDefaultRecord(Date_Ref, performanceAdminMap, performanceDefaultMap);
            
            //oppEngineMap(inputYear, equipment, cust, oppType, oppMap, woOppMap);
            
            if(!won.isEmpty())
            	oppWON(Date_Ref, won, oppWonMap, performanceOwner, woOppMap);
                                      
            if(!eventCode.IsEmpty())
                eventCode(Date_Ref, eventCode, wodRefMap, oppType);                            
            
            if(!quote.IsEmpty())
                quoteNumber(Date_Ref, quote, performanceOwner, oppMap, woOppMap);
            
            if(!cust.IsEmpty())
                customerNumber(Date_Ref, cust, performanceOwner, accountMap);
            
            if(!mstDispatch.IsEmpty())
                mstAircraftAccountOwner(Date_Ref, mstDispatch, performanceOwner, mstMap);
            
            system.debug('Performance Owner: ' + performanceOwner);
        
            if(!performanceOwner.IsEmpty())
                performanceOwner(performanceOwner, oppMap, accountMap, mstMap, performanceMap, oppWonMap);
        }
               
        for(WO_Detail__c wo : workOrders){
            
            if(!wo.Locked__c){
            
                //Which system to include in the wo name
                //Reset qtr from Dispatch Date
                String nd = null;           
                String qtr = null;
                
                if(wo.System__c == 'VECTOR AEROSPACE INT\'L LIMITED'){
                    if(wo.TFE_S_N__c != null){
                        if( WO.Short_Eng_Model__c == 'TFE'){                    
                            nd = 'Navixa.TFE.' + wo.TFE_S_N__c;
                            nd = nd.replace('P-', '');
                        }else if( wo.Short_Eng_Model__c == 'PW300'){
                            if(wo.TFE_Model__c != null){
                            	nd = wo.TFE_Model__c;                    
                           	 	nd = 'Navixa.PW.' + wo.TFE_S_N__c + ' (' + nd.right(4) + ')'; 
                            	wo.Prod_Line__c = wo.TFE_Model__c;
                            }
                            wo.Event_Code__c = 'Off';
                        }
                    }else{
                        nd = 'Navixa.Pending';
                    }
                    wo.System__c = 'Navixa'; 
                }else if(wo.TCN_SA_Menu__c != null){
                    wo.System__c = 'SA Menu';
                    nd = wo.TCN_SA_Menu__c;               
                }else{
                    nd = wo.WO__c;
                    wo.System__c = 'RPA';
                }
                
                //Names Work Order Detail
                if (wo.Dispatch_date__c != null){
                    qtr = wo.Dispatch_date__c.year() + ' Q' + Math.ceil(Decimal.valueOf(wo.Dispatch_date__c.Month())/3).intValue();
                    wo.Name = qtr + ' - ' + nd + ' - ' + wo.Dispatch_date__c.Month() + '/' + wo.Dispatch_date__c.Day();
                }else{
                    wo.Name = 'Pending';
                } 
                
                //populates Short Dept fields
                if(wodRefMap.containsKey(wo.Event_Code__c)){
                    wo.Short_Dept__c = wodRefMap.get(wo.Event_Code__c).Short_Dept__c;
                    wo.Workscope__c = wodRefMap.get(wo.Event_Code__c).Workscope__c;
                    wo.Engine_Prefix__c = wodRefMap.get(wo.Event_Code__c).Prefix__c;
                    wo.Category__c = wodRefMap.get(wo.Event_Code__c).Category__c;
                    wo.Type__c = wodRefMap.get(wo.Event_Code__c).Type__c;                       
                }
                
                //populates Consensus RSM from Map
                if(wo.Name != 'Pending'){
                    
                    //Navixa and SA Menu
                    if(wo.System__c != 'RPA' && performanceDefaultMap.containskey(qtr)){
                        wo.Consensus_RSM__c = performanceDefaultMap.get(qtr).Id;
                        wo.Source_of_Consensus_RSM__c = wo.System__c;
                    }else{
                        
                        //Default Consensus RSM to Admin
                        if(wo.Short_Dept__c == 'Other' && performanceAdminMap.containskey(qtr)){
                            wo.Consensus_RSM__c = performanceAdminMap.get(qtr).Id;
                            wo.Source_of_Consensus_RSM__c = 'Short Dept: Other';
                        }else 
                            
                            // Update To MST Reference
                            if(wo.Event_Code__c != null && wo.Event_Code__c.substring(0,2) == 'BA' && performanceMap.containskey(qtr + ' ' + wo.WO__c)){                      
                                wo.Consensus_RSM__c = performanceMap.get(qtr + ' ' + wo.WO__c);
                                wo.Source_of_Consensus_RSM__c = 'MST Dispatch';
                            }else 
                                
                                //Update From Opportunity Using WO #
                                if(wo.WO__c != null){
                    				wo.Opportunity__c = woOppMap.get(wo.WO__c);
                                    if(performanceMap.containskey(wo.WO__c)){
                                        wo.Consensus_RSM__c = performanceMap.get(wo.WO__c);
                                        wo.Source_of_Consensus_RSM__c = 'Opportunity';
                                    }
                                }else
                                    
                                    //Update From Opportunity Using Quote Number
                                    if(wo.Quote__c != null && wo.Quote__c.length() >= 5 && performanceMap.containskey(qtr + ' ' + wo.Quote__c.substring(0,5))){
                                        wo.Consensus_RSM__c = performanceMap.get(qtr + ' ' + wo.Quote__c.substring(0,5));
                                        wo.Source_of_Consensus_RSM__c = 'Opportunity';
                                        wo.Opportunity__c = woOppMap.get(wo.OP_Reference__c);              
                                    }else 
                                        
                                        //Update From Account Using Customer Number
                                        if(wo.Customer__c != null && performanceMap.containskey(qtr + ' ' + wo.Customer__c)){                           
                                            wo.Consensus_RSM__c = performanceMap.get(qtr + ' ' + wo.Customer__c);
                                            wo.Source_of_Consensus_RSM__c = 'Account';   
                                        }else{
                                            wo.Source_of_Consensus_RSM__c = 'Needs Review';                   
                                        }
                    }
                }else{
                    if(wo.Customer__c != null)
                        system.debug('Work Order Detail Account: ' + wo.Customer__c);
                    wo.Source_of_Consensus_RSM__c = 'Needs Review';
                }
            }
        }
    }
    
    //Map Performance Records To MTS Dispatch
    public static void mstAircraftAccountOwner(Set<String> Date_Ref, Set<String> mstDispatch, Set<String> performanceOwner, Map<String, List<String>> mstMap){
        for(MST_Dispatch__c mst : [Select RPA_Work_Order_Num__c, Aircraft__r.Account__r.OwnerId from MST_Dispatch__c where RPA_Work_Order_Num__c In: mstDispatch]){                       
            for(String dr : Date_Ref){
                String owner = dr + ' ' + mst.Aircraft__r.Account__r.OwnerId;
                String reference = dr + ' ' + mst.RPA_Work_Order_Num__c;                               
                
                performanceOwner.add(owner);
                                
                if(mstMap.containsKey(owner)){
                    List<String> mstWO = mstMap.get(owner);
                    mstWO.add(reference);
                    mstMap.put(owner, mstWO);
                }else{
                    mstMap.put(owner, new List<String> {reference});
                }             
            }  
        }
    }
    
    //Map Performance Records To Admin Record
    public static void perfDefaultRecord(Set<String> Date_Ref, Map<String, Performance__c> performanceAdminMap, Map<String, Performance__c> performanceDefaultMap){
        for(Performance__c p : [Select Id, Name, Performance_Owner__c, Year_Quarter__c from Performance__c where Year_Quarter__c In: Date_Ref and (Name Like '%Administrative' or Name Like '%Gillette')]){
            String pName = p.Name; 
            if(pName.contains('Administrative')){
                if(!performanceAdminMap.containsKey(p.Year_Quarter__c)){
                    performanceAdminMap.put(p.Year_Quarter__c, p);
                }
            }else{
                if(!performanceDefaultMap.containsKey(p.Year_Quarter__c)){
                    performanceDefaultMap.put(p.Year_Quarter__c, p);  
                }   
            }
        }
    }
    
    //Map Work Order Detail Reference To Event Code
    public static void eventCode(Set<String> Date_Ref, Set<String> eventCode, Map<String, Work_Order_Detail_Reference__c> wodRefMap, Set<String> oppType){
        for(Work_Order_Detail_Reference__c wodr : [Select Id, Name, Short_Dept__c, Workscope__c, Type__c, Prefix__c, Category__c from Work_Order_Detail_Reference__c where Name In: eventCode]){
            if(!wodRefMap.containsKey(wodr.Name)){
                wodRefMap.put(wodr.Name, wodr);
                //oppType.add(wodr.Type__c);
            }     
        }
    }
    
    //Match Performance Records To Opportunity Via Mulitple Fields
    /*public static void oppEngineMap(Set<Integer> inputYear, Set<String> equipment, Set<String> cust, Set<String> oppType, Map<String, List<String>> oppMap, Map<String, Id> woOppMap){

        for(Opportunity o : [Select Id, Name from Opportunity where Type In: oppType
                             AND StageName = 'RFS' 
                             AND Account.RPACustomerNumber__c In: cust 
                             AND CALENDAR_MONTH(InputDate__c) In: inputYear 
                             AND wodReference__c In: equipment]){
                                 
                                 system.debug('Opportunity: ' + o.Id);
              
            
        }
    }*/
    
    public static void oppWON(Set<String> Date_Ref, Set<Integer> won, Map<String, List<String>> oppWonMap, Set<String> performanceOwner,Map<String, Id> woOppMap){      
        
        Set<Integer> wonList = new Set<Integer>();
        wonList.addAll(won);
        
        //RPA WO1
        for(Opportunity o : [Select Id, Name, OwnerId, Owner.LastName, RPAWorkOrderNum__c from Opportunity where StageName = 'RFS' AND RPAWorkOrderNum__c In: wonList]){                  
        	wonList.remove(integer.valueof(o.RPAWorkOrderNum__c));
            system.debug('Opportunity: ' + o.Name);
            for(String dr : Date_Ref){
                String owner = dr + ' ' + o.OwnerId;
                String reference = string.valueOf(o.RPAWorkOrderNum__c);                               
                
                performanceOwner.add(owner);
                
                if(!woOppMap.containsKey(reference))
                    woOppMap.put(reference, o.id);
                              
                if(oppWonMap.containsKey(owner)){
                    List<String> woRef = oppWonMap.get(owner);
                    woRef.add(reference);
                    oppWonMap.put(owner, woRef);
                }else{
                    oppWonMap.put(owner, new List<String> {reference});
                }  
            }                                  
    	}
        
        //RPA WO2
        if(!wonList.IsEmpty()){
            for(Opportunity o : [Select Id, Name, OwnerId, Owner.LastName, Additional_RPA_Work_Order_Numbers__c from Opportunity where StageName = 'RFS' AND Additional_RPA_Work_Order_Numbers__c In: wonList]){           
                
                for(String dr : Date_Ref){
                    String owner = dr + ' ' + o.OwnerId;
                    String reference = string.valueOf(o.Additional_RPA_Work_Order_Numbers__c);                               
                    
                    performanceOwner.add(owner);
                    
                    if(!woOppMap.containsKey(reference))
                        woOppMap.put(reference, o.id);
                    
                    if(oppWonMap.containsKey(owner)){
                        List<String> woRef = oppWonMap.get(owner);
                        woRef.add(reference);
                        oppWonMap.put(owner, woRef);
                    }else{
                        oppWonMap.put(owner, new List<String> {reference});
                    }  
                }                                  
            }
        }
        
        //RPA WO3
        if(!wonList.IsEmpty()){
            for(Opportunity o : [Select Id, Name, OwnerId, Owner.LastName, RPA_WO_3__c from Opportunity where StageName = 'RFS' AND RPA_WO_3__c In: wonList]){           
                
                for(String dr : Date_Ref){
                    String owner = dr + ' ' + o.OwnerId;
                    String reference = string.valueOf(o.RPA_WO_3__c);                               
                    
                    performanceOwner.add(owner);
                    
                    if(!woOppMap.containsKey(reference))
                        woOppMap.put(reference, o.id);
                    
                    if(oppWonMap.containsKey(owner)){
                        List<String> woRef = oppWonMap.get(owner);
                        woRef.add(reference);
                        oppWonMap.put(owner, woRef);
                    }else{
                        oppWonMap.put(owner, new List<String> {reference});
                    }  
                }                                  
            }
        }
        
        //RPA WO4
        if(!wonList.IsEmpty()){
            for(Opportunity o : [Select Id, Name, OwnerId, Owner.LastName, RPA_WO_4__c from Opportunity where StageName = 'RFS' AND RPA_WO_4__c In: wonList]){           
                
                for(String dr : Date_Ref){
                    String owner = dr + ' ' + o.OwnerId;
                    String reference = string.valueOf(o.RPA_WO_4__c);                               
                    
                    performanceOwner.add(owner);
                    
                    if(!woOppMap.containsKey(reference))
                        woOppMap.put(reference, o.id);
                    
                    if(oppWonMap.containsKey(owner)){
                        List<String> woRef = oppWonMap.get(owner);
                        woRef.add(reference);
                        oppWonMap.put(owner, woRef);
                    }else{
                        oppWonMap.put(owner, new List<String> {reference});
                    }  
                }                                  
            }
        }
        
        //RPA WO5
        if(!wonList.IsEmpty()){
            for(Opportunity o : [Select Id, Name, OwnerId, Owner.LastName, RPA_WO_5__c from Opportunity where StageName = 'RFS' AND RPA_WO_5__c In: wonList]){           
                
                for(String dr : Date_Ref){
                    String owner = dr + ' ' + o.OwnerId;
                    String reference = string.valueOf(o.RPA_WO_5__c);                               
                    
                    performanceOwner.add(owner);
                    
                    if(!woOppMap.containsKey(reference))
                        woOppMap.put(reference, o.id);
                    
                    if(oppWonMap.containsKey(owner)){
                        List<String> woRef = oppWonMap.get(owner);
                        woRef.add(reference);
                        oppWonMap.put(owner, woRef);
                    }else{
                        oppWonMap.put(owner, new List<String> {reference});
                    }  
                }                                  
            }
        }
        
        //RPA WO6
        if(!wonList.IsEmpty()){
            for(Opportunity o : [Select Id, Name, OwnerId, Owner.LastName, RPA_WO_6__c from Opportunity where StageName = 'RFS' AND RPA_WO_6__c In: wonList]){           
                
                for(String dr : Date_Ref){
                    String owner = dr + ' ' + o.OwnerId;
                    String reference = string.valueOf(o.RPA_WO_6__c);                               
                    
                    performanceOwner.add(owner);
                    
                    if(!woOppMap.containsKey(reference))
                        woOppMap.put(reference, o.id);
                    
                    if(oppWonMap.containsKey(owner)){
                        List<String> woRef = oppWonMap.get(owner);
                        woRef.add(reference);
                        oppWonMap.put(owner, woRef);
                    }else{
                        oppWonMap.put(owner, new List<String> {reference});
                    }  
                }                                  
            }
        }
        
        //RPA WO7
        if(!wonList.IsEmpty()){
            for(Opportunity o : [Select Id, Name, OwnerId, Owner.LastName, RPA_WO_7__c from Opportunity where StageName = 'RFS' AND RPA_WO_7__c In: wonList]){           
                
                for(String dr : Date_Ref){
                    String owner = dr + ' ' + o.OwnerId;
                    String reference = string.valueOf(o.RPA_WO_7__c);                               
                    
                    performanceOwner.add(owner);
                    
                    if(!woOppMap.containsKey(reference))
                        woOppMap.put(reference, o.id);
                    
                    if(oppWonMap.containsKey(owner)){
                        List<String> woRef = oppWonMap.get(owner);
                        woRef.add(reference);
                        oppWonMap.put(owner, woRef);
                    }else{
                        oppWonMap.put(owner, new List<String> {reference});
                    }  
                }                                  
            }
        }
        
        //RPA WO8
        if(!wonList.IsEmpty()){
            for(Opportunity o : [Select Id, Name, OwnerId, Owner.LastName, RPA_WO_8__c from Opportunity where StageName = 'RFS' AND RPA_WO_8__c In: wonList]){           
                
                for(String dr : Date_Ref){
                    String owner = dr + ' ' + o.OwnerId;
                    String reference = string.valueOf(o.RPA_WO_8__c);                               
                    
                    performanceOwner.add(owner);
                    
                    if(!woOppMap.containsKey(reference))
                        woOppMap.put(reference, o.id);
                    
                    if(oppWonMap.containsKey(owner)){
                        List<String> woRef = oppWonMap.get(owner);
                        woRef.add(reference);
                        oppWonMap.put(owner, woRef);
                    }else{
                        oppWonMap.put(owner, new List<String> {reference});
                    }  
                }                                  
            }
        }
        
        system.debug('Won Map: ' + oppWonMap);
    }
    
    //Match Performance Records To Opportunity Via Quote Number
    public static void quoteNumber(Set<String> Date_Ref, Set<String> quote, Set<String> performanceOwner, Map<String, List<String>> oppMap, Map<String, Id> woOppMap){
        
        Id rfsRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RFS').getRecordTypeId();
        
        for(Opportunity o : [Select Id, OwnerId, Owner.LastName, Quote_Reference__c from Opportunity where RecordTypeId =: rfsRecTypeId and Quote_Reference__c In: quote Order By OutputDate__c desc]){
            for(String dr : Date_Ref){
                String owner = dr + ' ' + o.OwnerId;
                String reference = dr + ' ' + o.Quote_Reference__c;                               
                
                performanceOwner.add(owner);
                
                if(!woOppMap.containsKey(reference))
                    woOppMap.put(reference, o.id);
                              
                if(oppMap.containsKey(owner)){
                    List<String> quoteRef = oppMap.get(owner);
                    quoteRef.add(reference);
                    oppMap.put(owner, quoteRef);
                }else{
                    oppMap.put(owner, new List<String> {reference});
                }  
            }
        }
    }
    
    //Match Performance Records To Account via Customer Number
    public static void customerNumber(Set<String> Date_Ref, Set<String> cust, Set<String> performanceOwner, Map<String, List<String>> accountMap){              
        for(Account a : [Select RPACustomerNumber__c, Owner.lastName, X18_Character_Owner_Id__c from Account where RPACustomerNumber__c In: cust and Most_Recent_RFS__c != null Order By Most_Recent_RFS__c desc]){
            for(String dr : Date_Ref){
                String owner = dr + ' ' + a.X18_Character_Owner_Id__c;
                String reference = dr + ' ' + a.RPACustomerNumber__c; 
                         
                performanceOwner.add(owner);
                
                if(accountMap.containsKey(owner)){
                    List<String> custRef = accountMap.get(owner);
                    custRef.add(reference);
                    accountMap.put(owner, custRef);
                }else{
                    accountMap.put(owner, new List<String> {reference});
                }             
            }                     
        }      
    }
    
    //Map Performance Records To Unique Id From Customer Number
    public static void performanceOwner(Set<String> performanceOwner, Map<String, List<String>> oppMap, Map<String, List<String>> accountMap, Map<String, List<String>> mstMap, Map<String, Id> performanceMap, Map<String, List<String>> oppWonMap){        
        for(Performance__c p : [Select Id, Performance_Owner__c, Year_Quarter__c from Performance__c where Performance_Owner__c In: performanceOwner and QSE_Role__c =: 'RSM']){
            system.debug('Performance Id: ' + p.Id);
            
            if(oppWonMap.containsKey(p.Performance_Owner__c)){
                for(Integer i = 0; i < oppWonMap.get(p.Performance_Owner__c).Size(); i++){
                    performanceMap.put(oppWonMap.get(p.Performance_Owner__c)[i], p.id);
                }               
            }
            
            if(oppMap.containsKey(p.Performance_Owner__c)){
                for(Integer i = 0; i < oppMap.get(p.Performance_Owner__c).Size(); i++){
                    performanceMap.put(oppMap.get(p.Performance_Owner__c)[i], p.id);
                }
            }              
                    
            if(accountMap.containsKey(p.Performance_Owner__c)){
                for(Integer i = 0; i < accountMap.get(p.Performance_Owner__c).Size(); i++){
                    performanceMap.put(accountMap.get(p.Performance_Owner__c)[i], p.id);
                }
            }        
          
            if(mstMap.containsKey(p.Performance_Owner__c)){
                for(Integer i = 0; i < mstMap.get(p.Performance_Owner__c).Size(); i++){
                    performanceMap.put(mstMap.get(p.Performance_Owner__c)[i], p.id);
                }
            }  
        }
    }
}