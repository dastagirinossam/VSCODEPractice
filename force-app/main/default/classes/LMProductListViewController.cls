public class LMProductListViewController {

    /*apex method to fetch wrapper of list view*/ 
    @AuraEnabled
    public static list<listViewWrapper> listValues(string objectInfo){
 
        list<listViewWrapper> oListViewWrapper = new list<listViewWrapper>();
 
        for(ListView lv : [SELECT id, Name, DeveloperName FROM ListView WHERE sObjectType = : objectInfo ORDER By Name ASC]){
            System.debug('list view is '+lv);
            listViewWrapper oWrapper = new listViewWrapper();
            oWrapper.label = lv.Name;
            oWrapper.developerName = lv.DeveloperName;
            oListViewWrapper.add(oWrapper);
        }
        
        return oListViewWrapper; 
    }
    
    @AuraEnabled
    public static String getListViewId(string listViewName, string objectInfo){
        ListView listView =[Select Id,Name FROM ListView WHERE sObjectType =: objectInfo and DeveloperName =: listViewName];
        String listViewId = listView.Id;
        return listViewId;
        
    }
 
    /*wrapper class to store listView details*/ 
    public class listViewWrapper{
        @AuraEnabled public string label{get;set;} 
        @AuraEnabled public string developerName{get;set;} 
    }
}