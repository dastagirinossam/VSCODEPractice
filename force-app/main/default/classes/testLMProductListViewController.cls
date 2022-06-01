@isTest
public class testLMProductListViewController {
    @isTest
    static void testListValues(){
        test.startTest();
        LMProductListViewController.listValues('Product2');
        ListView listView =[Select Id,Name,DeveloperName FROM ListView WHERE sObjectType ='Product2' Limit 1];
        LMProductListViewController.getListViewId(listView.DeveloperName,'Product2');
        test.stopTest();
        
    }

}