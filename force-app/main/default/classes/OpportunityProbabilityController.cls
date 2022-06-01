public class OpportunityProbabilityController {
    
    private String soql {get;set;}
    public List<Opportunity> opps {get;set;} 
    
	public OpportunityProbabilityController(ApexPages.StandardController controller){      
        String MPI = 'TFE731 - MPI';
        String CZI = 'TFE731 - CZI';
        
        soql = 'Select Id, Name, Probability, Probability_Grouping_Override__c, InputDate__c, StageName from Opportunity where IsClosed = False and OwnerId = \'' + userinfo.getUserId() + '\'';
        soql += 'and (Subtype__c = \'' + MPI + '\' Or Subtype__c = \'' + CZI + '\') AND (InputDate__c = THIS_QUARTER or InputDate__c = Next_QUARTER)';
        
        runQuery();    
    }
    
	// the current sort direction. defaults to asc
    public String sortDir {
        get{ 
        	if (sortDir == null){  
            	sortDir = 'asc'; 
            } 
            return sortDir;  
        }
        set;
    }

    // the current field to sort by defaults to name
    public String sortField {
        get{ 
        	if (sortField == null) {
            	sortField = 'name'; 
            } 
            return sortField;  
        }
        set;
    }

  
    // toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        runQuery();
    }
        
    public void runQuery() {
        try {     
            opps = Database.query(soql + ' order by ' + sortField + ' ' + sortDir );
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Opportunities Found'));
        }
        
        if(opps.size() == 0)
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You Currently Do Not Have Any TFE731 Opportunities In Your Pipeline.'));               
    }
   
    public PageReference saveOpportunities(){
        /*for(Opportunity o: opps){
            o.Probability_Grouping_Override__c = True;
        }*/
        
        try {
            update opps;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your Opportunity Probabilities Have Been Updated'));    
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  e.getMessage()));
        }
        
        runQuery();      
        return null;
    }
       
}