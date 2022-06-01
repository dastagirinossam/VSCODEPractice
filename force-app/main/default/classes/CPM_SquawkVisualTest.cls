@istest
public class CPM_SquawkVisualTest {
    
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
            
            //Create Product Line
            Product_Line__c prodLine = new Product_Line__c(
                Product_Line_Family__c = 'Aircraft',
                Name = 'new'
            );
            insert prodLine;
            
            //Create Account
            Account portalAccount = new Account();
            portalAccount.Name = 'test name';
            portalAccount.BillingStreet = '1600 Amphitheatre Parkway';
            portalAccount.BillingCity = 'Mountain View';
            portalAccount.BillingState = 'CA';
            portalAccount.BillingPostalCode = '94043';
            portalAccount.BillingCountry = 'United States';
            insert portalAccount;
            
            system.debug('Portal Account Owner Role: ' + portalAccount.Owner.UserRole);
            
            Aircraft__c ac = new Aircraft__c();
            ac.Product_Line__c = prodLine.id;
            ac.Aircraft_Make__c = 'CASA';
            ac.Aircraft_SN__c = '213';
            ac.name = 'NA';
            ac.Aircraft_Type__c = 'Aircraft';
            ac.Account__c = portalAccount.Id;
            ac.OwnerId = UserInfo.getUserId();
            
            insert ac;
            
            //Create Engine
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.id,
                Account__c = portalAccount.id,
                Aircraft__c = ac.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                Model__c = 'HTF7000'
            );
            
            insert equip;
            
            //Create Product
            Product2 prod = new Product2(
                Name = 'Unscheduled Product',
                ProductCode = 'Code1',
                isActive = True
            );
            insert prod;
            
            //Create contact
            Contact portalcontact = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount.Id
            );
            insert portalContact;
            
            //Create User
            User portalUser = new User(
                ProfileId = [Select Id from profile where name = 'Customer Community Plus - Custom'].Id,
                PortalRole = 'Executive',
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testUser123',
                IsActive = true,
                ContactId = portalContact.id
            );
            insert portalUser;
            
            system.debug('Portal User: ' + portalUser.Id);
            
            Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
            Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
            Id rtId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
            
            //Create Project
            MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c();
            proj.Name = 'Project Test';
            proj.MPM4_BASE__Account__c = portalAccount.Id;
            proj.Aircraft__c = ac.Id;
            proj.Engine__c = equip.Id;
            proj.Input_Date__c = Date.today();
            proj.Delivery_Date__c = Date.today();
            proj.MPM4_BASE__Kickoff__c = Date.today();
            proj.MPM4_BASE__Deadline__c = Date.today();
            proj.Crew_Chief__c = 'Spoon Man';
            proj.CPM__c = userInfo.getUserId();
            proj.Designated_Approver__c = portalUser.Id;
            proj.MPM4_BASE__Status__c = 'Active';             
            insert proj;
            
            //Check Pending Squawks number on Project
            MPM4_BASE__Milestone1_Project__c updatedProj = [Select Id, Pending_Squawks__c from MPM4_BASE__Milestone1_Project__c];
            Integer actual = integer.valueOf(updatedProj.Pending_Squawks__c);       
            System.AssertEquals(0, actual);
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId(),
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS');  
            insert quote; 
            
            //Create Squawks
            List<SBQQ__QuoteLine__c> qls = new List<SBQQ__QuoteLine__c>();
            For(integer i=0; i<=8;i++){
                SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
                ql.SBQQ__Product__c = prod.Id;
                ql.Project__c = proj.Id;
                ql.Job_Card_Description__c = 'Test Squawk' + i;
                ql.SBQQ__Quote__c = quote.id; 
                ql.Designated_Approver__c = portalUser.id;
                if(i<=2)
                    ql.Add_Work_Status__c = 'Approved';
                if(i>2 && i<=4)
                    ql.Add_Work_Status__c = 'Denied';
                if(i>4 && i<=6)
                    ql.Add_Work_Status__c = 'Pending';
                if(i>6 && i<=8)
                    ql.Add_Work_Status__c = '';
                qls.add(ql);
            }
            insert qls;
            
        }
    }
    
    public static testmethod void CPM_SquawkVisualTest(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_SquawkVisual;
        pageref.getParameters().put('Name','QL');
        pageref.getParameters().put('JobCardDescription','nlg');
        pageref.getParameters().put('sqkStatus','Aircraft');    
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        CPM_SquawkVisual sv = new CPM_SquawkVisual(sc);
        String sd = sv.sortDir;
        String sf = sv.sortField;
        String ds = sv.debugSoql;
        
        CPM_SquawkVisual controller = new CPM_SquawkVisual(sc);
        
        
        
        list<String> status = sv.sqkStatusS;
        
        sv.toggleSort();
        sv.runQuery();    
        sv.runSearch();
        
        
        
        Test.StopTest();  
    } 
    
    public static testmethod void CPM_ViewAllSquawksTestApproved(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','True');
        pageRef.getParameters().put('Declined','False');
        pageRef.getParameters().put('Pending','False');
        pageRef.getParameters().put('NotSubmitted','False');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestDeclined(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','False');
        pageRef.getParameters().put('Declined','True');
        pageRef.getParameters().put('Pending','False');
        pageRef.getParameters().put('NotSubmitted','False');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestPending(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','False');
        pageRef.getParameters().put('Declined','False');
        pageRef.getParameters().put('Pending','True');
        pageRef.getParameters().put('NotSubmitted','False');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestNS(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','False');
        pageRef.getParameters().put('Declined','False');
        pageRef.getParameters().put('Pending','False');
        pageRef.getParameters().put('NotSubmitted','True');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTest2(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','True');
        pageRef.getParameters().put('Declined','True');
        pageRef.getParameters().put('Pending','False');
        pageRef.getParameters().put('NotSubmitted','False');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestAP(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','True');
        pageRef.getParameters().put('Declined','False');
        pageRef.getParameters().put('Pending','True');
        pageRef.getParameters().put('NotSubmitted','False');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestANS(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','True');
        pageRef.getParameters().put('Declined','False');
        pageRef.getParameters().put('Pending','False');
        pageRef.getParameters().put('NotSubmitted','True');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestDP(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','False');
        pageRef.getParameters().put('Declined','True');
        pageRef.getParameters().put('Pending','True');
        pageRef.getParameters().put('NotSubmitted','False');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestDNS(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','False');
        pageRef.getParameters().put('Declined','True');
        pageRef.getParameters().put('Pending','False');
        pageRef.getParameters().put('NotSubmitted','True');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestPNS(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','False');
        pageRef.getParameters().put('Declined','False');
        pageRef.getParameters().put('Pending','True');
        pageRef.getParameters().put('NotSubmitted','True');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestADP(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','True');
        pageRef.getParameters().put('Declined','True');
        pageRef.getParameters().put('Pending','True');
        pageRef.getParameters().put('NotSubmitted','False');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestAPNS(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','True');
        pageRef.getParameters().put('Declined','False');
        pageRef.getParameters().put('Pending','True');
        pageRef.getParameters().put('NotSubmitted','True');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestADNS(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','True');
        pageRef.getParameters().put('Declined','True');
        pageRef.getParameters().put('Pending','False');
        pageRef.getParameters().put('NotSubmitted','True');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTestDPNS(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','False');
        pageRef.getParameters().put('Declined','True');
        pageRef.getParameters().put('Pending','True');
        pageRef.getParameters().put('NotSubmitted','True');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void CPM_ViewAllSquawksTest4(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();
        
        PageReference pageRef = Page.CPM_ViewAllSquawks; 
        pageRef.getParameters().put('id', proj.Id);
        pageRef.getParameters().put('Approved','True');
        pageRef.getParameters().put('Declined','True');
        pageRef.getParameters().put('Pending','True');
        pageRef.getParameters().put('NotSubmitted','True');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController vas = new ApexPages.StandardController(proj);
        CPM_ViewAllSquawks c = new CPM_ViewAllSquawks(vas);
        c.getProject();
        c.getSquawks();
        c.runQuery();
        c.toggleSort();
        c.pdf();
        c.prepareSquawkLinesForPrinting();
        c.runSearch();
        Test.StopTest();            		
    }
    
    public static testmethod void exportSquawksTest(){
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        
        Test.StartTest();     
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        exportSquawks expSqk = new exportSquawks(sc);
        
        expSqk.exportToExcel();
        
        Test.StopTest();  
    }
    
    public static testmethod void CPM_SquawkVisualQuote(){
        SBQQ__Quote__c qte = [Select Id from SBQQ__Quote__c];
        
        Test.StartTest();     
        ApexPages.StandardController sc = new ApexPages.StandardController(qte);
        CPM_SquawkVisual_Quote testCPM_Quote = new CPM_SquawkVisual_Quote(sc);
        
        testCPM_Quote.getQuoteLines();
        
        Test.StopTest();  
    }
    
}