@isTest(seealldata=true)
public class SquawkApprovalTest {
    testmethod static void testing(){
        Test.startTest();
                   
        
        Product_Line__c pl=TestDataGenerator.createProductLine();
        Aircraft__c arc=TestDataGenerator.createAircraft(pl.id);
        Account acc=TestDataGenerator.createAccount();
        Equipment__c eqp=TestDataGenerator.createEquipment(pl.id,acc.id);
        Opportunity opp=TestDataGenerator.instantiateOpportunity();
        product2 prod=TestDataGenerator.createProduct();
        string uid=Userinfo.getUserId();
        id  ids=Userinfo.getUserId();
        list<id> linkedids=new list<id>();
        linkedids.add(ids);
        MPM4_BASE__Milestone1_Project__c proj=TestDataGenerator.instantiateProject(acc.id, opp.Id, arc.Id, eqp.Id, opp.InputDate__c, opp.OutputDate__c,uid , uid, uid, uid, uid, uid, uid, uid);
        list<id> projlist=new list<id>();
        projlist.add(proj.id);
        SBQQ__Quote__c sb=TestDataGenerator.instantiateQuote(acc.id,arc.id,proj.id);
        //SBQQ__QuoteDocument__c sbq=TestDataGenerator.instantiateQuoteSDocument(proj.Id, sb.Id);
        //list<id> qd=new list<id>();
       // qd.add(sbq.Id);
       
        list<id> ad=new list<id>();
        ad.add(sb.id);
        list<id> sd=new list<id>();
       // sd.add(sq.id);
        //string s=sq.id;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 5];
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = sb.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                cdl.LinkedEntityId=Userinfo.getUserId();
            insert cdl; 
        list<id> cdllist=new list<id>();
        cdllist.add(CDL.Id);
        SquawkApproval sq1=new SquawkApproval();
        SquawkApproval.getQuote(ad);
        SquawkApproval.getQuotes(ad);
        SquawkApproval.getSquawks(sd);
        SquawkApproval.getSqk();
        SquawkApproval.getLbPreview(CDL.id);
        SquawkApproval.getPreview(CDL.Id);
        SquawkApproval.getProjectDetails(projlist);
        SquawkApproval.checkProjectType(projlist);
        //SquawkApproval.getQuoteFiles(linkedids);
        SquawkApproval.getFiles(linkedids);
       // SquawkApproval.getProjFiles(projlist);
        SquawkApproval.findSquawks('Project Test');
        //SquawkApproval.getAllQuoteLineRecords(sq.Id);
        SquawkApproval.getProjectRecords(projlist);
        SquawkApproval.getProjectQuoteLines(projlist);
        SquawkApproval.getActiveProjects();
        SquawkApproval.getOldProjects();
        SquawkApproval.findProjects('Project Test');
        //SquawkApproval.getAllQuoteLineRecords(proj.Id);
        SquawkApproval.fetchSqk(proj.Id, 'ASC', true);
        //SquawkApproval.getQuoteDoc(projlist);
        SquawkApproval.getQuoteDoc2(ad);
        SquawkApproval.getCcos(projlist);
       SquawkApproval.getLbEntries(projlist);
        SquawkApproval.getAppHistory(projlist);
        SquawkApproval.rejectRecords(projlist);
        SquawkApproval.getCount();
        SquawkApproval.viewAllSquawks(projlist);
        Test.stopTest();
        
        
    }
    
    testmethod static void testing2(){
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
      
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
            
            SquawkApproval sq1=new SquawkApproval();
            SquawkApproval.getOwner();
            //SquawkApproval.checkIsBroker();
        }
        Test.stopTest();
    }

    testmethod static void testing1(){
        Test.startTest();
                   
        
        Product_Line__c pl=TestDataGenerator.createProductLine();
        Aircraft__c arc=TestDataGenerator.createAircraft(pl.id);
        Account acc=TestDataGenerator.createAccount();
        Equipment__c eqp=TestDataGenerator.createEquipment(pl.id,acc.id);
        Opportunity opp=TestDataGenerator.instantiateOpportunity();
        product2 prod=TestDataGenerator.createProduct();
        string uid=Userinfo.getUserId();
        id  ids=Userinfo.getUserId();
        list<id> linkedids=new list<id>();
        linkedids.add(ids);
        MPM4_BASE__Milestone1_Project__c proj=TestDataGenerator.instantiateProject(acc.id, opp.Id, arc.Id, eqp.Id, opp.InputDate__c, opp.OutputDate__c,uid , uid, uid, uid, uid, uid, uid, uid);
        list<id> projlist=new list<id>();
        projlist.add(proj.id);
        SBQQ__Quote__c sb=TestDataGenerator.instantiateQuote(acc.id,arc.id,proj.id);
        
        //SBQQ__QuoteDocument__c sbq=TestDataGenerator.instantiateQuoteSDocument(proj.Id, sb.Id);
        //list<id> qd=new list<id>();
       // qd.add(sbq.Id);
       
        list<id> ad=new list<id>();
        ad.add(sb.id);
        list<id> sd=new list<id>();
        sd.add(sb.id);
        sd.add(ids);
       // sd.add(sq.id);
        //string s=sq.id;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 5];
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = sb.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                cdl.LinkedEntityId=Userinfo.getUserId();
            insert cdl; 
        sd.add(cdl.id);
        sd.add(proj.id);
        list<id> cdllist=new list<id>();
        cdllist.add(CDL.Id);
        SquawkApproval sq1=new SquawkApproval();
        SquawkApproval.fetchSqk(proj.Id, 'Project__r.Name', false);
        SquawkApproval.getQuoteFiles(sd);
        SquawkApproval.getProjFiles(sd);
        Test.stopTest();
    }
    testmethod static void testing3(){
                   Test.startTest();
        
        Product_Line__c pl=TestDataGenerator.createProductLine();
        Aircraft__c arc=TestDataGenerator.createAircraft(pl.id);
        Account acc=TestDataGenerator.createAccount();
        Equipment__c eqp=TestDataGenerator.createEquipment(pl.id,acc.id);
        Opportunity opp=TestDataGenerator.instantiateOpportunity();
        product2 prod=TestDataGenerator.createProduct();
        string uid=Userinfo.getUserId();
        id  ids=Userinfo.getUserId();
        list<id> linkedids=new list<id>();
        linkedids.add(ids);
        MPM4_BASE__Milestone1_Project__c proj=TestDataGenerator.instantiateProject(acc.id, opp.Id, arc.Id, eqp.Id, opp.InputDate__c, opp.OutputDate__c,uid , uid, uid, uid, uid, uid, uid, uid);
        list<id> projlist=new list<id>();
        projlist.add(proj.id);
        
         SBQQ__Quote__c sb =[select id,Labor_Type1__c,SBQQ__Status__c,Aircraft__c,Facility1__c,Project__c from SBQQ__Quote__c limit 1];
        SBQQ__QuoteDocument__c sbq=TestDataGenerator.instantiateQuoteSDocument(proj.Id, sb.Id);
        list<id> qd=new list<id>();
       qd.add(sbq.Id);
        SBQQ__QuoteLine__c sql=[select id from SBQQ__QuoteLine__c limit 1];
       list<id> sqlst=new list<id>();
        sqlst.add(sql.id);
        list<id> ad=new list<id>();
        ad.add(sb.id);
        list<id> sd=new list<id>();
        sd.add(sb.id);
        sd.add(ids);
         Log_Book_Entry__c lb = new Log_Book_Entry__c();
                lb.Name = 'Test Logbook';
                lb.Project__c = proj.Id;
            insert lb;
            list<id>  lblist=new list<id>();
        lblist.add(lb.id);
            //Insert Contract Change Order
            Contract_Change_Order__c cco = new Contract_Change_Order__c();
              cco.Project__c = proj.Id;
            insert cco;
        list<id> cc=new list<id>();
        cc.add(cco.id);
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 5];
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
                //cdl.LinkedEntityId = sb.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                cdl.LinkedEntityId=Userinfo.getUserId();
            insert cdl; 
        sd.add(cdl.id);
        sd.add(proj.id);
        list<id> cdllist=new list<id>();
        cdllist.add(CDL.Id);
        SquawkApproval sq1=new SquawkApproval();
        SquawkApproval.getQuoteDocument(qd);
        SquawkApproval.getQuoteLine(sqlst);
        SquawkApproval.getRtsRecords(sqlst);
        SquawkApproval.approveRecords(sqlst, 1000, 500);
        SquawkApproval.QuoteLineEmail(sqlst, 'yes', 'red');
        SquawkApproval.getLbEntry(lblist);
        SquawkApproval.getCCO(cc);
        SquawkApproval.getQuoteDoc(projlist);
        //SquawkApproval.checkIsBroker();
        Test.stopTest();
    }
    testmethod static void testing5(){
        Test.startTest();
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        UserRole r2 = [SELECT DeveloperName,Id,Name FROM UserRole WHERE Name = 'President' limit 1 ];
        String profileId1 = [Select Id from profile where name = 'NBAA Customer'].Id;
        User u2 = new User(
            Alias = 'nUser21',
            UserRoleId = r2.Id,
            Email='newuser21@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com');
        UserRole r = new UserRole(DeveloperName = 'StandardAeroCustomerUser', Name = 'StandardAeroCustomer User');
        insert r;
        Contact con=new Contact();
        insert u2;
        system.runAs(u2) {
            Account acc = new Account(name = 'StandardAeroAcc12test', Type = 'Customer', Area__c = 'W/U', BillingState = 'CA');
            insert acc;
            
            con = new Contact(FirstName = 'Test',Eligible_for_BizAv_Intro_Email__c='yes', LastName = 'Con345', Email = 'Test345@Test.com',AccountId=acc.Id,User_Record__c=UserInfo.getUserId());
            insert con;
            
            User u1 = new User(
                ProfileId = profileId1,
                //PortalRole = 'President',
                Username = con.Email + '.NBAA',
                Alias = 'Supbman',
                Email=con.Email,
                EmailEncodingKey='UTF-8',
                Firstname=con.FirstName,
                Lastname=con.LastName,
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testUser123',
                //UserRoleId = stringrole,
                //UserRoleId=r.id,
                IsActive = true,
                ContactId = con.id
            );
            insert u1;
            system.runAs(u1){
           SquawkApproval sq1=new SquawkApproval();
            SquawkApproval.checkIsBroker();
        }
        }
        Test.stopTest();
        
    }
}