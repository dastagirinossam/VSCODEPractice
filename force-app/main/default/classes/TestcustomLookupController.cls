@isTest
public class TestcustomLookupController {
  @isTest
    Public static void method1(){
        Profile p = [select Id,name from Profile where name = :'Customer Community Plus Login - Opportunity Agent' ];
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User u ;
        Account portalAccount1;
        contact c;
 
        System.runAs (thisUser) {
              portalAccount1   = new Account();
                portalAccount1.Name = 'Second Account';
                portalAccount1.BillingStreet = '1600 Amphitheatre Parkway';
                portalAccount1.BillingCity = 'Mountain View';
                portalAccount1.BillingState = 'TN';
                portalAccount1.BillingPostalCode = '37128';
                portalAccount1.BillingCountry = 'United States';
                portalAccount1.Area__c = 'East';
            insert portalAccount1;
            
         c = new contact();
         c.lastname='test';
        c.AccountId =portalAccount1.Id;
         insert c;
            u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,contactId = c.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
      
        
         insert u;
        }
        string namestr = 'standa';
        string objname = 'User';
        test.startTest();
        customLookUpController.fetchLookUpValues(namestr,objname );
        test.stopTest();
    }
    @isTest
    Public static void method2(){
        Profile p = [select Id,name from Profile where name = :'Customer Community Plus Login - Opportunity Agent' ];
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User u ;
        Account portalAccount1;
        contact c;
 
        System.runAs (thisUser) {
              portalAccount1   = new Account();
                portalAccount1.Name = 'Second Account';
                portalAccount1.BillingStreet = '1600 Amphitheatre Parkway';
                portalAccount1.BillingCity = 'Mountain View';
                portalAccount1.BillingState = 'TN';
                portalAccount1.BillingPostalCode = '37128';
                portalAccount1.BillingCountry = 'United States';
                portalAccount1.Area__c = 'East';
            insert portalAccount1;
            
         c = new contact();
         c.lastname='test';
        c.AccountId =portalAccount1.Id;
         insert c;
             u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,contactId = c.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
      
        
         insert u;
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
            //Create Product Line
            Product_Line__c prodLine = new Product_Line__c(
                Product_Line_Family__c = 'Aircraft',
                SFDC_Name_Prefix__c = 'F7X.',               
                Name = 'new'
            );
            insert prodLine;
            
            //Create Engine
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.id,
                Account__c = portalAccount1.id,
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
            	ac.Account__c = portalAccount1.Id;
            	ac.Aircraft_Type__c = 'Aircraft';
            insert ac;
                       
            //Create Product
            Product2 prod = new Product2(
                Name = 'Master Opportunity Product',
                ProductCode = 'Code1',
                isActive = True
            );
            insert prod;
            
 PricebookEntry pbk = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prod.Id, IsActive = true, UnitPrice = 100);
            insert pbk;
            //Create Probability Group
            Probability_Grouping__c pb = New Probability_Grouping__c();
                pb.SystemProbabilityGroupingName__c = 'EAST.PHX.Avionics';
                pb.Probability_to_Use__c = 62;
                pb.Account_Area__c = 'EAST';
                pb.Facility__c = 'PHX';
                pb.Type__c = 'Avionics';
            insert pb;
            
                       
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
                oppty.AccountId = portalAccount1.Id;
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
                oppty.Contact__c = c.id;
                oppty.AFSM_Lookup__c = u.id;
            oppty.Pricebook2Id = Test.getStandardPricebookId();
            insert oppty;
            
             OpportunityLineItem opli = new OpportunityLineItem();
                   opli.UnitPrice= 100000;
                    opli.Quantity=1;
                    opli.OpportunityId=oppty.Id;
                    opli.product2Id=prod.Id;
            insert opli;
            
            //Create Associated Opp
            Opportunity ao = new Opportunity();
                ao.RecordTypeId = rtId;
                ao.Operator__c = 'FAA Part 135';
                ao.RSM__c = 'Campbell,Tom';
                ao.Name = 'trigger test';
                ao.Opportunity_Name_Details__c = 'AO trigger test';
                ao.StageName = 'Cust Submitted Quote';
                ao.AccountId =  portalAccount1.Id;
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
                ao.QuoteRequiredBy__c =  system.today();
                ao.Base_Quote_Number__c = '1';
                ao.QuotedDate__c =  Date.today();
                ao.Concession1__c = 'None';
                ao.Agent_Representative__c = 'Not Applicable';
                ao.MasterOpportunitylookup__c = oppty.id;
                ao.Competitor__c = 'Harrods Aviation';
                ao.WinorLossReason1__c = 'Location';
                ao.Win_Loss_Description__c = 'Test';
                ao.Customer_Satisfaction_Survey_Contact__c = c.id;
                ao.Contact__c = c.id;
                ao.AFSM_Lookup__c = u.id;
            insert ao;
            
            
            //Create Associated Opp1
            Opportunity ao1 = new Opportunity();
                ao1.RecordTypeId = rtId;
                ao1.Operator__c = 'FAA Part 135';
                ao1.RSM__c = 'Campbell,Tom';
                ao1.Name = 'trigger test';
                ao1.Opportunity_Name_Details__c = 'AO1 trigger test';
                ao1.StageName = 'Cust Submitted Quote';
                ao1.AccountId = portalAccount1.Id;
                ao1.Aircraft__c = ac.Id;
                ao1.Amount = decimal.valueof('1471620');
                ao1.Equipment__c = equip.Id;
                ao1.CustomerName__c = 'World Jet, Inc.';
                ao1.Facility__c = 'AGS';
                ao1.Tier_Level__c = '1';
                ao1.CloseDate =  Date.today();
                ao1.InputDate__c =  Date.today();
                ao1.OutputDate__c =  Date.today();
                ao1.Product_Line__c =ac.Product_Line__c;
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
                ao1.Customer_Satisfaction_Survey_Contact__c = c.id;
                ao1.Contact__c = c.id;
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
                ao2.AccountId = portalAccount1.Id;
                ao2.Aircraft__c = ac.Id;
                ao2.Amount = decimal.valueof('1471620');
                ao2.Equipment__c = equip.Id;
                ao2.CustomerName__c = 'World Jet, Inc.';
                ao2.Facility__c = 'AGS';
                ao2.Tier_Level__c = '1';
                ao2.CloseDate =  Date.today();
                ao2.InputDate__c =  Date.today();
                ao2.OutputDate__c =  Date.today();
                ao2.Product_Line__c = ac.Product_Line__c;
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
                ao2.Customer_Satisfaction_Survey_Contact__c = c.id;
                ao2.Contact__c = c.id;
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
                ao3.AccountId =portalAccount1.Id;
                ao3.Aircraft__c =ac.Id;
                ao3.Amount = decimal.valueof('1471620');
                ao3.Equipment__c =equip.Id;
                ao3.CustomerName__c = 'World Jet, Inc.';
                ao3.Facility__c = 'AGS';
                ao3.Tier_Level__c = '1';
                ao3.CloseDate =  Date.today();
                ao3.InputDate__c =  Date.today();
                ao3.OutputDate__c =  Date.today();
                ao3.Product_Line__c = ac.Product_Line__c;
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
                ao3.Customer_Satisfaction_Survey_Contact__c = c.id;
                ao3.Contact__c = c.id;
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
                ao4.AccountId = portalAccount1.Id;
                ao4.Aircraft__c = ac.Id;
                ao4.Amount = decimal.valueof('1471620');
                ao4.Equipment__c =equip.Id;
                ao4.CustomerName__c = 'World Jet, Inc.';
                ao4.Facility__c = 'AGS';
                ao4.Tier_Level__c = '1';
                ao4.CloseDate =  Date.today();
                ao4.InputDate__c =  Date.today();
                ao4.OutputDate__c =  Date.today();
                ao4.Product_Line__c = ac.Product_Line__c;
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
                ao4.Customer_Satisfaction_Survey_Contact__c = c.id;
                ao4.Contact__c = c.id;
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
                ao5.AccountId = portalAccount1.Id;
                ao5.Aircraft__c =ac.Id;
                ao5.Amount = decimal.valueof('1471620');
                ao5.Equipment__c = equip.Id;
                ao5.CustomerName__c = 'World Jet, Inc.';
                ao5.Facility__c = 'AGS';
                ao5.Tier_Level__c = '1';
                ao5.CloseDate =  Date.today();
                ao5.InputDate__c =  Date.today();
                ao5.OutputDate__c =  Date.today();
                ao5.Product_Line__c =ac.Product_Line__c;
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
                ao5.Customer_Satisfaction_Survey_Contact__c = c.id;
                ao5.Contact__c = c.id;
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
                ao6.AccountId =portalAccount1 .Id;
                ao6.Aircraft__c = ac.Id;
                ao6.Amount = decimal.valueof('1471620');
                ao6.Equipment__c = equip.Id;
                ao6.CustomerName__c = 'World Jet, Inc.';
                ao6.Facility__c = 'AGS';
                ao6.Tier_Level__c = '1';
                ao6.CloseDate =  Date.today();
                ao6.InputDate__c =  Date.today();
                ao6.OutputDate__c =  Date.today();
                ao6.Product_Line__c = ac.Product_Line__c;
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
                ao6.Customer_Satisfaction_Survey_Contact__c = c.id;
                ao6.Contact__c = c.id;
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
                ao7.AccountId =portalAccount1 .Id;
                ao7.Aircraft__c =ac.Id;
                ao7.Amount = decimal.valueof('1471620');
                ao7.Equipment__c =equip.Id;
                ao7.CustomerName__c = 'World Jet, Inc.';
                ao7.Facility__c = 'AGS';
                ao7.Tier_Level__c = '1';
                ao7.CloseDate =  Date.today();
                ao7.InputDate__c =  Date.today();
                ao7.OutputDate__c =  Date.today();
                ao7.Product_Line__c = ac.Product_Line__c;
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
                ao7.Customer_Satisfaction_Survey_Contact__c = c.id;
                ao7.Contact__c = c.id;
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
        
    
           
            test.startTest();
            customLookupController.createAgentRec(oppty.Id, u);
            test.stopTest();
        }
            }
}