@IsTest
public class tsmQuoteRoutingController_Test {
    static testmethod void method1(){ 
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
            Credit_Analyst_State_Account__c='SD',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com',
        	Product_Directors__c = 'Airframe;Interior;Paint;Other');
        insert u2;

        System.runAs(u2) {
            sbaa__ApprovalChain__c cpqAC = TestDataGenerator.createApprovalChain();
            Product_Line__c prodLine = TestDataGenerator.createProductLine();
            Account portalAccount = TestDataGenerator.createAccount();
            Contact c = TestDataGenerator.createContact(portalAccount.Id);
			Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
            Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
            Facility__c fac1 = TestDataGenerator.createFacility();
            Contact createContact = TestDataGenerator.createContact(portalAccount.Id);
            Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
            Opportunity oppty = TestDataGenerator.instantiateOpportunity(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                SBQQ__Opportunity2__c = oppty.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Downtime_Days__c=50,                
                SBQQ__SalesRep__c=u2.id,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS',
                SBQQ__Primary__c = True);  
            insert quote;  
         
            List<User> ulist = new List<User>();
            ulist.add(u2);
            
            String so='SD';
            Map<String, Facility__c> facMap = new Map<String, Facility__c>();
            facMap.put('AGS',fac1);  
            Decimal amt = 3000;  
            
            test.startTest();
            tsmQuoteRoutingController.getPicklistvalues();
            tsmQuoteRoutingController.getQuoteCreditAnalyst(so);
            tsmQuoteRoutingController.wrapperClass tsmwc = tsmQuoteRoutingController.getMargins(quote.Id);
            tsmQuoteRoutingController.tfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.htfApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.cfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.apuApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.paintApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.interiorApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.avionicsApprover(amt,tsmwc,facMap);            
            tsmQuoteRoutingController.otherApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.getFacility(quote.Id);
            tsmQuoteRoutingController.wrapperClass tsmwc1= new tsmQuoteRoutingController.wrapperClass();
            oppty.Type = 'APU';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc2 = tsmQuoteRoutingController.getMargins(quote.Id);
            oppty.Type = 'Avionics';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc3 = tsmQuoteRoutingController.getMargins(quote.Id);
            test.stopTest(); 
        }
    } 
    static testmethod void method2(){ 
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
            Credit_Analyst_State_Account__c='SD',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com',
        	Product_Directors__c = 'Airframe;Interior;Paint;Other');
        insert u2;
              
        System.runAs(u2) {
             AddWork_Trigger_Setting__c add = new  AddWork_Trigger_Setting__c();
            add.Name = 'AddWork';
            add.IsActive__c = False;
            insert add;
            
            sbaa__ApprovalChain__c cpqAC = TestDataGenerator.createApprovalChain();
            Product_Line__c prodLine = TestDataGenerator.createProductLine();
            Account portalAccount = TestDataGenerator.createAccount();
           
	 Contact c = new Contact();
        c.FirstName = 'Test1T';
        c.Lastname = 'McTesty1T';
        c.ContactType__c = 'Primary Contact';
        c.AccountId = portalAccount.Id;
        
        insert c;
			Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
            Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
            Facility__c fac1 = TestDataGenerator.createFacility();
            Contact createContact = TestDataGenerator.createContact(portalAccount.Id);
            Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
            Opportunity oppty = TestDataGenerator.createMasterOpportunity(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
            SBQQ__Quote__c quote = TestDataGenerator.createQuote(ac, portalAccount, oppty);

            //Create Quote     
            /*SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                SBQQ__Opportunity2__c = oppty.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Downtime_Days__c=50,                
                SBQQ__SalesRep__c=u2.id,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS',
                SBQQ__Primary__c = True);  
            insert quote;  */  
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;  
            
             test.startTest();
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = quote.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            insert cdl;
            
            List<User> ulist=new  List<User>();
            ulist.add(u2);
            
            String so='SD';
            Map<String, Facility__c> facMap = new Map<String, Facility__c>();
            facMap.put('AGS',fac1);  
            Decimal amt = 3000;
          
            tsmQuoteRoutingController.getPicklistvalues();
            tsmQuoteRoutingController.getQuoteCreditAnalyst(so);
            tsmQuoteRoutingController.wrapperClass tsmwc = tsmQuoteRoutingController.getMargins(quote.Id);
            tsmQuoteRoutingController.tfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.htfApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.cfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.apuApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.paintApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.interiorApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.avionicsApprover(amt,tsmwc,facMap);            
            tsmQuoteRoutingController.otherApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.getFacility(quote.Id);
           
            tsmQuoteRoutingController.wrapperClass tsmwc1= new tsmQuoteRoutingController.wrapperClass();
            oppty.Type = 'Interior';
            update oppty;
             
            tsmQuoteRoutingController.wrapperClass tsmwc2 = tsmQuoteRoutingController.getMargins(quote.Id);
            oppty.Type = 'CFE738';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc3 = tsmQuoteRoutingController.getMargins(quote.Id);
            oppty.Type = 'Paint';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc4 = tsmQuoteRoutingController.getMargins(quote.Id);
            oppty.Type = 'Aircraft Purchase';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc5 = tsmQuoteRoutingController.getMargins(quote.Id);
            
            string emailstr = 'xyz@gmail.com';
            string emailstrcc = 'test1@test.com, test2@test.com';
            string str = 'AGS';
            string erev = '1000';
            string eMP = '1000';
            string eHrs = '3';
            
            String dateFormatString = 'yyyy-MM-dd';
            Date d2 = Date.today();
            Datetime dt2 = Datetime.newInstance(d2.year(), d2.month(),d2.day());
            String newDate = dt2.format(dateFormatString);
            String dTr = '11/11/2019';
            string qdwntime = '3';
            string competitor = 'competitor';
            string note = 'test';
            string ids = (string)u2.Id;
            string ids1 = (string)quote.id;
            string  prodTypes = 'Test';
            String fileMap;
                            
            Set<Id> userId = new Set<Id>();
            userId.add(userinfo.getUserId());
            
            tsmQuoteRoutingController.EmailQuoteDetails(emailstr, emailstrcc, ids, ids1, prodTypes, erev, eMP, eHrs, newDate, qdwntime, competitor, note, fileMap);
            tsmQuoteRoutingController.getRecordValues(oppty.Id);
            tsmQuoteRoutingController.getAttachments(cdl.LinkedEntityId);
            tsmQuoteRoutingController.createQuoteApprovers(userId);
              test.stopTest();
            
        }
    } 
    
      static testmethod void method3(){ 
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
            Credit_Analyst_State_Account__c='SD',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com',
        	Product_Directors__c = 'Airframe;Interior;Paint;Other');
        insert u2;

        System.runAs(u2) {
            sbaa__ApprovalChain__c cpqAC = TestDataGenerator.createApprovalChain();
            Product_Line__c prodLine = TestDataGenerator.createProductLine();
            Account portalAccount = TestDataGenerator.createAccount();
           
	 Contact c = new Contact();
        c.FirstName = 'Test2T';
        c.Lastname = 'McTesty2T';
        c.ContactType__c = 'Primary Contact';
        c.AccountId = portalAccount.Id;
        
        insert c;
			Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
            Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
            Facility__c fac1 = TestDataGenerator.createFacility();
            Contact createContact = TestDataGenerator.createContact(portalAccount.Id);
            Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
            Opportunity oppty = TestDataGenerator.instantiateOpportunity1(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                SBQQ__Opportunity2__c = oppty.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Downtime_Days__c=50,                
                SBQQ__SalesRep__c=u2.id,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS',
                SBQQ__Primary__c = True);  
            insert quote;  
         
            List<User> ulist = new List<User>();
            ulist.add(u2);
            
            String so='SD';
            Map<String, Facility__c> facMap = new Map<String, Facility__c>();
            facMap.put('AGS',fac1);  
            Decimal amt = 3000;  
            
            test.startTest();
            tsmQuoteRoutingController.getPicklistvalues();
            tsmQuoteRoutingController.getQuoteCreditAnalyst(so);
            tsmQuoteRoutingController.wrapperClass tsmwc = tsmQuoteRoutingController.getMargins(quote.Id);
            tsmQuoteRoutingController.tfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.htfApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.cfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.apuApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.paintApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.interiorApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.avionicsApprover(amt,tsmwc,facMap);            
            tsmQuoteRoutingController.otherApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.getFacility(quote.Id);
            tsmQuoteRoutingController.wrapperClass tsmwc1= new tsmQuoteRoutingController.wrapperClass();
            oppty.Type = 'APU';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc2 = tsmQuoteRoutingController.getMargins(quote.Id);
            oppty.Type = 'Avionics';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc3 = tsmQuoteRoutingController.getMargins(quote.Id);
            test.stopTest(); 
        }
              
    } 
      static testmethod void method4(){ 
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
            Credit_Analyst_State_Account__c='SD',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com',
        	Product_Directors__c = 'Airframe;Interior;Paint;Other');
        insert u2;

        System.runAs(u2) {
            sbaa__ApprovalChain__c cpqAC = TestDataGenerator.createApprovalChain();
            Product_Line__c prodLine = TestDataGenerator.createProductLine();
            Account portalAccount = TestDataGenerator.createAccount();
           
	 Contact c = new Contact();
        c.FirstName = 'Test3T';
        c.Lastname = 'McTesty3T';
        c.ContactType__c = 'Primary Contact';
        c.AccountId = portalAccount.Id;
        
        insert c;
			Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
            Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
            Facility__c fac1 = TestDataGenerator.createFacility();
            Contact createContact = TestDataGenerator.createContact(portalAccount.Id);
            Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
            Opportunity oppty = TestDataGenerator.instantiateOpportunity2(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                SBQQ__Opportunity2__c = oppty.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Downtime_Days__c=50,                
                SBQQ__SalesRep__c=u2.id,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS',
                SBQQ__Primary__c = True);  
            insert quote;  
         
            List<User> ulist = new List<User>();
            ulist.add(u2);
            
            String so='SD';
            Map<String, Facility__c> facMap = new Map<String, Facility__c>();
            facMap.put('AGS',fac1);  
            Decimal amt = 3000;  
            
            test.startTest();
            tsmQuoteRoutingController.getPicklistvalues();
            tsmQuoteRoutingController.getQuoteCreditAnalyst(so);
            tsmQuoteRoutingController.wrapperClass tsmwc = tsmQuoteRoutingController.getMargins(quote.Id);
            tsmQuoteRoutingController.tfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.htfApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.cfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.apuApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.paintApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.interiorApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.avionicsApprover(amt,tsmwc,facMap);            
            tsmQuoteRoutingController.otherApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.getFacility(quote.Id);
            tsmQuoteRoutingController.wrapperClass tsmwc1= new tsmQuoteRoutingController.wrapperClass();
            oppty.Type = 'APU';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc2 = tsmQuoteRoutingController.getMargins(quote.Id);
            oppty.Type = 'Avionics';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc3 = tsmQuoteRoutingController.getMargins(quote.Id);
            test.stopTest(); 
        }
              
    } 
    static testmethod void method5(){ 
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
            Credit_Analyst_State_Account__c='SD',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com',
        	Product_Directors__c = 'Airframe;Interior;Paint;Other');
        insert u2;

        System.runAs(u2) {
            sbaa__ApprovalChain__c cpqAC = TestDataGenerator.createApprovalChain();
            Product_Line__c prodLine = TestDataGenerator.createProductLine();
            Account portalAccount = TestDataGenerator.createAccount();
         
	 Contact c = new Contact();
        c.FirstName = 'Test4T';
        c.Lastname = 'McTesty4T';
        c.ContactType__c = 'Primary Contact';
        c.AccountId = portalAccount.Id;
        
        insert c;
			Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
            Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
            Facility__c fac1 = TestDataGenerator.createFacility();
            Contact createContact = TestDataGenerator.createContact(portalAccount.Id);
            Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
            Opportunity oppty = TestDataGenerator.instantiateOpportunity3(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                SBQQ__Opportunity2__c = oppty.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Downtime_Days__c=50,                
                SBQQ__SalesRep__c=u2.id,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS',
                SBQQ__Primary__c = True);  
            insert quote;  
         
            List<User> ulist = new List<User>();
            ulist.add(u2);
            
            String so='SD';
            Map<String, Facility__c> facMap = new Map<String, Facility__c>();
            facMap.put('AGS',fac1);  
            Decimal amt = 3000;  
            
            test.startTest();
            tsmQuoteRoutingController.getPicklistvalues();
            tsmQuoteRoutingController.getQuoteCreditAnalyst(so);
            tsmQuoteRoutingController.wrapperClass tsmwc = tsmQuoteRoutingController.getMargins(quote.Id);
            tsmQuoteRoutingController.tfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.htfApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.cfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.apuApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.paintApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.interiorApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.avionicsApprover(amt,tsmwc,facMap);            
            tsmQuoteRoutingController.otherApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.getFacility(quote.Id);
            tsmQuoteRoutingController.wrapperClass tsmwc1= new tsmQuoteRoutingController.wrapperClass();
            oppty.Type = 'APU';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc2 = tsmQuoteRoutingController.getMargins(quote.Id);
            oppty.Type = 'Avionics';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc3 = tsmQuoteRoutingController.getMargins(quote.Id);
            test.stopTest(); 
        }
              
    }
    static testmethod void method6(){ 
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
            Credit_Analyst_State_Account__c='SD',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com',
        	Product_Directors__c = 'Airframe;Interior;Paint;Other');
        insert u2;

        System.runAs(u2) {
            sbaa__ApprovalChain__c cpqAC = TestDataGenerator.createApprovalChain();
            Product_Line__c prodLine = TestDataGenerator.createProductLine();
            Account portalAccount = TestDataGenerator.createAccount();
           
	 Contact c = new Contact();
        c.FirstName = 'Test5T';
        c.Lastname = 'McTesty5T';
        c.ContactType__c = 'Primary Contact';
        c.AccountId = portalAccount.Id;
        
        insert c;
			Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
            Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
            Facility__c fac1 = TestDataGenerator.createFacility();
            Contact createContact = TestDataGenerator.createContact(portalAccount.Id);
            Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
            Opportunity oppty = TestDataGenerator.instantiateOpportunity4(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                SBQQ__Opportunity2__c = oppty.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Downtime_Days__c=50,                
                SBQQ__SalesRep__c=u2.id,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS',
                SBQQ__Primary__c = True);  
            insert quote;  
         
            List<User> ulist = new List<User>();
            ulist.add(u2);
            
            String so='SD';
            Map<String, Facility__c> facMap = new Map<String, Facility__c>();
            facMap.put('AGS',fac1);  
            Decimal amt = 3000;  
            
            test.startTest();
            tsmQuoteRoutingController.getPicklistvalues();
            tsmQuoteRoutingController.getQuoteCreditAnalyst(so);
            tsmQuoteRoutingController.wrapperClass tsmwc = tsmQuoteRoutingController.getMargins(quote.Id);
            tsmQuoteRoutingController.tfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.htfApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.cfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.apuApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.paintApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.interiorApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.avionicsApprover(amt,tsmwc,facMap);            
            tsmQuoteRoutingController.otherApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.getFacility(quote.Id);
            tsmQuoteRoutingController.wrapperClass tsmwc1= new tsmQuoteRoutingController.wrapperClass();
            oppty.Type = 'APU';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc2 = tsmQuoteRoutingController.getMargins(quote.Id);
            oppty.Type = 'Avionics';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc3 = tsmQuoteRoutingController.getMargins(quote.Id);
            test.stopTest(); 
        }
              
    } 
     static testmethod void method7(){ 
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
            Credit_Analyst_State_Account__c='SD',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com',
        	Product_Directors__c = 'Airframe;Interior;Paint;Other');
        insert u2;

        System.runAs(u2) {
            sbaa__ApprovalChain__c cpqAC = TestDataGenerator.createApprovalChain();
            Product_Line__c prodLine = TestDataGenerator.createProductLine();
            Account portalAccount = TestDataGenerator.createAccount();
          
	 Contact c = new Contact();
        c.FirstName = 'Test6T';
        c.Lastname = 'McTesty6T';
        c.ContactType__c = 'Primary Contact';
        c.AccountId = portalAccount.Id;
        
        insert c;
			Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
            Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
            Facility__c fac1 = TestDataGenerator.createFacility();
            Contact createContact = TestDataGenerator.createContact(portalAccount.Id);
            Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
            Opportunity oppty = TestDataGenerator.instantiateOpportunity5(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                SBQQ__Opportunity2__c = oppty.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Downtime_Days__c=50,                
                SBQQ__SalesRep__c=u2.id,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS',
                SBQQ__Primary__c = True);  
            insert quote;  
         
            List<User> ulist = new List<User>();
            ulist.add(u2);
            
            String so='SD';
            Map<String, Facility__c> facMap = new Map<String, Facility__c>();
            facMap.put('AGS',fac1);  
            Decimal amt = 3000;  
            
            test.startTest();
            tsmQuoteRoutingController.getPicklistvalues();
            tsmQuoteRoutingController.getQuoteCreditAnalyst(so);
            tsmQuoteRoutingController.wrapperClass tsmwc = tsmQuoteRoutingController.getMargins(quote.Id);
            tsmQuoteRoutingController.tfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.htfApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.cfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.apuApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.paintApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.interiorApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.avionicsApprover(amt,tsmwc,facMap);            
            tsmQuoteRoutingController.otherApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.getFacility(quote.Id);
            tsmQuoteRoutingController.wrapperClass tsmwc1= new tsmQuoteRoutingController.wrapperClass();
            oppty.Type = 'APU';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc2 = tsmQuoteRoutingController.getMargins(quote.Id);
            oppty.Type = 'Avionics';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc3 = tsmQuoteRoutingController.getMargins(quote.Id);
            test.stopTest(); 
        }
              
    } 
    static testmethod void method8(){ 
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
            Credit_Analyst_State_Account__c='SD',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com',
        	Product_Directors__c = 'Airframe;Interior;Paint;Other');
        insert u2;

        System.runAs(u2) {
            sbaa__ApprovalChain__c cpqAC = TestDataGenerator.createApprovalChain();
            Product_Line__c prodLine = TestDataGenerator.createProductLine();
            Account portalAccount = TestDataGenerator.createAccount();
           
	 Contact c = new Contact();
        c.FirstName = 'Test7T';
        c.Lastname = 'McTesty7T';
        c.ContactType__c = 'Primary Contact';
        c.AccountId = portalAccount.Id;
        
        insert c;
			Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
            Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
            Facility__c fac1 = TestDataGenerator.createFacility();
            Contact createContact = TestDataGenerator.createContact(portalAccount.Id);
            Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
            Opportunity oppty = TestDataGenerator.instantiateOpportunity6(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                SBQQ__Opportunity2__c = oppty.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Downtime_Days__c=50,                
                SBQQ__SalesRep__c=u2.id,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS',
                SBQQ__Primary__c = True);  
            insert quote;  
         
            List<User> ulist = new List<User>();
            ulist.add(u2);
            
            String so='SD';
            Map<String, Facility__c> facMap = new Map<String, Facility__c>();
            facMap.put('AGS',fac1);  
            Decimal amt = 3000;  
          //  Decimal amt1=100000;
            test.startTest();
            tsmQuoteRoutingController.getPicklistvalues();
            tsmQuoteRoutingController.getQuoteCreditAnalyst(so);
            tsmQuoteRoutingController.wrapperClass tsmwc = tsmQuoteRoutingController.getMargins(quote.Id);
            tsmQuoteRoutingController.tfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.htfApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.cfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.apuApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.paintApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.interiorApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.avionicsApprover(amt,tsmwc,facMap);            
            tsmQuoteRoutingController.otherApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.getFacility(quote.Id);
            tsmQuoteRoutingController.getMST('East');
            tsmQuoteRoutingController.wrapperClass tsmwc1= new tsmQuoteRoutingController.wrapperClass();
            oppty.Type = 'APU';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc2 = tsmQuoteRoutingController.getMargins(quote.Id);
            oppty.Type = 'Avionics';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc3 = tsmQuoteRoutingController.getMargins(quote.Id);
            test.stopTest(); 
        }             
    } 
    
     static testmethod void method9(){ 
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
            Credit_Analyst_State_Account__c='SD',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com',
        	Product_Directors__c = 'Airframe;Interior;Paint;Other');
        insert u2;

        System.runAs(u2) {
            sbaa__ApprovalChain__c cpqAC = TestDataGenerator.createApprovalChain();
            Product_Line__c prodLine = TestDataGenerator.createProductLine();
            Account portalAccount = TestDataGenerator.createAccount();
           
	 Contact c = new Contact();
        c.FirstName = 'Test2T';
        c.Lastname = 'McTesty2T';
        c.ContactType__c = 'Primary Contact';
        c.AccountId = portalAccount.Id;
        
        insert c;
			Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
            Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
            Facility__c fac1 = TestDataGenerator.createFacility1();
            Contact createContact = TestDataGenerator.createContact(portalAccount.Id);
            Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
            Opportunity oppty = TestDataGenerator.instantiateOpportunity1(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                SBQQ__Opportunity2__c = oppty.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Downtime_Days__c=50,                
                SBQQ__SalesRep__c=u2.id,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS',
                SBQQ__Primary__c = True);  
            insert quote;  
         
            List<User> ulist = new List<User>();
            ulist.add(u2);
            
            String so='SD';
            Map<String, Facility__c> facMap = new Map<String, Facility__c>();
            facMap.put('AGS',fac1);  
            Decimal amt = 2;  
            
            test.startTest();
            tsmQuoteRoutingController.getPicklistvalues();
            tsmQuoteRoutingController.getQuoteCreditAnalyst(so);
            tsmQuoteRoutingController.wrapperClass tsmwc = tsmQuoteRoutingController.getMargins(quote.Id);
            tsmQuoteRoutingController.tfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.htfApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.cfeApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.apuApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.paintApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.interiorApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.avionicsApprover(amt,tsmwc,facMap);            
            tsmQuoteRoutingController.otherApprover(amt,tsmwc,facMap);
            tsmQuoteRoutingController.getFacility(quote.Id);
            tsmQuoteRoutingController.wrapperClass tsmwc1= new tsmQuoteRoutingController.wrapperClass();
            oppty.Type = 'APU';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc2 = tsmQuoteRoutingController.getMargins(quote.Id);
            oppty.Type = 'Avionics';
            update oppty;
            tsmQuoteRoutingController.wrapperClass tsmwc3 = tsmQuoteRoutingController.getMargins(quote.Id);
            test.stopTest(); 
        }
              
    } 
    
}