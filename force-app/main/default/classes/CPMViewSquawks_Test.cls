@istest
public class CPMViewSquawks_Test {
    
    @isTest
    public static void mehtod1(){
        
        String PDFData ='';
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
            
            
            //Create Aircraft
            Aircraft__c ac = new Aircraft__c();
            ac.Product_Line__c = prodLine.Id;
            ac.Aircraft_Make__c = 'CASA';
            ac.Aircraft_SN__c = '213';
            ac.name = 'NA';
            //ac.
            ac.Aircraft_Type__c = 'Aircraft';
            ac.OwnerId = UserInfo.getUserId();
            insert ac;
            
            
            //Create Engine
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.Id,
                Account__c = portalAccount.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                Model__c = 'HTF7000',
                Aircraft__c=ac.id
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
                AccountId = portalAccount.Id,
                Eligible_for_BizAv_Intro_Email__c = 'Yes'
            );
            insert portalContact;
            
            //Create User
            User portalUser = new User(
                ProfileId = [Select Id from profile where name = 'Customer Community Plus Login User - Custom'].Id,
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
            
            //Create Opportunity
            Opportunity oppty = new Opportunity();
            oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
            oppty.RSM__c = 'Campbell,Tom';
            oppty.Name = 'trigger test';
            oppty.Opportunity_Name_Details__c = 'trigger test';
            oppty.StageName = 'Cust Submitted Quote';
            oppty.AccountId = portalAccount.Id;
            oppty.Aircraft__c = ac.Id;
            oppty.Amount = decimal.valueof('1471620');
            oppty.Equipment__c = equip.Id;
            oppty.CustomerName__c = 'World Jet, Inc.';
            oppty.Facility__c = 'AGS';
            oppty.Tier_Level__c = '1';
            oppty.CloseDate =  Date.today();
            oppty.InputDate__c =  Date.today();
            oppty.OutputDate__c =  Date.today();
            oppty.Product_Line__c = ac.Product_Line__c;
            oppty.Type = 'Airframe';
            oppty.SubType__c = 'Airframe - Inspection';
            oppty.LeadSource = 'CPM';
            oppty.QuoteDelivery__c = 'Hand Delivery';
            oppty.QuoteRequiredBy__c =  Date.today();
            oppty.Base_Quote_Number__c = '1';
            oppty.QuotedDate__c =  Date.today();
            oppty.Concession1__c = 'None';
            oppty.Agent_Representative__c = 'Not Applicable';                                   
            insert oppty;
            
            //Create Project
            MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c();
            proj.Name = 'Project Test';
            proj.MPM4_BASE__Account__c = portalAccount.Id;
            proj.Opportunity__c = oppty.Id;
            proj.Aircraft__c = ac.Id;
            proj.Engine__c = equip.Id;
            proj.Input_Date__c = oppty.InputDate__c;
            proj.Delivery_Date__c = oppty.OutputDate__c;
            proj.MPM4_BASE__Kickoff__c = oppty.InputDate__c;
            proj.MPM4_BASE__Deadline__c = oppty.OutputDate__c;
            //proj.Crew_Chief__c = 'Spoon Man';
            proj.CPM__c = userInfo.getUserId();
            proj.Designated_Approver__c = portalUser.Id;
            proj.MPM4_BASE__Status__c = 'Active';
            proj.Same_Labor_Rate_Applied__c = True;
            Test.startTest();
            insert proj;
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId(),
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                Aircraft__c = ac.Id,
                Facility1__c = 'AGS');
            //,Project__c = proj.Id);
            
            insert quote;            
            
            String quotestring = String.valueOf(quote.id); 
            system.debug('quotestring>>'+quotestring);
            
            //Create Squawks
            List<SBQQ__QuoteLine__c> qls = new List<SBQQ__QuoteLine__c>();
            For(integer i=0; i<=8;i++){
                SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
                ql.SBQQ__Product__c = prod.Id;
                ql.Project__c = proj.Id;
                ql.Job_Card_Description__c = 'Test Squawk' + i;
                ql.SBQQ__Quote__c = quote.id; 
                ql.Designated_Approver__c = userInfo.getUserId();
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
            
            List<String> status = new List<String>();
            status.add('Approved');
           
            cpm_ViewSquawks csw = new cpm_ViewSquawks();
            csw.downloadPDF();
            
            qls = cpm_ViewSquawks.getSquawks(proj.Id);
            qls = cpm_ViewSquawks.getSquawkStatus(proj.Id, status);
            
            cpm_ViewSquawks.getQuoteSquawks(quote.Id);
                   
            cpm_ViewSquawks.wrapperClass wc= new cpm_ViewSquawks.wrapperClass();
            wc =  cpm_ViewSquawks.getAmounts(proj.Id);
            
           
            String squawkNo='4';
            String description='C/W proposal 55121-2';
           
            qls = cpm_ViewSquawks.getSquawkSearch(proj.Id, squawkNo, description);
            wc= cpm_ViewSquawks.getSquawkSearchAmount(proj.Id, squawkNo, description);
            wc= cpm_ViewSquawks.getStatusAmounts(proj.Id, status);
            
            
        }
        
        
    }
    
}