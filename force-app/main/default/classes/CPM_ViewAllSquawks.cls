public class CPM_ViewAllSquawks {
    
    public MPM4_BASE__Milestone1_Project__c proj;
    private static Integer FIRST_BREAK = 11;
    private static Integer SUBSEQ_BREAKS = 11; 
    public List<SBQQ__QuoteLine__c[]> pageBrokenSquawkLines {get; private set; }
    public List<SBQQ__QuoteLine__c> sqk {get;set;}
    private String soql {get;set;}
    
    public CPM_ViewAllSquawks(ApexPages.StandardController controller){
        this.proj = (MPM4_BASE__Milestone1_Project__c)controller.getRecord();
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteLine__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
                  
        soql = 'Select ' + joinedString + ' from SBQQ__QuoteLine__c where SBQQ__ProductCode__c != \'UnscheduledBundle\' And project__c = \'' + proj.Id + '\'';    
           
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

    // the current field to sort by. defaults to fxItemNo__c
    public String sortField {
        get{ 
        	if (sortField == null) {
            	sortField = 'fxItemNo__c'; 
            } 
            return sortField;  
        }
        set;
    }

    // format the soql for display on the visualforce page
    public String debugSoql {
        get { 
            return soql + ' order by ' + sortField + ' ' + sortDir ; 
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

    // runs the actual query
    public void runQuery() {
        try {     
            sqk = Database.query(soql + ' order by ' + sortField + ' ' + sortDir );
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Quote Lines Found'));
        }
        if(sqk.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'There are currently no Squawks on this Project.'));
        }
    }
     
    // runs the search with parameters passed via Javascript
    public PageReference runSearch() {

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteLine__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
                
        Boolean Approved = Boolean.ValueOf(Apexpages.currentPage().getParameters().get('Approved')); 
        Boolean Declined = Boolean.ValueOf(Apexpages.currentPage().getParameters().get('Declined')); 
		Boolean Pending = Boolean.ValueOf(Apexpages.currentPage().getParameters().get('Pending'));         
        Boolean NotSubmitted = Boolean.ValueOf(Apexpages.currentPage().getParameters().get('NotSubmitted'));
        Integer i = 0;
        
        if (Approved)
            i=i+1;
        if (Declined)
            i=i+1;
        if (Pending)
            i=i+1;
        if (NotSubmitted)
            i=i+1;
        
        soql = 'Select ' + joinedString;
        
        if(i<2){            
        	soql += ' From SBQQ__QuoteLine__c where SBQQ__ProductCode__c != \'UnscheduledBundle\' And project__c = \'' + proj.Id + '\'';    
        
        	if (Approved)
        		soql += 'and Add_Work_Status__c  = \'Approved\'';
        
        	if (Pending)
         		soql += 'and Add_Work_Status__c  = \'Pending\'';
        	
            if (Declined)
            	soql += 'and Add_Work_Status__c = \'Denied\'';
            
            if (NotSubmitted)
            	soql += 'and Add_Work_Status__c = \'\'';
        }
        
        if(i==2){            
        	soql += ' From SBQQ__QuoteLine__c where SBQQ__ProductCode__c != \'UnscheduledBundle\' And project__c = \'' + proj.Id + '\' and (';    
        
        	if (Approved && Declined && !Pending && !NotSubmitted)
        		soql += 'Add_Work_Status__c  = \'Approved\' or Add_Work_Status__c = \'Denied\'';
        
        	if (Approved && Pending && !Declined && !NotSubmitted)
         		soql += 'Add_Work_Status__c  = \'Approved\' or Add_Work_Status__c  = \'Pending\'';
        	
            if (Approved && NotSubmitted && !Declined && !Pending)
            	soql += 'Add_Work_Status__c  = \'Approved\' or Add_Work_Status__c = \'\'';
            
            if (!Approved && Declined && Pending && !NotSubmitted)
        		soql += 'Add_Work_Status__c  = \'Denied\' or Add_Work_Status__c = \'Pending\'';
        
        	if (!Approved && Declined && !Pending && NotSubmitted)
         		soql += 'Add_Work_Status__c  = \'Denied\' or Add_Work_Status__c  = \'\'';
        	
            if (!Approved && !Declined && Pending && NotSubmitted)
            	soql += 'Add_Work_Status__c  = \'Pending\' or Add_Work_Status__c = \'\'';
                       
            soql += ')';
        }
        
        if(i==3){            
        	soql += ' From SBQQ__QuoteLine__c where SBQQ__ProductCode__c != \'UnscheduledBundle\' And project__c = \'' + proj.Id + '\' and (';    
        
        	if (Approved && Declined && Pending && !NotSubmitted)
        		soql += 'Add_Work_Status__c  = \'Approved\' or Add_Work_Status__c = \'Denied\' or Add_Work_Status__c  = \'Pending\'';
        
            if (Approved && Declined && !Pending && NotSubmitted)
         		soql += 'Add_Work_Status__c  = \'Approved\' or Add_Work_Status__c  = \'Denied\' or Add_Work_Status__c  = \'\'';
            
        	if (Approved && !Declined && Pending && NotSubmitted)
         		soql += 'Add_Work_Status__c  = \'Approved\' or Add_Work_Status__c  = \'Pending\' or Add_Work_Status__c  = \'\'';
                              	
            if (!Approved && Declined && Pending && NotSubmitted)
            	soql += 'Add_Work_Status__c  = \'Denied\' or Add_Work_Status__c = \'Pending\' or Add_Work_Status__c = \'\'';
                       
            soql += ')';
        }
        
        if(i==4)            
        	soql += ' From SBQQ__QuoteLine__c where SBQQ__ProductCode__c != \'UnscheduledBundle\' And project__c = \'' + proj.Id + '\'';
        
        runQuery();  
        return null;
    }
    
   	public List<SBQQ__QuoteLine__c> getSquawks() {
        return sqk; 
	}
    
    public List<MPM4_BASE__Milestone1_Project__c> getProject() {
        return [Select Name, CPM_Name__c, Designated_Approver__r.Name, MPM4_BASE__Account__R.Name, Aircraft__r.ACReg__c, Delivery_Date__c, MPM4_BASE__Description__c from MPM4_BASE__Milestone1_Project__c where id =: proj.Id]; 
	}
    
    public PageReference pdf(){
        PageReference pr = new PageReference('/apex/SquawksPDF');
		pr.getParameters().put('id', proj.Id);
		return pr;
    }
                  
    //splits the quote lines into an approximate number of rows that can be displayed per page
    public void prepareSquawkLinesForPrinting(){
        pageBrokenSquawkLines = new List<SBQQ__QuoteLine__c[]>();
    
        SBQQ__QuoteLine__c[] pageOfSquawks = new SBQQ__QuoteLine__c[]{};
        Integer counter = 0;
    
        boolean firstBreakFound = false;
        for(SBQQ__QuoteLine__c s : sqk){
			if(!firstBreakFound){
                if(counter < FIRST_BREAK){
                    pageOfSquawks.add(s);
                    counter++;  
                }
                if(counter == FIRST_BREAK){
                    firstBreakFound = true;
                    counter = 0;
                    pageBrokenSquawkLines.add(pageOfSquawks);
                    pageOfSquawks = new SBQQ__QuoteLine__c[]{};
            	}
			}else{
                if(counter < SUBSEQ_BREAKS){
                    pageOfSquawks.add(s);
                	counter++;
                }
                if(counter == SUBSEQ_BREAKS){
                    counter = 0;
                    pageBrokenSquawkLines.add(pageOfSquawks);
                	pageOfSquawks = new SBQQ__QuoteLine__c[]{};
            	}   
        	}
        }

        if(!pageOfSquawks.isEmpty())
            pageBrokenSquawkLines.add(pageOfSquawks);        
	}
            
}