public class SalesToolKitController {

	public SalesToolKitController(ApexPages.StandardController stdController){}

    // the soql without the order and limit
    private String soql {get;set;}
    public String soqlAC {get;set;}
    public String soqlEngine {get;set;}
    public String soqlAvionics {get;set;} 
    public String recordId {get; set;}
    public String fileId {get; set;}
       
  	// the collection of marketing Material to display
  	public List<Marketing_Material__c> mc {get;set;}
      
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

	// init the controller and display some marketing Material data when the page loads
  	public SalesToolKitController() {
    	soql = 'select id, name, product_name__c, Manufacturer__c, Make__c, Model__c, Category__c, data_type__c, target_audience__c, Show_Attached_File__c, (Select RelatedRecordId From Feeds Order By LastModifiedDate desc Limit 1)  from marketing_Material__c where name!= null and Show_Attached_File__c != null';     
    	runQuery();
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
     		mc = Database.query(soql + ' order by ' + sortField + ' ' + sortDir );
    	} catch (Exception e) {
      		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Marketing Material Found'));
    	}
  	}
  
  	// runs the search with parameters passed via Javascript
  	public PageReference runSearch() {

    	String name = Apexpages.currentPage().getParameters().get('name');
    	String targetAudience = Apexpages.currentPage().getParameters().get('targetAudience');
    	String dataType = Apexpages.currentPage().getParameters().get('dataType');
       
    	soql = 'select id, name, product_name__c, Manufacturer__c, Make__c, Model__c, Category__c, data_type__c, target_audience__c, Show_Attached_File__c, (Select RelatedRecordId From Feeds Order By LastModifiedDate desc Limit 1) from marketing_Material__c where name!= null and Show_Attached_File__c != null'; 
    
    	if (!name.equals(''))
      		soql += ' and name Like \'%'+String.escapeSingleQuotes(name)+'%\'';
    	if (!targetAudience.equals(''))
      		soql += ' and target_audience__c = \''+targetAudience+'\'';  
    	if (!dataType.equals(''))
      		soql += ' and data_type__c = \''+dataType+'\'';            
    	// run the query again
    	runQuery();
    
    	return null;
  	}

  	public void airframeSearch(){
    	soqlAC = 'select id, name, product_name__c, Manufacturer__c, Make__c, Model__c, Category__c, data_type__c, target_audience__c, Show_Attached_File__c, (Select RelatedRecordId From Feeds Order By LastModifiedDate desc Limit 1) from marketing_Material__c where Category__c = \'Aircraft\' and Show_Attached_File__c != null';
       	try{
         	mc = Database.query(soqlAC + ' order by ' + sortField + ' ' + sortDir);
		}catch (Exception e){
         	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, No Marketing Material Found For Aircraft...'));
      	}
  	}
  
  	public void engineSearch(){ 
    	soqlEngine = 'select id, name, product_name__c, Manufacturer__c, Make__c, Model__c, Category__c, data_type__c, target_audience__c, Show_Attached_File__c, (Select RelatedRecordId From Feeds Order By LastModifiedDate desc Limit 1) from marketing_Material__c where Category__c = \'Engine & APU\'and Show_Attached_File__c != null';
       	try{
         	mc = Database.query(soqlEngine + ' order by ' + sortField + ' ' + sortDir);
		}catch (Exception e){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, No Marketing Material Found For Engine...'));
      	}
  	}

  	public void avionicsSearch(){ 
    	soqlAvionics = 'select id, name, product_name__c, Manufacturer__c, Make__c, Model__c, Category__c, data_type__c, target_audience__c, Show_Attached_File__c, (Select RelatedRecordId From Feeds Order By LastModifiedDate desc Limit 1) from  marketing_Material__c where Category__c =\'Avionics & Paint/Interior\' and Show_Attached_File__c != null';
        if([select count() from marketing_Material__c where category__c ='Avionics & Paint/Interior'] < 1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, No Marketing Material Found For Avionics...'));
        }
        
        if([select count() from marketing_Material__c where category__c ='Avionics & Paint/Interior'] > 0){           
            try {
             	mc = Database.query(soqlAvionics + ' order by ' + sortField + ' ' + sortDir);
			} catch (Exception e) {
             	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, No Marketing Material Found For Avionics & Paint/Interior...'));
          	}
      	}
  	}
  
    public void sitesSearch(){ 
    	soqlAvionics = 'select id, name, product_name__c, Manufacturer__c, Make__c, Model__c, Category__c, data_type__c, target_audience__c, Show_Attached_File__c, (Select RelatedRecordId From Feeds Order By LastModifiedDate desc Limit 1) from  marketing_Material__c where Category__c =\'Sites, General Marketing & Misc\' and Show_Attached_File__c != null';
        if([select count() from marketing_Material__c where category__c ='Sites, General Marketing & Misc'] < 1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, No Marketing Material Found For Sites, General Marketing & Misc...'));
        }
        
        if([select count() from marketing_Material__c where category__c ='Sites, General Marketing & Misc'] > 0){           
            try {
             	mc = Database.query(soqlAvionics + ' order by ' + sortField + ' ' + sortDir);
			} catch (Exception e) {
             	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, No Marketing Material Found For Sites, General Marketing & Misc...'));
          	}
      	}
  	}
    
	public List<String> targetAudiences {
    	get {
      		if (targetAudiences == null) {

        		targetAudiences = new List<String>();
        		Schema.DescribeFieldResult field = marketing_Material__c.target_audience__c.getDescribe();

        		for (Schema.PicklistEntry f : field.getPicklistValues())
          			targetAudiences.add(f.getLabel());
      		}
      		return targetAudiences;          
    	}
    	set;
  	}
  
	public List<String> dataType {
    	get {
      		if (dataType == null) {

        		dataType = new List<String>();
        		Schema.DescribeFieldResult field = marketing_Material__c.data_type__c.getDescribe();

        		for (Schema.PicklistEntry f : field.getPicklistValues())
          			dataType.add(f.getLabel());
      		}
      		return dataType;          
    	}
    	set;
  	}
    
	public ApexPages.PageReference countReference() {
        
        Sales_Toolkit_Tracker__c tracker = new Sales_Toolkit_Tracker__c(
            Marketing_Material__c = recordId,
        	User__c = userinfo.getUserId());
        insert tracker;

        return null;
	}
             
    /*public List<selectoption> getLevel1Lst(){
        system.debug('Level1');
        
    list<SelectOption> l1Lst = new List<SelectOption>();
    Set<SelectOption> CatList1 = new Set<SelectOption>();
    
        l1Lst.add(new SelectOption('',''));
        
    list<Marketing_Material__c> cat= [select id, Category__c from Marketing_Material__c where Category__C != null];
            for(Marketing_Material__c c:cat){
                CatList1.add(new selectoption(c.category__c, c.category__c));
            }
    
        l1Lst.addAll(CatList1);
    
    System.debug('Level 1 Lst ('+l1ValStr+')');     
    return l1Lst;

    }
               
    public List<SelectOption> getLevel2Lst(){
        system.debug('Level2');

        if (l1ValStr != null) {

        List<selectOption> l2Lst = new List <SelectOption>();
        
            l2Lst.add(new SelectOption('',''));
        
        List <String> picklistvalues = new List<String>();
            picklistvalues.addall(manMap.get(l1ValStr));
                for(String picklistValue :picklistvalues){
                    l2Lst.add(new selectoption(picklistValue, picklistValue));  
                }
           
        System.debug('Level 2 Lst ('+l1ValStr+')');
        return l2Lst;}
        else
        return null;
    }
    
    public List<SelectOption> getLevel3Lst(){
        system.debug('Level3');
        
        if (l1ValStr != null && l2ValStr != null) {

        List<selectOption> l3Lst = new List <SelectOption>();
        
            l3Lst.add(new SelectOption('',''));
        
        List <String> picklistvalues = new List<String>();
            picklistvalues.addall(makMap.get(l2ValStr));
                for(String picklistValue :picklistvalues){
                    l3Lst.add(new selectoption(picklistValue, picklistValue));  
                }
     
        System.debug('Level 3 Lst ('+l2ValStr+')');
        return l3Lst;}
        else
        return null;
    }


    public List<SelectOption> getLevel4Lst(){
        system.debug('Level4');
        
        if (l1ValStr != null && l2ValStr != null && l3ValStr != null) {

        List<selectOption> l4Lst = new List <SelectOption>();
        
            l4Lst.add(new SelectOption('',''));
        
        List <String> picklistvalues = new List<String>();
            picklistvalues.addall(modMap.get(l3ValStr));
                for(String picklistValue :picklistvalues){
                    l4Lst.add(new selectoption(picklistValue, picklistValue));  
                }
     
        System.debug('Level 4 Lst ('+l3ValStr+')');
        return l4Lst;}
        else
        return null;
    }*/
       
}