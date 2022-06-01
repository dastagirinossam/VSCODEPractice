@isTest
public class icUpdateTest {
    
    @testSetup 
    static void setup(){
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
   
        System.runAs(u2) {
        
            User u = new User(
                ProfileId = p.Id,
    
                Username = System.now().millisecond() + 'test@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                IsActive = true
            );
            insert u;
            
            User leader = new User(
                ProfileId = p.Id,
                Username = System.now().millisecond() + 'rfox@test.com',
                Alias = 'rfox',
                Email='rob.fox@test.com',
                EmailEncodingKey='UTF-8',
                Firstname='Rob',
                Lastname='Fox',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                IsActive = true
            );
            insert leader;
                       
            Integer currentYear = System.Today().year();
            Decimal month = Date.today().month();
            Decimal currentQuarter = month.divide(3, 0, System.RoundingMode.UP);
            String qtr = 'Q' + String.valueOf(currentQuarter);
            
            system.debug('Quarter: ' + qtr);
                                            
            Quota_Master__c qm = new Quota_Master__c(
                Name = String.valueOf(currentYear) + ' AOP',
                Year__c = String.valueOf(currentYear)        
            ); 
            insert qm;
            
            Quota_Sales_Region__c qsr = new Quota_Sales_Region__c(
                name = String.valueOf(currentYear) + ' - East',
                year__c = String.valueOf(currentYear),
                Quota_Master__c = qm.Id,
                Region__c = 'East',
                Leader__c = leader.Id
            );
            insert qsr;
            
            Quota_Sales_Region__c qsrMEX = new Quota_Sales_Region__c(
                name = String.valueOf(currentYear) + ' - MEX',
                year__c = String.valueOf(currentYear),
                Quota_Master__c = qm.Id,
                Region__c = 'MEX',
                Leader__c = leader.Id
            );
            insert qsrMEX;
            
            Quota_Sales_Employee__c qse = new Quota_Sales_Employee__c(
                Name = String.valueOf(currentYear) + ' - Wayne',
                Year__c = String.valueOf(currentYear),
                User__c = u.Id,
                Quota_Sales_Region__c = qsr.Id,
                Role__c = 'RSM'
            );
            insert qse;
            
            Quota_Sales_Employee__c qseMEX = new Quota_Sales_Employee__c(
                Name = String.valueOf(currentYear) + ' - Wayne',
                Year__c = String.valueOf(currentYear),
                User__c = u.Id,
                Quota_Sales_Region__c = qsrMEX.Id,
                Role__c = 'RSM'
            );
            insert qseMEX;
            
            Quota_Sales_Employee__c qseESM = new Quota_Sales_Employee__c(
                Name = String.valueOf(currentYear) + ' - Wayne',
                Year__c = String.valueOf(currentYear),
                User__c = u.Id,
                Quota_Sales_Region__c = qsr.Id,
                Role__c = 'ESM'
            );
            insert qseESM;
            
            Quota_Sales_Employee__c qseOther = new Quota_Sales_Employee__c(
                Name = String.valueOf(currentYear) + ' - Wayne',
                Year__c = String.valueOf(currentYear),
                User__c = u.Id,
                Quota_Sales_Region__c = qsr.Id,
                Role__c = 'Other'
            );
            insert qseOther;
                   
            Performance__C perf = new Performance__c(
                Name = String.valueOf(currentYear) + ' ' + qtr + ' - Wayne',
                Quota_Master__c = qm.Id,
                Quota_Sales_Employee__c = qse.Id,
                Quarter__c = qtr,
                Leader__c = 'Fox, Rob',
                Short_Dept__c = 'Airframe; HTF 7000;'
            );
            insert perf;
            
            Performance__C perfMEX = new Performance__c(
                Name = String.valueOf(currentYear) + ' ' + qtr + ' - Wayne',
                Quota_Master__c = qm.Id,
                Quota_Sales_Employee__c = qseMEX.Id,
                Quarter__c = qtr,
                Leader__c = 'Fox, Rob',
                Short_Dept__c = 'Airframe; HTF 7000;'
            );
            insert perfMEX;
            
            Performance__C ESM = new Performance__c(
                Name = String.valueOf(currentYear) + ' ' + qtr + ' - Wayne',
                Quota_Master__c = qm.Id,
                Quota_Sales_Employee__c = qseESM.Id,
                Quarter__c = qtr,
                Leader__c = 'Fox, Rob'
            );
            insert ESM;
            
            Performance__C engSplit = new Performance__c(
                Name = String.valueOf(currentYear) + ' ' + qtr + ' - Rental',
                Quota_Master__c = qm.Id,
                Quota_Sales_Employee__c = qseOther.Id,
                Quarter__c = qtr
            );
            insert engSplit; 
            
            Performance__c acSplit = new Performance__c(
                Name = String.valueOf(currentYear) + ' ' + qtr + ' - Airline',
                Quota_Master__c = qm.Id,
                Quota_Sales_Employee__c = qseOther.Id,
                Quarter__c = qtr
            );
            insert acSplit; 
            
            WO_Detail__c wod = new WO_Detail__c(
                name = String.valueOf(currentYear) + ' ' + qtr + ' - 123456 - 6/27',
                Consensus_RSM__c = perf.Id,
                Short_Dept__C = 'Airframe',
                Dispatch_Date__c = Date.Today(),                
                GL_Margin__c = 1.00,
                GL_Sale__c = 1.00
            );
            insert wod;
            
            WO_Detail__c eng = new WO_Detail__c(
                name = String.valueOf(currentYear) + ' ' + qtr + ' - 123456 - 6/27',
                Consensus_RSM__c = engSplit.Id,
                Short_Dept__C = 'HTF 7000',
                Dispatch_Date__c = Date.Today(),                
                GL_Margin__c = 1.00,
                GL_Sale__c = 1.00
            );
            insert eng;
            
            WO_Detail__c ac = new WO_Detail__c(
                name = String.valueOf(currentYear) + ' ' + qtr + ' - 123456 - 6/27',
                Consensus_RSM__c = acSplit.Id,
                Short_Dept__C = 'Airframe',
                Dispatch_Date__c = Date.Today(),                
                GL_Margin__c = 1.00,
                GL_Sale__c = 1.00
            );
            insert ac;
            
			WO_Detail__c wodHTF = new WO_Detail__c(
                name = String.valueOf(currentYear) + ' ' + qtr + ' - 123456 - 6/27',
                Consensus_RSM__c = perf.Id,
                Short_Dept__C = 'HTF 7000',
                Dispatch_Date__c = Date.Today(),
                GL_Margin__c = 1.00,
                GL_Sale__c = 1.00
            );
            insert wodHTF;           
        }        
    }
    
    static testmethod void updatePerformance(){
		List<Performance__c> pr = [Select Id from Performance__c where Role__c = 'RSM'];
        List<Id> perf = new List<Id>();
        
        for(Performance__c p : pr){
            perf.add(p.id);
        }
        
        Test.startTest();                       
        icUpdate.updateIC(perf);                       
        Test.stopTest();                  
    }
    
	static testmethod void noLeader(){
		List<Performance__c> pr = [Select Id from Performance__c where Role__c = 'RSM'];
        List<Id> perf = new List<Id>();
        
        for(Performance__c p : pr){
            p.Leader__c = null;
            p.Region_Rollup__c = 'MEX';
            perf.add(p.id);
        }
        update pr;
        
        Test.startTest();                       
        icUpdate.updateIC(perf);                       
        Test.stopTest();                  
    }
    
	static testmethod void onlyRegion(){
		List<Performance__c> pr = [Select Id from Performance__c where Role__c = 'RSM'];
        List<Id> perf = new List<Id>();
        
        for(Performance__c p : pr){
            p.Leader__c = null;
            p.Region_Rollup__c = 'MEX';
            p.short_dept__c = null;
            perf.add(p.id);
        }
        update pr;
        
        Test.startTest();                       
        icUpdate.updateIC(perf);                       
        Test.stopTest();                  
    }
    
	static testmethod void leaderRegionOnly(){
		List<Performance__c> pr = [Select Id from Performance__c where Role__c = 'RSM'];
        List<Id> perf = new List<Id>();
        
        for(Performance__c p : pr){
            p.Short_Dept__c = null;
            p.Region_Rollup__c = 'MEX';
            perf.add(p.id);
        }
        update pr;
        
        Test.startTest();                       
        icUpdate.updateIC(perf);                       
        Test.stopTest();                  
    }
    
	static testmethod void allFields(){
		List<Performance__c> pr = [Select Id from Performance__c where Role__c = 'RSM'];
        List<Id> perf = new List<Id>();
        
        for(Performance__c p : pr){
            p.Region_Rollup__c = 'MEX';
            perf.add(p.id);
        }
        update pr;
        
        Test.startTest();                       
        icUpdate.updateIC(perf);                       
        Test.stopTest();                  
    }
    
	static testmethod void shortDeptOnly(){
		List<Performance__c> pr = [Select Id from Performance__c where Role__c = 'RSM'];
        List<Id> perf = new List<Id>();
        
        for(Performance__c p : pr){
            p.Leader__c = null;
            perf.add(p.id);
        }
        update pr;
        
        Test.startTest();                       
        icUpdate.updateIC(perf);                       
        Test.stopTest();                  
    }
    
	static testmethod void leaderOnly(){
		List<Performance__c> pr = [Select Id from Performance__c where Role__c = 'RSM'];
        List<Id> perf = new List<Id>();
        
        for(Performance__c p : pr){
            p.Short_Dept__c = null;
            perf.add(p.id);
        }
        update pr;
        
        Test.startTest();                       
        icUpdate.updateIC(perf);                       
        Test.stopTest();                  
    }
    
	static testmethod void ESM(){
		List<Performance__c> pr = [Select Id from Performance__c where Role__c = 'ESM'];
        List<Id> perf = new List<Id>();
        
        for(Performance__c p : pr){
            perf.add(p.id);
        }
        update pr;
        
        Test.startTest();                       
        icUpdate.updateIC(perf);                       
        Test.stopTest();                  
    }
    
	static testmethod void Other(){
		List<Performance__c> pr = [Select Id from Performance__c where Role__c = 'Other' limit 1];
        List<Id> perf = new List<Id>();
        
        for(Performance__c p : pr){
            perf.add(p.id);
        }
        update pr;
        
        Test.startTest();                       
        icUpdate.updateIC(perf);                       
        Test.stopTest();                  
    }
    
	static testmethod void ClearSplits(){
		List<Performance__c> pr = [Select Id from Performance__c where Role__c = 'ESM'];
        List<Id> perf = new List<Id>();
  
        for(Performance__c p : pr){
            p.exclude_splits__c = true;
            perf.add(p.id);
        }
        update pr;
        
        Test.startTest();                       
        icUpdate.updateIC(perf);                       
        Test.stopTest();                  
    }
        

}