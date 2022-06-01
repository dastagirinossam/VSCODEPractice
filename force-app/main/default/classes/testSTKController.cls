@istest
public class testSTKController{

    public static testmethod void STKController(){
           
         Test.StartTest();
         
         PageReference pageRef = Page.SalesToolKit;
         pageref.getParameters().put('Name','FalconTest');
         pageref.getParameters().put('targetAudience','External');
         pageref.getParameters().put('category','Aircraft'); 
         pageref.getParameters().put('datatype','Presentation');
         pageref.getParameters().put('manufacturer','Dassault');
         pageref.getParameters().put('make','Falcon');
         pageref.getParameters().put('model','7x');    
         Test.setCurrentPage(pageRef);
         
         SalesToolKitController mcs = new SalesToolKitController();
         String sd = mcs.sortDir;
         String sf = mcs.sortField;
         String ds = mcs.debugSoql;
         
         SalesToolKitController controller = new SalesToolKitController();
         
         try{
             
             list<String> dt = mcs.dataType;         
             list<String> ta = mcs.targetAudiences ;
        
             mcs.toggleSort();
             mcs.runQuery();
             mcs.airframeSearch();
             mcs.engineSearch();
             mcs.avionicsSearch();
             mcs.sitesSearch();
             mcs.runSearch();
             mcs.countReference();
             
             }catch(Exception e){
    
         	}
    
        Test.StopTest();
  
	}      
}