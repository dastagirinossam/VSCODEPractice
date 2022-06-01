@isTest
public class TestLM_MailMerge {
    @isTest
    static void testSfdcUrl(){
        Account acc = TestDataGenerator.createAccount();
        test.startTest();
        List<String> sfdcUrl = LM_MailMerge.sfdcURL(acc.Id,'Account');
        test.stopTest();
        system.assertEquals(2, sfdcUrl.size());
        
    }

}