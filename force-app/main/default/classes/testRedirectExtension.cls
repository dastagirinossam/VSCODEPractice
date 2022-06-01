@isTest
public class testRedirectExtension {
    @isTest
    static void testdoSubmit(){
         Product2 prod = new Product2();
            prod.Name = 'Test Product';
            prod.Family_Type__c = 'Avionics';
            Insert prod;
        test.startTest();
        Product2 prod1 = [Select Id from Product2 Limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(prod1);
        RedirectExtension re=new RedirectExtension(sc);
        RedirectExtension.doSubmit();
        test.stopTest();
    }

}