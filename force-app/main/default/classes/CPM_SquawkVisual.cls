public class CPM_SquawkVisual {
    
    public MPM4_BASE__Milestone1_Project__c proj;      
    public List<SBQQ__QuoteLine__c> sqk {get;set;}
    private String soql {get;set;}
    
    public CPM_SquawkVisual(ApexPages.StandardController controller){
        this.proj = (MPM4_BASE__Milestone1_Project__c)controller.getRecord();
        
        String proCode = 'UnscheduledBundle';        
              
        soql = 'Select Id, Name, Add_Work_Status__c, Designated_Approver__c, fxJob_Card__c, Job_Card__c, Job_Card_Description__c, Material_Amount__c, Material_Type__c, Labor_Amount__c, Add_Work_Labor_Type__c, IsRTS__c ';
        soql += 'From SBQQ__QuoteLine__c where SBQQ__ProductCode__c != \'' + String.escapeSingleQuotes(proCode) + '\' And project__c = \'' + proj.Id + '\'';    
           
        runQuery();    
    }
       
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }

    // the current field to sort by. defaults to name
    public String sortField {
        get  { if (sortField == null) {sortField = 'name'; } return sortField;  }
        set;
    }

    // format the soql for display on the visualforce page
    public String debugSoql {
        get { return soql + ' order by ' + sortField + ' ' + sortDir ; }
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

        String name = Apexpages.currentPage().getParameters().get('name'); 
        String JobCardDescription = Apexpages.currentPage().getParameters().get('JobCardDescription');
        String sqkStatus = Apexpages.currentPage().getParameters().get('sqkStatus');
        String proCode = 'UnscheduledBundle';
           
        soql = 'Select Id, Name, Add_Work_Status__c, Designated_Approver__c, fxJob_Card__c, Job_Card__c, Job_Card_Description__c, Material_Amount__c, Material_Type__c, Labor_Amount__c, Add_Work_Labor_Type__c, IsRTS__c ';
        soql += 'From SBQQ__QuoteLine__c where SBQQ__ProductCode__c != \'' + String.escapeSingleQuotes(proCode) + '\' And project__c = \'' + proj.Id + '\'';    
        
        if (!name.equals(''))
            soql += ' and name Like \'%'+String.escapeSingleQuotes(name)+'%\'';
        if (!JobCardDescription.equals(''))
            soql += ' and Job_Card_Search_1__c Like \'%'+String.escapeSingleQuotes(JobCardDescription)+'%\'';
        if (!sqkStatus.equals(''))
            soql += ' and Add_Work_Status__c = \''+ sqkStatus +'\''; 
        system.debug('SOQL: ' + soql);     
        runQuery();
  
        return null;
    }
            
    public List<String> sqkStatusS {
        get {
            if (sqkStatusS == null) {
                sqkStatusS = new List<String>();
                Schema.DescribeFieldResult field = SBQQ__QuoteLine__c.Add_Work_Status__c.getDescribe();
    
                for (Schema.PicklistEntry f : field.getPicklistValues())
                    sqkStatusS.add(f.getLabel());
            }
        return sqkStatusS;          
        }
        set;
    }
    
}