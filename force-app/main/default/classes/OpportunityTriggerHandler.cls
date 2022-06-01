public class OpportunityTriggerHandler {
    
    public static boolean runAfter = false;
    
    public static Map<Id, List<Id>>lostAssocOppMap = new Map<Id, List<Id>>();
    public static Map<String, OpportunityStage> StageMap = new Map<String, OpportunityStage>();
    public Static List<Opportunity> updateMasterOppsList = new List<Opportunity>();
    
    private static Id masterRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Master Opportunity').getRecordTypeId();
    private static Id csqRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Cust Submitted Quote').getRecordTypeId();
    private static Id rfsRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RFS').getRecordTypeId();
    private static Id rfqRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RFQ').getRecordTypeId();
    private static Id ldRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Loss Debrief').getRecordTypeId();
    private static Id cancelRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Cancelled').getRecordTypeId();    
    
    //   ***---Before Methods---***
    //Get All Before Values For Before Insert
    public static void BeforeInsertMAO(List<Opportunity> opps){
        
        List<String> facilityList = new List<String>();
        List<String> pgList = new List<String>();
        List<Id> subtype2List = new List<Id>();
        
        //Populate Stage Map
        for(OpportunityStage os : [SELECT ApiName, DefaultProbability FROM OpportunityStage where IsActive = True]){
            StageMap.put(os.ApiName , OS);
        }
        
        for(Opportunity opp : opps){        
            
            if(!facilityList.contains(opp.Facility__c))
                facilityList.add(opp.Facility__c);
            
            if(!pgList.contains(opp.Probability_Grouping__c))
                pgList.add(opp.Probability_Grouping__c);
            
            if(!subtype2List.contains(opp.SubType2__c))
                subtype2List.add(opp.SubType2__c);
            
        } 
        
        updateOppValues(opps, facilityList, pgList, subtype2List);      
    }
    
    //Update Before Values For Before Insert
    public static void updateOppValues(List<Opportunity> opps, List<String> facilityList, List<String> pgList, List<ID> subtype2List){
        
        Map<String, Facility__c> facility = new Map<String, Facility__c>();
        for(Facility__c f : [Select Name, City__c, State__c, Street__c, Zip_Code__c, Country__c, Fax__c from Facility__c where Name In: facilityList]){
            facility.put(f.name, f);
        }
        
        Map<String, Probability_Grouping__c> pgMap = new Map<String, Probability_Grouping__c>();
        for(Probability_Grouping__c p : [Select Name, Probability_to_Use__c from Probability_Grouping__c where Name In: pgList]){
            pgMap.put(p.name, p);
        }
        
        Map<Id, Sub_Type_2__c> subtype2Map = new Map<Id, Sub_Type_2__c>([Select Id, Name, Anchor_Inspection__c from Sub_Type_2__c where Id In: subtype2List]);
        
        for(Opportunity o : opps){
            
            //Anchor Inspection
            if(o.SubType2__c == Null){
                o.Anchor_Inspection__c = false;
            }else{
                o.Anchor_Inspection__c = subtype2Map.get(o.SubType2__c).Anchor_Inspection__c;
            }
            
            //Update Close Date
            if(o.StageName != 'RFS' && 
               o.StageName != 'Loss Debrief' && 
               o.StageName != 'Cancelled' && 
               o.StageName != 'Tracking Only' && 
               o.RecordType.Name != 'Amendment' && 
               o.CloseDate < System.Today()
              ){
                  o.CloseDate = o.New_Close_Date__c;
              }
            
            if(o.CloseDate == null)
                o.CloseDate = System.Today();
            
            //Update Is Quoted Field
            if(o.Base_Quote_Number__c != null && o.Base_Quote_Number__c != '1' && o.Base_Quote_Number__c != '0' && o.Base_Quote_Number__c != 'NA' ){
                o.IsQuoted__c = 'Yes';   
            }else{
                o.IsQuoted__c = 'No';
            }
            
            //Update Facility Info
            if(facility.containskey(o.Facility__c)){
                o.Facility_City__c = facility.get(o.Facility__c).City__c;
                o.Facility_Fax__c = facility.get(o.Facility__c).Fax__c;
                o.Facility_State__c = facility.get(o.Facility__c).State__c;
                o.Facility_Street__c = facility.get(o.Facility__c).Street__c;
                o.Facility_Zip_Code__c = facility.get(o.Facility__c).Zip_Code__c;
                o.Facility_Country__c = facility.get(o.Facility__c).Country__c;
            }
            
            //Update Probability Grouping
            if(o.StageName == 'RFS'){
                        o.Probability = 100;
                        o.Probability_To_Use__c = 100; 
            }else if(o.StageName == 'Cancelled' || o.StageName == 'Loss Debrief' || o.StageName == 'Tracking Only'){
                o.Probability = 0;
                o.Probability_To_Use__c = 0;                         
            }else if(pgMap.containskey(o.Probability_Grouping__c)){
                if(!o.Probability_Grouping_Override__c){   
                    o.Probability = pgMap.get(o.Probability_Grouping__c).Probability_to_Use__c;
                    o.Probability_To_Use__c = pgMap.get(o.Probability_Grouping__c).Probability_to_Use__c;  
                }else{
                    o.Probability_To_Use__c = pgMap.get(o.Probability_Grouping__c).Probability_to_Use__c;             
                }                                    
            }
        }
    }
    
    //Get All Before Values For Before Update
    public static void BeforeUpdateMAO(Map<Id, Opportunity> oppMap, Map<Id, Opportunity> oldOppMap){
        
        Set<String> facilityList = new Set<String>();
        Set<String> pgList = new Set<String>();
        Set<Id> subtype2List = new Set<Id>();       
        Map<Id, Id> masterOppMap = new Map<Id, Id>();
        
        //Populate Stage Map
        for(OpportunityStage os : [SELECT ApiName, DefaultProbability FROM OpportunityStage where IsActive = True]){
            StageMap.put(os.ApiName , OS);
        }
        
        for(Opportunity opp : oppMap.values()){     
            
            if(opp.MasterOpportunitylookup__c != null && !opp.Master_Opportunity__c && !opp.IsClosed && !opp.IsWon)
                masterOppMap.put(opp.Id, opp.MasterOpportunitylookup__c);            
            
            if(opp.Facility__c != null)
                facilityList.add(opp.Facility__c);
            
            if(opp.Probability_Grouping__c != null)
            	pgList.add(opp.Probability_Grouping__c);
            
            if(opp.SubType2__c != null)
                subtype2List.add(opp.SubType2__c);
            
        } 
        
        updateMapValues(oppMap, facilityList, pgList, subtype2List, oldOppMap, masterOppMap);
    }
    
    //Update Before Values For Before Update
    public static void updateMapValues(Map<Id, Opportunity> oppMap, Set<String> facilityList, Set<String> pgList, Set<ID> subtype2List, Map<Id, Opportunity> oldOppMap, Map<Id, Id> masterOppMap){
        
        Map<Id, Opportunity> lostOppMap = new Map<Id, Opportunity>();
        Map<Id, List<Id>> assocOppsMap = new Map<Id, List<Id>>();
        Map<Id, Opportunity> masterOps = new Map<Id, Opportunity>();
        
        Map<String, Facility__c> facility = new Map<String, Facility__c>();
        for(Facility__c f : [Select Name, City__c, State__c, Street__c, Zip_Code__c, Country__c, Fax__c from Facility__c where Name In: facilityList]){
            facility.put(f.name, f);
        }
        
        Map<String, Probability_Grouping__c> pgMap = new Map<String, Probability_Grouping__c>();
        for(Probability_Grouping__c p : [Select Name, Probability_to_Use__c from Probability_Grouping__c where Name In: pgList]){
            pgMap.put(p.name, p);
        }
        
        Map<Id, Sub_Type_2__c> subtype2Map = new Map<Id, Sub_Type_2__c>([Select Id, Name, Anchor_Inspection__c from Sub_Type_2__c where Id In: subtype2List]);
               
        //Get Associated Opportunities From Master
        if(!masterOppMap.IsEmpty()){
            Set<Id> masterOpps = new Set<Id>();       
            for(Id oppId : masterOppMap.keyset()){
                if(!masterOpps.Contains(masterOppMap.get(oppId)))
                    masterOpps.add(masterOppMap.get(oppId));           
            }
            
            for(Opportunity o : [Select Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c from Opportunity where Id In: masterOpps]){
                masterOps.put(o.Id, o);
            }
        }
        
        for(Opportunity o : oppMap.values()){
            
            //Disassociate Lost Opportunity From Associated Opportunities
            //Excludes Master Opportunities
            if(o.isClosed && !o.isWon && !o.Master_Opportunity__c){                
                lostOppMap.put(o.Id, o);
            }
            
            //Anchor Inspection
            if(o.SubType2__c == Null){
                o.Anchor_Inspection__c = false;
            }else{
                o.Anchor_Inspection__c = subtype2Map.get(o.SubType2__c).Anchor_Inspection__c;
            }
            
            //Update Close Date
            if(o.StageName != 'RFS' && 
               o.StageName != 'Loss Debrief' && 
               o.StageName != 'Cancelled' && 
               o.StageName != 'Tracking Only' && 
               o.RecordType.Name != 'Amendment' && 
               o.CloseDate < System.Today()){
                   o.CloseDate = o.New_Close_Date__c;
               }
            
            //Update Is Quoted Field
            if(o.Base_Quote_Number__c != null && o.Base_Quote_Number__c != '1' && o.Base_Quote_Number__c != '0' && o.Base_Quote_Number__c != 'NA' ){
                o.IsQuoted__c = 'Yes';   
            }else{
                o.IsQuoted__c = 'No';
            }
            
            //Update Facility Info
            if(facility.containskey(o.Facility__c)){
                o.Facility_City__c = facility.get(o.Facility__c).City__c;
                o.Facility_Fax__c = facility.get(o.Facility__c).Fax__c;
                o.Facility_State__c = facility.get(o.Facility__c).State__c;
                o.Facility_Street__c = facility.get(o.Facility__c).Street__c;
                o.Facility_Zip_Code__c = facility.get(o.Facility__c).Zip_Code__c;
                o.Facility_Country__c = facility.get(o.Facility__c).Country__c;
            }
            
            //Update Probability Grouping
            if(o.StageName == 'RFS'){
                        o.Probability = 100;
                        o.Probability_To_Use__c = 100; 
            }else if(o.StageName == 'Cancelled' || o.StageName == 'Loss Debrief' || o.StageName == 'Tracking Only'){
                o.Probability = 0;
                o.Probability_To_Use__c = 0;                         
            }else if(pgMap.containskey(o.Probability_Grouping__c)){
                if(!o.Probability_Grouping_Override__c){   
                    o.Probability = pgMap.get(o.Probability_Grouping__c).Probability_to_Use__c;
                    o.Probability_To_Use__c = pgMap.get(o.Probability_Grouping__c).Probability_to_Use__c;  
                }else{
                    o.Probability_To_Use__c = pgMap.get(o.Probability_Grouping__c).Probability_to_Use__c;
                    
                    if(oldOppMap.get(o.Id).StageName != oppMap.get(o.Id).StageName)
                            o.probability = oldOppMap.get(o.id).probability;                    
                }                                    
            }else if(o.Probability_Grouping_Override__c == True && oldOppMap.get(o.Id).StageName != oppMap.get(o.Id).StageName){
                o.Probability = oldOppMap.get(o.Id).Probability; 
            }
            
            //prevent gap of associated opportunities on master
            if(o.Master_Opportunity__c){
                List<Id> assocOpps = new List<Id>();
                
                if(o.Associated_Opportunity_01__c != null){
                    assocOpps.add(o.Associated_Opportunity_01__c);                   
                }
                if(o.Associated_Opportunity_02__c != null){
                    assocOpps.add(o.Associated_Opportunity_02__c);
                }
                if(o.Associated_Opportunity_03__c != null){
                    assocOpps.add(o.Associated_Opportunity_03__c);
                }
                if(o.Associated_Opportunity_04__c != null){
                    assocOpps.add(o.Associated_Opportunity_04__c);
                }
                if(o.Associated_Opportunity_05__c != null){
                    assocOpps.add(o.Associated_Opportunity_05__c);
                }
                if(o.Associated_Opportunity_06__c != null){
                    assocOpps.add(o.Associated_Opportunity_06__c);
                }
                if(o.Associated_Opportunity_07__c != null){
                    assocOpps.add(o.Associated_Opportunity_07__c);
                }
                if(o.Associated_Opportunity_08__c != null){
                    assocOpps.add(o.Associated_Opportunity_08__c); 
                }
                
                if(!assocOpps.IsEmpty()){
                    assocOppsMap.put(o.Id, assocOpps);   
                    
                    if(o.RecordTypeId == masterRecTypeId){
                        if(o.StageName == 'Cust Submitted Quote')
                            o.QuotedDate__c = system.today();
                        
                        if(o.StageName == 'RFQ Assigned')                      
                            o.QuotedDate__c = system.today();
                        
                        if(o.StageName == 'RFQ - Operations Review')
                            o.QuotedDate__c = system.today();                           
                    }
                }
            }
            
            //Update Associated Opportunities
            if(!masterOps.IsEmpty() && masterOps.get(o.MasterOpportunitylookup__c) != null){
                if(!o.Master_Opportunity__c && o.MasterOpportunitylookup__c != null){
                    if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_01__c != o.id)
                        o.Associated_Opportunity_01__c = masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_01__c;
                    
                    if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_02__c != o.id)
                        o.Associated_Opportunity_02__c = masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_02__c;
                    
                    if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_03__c != o.id)                   
                        o.Associated_Opportunity_03__c = masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_03__c;
                    
                    if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_04__c != o.id)
                        o.Associated_Opportunity_04__c = masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_04__c;
                    
                    if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_05__c != o.id)                   
                        o.Associated_Opportunity_05__c = masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_05__c;
                    
                    if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_06__c != o.id)
                        o.Associated_Opportunity_06__c = masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_06__c;
                    
                    if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_07__c != o.id)
                        o.Associated_Opportunity_07__c = masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_07__c;
                    
                    if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_08__c != o.id)
                        o.Associated_Opportunity_08__c = masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_08__c;
                }
                
                //Check Master Opportunity For Associated Opp
                if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_01__c != o.id && 
                   masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_02__c != o.id &&
                   masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_03__c != o.id &&
                   masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_04__c != o.id &&
                   masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_05__c != o.id &&
                   masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_06__c != o.id &&
                   masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_07__c != o.id &&
                   masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_08__c != o.id){
                       if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_01__c == null){
                           masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_01__c = o.Id;
                           updateMasterOppsList.add(masterOps.get(o.MasterOpportunitylookup__c));
                       }else if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_02__c == null){
                           masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_02__c = o.Id;
                           updateMasterOppsList.add(masterOps.get(o.MasterOpportunitylookup__c));
                       }else if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_03__c == null){
                           masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_03__c = o.Id;
                           updateMasterOppsList.add(masterOps.get(o.MasterOpportunitylookup__c));
                       }else if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_04__c == null){
                           masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_04__c = o.Id;
                           updateMasterOppsList.add(masterOps.get(o.MasterOpportunitylookup__c));
                       }else if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_05__c == null){
                           masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_05__c = o.Id;
                           updateMasterOppsList.add(masterOps.get(o.MasterOpportunitylookup__c));
                       }else if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_06__c == null){
                           masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_06__c = o.Id;
                           updateMasterOppsList.add(masterOps.get(o.MasterOpportunitylookup__c));
                       }else if(masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_07__c == null){
                           masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_07__c = o.Id;
                           updateMasterOppsList.add(masterOps.get(o.MasterOpportunitylookup__c));
                       }else{
                           masterOps.get(o.MasterOpportunitylookup__c).Associated_Opportunity_08__c = o.Id;
                           updateMasterOppsList.add(masterOps.get(o.MasterOpportunitylookup__c));
                       }
                   }               
            }                       
        }
        
        if(!assocOppsMap.isEmpty())
            updateMAO_GapPrevention(oppMap, assocOppsMap);
        
        if(!lostOppMap.isEmpty())
            removeCancelledOppsAssociatedOpps(lostOppMap);       
    }
    
    //Prevent Gaps In Associated Opportunities On Master Opportunity
    public static void updateMAO_GapPrevention(Map<Id, Opportunity> oppMap, Map<Id, List<Id>> assocOppsMap){      
        
        for(Id opp : assocOppsMap.keyset()){
            Opportunity o = oppMap.get(opp);
            if(assocOppsMap.get(opp).Size() == 1 && (!o.isclosed || o.IsWon)){
                o.Associated_Opportunity_01__c = assocOppsMap.get(opp)[0];
                o.Associated_Opportunity_02__c = null;                                                            
                o.Associated_Opportunity_03__c = null;
                o.Associated_Opportunity_04__c = null;
                o.Associated_Opportunity_05__c = null;
                o.Associated_Opportunity_06__c = null;
                o.Associated_Opportunity_07__c = null;
                o.Associated_Opportunity_08__c = null;
            }
            
            if(assocOppsMap.get(opp).Size() == 2 && (!o.isclosed || o.IsWon)){
                o.Associated_Opportunity_01__c = assocOppsMap.get(opp)[0];
                o.Associated_Opportunity_02__c = assocOppsMap.get(opp)[1];
                o.Associated_Opportunity_03__c = null;
                o.Associated_Opportunity_04__c = null;
                o.Associated_Opportunity_05__c = null;
                o.Associated_Opportunity_06__c = null;
                o.Associated_Opportunity_07__c = null;
                o.Associated_Opportunity_08__c = null;
            }
            
            if(assocOppsMap.get(opp).Size() == 3 && (!o.isclosed || o.IsWon)){
                o.Associated_Opportunity_01__c = assocOppsMap.get(opp)[0];
                o.Associated_Opportunity_02__c = assocOppsMap.get(opp)[1];
                o.Associated_Opportunity_03__c = assocOppsMap.get(opp)[2];
                o.Associated_Opportunity_04__c = null;
                o.Associated_Opportunity_05__c = null;
                o.Associated_Opportunity_06__c = null;
                o.Associated_Opportunity_07__c = null;
                o.Associated_Opportunity_08__c = null;
            }
            
            if(assocOppsMap.get(opp).Size() == 4 && (!o.isclosed || o.IsWon)){
                o.Associated_Opportunity_01__c = assocOppsMap.get(opp)[0];
                o.Associated_Opportunity_02__c = assocOppsMap.get(opp)[1];
                o.Associated_Opportunity_03__c = assocOppsMap.get(opp)[2];
                o.Associated_Opportunity_04__c = assocOppsMap.get(opp)[3];
                o.Associated_Opportunity_05__c = null;
                o.Associated_Opportunity_06__c = null;
                o.Associated_Opportunity_07__c = null;
                o.Associated_Opportunity_08__c = null;
            }
            
            if(assocOppsMap.get(opp).Size() == 5 && (!o.isclosed || o.IsWon)){
                o.Associated_Opportunity_01__c = assocOppsMap.get(opp)[0];
                o.Associated_Opportunity_02__c = assocOppsMap.get(opp)[1];
                o.Associated_Opportunity_03__c = assocOppsMap.get(opp)[2];
                o.Associated_Opportunity_04__c = assocOppsMap.get(opp)[3];
                o.Associated_Opportunity_05__c = assocOppsMap.get(opp)[4];
                o.Associated_Opportunity_06__c = null;
                o.Associated_Opportunity_07__c = null;
                o.Associated_Opportunity_08__c = null;
            }
            
            if(assocOppsMap.get(opp).Size() == 6 && (!o.isclosed || o.IsWon)){
                o.Associated_Opportunity_01__c = assocOppsMap.get(opp)[0];
                o.Associated_Opportunity_02__c = assocOppsMap.get(opp)[1];
                o.Associated_Opportunity_03__c = assocOppsMap.get(opp)[2];
                o.Associated_Opportunity_04__c = assocOppsMap.get(opp)[3];
                o.Associated_Opportunity_05__c = assocOppsMap.get(opp)[4];
                o.Associated_Opportunity_06__c = assocOppsMap.get(opp)[5];                
                o.Associated_Opportunity_07__c = null;
                o.Associated_Opportunity_08__c = null;
            }
            
            if(assocOppsMap.get(opp).Size() == 7 && (!o.isclosed || o.IsWon)){
                o.Associated_Opportunity_01__c = assocOppsMap.get(opp)[0];
                o.Associated_Opportunity_02__c = assocOppsMap.get(opp)[1];
                o.Associated_Opportunity_03__c = assocOppsMap.get(opp)[2];
                o.Associated_Opportunity_04__c = assocOppsMap.get(opp)[3];
                o.Associated_Opportunity_05__c = assocOppsMap.get(opp)[4];
                o.Associated_Opportunity_06__c = assocOppsMap.get(opp)[5]; 
                o.Associated_Opportunity_07__c = assocOppsMap.get(opp)[6]; 
                o.Associated_Opportunity_08__c = null;
            }
            
            if(assocOppsMap.get(opp).Size() == 8 && (!o.isclosed || o.IsWon)){
                o.Associated_Opportunity_01__c = assocOppsMap.get(opp)[0];
                o.Associated_Opportunity_02__c = assocOppsMap.get(opp)[1];
                o.Associated_Opportunity_03__c = assocOppsMap.get(opp)[2];
                o.Associated_Opportunity_04__c = assocOppsMap.get(opp)[3];
                o.Associated_Opportunity_05__c = assocOppsMap.get(opp)[4];
                o.Associated_Opportunity_06__c = assocOppsMap.get(opp)[5]; 
                o.Associated_Opportunity_07__c = assocOppsMap.get(opp)[6];
                o.Associated_Opportunity_08__c = assocOppsMap.get(opp)[7];
            }        
        }
    }
    
    //Disassociate Cancelled Opportunity
    public static void removeCancelledOppsAssociatedOpps(Map<Id, Opportunity> lostOppMap){
        
        for(Opportunity o : lostOppMap.values()){ 
            
            List<Id> associatedOpps = new List<Id>();
            
            if(o.MasterOpportunitylookup__c != null){
                associatedOpps.add(o.MasterOpportunitylookup__c);
                o.MasterOpportunitylookup__c = null;
            }
            
            if(o.Associated_Opportunity_01__c != null){
                associatedOpps.add(o.Associated_Opportunity_01__c);
                o.Associated_Opportunity_01__c = null;
            }
            
            if(o.Associated_Opportunity_02__c != null){
                associatedOpps.add(o.Associated_Opportunity_02__c);
                o.Associated_Opportunity_02__c = null;
            }
            
            if(o.Associated_Opportunity_03__c != null){
                associatedOpps.add(o.Associated_Opportunity_03__c);
                o.Associated_Opportunity_03__c = null;
            }
            
            if(o.Associated_Opportunity_04__c != null){
                associatedOpps.add(o.Associated_Opportunity_04__c);
                o.Associated_Opportunity_04__c = null;
            }
            
            if(o.Associated_Opportunity_05__c != null){
                associatedOpps.add(o.Associated_Opportunity_05__c);
                o.Associated_Opportunity_05__c = null;
            }
            
            if(o.Associated_Opportunity_06__c != null){
                associatedOpps.add(o.Associated_Opportunity_06__c);
                o.Associated_Opportunity_06__c = null;
            }
            
            if(o.Associated_Opportunity_07__c != null){
                associatedOpps.add(o.Associated_Opportunity_07__c);
                o.Associated_Opportunity_07__c = null;
            }
            
            if(o.Associated_Opportunity_08__c != null){
                associatedOpps.add(o.Associated_Opportunity_08__c);
                o.Associated_Opportunity_08__c = null;
            }
            
            if(!associatedOpps.IsEmpty())
                lostAssocOppMap.put(o.id, associatedOpps);
        }        
    }  
    
    //   ***---After Methods---*** 
    //Update After Trigger Values
    public static void updateAfterMAO(Map<Id, Opportunity> oppTriggerMap){
        
        Set<Id> accountList = new Set<Id>();
        
        Map<Id, List<Id>> masterOppMap = new Map<Id, List<Id>>();       
        Map<Id, Opportunity> oppMap = new Map<Id , Opportunity>();
        
        for(Opportunity o : oppTriggerMap.values()){
            
            oppMap.put(o.id, o);
            
            if(!accountList.contains(o.AccountId))
                accountList.add(o.AccountId);
            
            //Maps Associated Opportunities Back To Master
            if(o.Master_Opportunity__c){
                List<Id> assocOpps = new List<Id>();
                
                if(o.Associated_Opportunity_01__c != null)
                    assocOpps.add(o.Associated_Opportunity_01__c);                   
                
                if(o.Associated_Opportunity_02__c != null)
                    assocOpps.add(o.Associated_Opportunity_02__c);
                
                if(o.Associated_Opportunity_03__c != null)
                    assocOpps.add(o.Associated_Opportunity_03__c);
                
                if(o.Associated_Opportunity_04__c != null)
                    assocOpps.add(o.Associated_Opportunity_04__c);
                
                if(o.Associated_Opportunity_05__c != null)
                    assocOpps.add(o.Associated_Opportunity_05__c);
                
                if(o.Associated_Opportunity_06__c != null)
                    assocOpps.add(o.Associated_Opportunity_06__c);
                
                if(o.Associated_Opportunity_07__c != null)
                    assocOpps.add(o.Associated_Opportunity_07__c);
                
                if(o.Associated_Opportunity_08__c != null)
                    assocOpps.add(o.Associated_Opportunity_08__c); 
                
                if(assocOpps != null || !assocOpps.IsEmpty())
                    masterOppMap.put(o.Id, assocOpps);                                                                                   
            }
        }
        
        //Update Map Values Here
        if(masterOppMap != null || masterOppMap.IsEmpty())
            updateMasterOpportunityManagement(oppMap, masterOppMap);
        
        if(lostAssocOppMap != null || !lostAssocOppMap.IsEmpty())
            removeOppFromAssociatedOpps(lostAssocOppMap);  
        
        if(accountList != null || !accountList.IsEmpty())   
            updateOpportunityAccount(accountList);
        
        if(updateMasterOppsList != null || !updateMasterOppsList.IsEmpty())
            update updateMasterOppsList;
    }
    
    //Master Opportunity Management
    public static void updateMasterOpportunityManagement(Map<Id, Opportunity> oppMap, Map<Id, List<Id>>masterOppMap){
        
        Map<Id, Opportunity> oppMapUpdate = new Map<Id, Opportunity>();  
        
        Set<Id> assocOpps = new Set<Id>();       
        for(Id oppId : masterOppMap.keyset()){
            for(Id ao : masterOppMap.get(oppId)){
                if(!assocOpps.Contains(ao))
                    assocOpps.add(ao);
            }
        }
        
        Map<Id, Opportunity> associatedOps = new Map<Id, Opportunity>([Select Id, RecordTypeId, StageName, IsClosed, IsWon from Opportunity where Id In: assocOpps]);
        for(Id oppId : masterOppMap.keyset()){
            Opportunity opp = oppMap.get(oppId);
            
            //Loops Thru Associated Opportunties
            for(Id ao : masterOppMap.get(oppId)){
                Opportunity o = associatedOps.get(ao);
                              
                //Updating Master and Associated Opportunities
                o.MasterOpportunitylookup__c = opp.Id;
                
                if(opp.Associated_Opportunity_01__c != o.Id){                            
                    o.Associated_Opportunity_01__c = opp.Associated_Opportunity_01__c;                                   
                }else{                                  
                    o.Associated_Opportunity_01__c = null;                                  
                }
                
                if(opp.Associated_Opportunity_02__c != o.Id){                                       
                    o.Associated_Opportunity_02__c = opp.Associated_Opportunity_02__c;                                    
                }else{                                        
                    o.Associated_Opportunity_02__c = null;                                
                }
                
                if(opp.Associated_Opportunity_03__c != o.Id){                                      
                    o.Associated_Opportunity_03__c = opp.Associated_Opportunity_03__c;                                  
                }else{                                        
                    o.Associated_Opportunity_03__c = null;                                 
                }
                
                if(opp.Associated_Opportunity_04__c != o.Id){                                        
                    o.Associated_Opportunity_04__c = opp.Associated_Opportunity_04__c;                                    
                }else{                                        
                    o.Associated_Opportunity_04__c = null;                                    
                }                                                            
                
                if(opp.Associated_Opportunity_05__c != o.Id){                                        
                    o.Associated_Opportunity_05__c = opp.Associated_Opportunity_05__c;                                    
                }else{                                        
                    o.Associated_Opportunity_05__c = null;                                    
                }
                
                if(opp.Associated_Opportunity_06__c != o.Id){
                    o.Associated_Opportunity_06__c = opp.Associated_Opportunity_06__c;
                }else{                                      
                    o.Associated_Opportunity_06__c = null;                                   
                }
                
                if(opp.Associated_Opportunity_07__c != o.Id){                                       
                    o.Associated_Opportunity_07__c = opp.Associated_Opportunity_07__c;                                    
                }else{                                       
                    o.Associated_Opportunity_07__c = null;                                    
                } 
                
                if(opp.Associated_Opportunity_08__c != o.Id){                                        
                    o.Associated_Opportunity_08__c = opp.Associated_Opportunity_08__c;                                    
                }else{                                       
                    o.Associated_Opportunity_08__c = null;                                   
                }
                
                //If Associated Opportunity Is Not Closed
                if(!o.IsClosed){
                    
                    //Master Record Type CSQ
                    if(opp.StageName == 'Cust Submitted Quote' && opp.RecordTypeId == masterRecTypeId){
                        o.QuotedDate__c = system.today();
                        o.RecordTypeId = csqRecTypeId;
                        o.StageName = opp.StageName;      
                    }
                    
                    //Master Record Type RFQ Assigned
                    if(opp.StageName == 'RFQ Assigned' && opp.RecordTypeId == masterRecTypeId){
                        if(o.StageName != 'RFQ - Subsection Complete'){
                            o.RecordTypeId = rfqRecTypeId;
                            o.StageName = opp.StageName;
                        } 
                    }
                    
                    //Master Record Type RFQ Ops Review
                    if(opp.StageName == 'RFQ - Operations Review' && opp.RecordTypeId == masterRecTypeId){
                        o.RecordTypeId = rfqRecTypeId;
                        o.StageName = opp.StageName;
                    }
                    
                    //Master Record Type RFQ Ops Review
                    if(opp.StageName == 'RFQ Submitted' && opp.RecordTypeId == masterRecTypeId){
                        o.RecordTypeId = rfqRecTypeId;
                        o.StageName = opp.StageName;
                    }
                    
                    //Master Record Type RFS
                    if(opp.StageName == 'RFS'){
                        //if(o.RecordTypeId != masterRecTypeId)
                        o.RecordTypeId = rfsRecTypeId;                                         
                        o.StageName = opp.StageName;
                    }
                    
                    //Master Record Type Loss Debrief
                    if(opp.StageName == 'Loss Debrief'){
                        //if(opp.RecordTypeId != masterRecTypeId)
                        o.RecordTypeId = ldRecTypeId;                                         
                        o.StageName = opp.StageName;
                    }
                    
                    //Master Record Type Cancelled
                    if(opp.StageName == 'Cancelled'){
                        //if(opp.RecordTypeId != masterRecTypeId)
                        o.RecordTypeId = cancelRecTypeId;                                         
                        o.StageName = opp.StageName;
                    }
                    
                    //MOM
                    if(opp.StageName != 'RFQ Accepted' && 
                       opp.StageName != 'RFQ Assigned'  && 
                       opp.StageName != 'RFQ - Logbook Review' && 
                       opp.StageName != 'RFQ - Subsection Complete' && 
                       opp.StageName != 'RFQ Rejected' && 
                       o.StageName != 'RFQ Accepted' && 
                       o.StageName != 'RFQ Assigned' && 
                       o.StageName != 'RFQ - Logbook Review' &&
                       o.StageName != 'RFQ - Subsection Complete' && 
                       o.StageName != 'RFQ Rejected'){
                           o.StageName = opp.StageName; 
                           if(opp.RecordTypeId != masterRecTypeId)
                               o.RecordTypeId = opp.RecordTypeId;
                       }                       
                    
                    o.Operator__c = opp.Operator__c;
                    o.Lead_TSM__c = opp.Lead_TSM__c;
                    o.LeadSource = opp.LeadSource;
                    o.NextStepCode__c = opp.NextStepCode__c;
                    o.Contact__c = opp.Contact__c;
                    o.CloseDate = opp.CloseDate;
                    o.InputDate__c = opp.InputDate__c;
                    o.Input_Date_Accuracy__c = opp.Input_Date_Accuracy__c;
                    o.OutputDate__c = opp.OutputDate__c;
                    o.Auto_Update_Override__c = opp.Auto_Update_Override__c;
                    o.Master_Associated_Total__c = opp.Master_Associated_Total__c;
                    o.QuoteDelivery__c = opp.QuoteDelivery__c;                               
                    o.QuoteRequiredBy__c = opp.QuoteRequiredBy__c;
                    o.Competitor__c = opp.Competitor__c;
                    o.Event__c = opp.Event__c;
                    o.Facility__c = opp.Facility__c;
                    o.Customer_Satisfaction_Survey_Contact__c = opp.Customer_Satisfaction_Survey_Contact__c;
                    o.SchedulingConflict__c = opp.SchedulingConflict__c;
                    o.SchedulingConflictDesc__c = opp.SchedulingConflictDesc__c;
                    o.Will_Carry_HazMat__c = opp.Will_Carry_HazMat__c;
                    o.WinorLossReason1__c = opp.WinorLossReason1__c;
                    o.Sub_Reason__c = opp.Sub_Reason__c;
                    o.Win_or_Loss_Reason2__c = opp.Win_or_Loss_Reason2__c;
                    o.Win_Loss_Description__c = opp.Win_Loss_Description__c;
                    o.Last_Customer_Communication_Date__c = opp.Last_Customer_Communication_Date__c;
                    o.What_Else_Is_Need_To_Win_Event__c = opp.What_Else_Is_Need_To_Win_Event__c;
                    o.MST_Support_Required__c = opp.MST_Support_Required__c;
                    o.MST_Support_Details__c = opp.MST_Support_Details__c;
                }
                
                oppMapUpdate.put(o.Id, o);                  
            }
        }
        
        try{
            update oppMapUpdate.values();
        }catch (Exception e){
            system.debug(e.getMessage());
        }
    }
    
    //Update Opportunity Account
    public static void updateOpportunityAccount(Set<Id>accountList){
        
        Date future5Y = system.today().addDays(+1825);
        Date arrears5Y = system.today().addDays(-1825);
        
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();        
        Map<Id, Account> accountMap = new Map<Id, Account>([Select Id FROM Account where Id IN: accountList]);
        
        Map<id, Decimal> total_RfsSumMap = new Map<id, Decimal>();
        for(AggregateResult ar : [Select AccountId, Sum(Amount) totalAmount From Opportunity WHERE AccountID In: accountList AND InputDate__c > :arrears5Y AND Account.Disabled_from_5YrRollups__c = False AND IsClosed = true and StageName = 'RFS' group by AccountId]){
            total_RfsSumMap.put((Id)ar.get('AccountId'), (Decimal)ar.get('totalAmount'));
        }
        
        Map<id, Decimal> total_ForecastSumMap = new Map<id, Decimal>();
        for(AggregateResult ar : [Select AccountId, Sum(Amount) totalAmount From Opportunity WHERE AccountID In: accountList AND InputDate__c < :future5Y AND Account.Disabled_from_5YrRollups__c = False AND IsClosed = false group by AccountId]){
            total_ForecastSumMap.put((Id)ar.get('AccountId'), (Decimal)ar.get('totalAmount'));
        }
        
        if(!accountMap.IsEmpty()){
            for(Account a : accountMap.values()){             
                a.X5_Year_RFS_Sum__c =  total_RfsSumMap.get(a.id);
                a.X5_Year_Forecast_Sum__c =  total_ForecastSumMap.get(a.id); 
                accountsToUpdate.put(a.Id, a);
            }
        }
        
        if(!accountsToUpdate.IsEmpty())
            update accountsToUpdate.Values();       
    }
    
    //Disassociate Cancelled Opportunity From Associated Opportunities
    public static void removeOppFromAssociatedOpps(Map<Id, List<Id>>lostAssocOppMap){
        
        Map<Id, Opportunity> updateOpps = new Map<Id, Opportunity>();
        
        Set<Id> assocOpps = new Set<Id>();
        For(Id oppId : lostAssocOppMap.keyset()){
            List<Id> lstId = lostAssocOppMap.get(oppId);
            for(id i : lstId){
                if(!assocOpps.contains(i))
                    assocOpps.add(i); 
            }     
        }
        
        List<Opportunity> oppList = [Select MasterOpportunitylookup__c, Associated_Opportunity_01__c, Associated_Opportunity_02__c,  Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c from Opportunity where Id In: assocOpps]; 
        
        for(Opportunity o : oppList){
            if(lostAssocOppMap.containskey(o.MasterOpportunitylookup__c))
                o.MasterOpportunitylookup__c = null;  
            
            if(lostAssocOppMap.containskey(o.Associated_Opportunity_01__c))
                o.Associated_Opportunity_01__c = null;  
            
            if(lostAssocOppMap.containskey(o.Associated_Opportunity_02__c))
                o.Associated_Opportunity_02__c = null;
            
            if(lostAssocOppMap.containskey(o.Associated_Opportunity_03__c))
                o.Associated_Opportunity_03__c = null;
            
            if(lostAssocOppMap.containskey(o.Associated_Opportunity_04__c))
                o.Associated_Opportunity_04__c = null; 
            
            if(lostAssocOppMap.containskey(o.Associated_Opportunity_05__c))
                o.Associated_Opportunity_05__c = null;
            
            if(lostAssocOppMap.containskey(o.Associated_Opportunity_06__c))
                o.Associated_Opportunity_06__c = null; 
            
            if(lostAssocOppMap.containskey(o.Associated_Opportunity_07__c))
                o.Associated_Opportunity_07__c = null;
            
            if(lostAssocOppMap.containskey(o.Associated_Opportunity_08__c))
                o.Associated_Opportunity_08__c = null;
            
            updateOpps.put(o.id, o);
        }
        
        try{
            update updateOpps.Values(); 
        }catch (Exception e){
            system.debug(e.getMessage());
        }
    }
    
    public static void relationDisestablishment(Map<Id,Opportunity> newMapvalue, Map<Id,Opportunity> oldMapValue){
        List<Opportunity> opToUpdate = new List<Opportunity>();
        set<Id> ids = new set<Id>();
        
        //Loops thru Opportunity Values
        for(Opportunity opp: newMapvalue.values()){
            
            //if Associated Opportunity Does Not Equal Old Associated Opportunity
            //and New Associated Opportunity Has a Value
            //Old Associated Map Value is Added to Set
            if((opp.Associated_Opportunity_01__c != oldMapValue.get(opp.Id).Associated_Opportunity_01__c) && (opp.Associated_Opportunity_01__c == Null) )
                ids.add(oldMapValue.get(opp.Id).Associated_Opportunity_01__c);
            
            if((opp.Associated_Opportunity_02__c != oldMapValue.get(opp.Id).Associated_Opportunity_02__c) && (opp.Associated_Opportunity_02__c == Null) )
                ids.add(oldMapValue.get(opp.Id).Associated_Opportunity_02__c);
            
            if((opp.Associated_Opportunity_03__c != oldMapValue.get(opp.Id).Associated_Opportunity_03__c) && (opp.Associated_Opportunity_03__c == Null) )
                ids.add(oldMapValue.get(opp.Id).Associated_Opportunity_03__c);
            
            if((opp.Associated_Opportunity_04__c != oldMapValue.get(opp.Id).Associated_Opportunity_04__c) && (opp.Associated_Opportunity_04__c == Null) )
                ids.add(oldMapValue.get(opp.Id).Associated_Opportunity_04__c);
            
            if((opp.Associated_Opportunity_05__c != oldMapValue.get(opp.Id).Associated_Opportunity_05__c) && (opp.Associated_Opportunity_05__c == Null) )
                ids.add(oldMapValue.get(opp.Id).Associated_Opportunity_05__c);
            
            if((opp.Associated_Opportunity_06__c != oldMapValue.get(opp.Id).Associated_Opportunity_06__c) && (opp.Associated_Opportunity_06__c == Null) )
                ids.add(oldMapValue.get(opp.Id).Associated_Opportunity_06__c);
            
            if((opp.Associated_Opportunity_07__c != oldMapValue.get(opp.Id).Associated_Opportunity_07__c) && (opp.Associated_Opportunity_07__c == Null) )
                ids.add(oldMapValue.get(opp.Id).Associated_Opportunity_07__c);
            
            if((opp.Associated_Opportunity_08__c != oldMapValue.get(opp.Id).Associated_Opportunity_08__c) && (opp.Associated_Opportunity_08__c == Null) )
                ids.add(oldMapValue.get(opp.Id).Associated_Opportunity_08__c);
            
        } 
        
        //Query Master Opportunities for Associated Opportunities in Set
        list<opportunity> oppList = [select Id, MasterOpportunitylookup__c from Opportunity Where Id IN: ids];
        Map<Id,opportunity> opMap = new Map<Id,opportunity>();
        
        //Loop thru Master List if not Empty
        if(!oppList.isEmpty()){
            
            //Add to Opportunity to opMap
            for(Opportunity p : oppList){
                opMap.put(p.Id, p);
            } 
            
            List<Id> idsl = new List<Id>();
            idsl.addAll(opMap.keyset());
            
            //Disassociate Master Opportunity Where it Existed On Old Opportunities
            for(Opportunity p1 : oldMapValue.values()){           
                if(idsl.contains(p1.Associated_Opportunity_01__c)){
                    if(opMap.get(p1.Associated_Opportunity_01__c).MasterOpportunitylookup__c == p1.Id)
                        opMap.get(p1.Associated_Opportunity_01__c).MasterOpportunitylookup__c = null; 
                }
                
                if(idsl.contains(p1.Associated_Opportunity_02__c)) {
                    if(opMap.get(p1.Associated_Opportunity_02__c).MasterOpportunitylookup__c == p1.Id)
                        opMap.get(p1.Associated_Opportunity_02__c).MasterOpportunitylookup__c = null;
                }
                
                if(idsl.contains(p1.Associated_Opportunity_03__c)) {
                    if(opMap.get(p1.Associated_Opportunity_03__c).MasterOpportunitylookup__c == p1.Id)
                        opMap.get(p1.Associated_Opportunity_03__c).MasterOpportunitylookup__c = null;
                }
                
                if(idsl.contains(p1.Associated_Opportunity_04__c)) {
                    if(opMap.get(p1.Associated_Opportunity_04__c).MasterOpportunitylookup__c == p1.Id)
                        opMap.get(p1.Associated_Opportunity_04__c).MasterOpportunitylookup__c = null;
                }
                
                if(idsl.contains(p1.Associated_Opportunity_05__c)) {
                    if (opMap.get(p1.Associated_Opportunity_05__c).MasterOpportunitylookup__c == p1.Id)
                        opMap.get(p1.Associated_Opportunity_05__c).MasterOpportunitylookup__c = null;
                }
                
                if(idsl.contains(p1.Associated_Opportunity_06__c)) {
                    if(opMap.get(p1.Associated_Opportunity_06__c).MasterOpportunitylookup__c == p1.Id)
                        opMap.get(p1.Associated_Opportunity_06__c).MasterOpportunitylookup__c = null;
                }
                
                if(idsl.contains(p1.Associated_Opportunity_07__c)) {
                    if(opMap.get(p1.Associated_Opportunity_07__c).MasterOpportunitylookup__c == p1.Id)
                        opMap.get(p1.Associated_Opportunity_07__c).MasterOpportunitylookup__c = null;
                }
                
                if(idsl.contains(p1.Associated_Opportunity_08__c)) {                  
                    if(opMap.get(p1.Associated_Opportunity_08__c).MasterOpportunitylookup__c == p1.Id)
                        opMap.get(p1.Associated_Opportunity_08__c).MasterOpportunitylookup__c = null;               
                }    
            }
            
            update opMap.values();
        }
    }    
}