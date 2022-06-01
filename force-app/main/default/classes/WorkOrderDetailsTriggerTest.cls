@isTest
public class WorkOrderDetailsTriggerTest {

    @testSetup 
    static void setup(){
        
        //Create WODR
        Work_Order_Detail_Reference__c wodr = new Work_Order_Detail_Reference__c();
        wodr.Name = 'M19';
        wodr.Short_Dept__c = 'Airframe';
        wodr.Workscope__c = 'Test Airframe ws';
        insert wodr;
        
        Work_Order_Detail_Reference__c wodr2 = new Work_Order_Detail_Reference__c();
        wodr2.Name = 'ZZZ';
        wodr2.Short_Dept__c = 'Other';
        wodr2.Workscope__c = 'Test other ws';
        insert wodr2;
        
        Work_Order_Detail_Reference__c wodr3 = new Work_Order_Detail_Reference__c();
        wodr3.Name = 'BA1';
        wodr3.Short_Dept__c = 'TFE';
        wodr3.Workscope__c = 'MST-TFE';
        insert wodr3;
               
        //Create Quota Master
        Quota_Master__c qm = new Quota_Master__c();
        qm.year__c = string.ValueOf(system.today().year());
        qm.Name = 'Test AOP';
        insert qm;
        
        //Create Quota Region
        Quota_Sales_Region__c qr = new Quota_Sales_Region__c();
        qr.name = 'Test Region';
        qr.Year__c = string.valueof(system.today().year());
        qr.Quota_Master__c = qm.Id;
        qr.Region__c = 'West';
        insert qr;
        
        //Create Quota Employee
        Quota_Sales_Employee__c qe = new Quota_Sales_Employee__c();
        qe.Name = 'Test Employee';
        qe.Year__c = String.valueof(system.today().year());
        qe.User__c = userinfo.getUserId();
        qe.Quota_Sales_Region__c = qr.Id;
        qe.Role__c = 'RSM';
        insert qe;
        
        //Create Quota Employee
        Quota_Sales_Employee__c qe1 = new Quota_Sales_Employee__c();
        qe1.Name = 'Administrative';
        qe1.Year__c = String.valueof(system.today().year());
        qe1.Quota_Sales_Region__c = qr.Id;
        qe1.Role__c = 'Other';
        insert qe1;
        
        //Create Quota Employee
        Quota_Sales_Employee__c qe2 = new Quota_Sales_Employee__c();
        qe2.Name = 'Gillette';
        qe2.Year__c = String.valueof(system.today().year());
        qe2.Quota_Sales_Region__c = qr.Id;
        qe2.Role__c = 'Other';
        insert qe2;
               
        //Create Performance Record
        Performance__c perf = new Performance__c();
        perf.Quarter__c = 'Q' + string.ValueOf(Math.ceil(system.today().month()/3.0));
        perf.Quota_Sales_Employee__c = qe.Id;
        perf.Quota_Master__c = qm.Id;
        perf.Name = 'Test Name';
		insert perf;
        
        Performance__c p = [Select Performance_Owner__c from Performance__C where Id =: perf.Id];
        system.debug('Performance Owner: '+ p.Performance_Owner__c);
        
        //Create Admin Performance Record
        Performance__c perf2 = new Performance__c();
        perf2.Quarter__c = 'Q' + Math.ceil(Decimal.valueOf(system.today().Month())/3).intValue();
        perf2.Quota_Sales_Employee__c = qe1.Id;
        perf2.Quota_Master__c = qm.Id;
        perf2.Name = 'Administrative';
		insert perf2;
        
        //Create Gillette Performance Record
        Performance__c perf3 = new Performance__c();
        perf3.Quarter__c = 'Q' + Math.ceil(Decimal.valueOf(system.today().Month())/3).intValue();
        perf3.Quota_Sales_Employee__c = qe2.Id;
        perf3.Quota_Master__c = qm.Id;
        perf3.Name = 'Gillette';
		insert perf3;
        
        //Create Product Line
   	 	Product_Line__c prodLine = new Product_Line__c(
            Product_Line_Family__c = 'Aircraft',
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
    	Account acnt = new Account();
        acnt.Name = 'test name';
        acnt.BillingStreet = '1600 Amphitheatre Parkway';
        acnt.BillingCity = 'Mountain View';
        acnt.BillingState = 'TN';
        acnt.BillingPostalCode = '37128';
        acnt.BillingCountry = 'United States';
        acnt.Area__c = 'East';
        acnt.RPACustomerNumber__c= 'G0501';
        insert acnt;

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
        ac.Account__c = acnt.Id;
        ac.Aircraft_Type__c = 'Aircraft';
        insert ac;
    
        //Create Engine
        Equipment__c equip = new Equipment__c(
            Product_Line__c = prodLine.id,
            Account__c = acnt.id,
            Equipment_Prefix__c = 'TFE',
            EngineorAPUSN__c = 'ABC',
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'HTF7000'
        );
        insert equip;
        
        //Create MST Dispatch
        MST_Dispatch__c mst = new MST_Dispatch__c(
            Account__c = acnt.id,
            Company_Name__c = 'Test Company',
            RPA_Work_Order_Num__c = '325022',
            Aircraft__c = ac.Id,
            Equipment__c = equip.Id,
            Current_Aircraft_Location__c = 'APA',
            Customer_Credit_Status__c = 'Approval Confirmed',
            Start_Date__c = System.today(),
            End_Date__c = System.today()           
        );
        insert mst;
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        //Create Opportunity
        Opportunity oppty = new Opportunity();
        oppty.Input_Date_Accuracy__c = 'Firm';
        oppty.Operator__c = 'FAA Part 135';
        oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RFS').getRecordTypeId();
        oppty.Name = 'trigger test';
        oppty.Opportunity_Name_Details__c = 'trigger test';
        oppty.StageName = 'RFS';
        oppty.AccountId = acnt.Id;
        oppty.Aircraft__c = ac.Id;
        oppty.Amount = decimal.valueof('1471620');
        oppty.Equipment__c = equip.Id;
        oppty.CustomerName__c = 'World Jet, Inc.';
        oppty.Facility__c = 'PHX';
        oppty.Tier_Level__c = '1';
        oppty.CloseDate =  system.today();
        oppty.InputDate__c =  system.today();
        oppty.OutputDate__c =  system.today();
        oppty.Product_Line__c = ac.Product_Line__c;
        oppty.Type = 'Airframe';
        oppty.SubType__c = 'Cabin Broadband';
        oppty.LeadSource = 'CPM';
        oppty.QuoteNum__c = '12345-1';
        oppty.QuoteDelivery__c = 'Hand Delivery';
        oppty.QuoteRequiredBy__c =  Date.today();
        oppty.Base_Quote_Number__c = '12345';
        oppty.QuotedDate__c =  Date.today();
        oppty.Concession1__c = 'None';
        oppty.Agent_Representative__c = 'Not Applicable';
        oppty.Competitor__c = 'Harrods Aviation';
        oppty.WinorLossReason1__c = 'Location';
        oppty.Win_Loss_Description__c = 'Test';
        oppty.Customer_Satisfaction_Survey_Contact__c = contact.Id;
        oppty.Contact__c = contact.Id;
        oppty.AFSM_Lookup__c = userinfo.getUserId();
        oppty.ownerId = userinfo.getUserId();
        insert oppty;
        
    	Opportunity oppty2 = new Opportunity();
        oppty2.Input_Date_Accuracy__c = 'Firm';
        oppty2.Operator__c = 'FAA Part 135';
        oppty2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RFS').getRecordTypeId();
        oppty2.Name = 'trigger test';
        oppty2.Opportunity_Name_Details__c = 'trigger test';
        oppty2.StageName = 'RFS';
        oppty2.AccountId = acnt.Id;
        oppty2.Aircraft__c = ac.Id;
        oppty2.Amount = decimal.valueof('1471620');
        oppty2.Equipment__c = equip.Id;
        oppty2.CustomerName__c = 'World Jet, Inc.';
        oppty2.Facility__c = 'PHX';
        oppty2.Tier_Level__c = '1';
        oppty2.CloseDate =  system.today();
        oppty2.InputDate__c =  system.today();
        oppty2.OutputDate__c =  system.today();
        oppty2.Product_Line__c = ac.Product_Line__c;
        oppty2.Type = 'Airframe';
        oppty2.SubType__c = 'Cabin Broadband';
        oppty2.LeadSource = 'CPM';
        oppty2.QuoteDelivery__c = 'Hand Delivery';
        oppty2.QuoteRequiredBy__c =  Date.today();
        oppty2.QuotedDate__c =  Date.today();
        oppty2.Concession1__c = 'None';
        oppty2.Agent_Representative__c = 'Not Applicable';
        oppty2.RPAWorkOrderNum__c = 103456;
        oppty2.Additional_RPA_Work_Order_Numbers__c = 120456;
        oppty2.RPA_WO_3__c = 123056;
        oppty2.RPA_WO_4__c = 123406;
        oppty2.RPA_WO_5__c = 123450;
        oppty2.RPA_WO_6__c = 113456;
        oppty2.RPA_WO_7__c = 121456;
		oppty2.RPA_WO_8__c = 123456;
        oppty2.Competitor__c = 'Harrods Aviation';
        oppty2.WinorLossReason1__c = 'Location';
        oppty2.Win_Loss_Description__c = 'Test';
        oppty2.Customer_Satisfaction_Survey_Contact__c = contact.Id;
        oppty2.Contact__c = contact.Id;
        oppty2.AFSM_Lookup__c = userinfo.getUserId();
        oppty2.ownerId = userinfo.getUserId();
        insert oppty2;
    }
    
    static testMethod void testPendingName(){
                        
        WO_Detail__c wod = new WO_Detail__c();
        wod.Quote__c = '12345';
        wod.Customer__c = 'G0501';
        wod.Event_Code__c = 'M19';

 		insert wod;
        
        test.startTest();
        
        WO_Detail__c wo = [Select Name from WO_Detail__c where Id =: wod.Id];
        
        test.stopTest();
        
        system.assertEquals('Pending', wo.Name);
	}
    
	static testMethod void testAccountPerformanceMap(){
               
        WO_Detail__c wod = new WO_Detail__c();
		wod.Name = 'test';
        wod.Customer__c = 'G0501';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'M19';

 		insert wod; 
        
        test.startTest();
        
        WO_Detail__c wo = [Select Consensus_RSM__c, Source_of_Consensus_RSM__c, Short_Dept__c, Workscope__c, Event_Code__c from WO_Detail__c where Id =: wod.Id];
        Work_Order_Detail_Reference__c wodr = [Select Name, Short_Dept__c, Workscope__c from Work_Order_Detail_Reference__c where Name =: wo.Event_Code__c];
        Account acnt = [Select OwnerId from Account where RPACustomerNumber__c =: wod.Customer__c];
        Performance__c perf = [Select Id from Performance__c where Quota_Sales_Employee__r.User__c =: acnt.OwnerId];
        
        test.stopTest();
        
        system.assertEquals(wo.Consensus_RSM__c, perf.id);
        system.assertEquals(wo.Source_of_Consensus_RSM__c, 'Account');
        system.assertEquals(wo.Short_Dept__c, wodr.Short_Dept__c);
        system.assertEquals(wo.Workscope__c, wodr.Workscope__c);      
	}
    
	static testMethod void testNoCustomerWithQuote(){
               
        WO_Detail__c wod = new WO_Detail__c();
		wod.Name = 'test';
        wod.Quote__c = '12345';
        wod.Customer__c = 'G0501';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'M19';

 		insert wod;
        
        test.startTest();
        
        WO_Detail__c wo = [Select Consensus_RSM__c, Source_of_Consensus_RSM__c, Short_Dept__c, Workscope__c, Event_Code__c from WO_Detail__c where Id =: wod.Id];
        Work_Order_Detail_Reference__c wodr = [Select Name, Short_Dept__c, Workscope__c from Work_Order_Detail_Reference__c where Name =: wo.Event_Code__c];
        Opportunity op = [Select OwnerId from Opportunity where Quote_Reference__c =: wod.Quote__c];
        Performance__c perf = [Select Id from Performance__c where Quota_Sales_Employee__r.User__c =: op.OwnerId];
        
        test.stopTest();
        
        system.assertEquals(wo.Consensus_RSM__c, perf.id);
        system.assertEquals(wo.Source_of_Consensus_RSM__c, 'Opportunity');
        system.assertEquals(wo.Short_Dept__c, wodr.Short_Dept__c);
        system.assertEquals(wo.Workscope__c, wodr.Workscope__c);  
	}
    
	static testMethod void testMST(){
               
        WO_Detail__c wod = new WO_Detail__c();
		wod.Name = 'test';
        wod.WO__c = '325022';
        wod.Quote__c = '12345';
        wod.Customer__c = 'G0501';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'BA1';

 		insert wod;
        
        test.startTest();
        
        WO_Detail__c wo = [Select Consensus_RSM__c, Source_of_Consensus_RSM__c, Short_Dept__c, Workscope__c, Event_Code__c from WO_Detail__c where Id =: wod.Id];
        Work_Order_Detail_Reference__c wodr = [Select Name, Short_Dept__c, Workscope__c from Work_Order_Detail_Reference__c where Name =: wo.Event_Code__c];
        MST_Dispatch__c mst = [Select Company_Name__c, RPA_Work_Order_Num__c, Aircraft__r.Account__r.OwnerId, Equipment__c from MST_Dispatch__c];
        Performance__c perf = [Select Id from Performance__c where Quota_Sales_Employee__r.User__c =: mst.Aircraft__r.Account__r.OwnerId];
        
        test.stopTest();
        
        system.assertEquals(wo.Consensus_RSM__c, perf.id);
        system.assertEquals(wo.Source_of_Consensus_RSM__c, 'MST Dispatch');
        system.assertEquals(wo.Short_Dept__c, wodr.Short_Dept__c);
        system.assertEquals(wo.Workscope__c, wodr.Workscope__c);  
	}
    
    static testMethod void testRPA1(){
        
        WO_Detail__c wod = new WO_Detail__c();
        wod.Name = 'test';
        wod.Customer__c = 'G1234';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'ZZZ';
        wod.WO__c = '103456';
        
        insert wod; 
    }
    
    static testMethod void testRPA2(){
        
        WO_Detail__c wod = new WO_Detail__c();
        wod.Name = 'test';
        wod.Customer__c = 'G1234';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'ZZZ';
        wod.WO__c = '120456';
        
        insert wod; 
    }
    
    static testMethod void testRPA3(){
        
        WO_Detail__c wod = new WO_Detail__c();
        wod.Name = 'test';
        wod.Customer__c = 'G1234';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'ZZZ';
        wod.WO__c = '123056';
        
        insert wod; 
    }
    
    static testMethod void testRPA4(){
        
        WO_Detail__c wod = new WO_Detail__c();
        wod.Name = 'test';
        wod.Customer__c = 'G1234';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'ZZZ';
        wod.WO__c = '123406';
        
        insert wod; 
    }
    
    static testMethod void testRPA5(){
        
        WO_Detail__c wod = new WO_Detail__c();
        wod.Name = 'test';
        wod.Customer__c = 'G1234';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'ZZZ';
        wod.WO__c = '123450';
        
        insert wod; 
    }
    
    static testMethod void testRPA6(){
        
        WO_Detail__c wod = new WO_Detail__c();
        wod.Name = 'test';
        wod.Customer__c = 'G1234';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'ZZZ';
        wod.WO__c = '113456';
        
        insert wod; 
    }
    
    static testMethod void testRPA7(){
        
        WO_Detail__c wod = new WO_Detail__c();
        wod.Name = 'test';
        wod.Customer__c = 'G1234';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'ZZZ';
        wod.WO__c = '121456';
        
        insert wod; 
    }
    
	static testMethod void testRPA8(){
               
        WO_Detail__c wod = new WO_Detail__c();
		wod.Name = 'test';
        wod.Customer__c = 'G1234';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'ZZZ';
        wod.WO__c = '123456';

 		insert wod; 
	}
    
	static testMethod void testNoQuoteWithCustomer(){
               
        WO_Detail__c wod = new WO_Detail__c();
		wod.Name = 'test';
        wod.Customer__c = 'G0501';
        wod.Dispatch_date__c = System.today();
        wod.Event_Code__c = 'ZZZ';

 		insert wod; 
               
        test.startTest();
        
        WO_Detail__c wo = [Select Consensus_RSM__c, Source_of_Consensus_RSM__c, Short_Dept__c, Workscope__c, Event_Code__c from WO_Detail__c where Id =: wod.Id];
        Work_Order_Detail_Reference__c wodr = [Select Name, Short_Dept__c, Workscope__c from Work_Order_Detail_Reference__c where Name =: wo.Event_Code__c];
        Performance__c perf = [Select Id from Performance__c where Name like '%Administrative%'];
        
        test.stopTest();
        
        system.assertEquals(wo.Consensus_RSM__c, perf.id);
        system.assertEquals(wo.Source_of_Consensus_RSM__c, 'Short Dept: Other');
        system.assertEquals(wo.Short_Dept__c, wodr.Short_Dept__c);
        system.assertEquals(wo.Workscope__c, wodr.Workscope__c);   
	}
    
	static testMethod void testNavixaTFE(){
               
        WO_Detail__c wod = new WO_Detail__c();
		wod.Name = 'test';
        wod.Dispatch_date__c = System.today();
        wod.System__c = 'VECTOR AEROSPACE INT\'L LIMITED';
        wod.Short_Eng_Model__c = 'TFE';
        wod.TFE_S_N__c = 'P-11123';

 		insert wod; 
               
        test.startTest();
        
        WO_Detail__c wo = [Select Consensus_RSM__r.Name, Consensus_RSM__c, Source_of_Consensus_RSM__c, Short_Dept__c, System__c, Workscope__c, Event_Code__c from WO_Detail__c where Id =: wod.Id];
        Performance__c perf = [Select Id from Performance__c where Name like '%Gillette%'];
        
        test.stopTest();
        system.debug(wo.System__c);
        system.assertEquals(wo.Consensus_RSM__c, perf.id);
        system.assertEquals(wo.Source_of_Consensus_RSM__c, 'Navixa');  
	}
    
	static testMethod void testNavixaPW(){
               
        WO_Detail__c wod = new WO_Detail__c();
		wod.Name = 'test';
        wod.Dispatch_date__c = System.today();
        wod.System__c = 'VECTOR AEROSPACE INT\'L LIMITED';
        wod.Short_Eng_Model__c = 'PW300';
        wod.TFE_S_N__c = 'CF0263';
        WOD.TFE_Model__c = 'PW308C';

 		insert wod; 
               
        test.startTest();
        
        WO_Detail__c wo = [Select Consensus_RSM__r.Name, Consensus_RSM__c, Source_of_Consensus_RSM__c, Short_Dept__c, System__c, Workscope__c, Event_Code__c from WO_Detail__c where Id =: wod.Id];
        Performance__c perf = [Select Id from Performance__c where Name like '%Gillette%'];
        
        test.stopTest();
        system.debug(wo.System__c);
        system.assertEquals(wo.Consensus_RSM__c, perf.id);
        system.assertEquals(wo.Source_of_Consensus_RSM__c, 'Navixa');  
	}
    
	static testMethod void testSAMenu(){
               
        WO_Detail__c wod = new WO_Detail__c();
		wod.Name = 'test';
        wod.Dispatch_date__c = System.today();
        wod.TCN_SA_Menu__c = 'FN203563';
        
 		insert wod; 
               
        test.startTest();
        
        WO_Detail__c wo = [Select Consensus_RSM__r.Name, Consensus_RSM__c, Source_of_Consensus_RSM__c, Short_Dept__c, System__c, Workscope__c, Event_Code__c from WO_Detail__c where Id =: wod.Id];
        Performance__c perf = [Select Id from Performance__c where Name like '%Gillette%'];
        
        test.stopTest();
        system.debug(wo.System__c);
        system.assertEquals(wo.Consensus_RSM__c, perf.id);
        system.assertEquals(wo.Source_of_Consensus_RSM__c, 'SA Menu');  
	}
}