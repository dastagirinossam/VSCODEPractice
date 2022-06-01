@isTest
public class testOpportunityTriggers {
            
    @testSetup 
    static void setup(){
        //Create User Role
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
		insert r;
        
        //Create User
        User u = new User(
        	ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
    	);
        insert u;
  
        System.runAs(u) {
            //Create Product Line
            Product_Line__c prodLine = new Product_Line__c(
                Product_Line_Family__c = 'Aircraft',
                SFDC_Name_Prefix__c = 'F7X.',               
                Name = 'new'
            );
            insert prodLine;
            
            //Create contact
            Contact contact = new Contact(
                    FirstName = 'Test',
                    Lastname = 'McTesty',
                    ContactType__c = 'Primary Contact'
            );
            insert contact;
    
            //Create Account
            Account portalAccount = new Account();
                portalAccount.Name = 'test name';
                portalAccount.BillingStreet = '1600 Amphitheatre Parkway';
                portalAccount.BillingCity = 'Mountain View';
                portalAccount.BillingState = 'TN';
                portalAccount.BillingPostalCode = '37128';
                portalAccount.BillingCountry = 'United States';
                portalAccount.Area__c = 'East';
            insert portalAccount;
            
            //Create Foreign Cert
            Foreign_Certification__c fc = new Foreign_Certification__c();
                fc.Country__c = 'United States';
                fc.Foreign_Certification__c = 'United States';
                fc.Status__c = 'Current';
                fc.Site__c = 'PHX';
                fc.Aircraft_Prefix__c = 'N';
                fc.Expiration_Date__c = date.Today();
                fc.Master_Foreign_Cert__c = True;
                fc.Name = 'PHX-United States-N';
				fc.Foreign_Cert_System_Name__c = 'PHX-United States-N';           
            insert fc;
             
            //Create Engine
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.id,
                Account__c = portalAccount.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                Model__c = 'HTF7000'
                );
            insert equip;
            
            //Create Aircraft
            Aircraft__c ac = new Aircraft__c();
                ac.Product_Line__c = prodLine.id;
                ac.Aircraft_Make__c = 'FALCON';
                ac.Aircraft_Model_2011__c = 'FALCON 7X';
                ac.Aircraft_SN__c = '213';
                ac.name = 'new';
                ac.ACReg__c = 'N12345';
                ac.Aircraft_Type__c = 'Aircraft';
                ac.OwnerId = UserInfo.getUserId();
            	ac.Account__c = portalAccount.Id;
            	ac.Aircraft_Type__c = 'Aircraft';
            insert ac;
                       
            //Create Product
            Product2 prod = new Product2(
                Name = 'Unscheduled Product',
                ProductCode = 'Code1',
                isActive = True
            );
            insert prod;
                            
            //Create Probability Group
            Probability_Grouping__c pb = New Probability_Grouping__c();
                pb.SystemProbabilityGroupingName__c = 'EAST.PHX.Avionics';
                pb.Probability_to_Use__c = 62;
                pb.Account_Area__c = 'EAST';
                pb.Facility__c = 'PHX';
                pb.Type__c = 'Avionics';
            insert pb;
            
           	Probability_Grouping__c p = [Select Name from Probability_Grouping__c where id =: pb.id];
            system.debug(p.name);
                       
            //Create Facility
            Facility__c fac = new Facility__c();
                fac.Name = 'PHX';
                fac.Street__c = '123 Anywhere Drive';
                fac.City__c = 'Nashville';
                fac.State__c = 'TN';
                fac.Zip_Code__c = '37617';
                fac.Phone__c = '123-456-7891';
                fac.Fax__c = '123-456-7891';
                fac.Airport__c = 'AGS';       
            insert fac;
            
            //Create SubType2
            Sub_Type_2__c st2 = new Sub_Type_2__c();
            	st2.Name = 'Test SubType2';
            	st2.Product_Line__c = prodLine.Id;
            	st2.Opportunity_Sub_Type__c = 'Cabin Broadband';
            	st2.Generic__c = True;
            	st2.Anchor_Inspection__c = True;
            insert st2;
            
            Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
            Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
            Id rtId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
            Id masterId = opportunityRecordTypeInfo .get('Master Opportunity').getRecordTypeId();
            
            //Create Opportunity
            Opportunity oppty = new Opportunity();
                oppty.Input_Date_Accuracy__c = 'Firm';
                oppty.Operator__c = 'FAA Part 135';
                oppty.RecordTypeId = masterId;
                oppty.RSM__c = 'Buchanan, Shaun';
                oppty.Name = 'trigger test';
                oppty.Opportunity_Name_Details__c = 'trigger test';
                oppty.StageName = 'New Opportunity';
                oppty.AccountId = portalAccount.Id;
                oppty.Aircraft__c = ac.Id;
                oppty.Amount = decimal.valueof('1471620');
                oppty.Equipment__c = equip.Id;
                oppty.CustomerName__c = 'World Jet, Inc.';
                oppty.Facility__c = 'PHX';
                oppty.Tier_Level__c = '2';
                oppty.CloseDate =  Date.today()+30;
                oppty.InputDate__c =  Date.today();
                oppty.OutputDate__c =  Date.today();
                oppty.Product_Line__c = ac.Product_Line__c;
                oppty.Type = 'Avionics';
                oppty.SubType__c = 'Cabin Broadband';
            	oppty.SubType2__c = st2.Id;
                oppty.LeadSource = 'CPM';
                oppty.QuoteDelivery__c = 'Hand Delivery';
                oppty.QuoteRequiredBy__c =  Date.today();
                oppty.Base_Quote_Number__c = '1';
                oppty.QuotedDate__c =  Date.today();
                oppty.Concession1__c = 'None';
                oppty.Agent_Representative__c = 'Not Applicable';
                oppty.Master_Opportunity__c = True;
                oppty.Competitor__c = 'Harrods Aviation';
                oppty.WinorLossReason1__c = 'Location';
                oppty.Win_Loss_Description__c = 'Test';
                oppty.Contact__c = contact.id;
                oppty.AFSM_Lookup__c = u.id;
            insert oppty;
            
            //Create Associated Opp
            Opportunity ao = new Opportunity();
                ao.RecordTypeId = rtId;
                ao.Operator__c = 'FAA Part 135';
                ao.RSM__c = 'Campbell,Tom';
                ao.Name = 'trigger test';
                ao.Opportunity_Name_Details__c = 'AO trigger test';
                ao.StageName = 'Cust Submitted Quote';
                ao.AccountId =  portalAccount.Id;
                ao.Aircraft__c = ac.Id;
                ao.Amount = decimal.valueof('1471620');
                ao.Equipment__c = equip.Id;
                ao.CustomerName__c = 'World Jet, Inc.';
                ao.Facility__c = 'PHX';
                ao.Tier_Level__c = '1';
                ao.CloseDate =  Date.today();
                ao.InputDate__c =  Date.today();
                ao.OutputDate__c =  Date.today();
                ao.Product_Line__c = ac.Product_Line__c;
                ao.Type = 'Avionics';
                ao.SubType__c = 'Cabin Broadband';
                ao.LeadSource = 'CPM';
                ao.QuoteDelivery__c = 'Hand Delivery';
                ao.QuoteRequiredBy__c =  Date.today();
                ao.Base_Quote_Number__c = '1';
                ao.QuotedDate__c =  Date.today();
                ao.Concession1__c = 'None';
                ao.Agent_Representative__c = 'Not Applicable';
                ao.MasterOpportunitylookup__c = oppty.id;
                ao.Competitor__c = 'Harrods Aviation';
                ao.WinorLossReason1__c = 'Location';
                ao.Win_Loss_Description__c = 'Test';
                ao.Customer_Satisfaction_Survey_Contact__c = contact.id;
                ao.Contact__c = contact.id;
                ao.AFSM_Lookup__c = u.id;
            insert ao;
            
            Opportunity ao_1 = [Select Probability_Grouping__c from Opportunity where Id =: ao.Id];
            system.debug(ao_1.Probability_Grouping__c);
            
            //Create Associated Opp1
            Opportunity ao1 = new Opportunity();
                ao1.RecordTypeId = rtId;
                ao1.Operator__c = 'FAA Part 135';
                ao1.RSM__c = 'Campbell,Tom';
                ao1.Name = 'trigger test';
                ao1.Opportunity_Name_Details__c = 'AO1 trigger test';
                ao1.StageName = 'Cust Submitted Quote';
                ao1.AccountId = [Select id from account].Id;
                ao1.Aircraft__c = [Select id from aircraft__c].Id;
                ao1.Amount = decimal.valueof('1471620');
                ao1.Equipment__c = [Select id from Equipment__c].Id;
                ao1.CustomerName__c = 'World Jet, Inc.';
                ao1.Facility__c = 'AGS';
                ao1.Tier_Level__c = '1';
                ao1.CloseDate =  Date.today();
                ao1.InputDate__c =  Date.today();
                ao1.OutputDate__c =  Date.today();
                ao1.Product_Line__c = [Select Product_Line__c from Aircraft__c].Product_Line__c;
                ao1.Type = 'Avionics';
                ao1.SubType__c = 'Cabin Broadband';
                ao1.LeadSource = 'CPM';
                ao1.QuoteDelivery__c = 'Hand Delivery';
                ao1.QuoteRequiredBy__c =  Date.today();
                ao1.Base_Quote_Number__c = '1';
                ao1.QuotedDate__c =  Date.today();
                ao1.Concession1__c = 'None';
                ao1.Agent_Representative__c = 'Not Applicable';
                ao1.MasterOpportunitylookup__c = oppty.id;
                ao1.Competitor__c = 'Harrods Aviation';
                ao1.WinorLossReason1__c = 'Location';
                ao1.Win_Loss_Description__c = 'Test';
                ao1.Customer_Satisfaction_Survey_Contact__c = contact.id;
                ao1.Contact__c = contact.id;
                ao1.AFSM_Lookup__c = u.id;
            insert ao1;
            
            //Create Associated Opp2
            Opportunity ao2 = new Opportunity();
                ao2.RecordTypeId = rtId;
                ao2.Operator__c = 'FAA Part 135';
                ao2.RSM__c = 'Campbell,Tom';
                ao2.Name = 'trigger test';
                ao2.Opportunity_Name_Details__c = 'AO2 trigger test';
                ao2.StageName = 'Cust Submitted Quote';
                ao2.AccountId = [Select id from account].Id;
                ao2.Aircraft__c = [Select id from aircraft__c].Id;
                ao2.Amount = decimal.valueof('1471620');
                ao2.Equipment__c = [Select id from Equipment__c].Id;
                ao2.CustomerName__c = 'World Jet, Inc.';
                ao2.Facility__c = 'AGS';
                ao2.Tier_Level__c = '1';
                ao2.CloseDate =  Date.today();
                ao2.InputDate__c =  Date.today();
                ao2.OutputDate__c =  Date.today();
                ao2.Product_Line__c = [Select Product_Line__c from Aircraft__c].Product_Line__c;
                ao2.Type = 'Avionics';
                ao2.SubType__c = 'Cabin Broadband';
                ao2.LeadSource = 'CPM';
                ao2.QuoteDelivery__c = 'Hand Delivery';
                ao2.QuoteRequiredBy__c =  Date.today();
                ao2.Base_Quote_Number__c = '1';
                ao2.QuotedDate__c =  Date.today();
                ao2.Concession1__c = 'None';
                ao2.Agent_Representative__c = 'Not Applicable';
                ao2.MasterOpportunitylookup__c = oppty.id;
                ao2.Competitor__c = 'Harrods Aviation';
                ao2.WinorLossReason1__c = 'Location';
                ao2.Win_Loss_Description__c = 'Test';
                ao2.Customer_Satisfaction_Survey_Contact__c = contact.id;
                ao2.Contact__c = contact.id;
                ao2.AFSM_Lookup__c = u.id;
            insert ao2;
                   
            //Create Associated Opp3
            Opportunity ao3 = new Opportunity();
                ao3.Operator__c = 'FAA Part 135';
                ao3.RecordTypeId = rtId;
                ao3.RSM__c = 'Campbell,Tom';
                ao3.Name = 'trigger test';
                ao3.Opportunity_Name_Details__c = 'AO3 trigger test';
                ao3.StageName = 'Cust Submitted Quote';
                ao3.AccountId = [Select id from account].Id;
                ao3.Aircraft__c = [Select id from aircraft__c].Id;
                ao3.Amount = decimal.valueof('1471620');
                ao3.Equipment__c = [Select id from Equipment__c].Id;
                ao3.CustomerName__c = 'World Jet, Inc.';
                ao3.Facility__c = 'AGS';
                ao3.Tier_Level__c = '1';
                ao3.CloseDate =  Date.today();
                ao3.InputDate__c =  Date.today();
                ao3.OutputDate__c =  Date.today();
                ao3.Product_Line__c = [Select Product_Line__c from Aircraft__c].Product_Line__c;
                ao3.Type = 'Avionics';
                ao3.SubType__c = 'Cabin Broadband';
                ao3.LeadSource = 'CPM';
                ao3.QuoteDelivery__c = 'Hand Delivery';
                ao3.QuoteRequiredBy__c =  Date.today();
                ao3.Base_Quote_Number__c = '1';
                ao3.QuotedDate__c =  Date.today();
                ao3.Concession1__c = 'None';
                ao3.Agent_Representative__c = 'Not Applicable';
                ao3.MasterOpportunitylookup__c = oppty.id;
                ao3.Competitor__c = 'Harrods Aviation';
                ao3.WinorLossReason1__c = 'Location';
                ao3.Win_Loss_Description__c = 'Test';
                ao3.Customer_Satisfaction_Survey_Contact__c = contact.id;
                ao3.Contact__c = contact.id;
                ao3.AFSM_Lookup__c = u.id;
            insert ao3;
            
            //Create Associated Opp4
            Opportunity ao4 = new Opportunity();
                ao4.RecordTypeId = rtId;
                ao4.Operator__c = 'FAA Part 135';
                ao4.RSM__c = 'Campbell,Tom';
                ao4.Name = 'trigger test';
                ao4.Opportunity_Name_Details__c = 'AO4 trigger test';
                ao4.StageName = 'Cust Submitted Quote';
                ao4.AccountId = [Select id from account].Id;
                ao4.Aircraft__c = [Select id from aircraft__c].Id;
                ao4.Amount = decimal.valueof('1471620');
                ao4.Equipment__c = [Select id from Equipment__c].Id;
                ao4.CustomerName__c = 'World Jet, Inc.';
                ao4.Facility__c = 'AGS';
                ao4.Tier_Level__c = '1';
                ao4.CloseDate =  Date.today();
                ao4.InputDate__c =  Date.today();
                ao4.OutputDate__c =  Date.today();
                ao4.Product_Line__c = [Select Product_Line__c from Aircraft__c].Product_Line__c;
                ao4.Type = 'Avionics';
                ao4.SubType__c = 'Cabin Broadband';
                ao4.LeadSource = 'CPM';
                ao4.QuoteDelivery__c = 'Hand Delivery';
                ao4.QuoteRequiredBy__c =  Date.today();
                ao4.Base_Quote_Number__c = '1';
                ao4.QuotedDate__c =  Date.today();
                ao4.Concession1__c = 'None';
                ao4.Agent_Representative__c = 'Not Applicable';
                ao4.MasterOpportunitylookup__c = oppty.id;
                ao4.Competitor__c = 'Harrods Aviation';
                ao4.WinorLossReason1__c = 'Location';
                ao4.Win_Loss_Description__c = 'Test';
                ao4.Customer_Satisfaction_Survey_Contact__c = contact.id;
                ao4.Contact__c = contact.id;
                ao4.AFSM_Lookup__c = u.id;
            insert ao4;
            
            //Create Associated Opp5
            Opportunity ao5 = new Opportunity();
                ao5.RecordTypeId = rtId;
                ao5.Operator__c = 'FAA Part 135';
                ao5.RSM__c = 'Campbell,Tom';
                ao5.Name = 'trigger test';
                ao5.Opportunity_Name_Details__c = 'AO5 trigger test';
                ao5.StageName = 'Cust Submitted Quote';
                ao5.AccountId = [Select id from account].Id;
                ao5.Aircraft__c = [Select id from aircraft__c].Id;
                ao5.Amount = decimal.valueof('1471620');
                ao5.Equipment__c = [Select id from Equipment__c].Id;
                ao5.CustomerName__c = 'World Jet, Inc.';
                ao5.Facility__c = 'AGS';
                ao5.Tier_Level__c = '1';
                ao5.CloseDate =  Date.today();
                ao5.InputDate__c =  Date.today();
                ao5.OutputDate__c =  Date.today();
                ao5.Product_Line__c = [Select Product_Line__c from Aircraft__c].Product_Line__c;
                ao5.Type = 'Avionics';
                ao5.SubType__c = 'Cabin Broadband';
                ao5.LeadSource = 'CPM';
                ao5.QuoteDelivery__c = 'Hand Delivery';
                ao5.QuoteRequiredBy__c =  Date.today();
                ao5.Base_Quote_Number__c = '1';
                ao5.QuotedDate__c =  Date.today();
                ao5.Concession1__c = 'None';
                ao5.Agent_Representative__c = 'Not Applicable';
                ao5.MasterOpportunitylookup__c = oppty.id;
                ao5.Competitor__c = 'Harrods Aviation';
                ao5.WinorLossReason1__c = 'Location';
                ao5.Win_Loss_Description__c = 'Test';
                ao5.Customer_Satisfaction_Survey_Contact__c = contact.id;
                ao5.Contact__c = contact.id;
                ao5.AFSM_Lookup__c = u.id;
            insert ao5;
            
            //Create Associated Opp6
            Opportunity ao6 = new Opportunity();
                ao6.RecordTypeId = rtId;
                ao6.Operator__c = 'FAA Part 135';
                ao6.RSM__c = 'Campbell,Tom';
                ao6.Name = 'trigger test';
                ao6.Opportunity_Name_Details__c = 'AO6 trigger test';
                ao6.StageName = 'Cust Submitted Quote';
                ao6.AccountId = [Select id from account].Id;
                ao6.Aircraft__c = [Select id from aircraft__c].Id;
                ao6.Amount = decimal.valueof('1471620');
                ao6.Equipment__c = [Select id from Equipment__c].Id;
                ao6.CustomerName__c = 'World Jet, Inc.';
                ao6.Facility__c = 'AGS';
                ao6.Tier_Level__c = '1';
                ao6.CloseDate =  Date.today();
                ao6.InputDate__c =  Date.today();
                ao6.OutputDate__c =  Date.today();
                ao6.Product_Line__c = [Select Product_Line__c from Aircraft__c].Product_Line__c;
                ao6.Type = 'Avionics';
                ao6.SubType__c = 'Cabin Broadband';
                ao6.LeadSource = 'CPM';
                ao6.QuoteDelivery__c = 'Hand Delivery';
                ao6.QuoteRequiredBy__c =  Date.today();
                ao6.Base_Quote_Number__c = '1';
                ao6.QuotedDate__c =  Date.today();
                ao6.Concession1__c = 'None';
                ao6.Agent_Representative__c = 'Not Applicable';
                ao6.MasterOpportunitylookup__c = oppty.id;
                ao6.Competitor__c = 'Harrods Aviation';
                ao6.WinorLossReason1__c = 'Location';
                ao6.Win_Loss_Description__c = 'Test';
                ao6.Customer_Satisfaction_Survey_Contact__c = contact.id;
                ao6.Contact__c = contact.id;
                ao6.AFSM_Lookup__c = u.id;
            insert ao6;
            
            //Create Associated Opp7
            Opportunity ao7 = new Opportunity();
                ao7.RecordTypeId = rtId;
                ao7.Operator__c = 'FAA Part 135';
                ao7.RSM__c = 'Campbell,Tom';
                ao7.Name = 'trigger test';
                ao7.Opportunity_Name_Details__c = 'AO7 trigger test';
                ao7.StageName = 'Cust Submitted Quote';
                ao7.AccountId = [Select id from account].Id;
                ao7.Aircraft__c = [Select id from aircraft__c].Id;
                ao7.Amount = decimal.valueof('1471620');
                ao7.Equipment__c = [Select id from Equipment__c].Id;
                ao7.CustomerName__c = 'World Jet, Inc.';
                ao7.Facility__c = 'AGS';
                ao7.Tier_Level__c = '1';
                ao7.CloseDate =  Date.today();
                ao7.InputDate__c =  Date.today();
                ao7.OutputDate__c =  Date.today();
                ao7.Product_Line__c = [Select Product_Line__c from Aircraft__c].Product_Line__c;
                ao7.Type = 'Avionics';
                ao7.SubType__c = 'Cabin Broadband';
                ao7.LeadSource = 'CPM';
                ao7.QuoteDelivery__c = 'Hand Delivery';
                ao7.QuoteRequiredBy__c =  Date.today();
                ao7.Base_Quote_Number__c = '1';
                ao7.QuotedDate__c =  Date.today();
                ao7.Concession1__c = 'None';
                ao7.Agent_Representative__c = 'Not Applicable';
                ao7.MasterOpportunitylookup__c = oppty.id;
                ao7.Competitor__c = 'Harrods Aviation';
                ao7.WinorLossReason1__c = 'Location';
                ao7.Win_Loss_Description__c = 'Test';
                ao7.Customer_Satisfaction_Survey_Contact__c = contact.id;
                ao7.Contact__c = contact.id;
                ao7.AFSM_Lookup__c = u.id;
                ao7.Associated_Opportunity_01__c = ao.id;
            	ao7.Associated_Opportunity_02__c = ao1.id;
            	ao7.Associated_Opportunity_03__c = ao2.id;
            	ao7.Associated_Opportunity_04__c = ao3.id;
            	ao7.Associated_Opportunity_05__c = ao4.id;
            	ao7.Associated_Opportunity_06__c = ao5.id;
            	ao7.Associated_Opportunity_07__c = ao6.id;
            insert ao7;            
            
            //Associate Opportunities To Master
            oppty.Associated_Opportunity_01__c = ao.id;
            oppty.Associated_Opportunity_02__c = ao1.id;
            oppty.Associated_Opportunity_03__c = ao2.id;
            oppty.Associated_Opportunity_04__c = ao3.id;
            oppty.Associated_Opportunity_05__c = ao4.id;
            oppty.Associated_Opportunity_06__c = ao5.id;
            oppty.Associated_Opportunity_07__c = ao6.id;
            oppty.Associated_Opportunity_08__c = ao7.id;
            update oppty;           
        }
    }
    
    static testMethod void ChangeFacility() {
        test.startTest();
        
        Opportunity myOpp = [SELECT Id, Probability FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
       
        myOpp.Probability = 82;
        myOpp.Facility__c = 'AGS';
    
        update myOpp;
        test.stopTest();
    
        Opportunity Opp = [SELECT Id, Probability FROM Opportunity where Id =: myOpp.Id];
        System.assertEquals(82, Opp.Probability);
    }
    
    static testMethod void testOpportunityTriggers_UpdateOpen() {
        test.startTest();
        
        Opportunity myOpp = [SELECT Id, Probability FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        myOpp.Probability = 82;
    
        update myOpp;
        test.stopTest();
    
        Opportunity Opp = [SELECT Id, Probability FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        System.assertEquals(62, Opp.Probability);
    }
    
	static testMethod void testOpportunityTriggers_UpdateOpenOverride() {
        test.startTest();
        
        Opportunity myOpp = [SELECT Id, Probability_To_Use__c, Probability_Grouping_Override__c  FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        myOpp.Probability = 21;
        myOpp.Probability_To_Use__c = 57;
        myOpp.Probability_Grouping_Override__c = True;
    
        update myOpp;
        test.stopTest();
    
        Opportunity Opp = [SELECT Id, Probability, Probability_To_Use__c FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        System.assertEquals(21, Opp.Probability);
        System.assertEquals(62, Opp.Probability_To_Use__c);
    }
    
    static testMethod void testOpportunityTriggers_UpdateWon() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('RFS').getRecordTypeId();
        
        test.startTest();
        
        Opportunity myOpp = [SELECT Id FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'RFS';
        myOpp.Probability_To_Use__c = 82;
        myOpp.Probability_Grouping_Override__c = True;
    
        update myOpp;
        test.stopTest();
    
        Opportunity Opp = [SELECT Id, Probability FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        System.assertEquals(100, Opp.Probability);
    }
    
    static testMethod void testOpportunityTriggers_UpdateWonNoOverride(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('RFS').getRecordTypeId();
        
        test.startTest();
        
        Opportunity myOpp = [SELECT Id FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'RFS';
        myOpp.Probability_To_Use__c = 82;
        
        update myOpp;
        test.stopTest();
    
        Opportunity Opp = [SELECT Id, Probability FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        System.assertEquals(100, Opp.Probability);
    }
    
    static testMethod void testOpportunityTriggers_UpdateLoss() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity myOpp = [SELECT Id FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
        myOpp.Probability_To_Use__c = 82;
        myOpp.Probability_Grouping_Override__c = True;
    
        update myOpp;
        test.stopTest();
    
        Opportunity Opp = [SELECT Id, Probability FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        System.assertEquals(0, Opp.Probability);
    }
    
    static testMethod void testOpportunityTriggers_UpdateLossNoOverride() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity myOpp = [SELECT Id FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
        myOpp.Probability_To_Use__c = 82;
  
        update myOpp;
        test.stopTest();
    
        Opportunity Opp = [SELECT Id, Probability FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        System.assertEquals(0, Opp.Probability);

    }  
        
	static testMethod void testOpportunityTriggers_AO_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
		Opportunity myOpp = [SELECT Id, MasterOpportunitylookup__r.Name FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
 		update myOpp;
                
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       

        System.assertEquals(null, oppty.Associated_Opportunity_01__c );        
        System.assertEquals('test name - F7X.213 - AO1 trigger test', oppty.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO2 trigger test', oppty.Associated_Opportunity_03__r.Name);
		System.assertEquals('test name - F7X.213 - AO3 trigger test', oppty.Associated_Opportunity_04__r.Name);
		System.assertEquals('test name - F7X.213 - AO4 trigger test', oppty.Associated_Opportunity_05__r.Name);
		System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty.Associated_Opportunity_06__r.Name);
		System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty.Associated_Opportunity_07__r.Name);
		System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty.Associated_Opportunity_08__r.Name);   
        test.stopTest();
    }
    
	static testMethod void testOpportunityTriggers_AO1_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
		Opportunity myOpp = [SELECT Id, MasterOpportunitylookup__r.Name FROM Opportunity where Name = 'test name - F7X.213 - AO1 trigger test'];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
 		update myOpp;
                
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       

        System.assertEquals(null, oppty.Associated_Opportunity_02__c );        
        System.assertEquals('test name - F7X.213 - AO trigger test', oppty.Associated_Opportunity_01__r.Name);
		System.assertEquals('test name - F7X.213 - AO2 trigger test', oppty.Associated_Opportunity_03__r.Name);
		System.assertEquals('test name - F7X.213 - AO3 trigger test', oppty.Associated_Opportunity_04__r.Name);
		System.assertEquals('test name - F7X.213 - AO4 trigger test', oppty.Associated_Opportunity_05__r.Name);
		System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty.Associated_Opportunity_06__r.Name);
		System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty.Associated_Opportunity_07__r.Name);
		System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty.Associated_Opportunity_08__r.Name);      
        test.stopTest();
    }
    
    static testMethod void testOpportunityTriggers_AO2_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
		Opportunity myOpp = [SELECT Id, MasterOpportunitylookup__r.Name FROM Opportunity where Name = 'test name - F7X.213 - AO2 trigger test'];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
 		update myOpp;
                
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       

        System.assertEquals(null, oppty.Associated_Opportunity_03__c );        
        System.assertEquals('test name - F7X.213 - AO trigger test', oppty.Associated_Opportunity_01__r.Name);
		System.assertEquals('test name - F7X.213 - AO1 trigger test', oppty.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO3 trigger test', oppty.Associated_Opportunity_04__r.Name);
		System.assertEquals('test name - F7X.213 - AO4 trigger test', oppty.Associated_Opportunity_05__r.Name);
		System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty.Associated_Opportunity_06__r.Name);
		System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty.Associated_Opportunity_07__r.Name);
		System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty.Associated_Opportunity_08__r.Name);  
        test.stopTest();
    }
    
	static testMethod void testOpportunityTriggers_AO3_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
		Opportunity myOpp = [SELECT Id, MasterOpportunitylookup__r.Name FROM Opportunity where Name = 'test name - F7X.213 - AO3 trigger test'];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
 		update myOpp;
                
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       

        System.assertEquals(null, oppty.Associated_Opportunity_04__c );        
        System.assertEquals('test name - F7X.213 - AO trigger test', oppty.Associated_Opportunity_01__r.Name);
		System.assertEquals('test name - F7X.213 - AO1 trigger test', oppty.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO2 trigger test', oppty.Associated_Opportunity_03__r.Name);
		System.assertEquals('test name - F7X.213 - AO4 trigger test', oppty.Associated_Opportunity_05__r.Name);
		System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty.Associated_Opportunity_06__r.Name);
		System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty.Associated_Opportunity_07__r.Name);
		System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty.Associated_Opportunity_08__r.Name);   
        test.stopTest();
    }
    
	static testMethod void testOpportunityTriggers_AO4_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
		Opportunity myOpp = [SELECT Id, MasterOpportunitylookup__r.Name FROM Opportunity where Name = 'test name - F7X.213 - AO4 trigger test'];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
 		update myOpp;
                
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       

        System.assertEquals(null, oppty.Associated_Opportunity_05__c );        
        System.assertEquals('test name - F7X.213 - AO trigger test', oppty.Associated_Opportunity_01__r.Name);
		System.assertEquals('test name - F7X.213 - AO1 trigger test', oppty.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO2 trigger test', oppty.Associated_Opportunity_03__r.Name);
		System.assertEquals('test name - F7X.213 - AO3 trigger test', oppty.Associated_Opportunity_04__r.Name);
		System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty.Associated_Opportunity_06__r.Name);
		System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty.Associated_Opportunity_07__r.Name);
		System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty.Associated_Opportunity_08__r.Name); 
        test.stopTest();
    }
    
	static testMethod void testOpportunityTriggers_AO5_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
		Opportunity myOpp = [SELECT Id, MasterOpportunitylookup__r.Name FROM Opportunity where Name = 'test name - F7X.213 - AO5 trigger test'];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
 		update myOpp;
                
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       

        System.assertEquals(null, oppty.Associated_Opportunity_06__c );        
        System.assertEquals('test name - F7X.213 - AO trigger test', oppty.Associated_Opportunity_01__r.Name);
		System.assertEquals('test name - F7X.213 - AO1 trigger test', oppty.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO2 trigger test', oppty.Associated_Opportunity_03__r.Name);
		System.assertEquals('test name - F7X.213 - AO3 trigger test', oppty.Associated_Opportunity_04__r.Name);
		System.assertEquals('test name - F7X.213 - AO4 trigger test', oppty.Associated_Opportunity_05__r.Name);
		System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty.Associated_Opportunity_07__r.Name);
		System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty.Associated_Opportunity_08__r.Name);      
        test.stopTest();
    }
    
	static testMethod void testOpportunityTriggers_AO6_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
		Opportunity myOpp = [SELECT Id, MasterOpportunitylookup__r.Name FROM Opportunity where Name = 'test name - F7X.213 - AO6 trigger test'];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
 		update myOpp;
                
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       

        System.assertEquals(null, oppty.Associated_Opportunity_07__c );        
        System.assertEquals('test name - F7X.213 - AO trigger test', oppty.Associated_Opportunity_01__r.Name);
		System.assertEquals('test name - F7X.213 - AO1 trigger test', oppty.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO2 trigger test', oppty.Associated_Opportunity_03__r.Name);
		System.assertEquals('test name - F7X.213 - AO3 trigger test', oppty.Associated_Opportunity_04__r.Name);
		System.assertEquals('test name - F7X.213 - AO4 trigger test', oppty.Associated_Opportunity_05__r.Name);
		System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty.Associated_Opportunity_06__r.Name);
		System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty.Associated_Opportunity_08__r.Name); 
        test.stopTest();
    }
    
	static testMethod void testOpportunityTriggers_AO7_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
		List<Opportunity> myOpp = [SELECT Id, MasterOpportunitylookup__r.Name, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c FROM Opportunity where Name = 'test name - F7X.213 - AO7 trigger test'];
        List<Id> assocOpps = new List<Id>();
        
        For(Opportunity o : myOpp){
			assocOpps.add(o.Associated_Opportunity_01__c);
            assocOpps.add(o.Associated_Opportunity_02__c);
            assocOpps.add(o.Associated_Opportunity_03__c);
            assocOpps.add(o.Associated_Opportunity_04__c);
            assocOpps.add(o.Associated_Opportunity_05__c);
            assocOpps.add(o.Associated_Opportunity_06__c);
            assocOpps.add(o.Associated_Opportunity_07__c);
            o.RecordTypeId = rtId;
        	o.StageName = 'Cancelled';
        }
        
 		update myOpp;
                
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];     
        List<Opportunity> assocOppsList = [SELECT Id, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name FROM Opportunity where Id In: assocOpps];
		List<Opportunity> myOp = [SELECT Id, MasterOpportunitylookup__r.Name, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c FROM Opportunity where Name = 'test name - F7X.213 - AO7 trigger test'];
                    
        System.assertEquals(null, myOp[0].MasterOpportunitylookup__c); 
		System.assertEquals(null, myOp[0].Associated_Opportunity_01__c ); 
		System.assertEquals(null, myOp[0].Associated_Opportunity_02__c ); 
		System.assertEquals(null, myOp[0].Associated_Opportunity_03__c ); 
		System.assertEquals(null, myOp[0].Associated_Opportunity_04__c ); 
        System.assertEquals(null, myOp[0].Associated_Opportunity_05__c ); 
        System.assertEquals(null, myOp[0].Associated_Opportunity_06__c ); 
        System.assertEquals(null, myOp[0].Associated_Opportunity_07__c ); 
        
        System.assertEquals(null, oppty.Associated_Opportunity_08__c ); 
        System.assertEquals('test name - F7X.213 - AO trigger test', oppty.Associated_Opportunity_01__r.Name);
		System.assertEquals('test name - F7X.213 - AO1 trigger test', oppty.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO2 trigger test', oppty.Associated_Opportunity_03__r.Name);
		System.assertEquals('test name - F7X.213 - AO3 trigger test', oppty.Associated_Opportunity_04__r.Name);
		System.assertEquals('test name - F7X.213 - AO4 trigger test', oppty.Associated_Opportunity_05__r.Name);
		System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty.Associated_Opportunity_06__r.Name);
		System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty.Associated_Opportunity_07__r.Name); 
              
        For(Opportunity o : assocOppsList){
            system.assertNotEquals('test name - F7X.213 - AO7 trigger test', o.Associated_Opportunity_01__r.Name);
            system.assertNotEquals('test name - F7X.213 - AO7 trigger test', o.Associated_Opportunity_01__r.Name);
            system.assertNotEquals('test name - F7X.213 - AO7 trigger test', o.Associated_Opportunity_02__r.Name);
            system.assertNotEquals('test name - F7X.213 - AO7 trigger test', o.Associated_Opportunity_03__r.Name);
            system.assertNotEquals('test name - F7X.213 - AO7 trigger test', o.Associated_Opportunity_04__r.Name);
            system.assertNotEquals('test name - F7X.213 - AO7 trigger test', o.Associated_Opportunity_05__r.Name);
            system.assertNotEquals('test name - F7X.213 - AO7 trigger test', o.Associated_Opportunity_06__r.Name);
            system.assertNotEquals('test name - F7X.213 - AO7 trigger test', o.Associated_Opportunity_07__r.Name); 
        }
        test.stopTest();
                                              
    }
    
   	static testMethod void testOpportunityTrigger_AO() {      
            
        test.startTest();
        
		Opportunity oppty = [SELECT Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c FROM Opportunity where Master_Opportunity__c = True];       

		oppty.Associated_Opportunity_01__c = null;
		update oppty;
        
		Opportunity oppty1 = [SELECT Id, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where id =: oppty.Id];       

        System.assertEquals('test name - F7X.213 - AO1 trigger test', oppty1.Associated_Opportunity_01__r.Name );        
        System.assertEquals('test name - F7X.213 - AO2 trigger test', oppty1.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO3 trigger test', oppty1.Associated_Opportunity_03__r.Name);
		System.assertEquals('test name - F7X.213 - AO4 trigger test', oppty1.Associated_Opportunity_04__r.Name);
		System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty1.Associated_Opportunity_05__r.Name);
        System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty1.Associated_Opportunity_06__r.Name);
		System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty1.Associated_Opportunity_07__r.Name);
		System.assertEquals(null, oppty1.Associated_Opportunity_08__r.Name); 
        test.stopTest();

    }
    
	static testMethod void testOpportunityTrigger_AO2() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c FROM Opportunity where Master_Opportunity__c = True];       
       
        oppty.Associated_Opportunity_01__c = null;
        oppty.Associated_Opportunity_02__c = null;
        update oppty;
        
		Opportunity oppty2 = [SELECT Id, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Id =: oppty.Id];       
        
        System.assertEquals('test name - F7X.213 - AO2 trigger test', oppty2.Associated_Opportunity_01__r.Name );        
        System.assertEquals('test name - F7X.213 - AO3 trigger test', oppty2.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO4 trigger test', oppty2.Associated_Opportunity_03__r.Name);
		System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty2.Associated_Opportunity_04__r.Name);
		System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty2.Associated_Opportunity_05__r.Name);
        System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty2.Associated_Opportunity_06__r.Name);
		System.assertEquals(null, oppty2.Associated_Opportunity_07__r.Name);
		System.assertEquals(null, oppty2.Associated_Opportunity_08__r.Name);  
        test.stopTest();
    }
    
	static testMethod void testOpportunityTrigger_AO3() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c FROM Opportunity where Master_Opportunity__c = True];       
       
        oppty.Associated_Opportunity_01__c = null;
        oppty.Associated_Opportunity_02__c = null;
        oppty.Associated_Opportunity_03__c = null;
        update oppty;
        
		Opportunity oppty3 = [SELECT Id, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Id =: oppty.Id];       
        
        System.assertEquals('test name - F7X.213 - AO3 trigger test', oppty3.Associated_Opportunity_01__r.Name );        
        System.assertEquals('test name - F7X.213 - AO4 trigger test', oppty3.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty3.Associated_Opportunity_03__r.Name);
		System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty3.Associated_Opportunity_04__r.Name);
		System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty3.Associated_Opportunity_05__r.Name);
        System.assertEquals(null, oppty3.Associated_Opportunity_06__r.Name);
		System.assertEquals(null, oppty3.Associated_Opportunity_07__r.Name);
		System.assertEquals(null, oppty3.Associated_Opportunity_08__r.Name); 
        test.stopTest();
    }
    
	static testMethod void testOpportunityTrigger_AO4() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c FROM Opportunity where Master_Opportunity__c = True];       
       
        oppty.Associated_Opportunity_01__c = null;
        oppty.Associated_Opportunity_02__c = null;
        oppty.Associated_Opportunity_03__c = null;
        oppty.Associated_Opportunity_04__c = null;
        update oppty;
        
		Opportunity oppty4 = [SELECT Id, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Id =: oppty.Id];       
        
        System.assertEquals('test name - F7X.213 - AO4 trigger test', oppty4.Associated_Opportunity_01__r.Name );        
        System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty4.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty4.Associated_Opportunity_03__r.Name);
		System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty4.Associated_Opportunity_04__r.Name);
		System.assertEquals(null, oppty4.Associated_Opportunity_05__r.Name);
        System.assertEquals(null, oppty4.Associated_Opportunity_06__r.Name);
		System.assertEquals(null, oppty4.Associated_Opportunity_07__r.Name);
		System.assertEquals(null, oppty4.Associated_Opportunity_08__r.Name); 
        test.stopTest();
    } 
    
	static testMethod void testOpportunityTrigger_AO5() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c FROM Opportunity where Master_Opportunity__c = True];       
       
        oppty.Associated_Opportunity_01__c = null;
        oppty.Associated_Opportunity_02__c = null;
        oppty.Associated_Opportunity_03__c = null;
        oppty.Associated_Opportunity_04__c = null;
        oppty.Associated_Opportunity_05__c = null;
        update oppty;
        
		Opportunity oppty5 = [SELECT Id, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Id =: oppty.Id];       
        
        System.assertEquals('test name - F7X.213 - AO5 trigger test', oppty5.Associated_Opportunity_01__r.Name );        
        System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty5.Associated_Opportunity_02__r.Name);
		System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty5.Associated_Opportunity_03__r.Name);
		System.assertEquals(null, oppty5.Associated_Opportunity_04__r.Name);
		System.assertEquals(null, oppty5.Associated_Opportunity_05__r.Name);
        System.assertEquals(null, oppty5.Associated_Opportunity_06__r.Name);
		System.assertEquals(null, oppty5.Associated_Opportunity_07__r.Name);
		System.assertEquals(null, oppty5.Associated_Opportunity_08__r.Name);
        test.stopTest();
    } 
    
	static testMethod void testOpportunityTrigger_AO6() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c FROM Opportunity where Master_Opportunity__c = True];       
       
        oppty.Associated_Opportunity_01__c = null;
        oppty.Associated_Opportunity_02__c = null;
        oppty.Associated_Opportunity_03__c = null;
        oppty.Associated_Opportunity_04__c = null;
        oppty.Associated_Opportunity_05__c = null;
        oppty.Associated_Opportunity_06__c = null;
        update oppty;
        
		Opportunity oppty6 = [SELECT Id, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Id =: oppty.Id];       
        
        System.assertEquals('test name - F7X.213 - AO6 trigger test', oppty6.Associated_Opportunity_01__r.Name );        
        System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty6.Associated_Opportunity_02__r.Name);
		System.assertEquals(null, oppty6.Associated_Opportunity_03__r.Name);
		System.assertEquals(null, oppty6.Associated_Opportunity_04__r.Name);
		System.assertEquals(null, oppty6.Associated_Opportunity_05__r.Name);
        System.assertEquals(null, oppty6.Associated_Opportunity_06__r.Name);
		System.assertEquals(null, oppty6.Associated_Opportunity_07__r.Name);
		System.assertEquals(null, oppty6.Associated_Opportunity_08__r.Name);
        test.stopTest();
    }
    
    static testMethod void testOpportunityTrigger_AO7() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c FROM Opportunity where Master_Opportunity__c = True];       
       
        oppty.Associated_Opportunity_01__c = null;
        oppty.Associated_Opportunity_02__c = null;
        oppty.Associated_Opportunity_03__c = null;
        oppty.Associated_Opportunity_04__c = null;
        oppty.Associated_Opportunity_05__c = null;
        oppty.Associated_Opportunity_06__c = null;
        oppty.Associated_Opportunity_07__c = null;
        update oppty;
        
		Opportunity oppty7 = [SELECT Id, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Id =: oppty.Id];       
        
        System.assertEquals('test name - F7X.213 - AO7 trigger test', oppty7.Associated_Opportunity_01__r.Name );        
        System.assertEquals(null, oppty7.Associated_Opportunity_02__r.Name);
		System.assertEquals(null, oppty7.Associated_Opportunity_03__r.Name);
		System.assertEquals(null, oppty7.Associated_Opportunity_04__r.Name);
		System.assertEquals(null, oppty7.Associated_Opportunity_05__r.Name);
        System.assertEquals(null, oppty7.Associated_Opportunity_06__r.Name);
		System.assertEquals(null, oppty7.Associated_Opportunity_07__r.Name);
		System.assertEquals(null, oppty7.Associated_Opportunity_08__r.Name);    
        test.stopTest();
    }
    
	static testMethod void testOpportunityTrigger_Master_CSQ() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id FROM Opportunity where Master_Opportunity__c = True];       
       
        oppty.StageName = 'Cust Submitted Quote';
        update oppty;
        
		Opportunity oppty1 = [SELECT Id, Associated_Opportunity_01__r.StageName, Associated_Opportunity_02__r.StageName, Associated_Opportunity_03__r.StageName, Associated_Opportunity_04__r.StageName, Associated_Opportunity_05__r.StageName, Associated_Opportunity_06__r.StageName, Associated_Opportunity_07__r.StageName, Associated_Opportunity_08__r.StageName FROM Opportunity where Id =: oppty.Id];       
      
        System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_01__r.StageName);        
        System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_02__r.StageName);
		System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_03__r.StageName);
		System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_04__r.StageName);
		System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_05__r.StageName);
        System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_06__r.StageName);
		System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_07__r.StageName);
		System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_08__r.StageName);     
        test.stopTest();
    }
    
	public static testMethod void testOpportunityTrigger_Master_RFS() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id FROM Opportunity where Master_Opportunity__c = True];              
        oppty.StageName = 'RFS';
       
        update oppty;
       
		Opportunity oppty1 = [SELECT Id, Associated_Opportunity_01__r.StageName, Associated_Opportunity_02__r.StageName, Associated_Opportunity_03__r.StageName, Associated_Opportunity_04__r.StageName, Associated_Opportunity_05__r.StageName, Associated_Opportunity_06__r.StageName, Associated_Opportunity_07__r.StageName, Associated_Opportunity_08__r.StageName FROM Opportunity where Id =: oppty.Id];       
      
        System.assertEquals('RFS', oppty1.Associated_Opportunity_01__r.StageName);        
        System.assertEquals('RFS', oppty1.Associated_Opportunity_02__r.StageName);
		System.assertEquals('RFS', oppty1.Associated_Opportunity_03__r.StageName);
		System.assertEquals('RFS', oppty1.Associated_Opportunity_04__r.StageName);
		System.assertEquals('RFS', oppty1.Associated_Opportunity_05__r.StageName);
        System.assertEquals('RFS', oppty1.Associated_Opportunity_06__r.StageName);
		System.assertEquals('RFS', oppty1.Associated_Opportunity_07__r.StageName);
		System.assertEquals('RFS', oppty1.Associated_Opportunity_08__r.StageName);  
        test.stopTest();
    }
    
 	static testMethod void testOpportunityTrigger_Master_RFQassigned() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id FROM Opportunity where Master_Opportunity__c = True];       
       
        oppty.StageName = 'RFQ Assigned';
        update oppty;
        
		Opportunity oppty1 = [SELECT Id, Associated_Opportunity_01__r.StageName, Associated_Opportunity_02__r.StageName, Associated_Opportunity_03__r.StageName, Associated_Opportunity_04__r.StageName, Associated_Opportunity_05__r.StageName, Associated_Opportunity_06__r.StageName, Associated_Opportunity_07__r.StageName, Associated_Opportunity_08__r.StageName FROM Opportunity where Id =: oppty.Id];       
      
        System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_01__r.StageName);        
        System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_02__r.StageName);
		System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_03__r.StageName);
		System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_04__r.StageName);
		System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_05__r.StageName);
        System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_06__r.StageName);
		System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_07__r.StageName);
		System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_08__r.StageName);  
        test.stopTest();
    }
    
	static testMethod void testOpportunityTrigger_Master_RFQ_OppsReview() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id FROM Opportunity where Master_Opportunity__c = True];       
       
        oppty.StageName = 'RFQ - Operations Review';
        update oppty;
        
		Opportunity oppty1 = [SELECT Id, Associated_Opportunity_01__r.StageName, Associated_Opportunity_02__r.StageName, Associated_Opportunity_03__r.StageName, Associated_Opportunity_04__r.StageName, Associated_Opportunity_05__r.StageName, Associated_Opportunity_06__r.StageName, Associated_Opportunity_07__r.StageName, Associated_Opportunity_08__r.StageName FROM Opportunity where Id =: oppty.Id];       
      
        System.assertEquals('RFQ - Operations Review', oppty1.Associated_Opportunity_01__r.StageName);        
        System.assertEquals('RFQ - Operations Review', oppty1.Associated_Opportunity_02__r.StageName);
		System.assertEquals('RFQ - Operations Review', oppty1.Associated_Opportunity_03__r.StageName);
		System.assertEquals('RFQ - Operations Review', oppty1.Associated_Opportunity_04__r.StageName);
		System.assertEquals('RFQ - Operations Review', oppty1.Associated_Opportunity_05__r.StageName);
        System.assertEquals('RFQ - Operations Review', oppty1.Associated_Opportunity_06__r.StageName);
		System.assertEquals('RFQ - Operations Review', oppty1.Associated_Opportunity_07__r.StageName);
		System.assertEquals('RFQ - Operations Review', oppty1.Associated_Opportunity_08__r.StageName);  
        test.stopTest();
    }
    
    //New Opportunity Stage Change
	static testMethod void testOpportunityTrigger_AO_Master() { 

        test.startTest();
        
		Opportunity oppty = [SELECT Id, MasterOpportunitylookup__c  FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];       
       	Opportunity masterOppty = [SELECT Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c FROM Opportunity where id =: oppty.MasterOpportunitylookup__c]; 
              
        oppty.Associated_Opportunity_01__c = masterOppty.Associated_Opportunity_02__c;
        oppty.Associated_Opportunity_02__c = masterOppty.Associated_Opportunity_03__c;
        oppty.Associated_Opportunity_03__c = masterOppty.Associated_Opportunity_04__c;
        oppty.Associated_Opportunity_04__c = masterOppty.Associated_Opportunity_05__c;
        oppty.Associated_Opportunity_05__c = masterOppty.Associated_Opportunity_06__c;
        oppty.Associated_Opportunity_06__c = masterOppty.Associated_Opportunity_07__c;

        delete masterOppty;
        
        oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
        oppty.StageName = 'New Opportunity';
        oppty.MasterOpportunitylookup__c = null;
        oppty.Master_Opportunity__c = True;
        update oppty;
        
		Opportunity oppty1 = [SELECT Id, Associated_Opportunity_01__r.StageName, Associated_Opportunity_02__r.StageName, Associated_Opportunity_03__r.StageName, Associated_Opportunity_04__r.StageName, Associated_Opportunity_05__r.StageName, Associated_Opportunity_06__r.StageName, Associated_Opportunity_07__r.StageName, Associated_Opportunity_08__r.StageName FROM Opportunity where Id =: oppty.Id];       
      	
        System.assertEquals('New Opportunity', oppty1.Associated_Opportunity_01__r.StageName);        
        System.assertEquals('New Opportunity', oppty1.Associated_Opportunity_02__r.StageName);
		System.assertEquals('New Opportunity', oppty1.Associated_Opportunity_03__r.StageName);
		System.assertEquals('New Opportunity', oppty1.Associated_Opportunity_04__r.StageName);
		System.assertEquals('New Opportunity', oppty1.Associated_Opportunity_05__r.StageName);
        System.assertEquals('New Opportunity', oppty1.Associated_Opportunity_06__r.StageName);    
        test.stopTest();
    }
    
    //CSQ Stage Change
    static testMethod void testOpportunityTriggerCSQ_AO_Master() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id, MasterOpportunitylookup__c  FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];       
       	Opportunity masterOppty = [SELECT Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c FROM Opportunity where id =: oppty.MasterOpportunitylookup__c]; 
              
        oppty.Associated_Opportunity_01__c = masterOppty.Associated_Opportunity_02__c;
        oppty.Associated_Opportunity_02__c = masterOppty.Associated_Opportunity_03__c;
        oppty.Associated_Opportunity_03__c = masterOppty.Associated_Opportunity_04__c;
        oppty.Associated_Opportunity_04__c = masterOppty.Associated_Opportunity_05__c;
        oppty.Associated_Opportunity_05__c = masterOppty.Associated_Opportunity_06__c;
        oppty.Associated_Opportunity_06__c = masterOppty.Associated_Opportunity_07__c;

        delete masterOppty;
        
        oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Cust Submitted Quote').getRecordTypeId();
        oppty.StageName = 'Cust Submitted Quote';
        oppty.MasterOpportunitylookup__c = null;
        oppty.Master_Opportunity__c = True;
        update oppty;
        
		Opportunity oppty1 = [SELECT Id, Associated_Opportunity_01__r.StageName, Associated_Opportunity_02__r.StageName, Associated_Opportunity_03__r.StageName, Associated_Opportunity_04__r.StageName, Associated_Opportunity_05__r.StageName, Associated_Opportunity_06__r.StageName, Associated_Opportunity_07__r.StageName, Associated_Opportunity_08__r.StageName FROM Opportunity where Id =: oppty.Id];       
      	
        System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_01__r.StageName);        
        System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_02__r.StageName);
		System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_03__r.StageName);
		System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_04__r.StageName);
		System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_05__r.StageName);
        System.assertEquals('Cust Submitted Quote', oppty1.Associated_Opportunity_06__r.StageName);  
        test.stopTest();
    }
    
    //RFS Stage Change
    static testMethod void testOpportunityTriggerRFS_AO_Master() {  

        test.startTest();
        
		Opportunity oppty = [SELECT Id, MasterOpportunitylookup__c  FROM Opportunity where Name = 'test name - F7X.213 - AO trigger test'];       
       	Opportunity masterOppty = [SELECT Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c FROM Opportunity where id =: oppty.MasterOpportunitylookup__c]; 
              
        oppty.Associated_Opportunity_01__c = masterOppty.Associated_Opportunity_02__c;
        oppty.Associated_Opportunity_02__c = masterOppty.Associated_Opportunity_03__c;
        oppty.Associated_Opportunity_03__c = masterOppty.Associated_Opportunity_04__c;
        oppty.Associated_Opportunity_04__c = masterOppty.Associated_Opportunity_05__c;
        oppty.Associated_Opportunity_05__c = masterOppty.Associated_Opportunity_06__c;
        oppty.Associated_Opportunity_06__c = masterOppty.Associated_Opportunity_07__c;

        delete masterOppty;
        
       	RecordType rfsRecType = [SELECT Id FROM RecordType where Name = 'RFS'];   
        Contact c = [Select Id from Contact];
       
        oppty.RecordTypeId = rfsRecType.Id;
        oppty.StageName = 'RFS';
        oppty.WinorLossReason1__c = 'Location';
        oppty.Win_Loss_Description__c = 'NA';
        oppty.Customer_Satisfaction_Survey_Contact__c  = c.Id;
        oppty.MasterOpportunitylookup__c = null;
        oppty.Master_Opportunity__c = True;
        oppty.Probability_Grouping_Override__c = true;
		update oppty;
      
		Opportunity oppty1 = [SELECT Id, IsWon, IsClosed, Associated_Opportunity_01__r.StageName, Associated_Opportunity_02__r.StageName, Associated_Opportunity_03__r.StageName, Associated_Opportunity_04__r.StageName, Associated_Opportunity_05__r.StageName, Associated_Opportunity_06__r.StageName, Associated_Opportunity_07__r.StageName, Associated_Opportunity_08__r.StageName FROM Opportunity where Id =: oppty.Id];       
      	
        System.assertEquals(True, oppty1.IsWon);
        System.assertEquals(True, oppty1.IsClosed);
        System.assertEquals('RFS', oppty1.Associated_Opportunity_01__r.StageName);        
        System.assertEquals('RFS', oppty1.Associated_Opportunity_02__r.StageName);
		System.assertEquals('RFS', oppty1.Associated_Opportunity_03__r.StageName);
		System.assertEquals('RFS', oppty1.Associated_Opportunity_04__r.StageName);
		System.assertEquals('RFS', oppty1.Associated_Opportunity_05__r.StageName);
        System.assertEquals('RFS', oppty1.Associated_Opportunity_06__r.StageName);   
        test.stopTest();
    }
    
    private static testMethod void testOpportunityProbability() {
   		User u = [Select id from User where email =: 'puser000@amamama.com'];
      	
        System.runAs(u) {
        	PageReference pref = Page.OpportunityProbability;   
      		Test.setCurrentPageReference(pref);
      		Test.startTest();   

      		ApexPages.StandardController sc = new ApexPages.StandardController(u);
      		OpportunityProbabilityController cls = new  OpportunityProbabilityController(sc);
      		cls.saveOpportunities();
            cls.toggleSort();
      		test.stopTest();
        }
	} 
     private static testMethod void crec() {
    CheckRecursive.runAfterOnce();
    CheckRecursive.runBeforeInsertOnce();
    CheckRecursive.runBeforeUpdateOnce();
     }
}