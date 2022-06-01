@isTest
public class TestListViewPrinter {
    
    static testMethod void testPrint(){
        List <Account> lstAccount = new List<Account>();
        
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        testAccount.BillingState='CA';
        lstAccount.add(testAccount);
        Account testAccount1 = new Account();
        testAccount1.Name='Test Account1' ;
        testAccount1.BillingState='CA';
        lstAccount.add(testAccount1);
        
        insert  lstAccount;
        test.startTest();
        Test.setCurrentPage(Page.AccountPrintListvf);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstAccount);
        stdSetController.setSelected(lstAccount);
        ListViewPrinter obj=new ListViewPrinter(stdSetController);
        ListViewPrinter.print();
        test.stopTest();
        
    } 
    
}