@isTest
public class Test_QuotaController {
  @isTest
    static  void Testmethod1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];    
      UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
      insert r;
                
      User u2 = new User(
          Alias = 'nUser21',
          UserRoleId = r.Id,
          Email='newuser21@testorg.com', 
          EmailEncodingKey='UTF-8', 
          LastName='Testing', 
          LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', 
          ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', 
          UserName='newuser21@testorg.com');
   
        System.runAs(u2){
            Quota_Master__c qm = new Quota_Master__c();
        qm.year__c = string.ValueOf(system.today().year());
        qm.Name = 'Test AOP';
        insert qm;
            
             Quota_Sales_Region__c qr = new Quota_Sales_Region__c();
        qr.name = 'Test Region';
        qr.Year__c = string.valueof(system.today().year());
        qr.Quota_Master__c = qm.Id;
        qr.Region__c = 'West';
        insert qr;
            
            Quota_Sales_Employee__c qe = new Quota_Sales_Employee__c();
        qe.Name = 'Test Employee';
        qe.Year__c = String.valueof(system.today().year());
        qe.User__c = userinfo.getUserId();
        qe.Quota_Sales_Region__c = qr.Id;
        qe.Role__c = 'RSM';
        insert qe;
            
            Performance__c perf = new Performance__c();
        perf.Quarter__c = 'Q' + string.ValueOf(Math.ceil(system.today().month()/3.0));
        perf.Quota_Sales_Employee__c = qe.Id;
        perf.Quota_Master__c = qm.Id;
        perf.Name = 'Test Name';
    insert perf;
            
            QuotaController  QC=new QuotaController();
            QuotaController.QPerformance();
            QuotaController.QPerformance1('2019');
            QuotaController.QPerformanceRecord(perf.id);
            QuotaController.QEmpRecord(qe.Id);
            QuotaPerformanceController QPC=new QuotaPerformanceController();
            QuotaPerformanceController.QuotaEmployee();
            QuotaPerformanceController.QuotaPerformance();
            QuotaController.quotaPerformanceYearly('2021');
            QuotaPerformanceYearly.quotaPerformanceYearly('2021');
              QuotaPerformanceYearly.quotaPerformanceYearly('All');
            QuotaWrapper QW=new QuotaWrapper();
            
        }
    }
}