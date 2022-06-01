@isTest
public class TestDataGenerator {
    
    public static sbaa__ApprovalChain__c createApprovalChain(){
        sbaa__ApprovalChain__c cpqAC = new sbaa__ApprovalChain__c();
        cpqAC.Name = 'Quote';
        
        insert cpqAC;
        return cpqAC;
    }
    
    public static sbaa__Approver__c createQuoteApprovers(String createAU){
        User u = [Select Id, FirstName, LastName from user where Id =: createAU];
        
        sbaa__Approver__c s = new sbaa__Approver__c();
        s.Name = u.FirstName + ' ' + u.LastName;
        s.sbaa__User__c = u.Id;         
                
        insert s;        
        return s;
    }
    
    public static SBQQ__Quote__c createQuote(Aircraft__c ac, Account acnt, Opportunity opp){
        SBQQ__Quote__c quote = new SBQQ__Quote__c( 
            Labor_Type1__c = 'Airframe',
            SBQQ__Status__c = 'Presented',
            SBQQ__Account__c = acnt.Id,
            SBQQ__Opportunity2__c = opp.Id,
            Aircraft__c = ac.Id,
            Account_Name__c = acnt.Name,
            Downtime_Days__c=50,                
            SBQQ__SalesRep__c = userinfo.getUserId(),
            Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
            Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
            Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
            Facility1__c = 'AGS',
            SBQQ__Primary__c = True);  
        insert quote;  
        return quote;
    }
    
    public static sbaa__ApprovalRule__c createApprovalRule(String chainId, String approverId){
        sbaa__ApprovalRule__c ar = new sbaa__ApprovalRule__c();
        ar.Name = 'Test Quote Approval';
        ar.sbaa__TargetObject__c = 'SBQQ__Quote__c';
        ar.sbaa__ApprovalStep__c = 1;
        ar.sbaa__ConditionsMet__c = 'Any';
        ar.sbaa__Active__c = True;
        ar.sbaa__Approver__c = approverId;
        ar.sbaa__ApprovalChain__c = chainId;
        
        insert ar;
        return ar;
    }
    
    public static sbaa__ApprovalCondition__c createApprovalCondition(String arId, String qId){
        sbaa__ApprovalCondition__c ac = new sbaa__ApprovalCondition__c();
        ac.sbaa__ApprovalRule__c = arId;
        ac.sbaa__TestedField__c = 'Name';
        ac.sbaa__Operator__c = 'equals';
        ac.sbaa__FilterType__c = 'Value';
        ac.sbaa__FilterValue__c = qId;
        
        insert ac;
        return ac;      
    }
    
    public static sbaa__Approval__c createApprovalRequest(String ruleId, String chainId, String approverId, String quoteId){      
        sbaa__Approval__c qa = new sbaa__Approval__c();
        qa.sbaa__Status__c = 'Requested';
     	qa.sbaa__ApprovalStep__c = 1;
        qa.sbaa__RecordField__c = 'Quote__c';
        qa.sbaa__Approver__c = approverId;
        qa.sbaa__AssignedTo__c = userinfo.getUserId();
        qa.Quote__c = quoteId;
        qa.sbaa__Rule__c = ruleId;
        qa.sbaa__ApprovalChain__c = chainId;
        
        insert qa;
        return qa;
    }
    
    public static Account createAccount(){
        Account acc = new Account();
        acc.Name= 'Test';
        acc.BillingState= 'TN';
        acc.Area__c = 'EAST';
        acc.Type= 'Customer';
        
        insert acc;
        return acc;
    }
    
    public static Facility__c createFacility(){
        Facility__c fac = new Facility__c();
        fac.Name = 'AGS';
        fac.Street__c = '123 Anywhere Drive';
        fac.City__c = 'Nashville';
        fac.State__c = 'TN';
        fac.Zip_Code__c = '37617';
        fac.Phone__c = '123-456-7891';
        fac.Fax__c = '123-456-7891';
        fac.Airport__c = 'AGS';
        fac.Airframe_Margin_Threshold_RSD__c=20;
        fac.Airframe_Plan_Margin__c=30;
        fac.Airframe_Margin_Threshold_VP_Sales__c =10;
        fac.Airframe_Margin_Threshold_RSM__c=10;
        fac.Airframe_Margin_Threshold_President__c=5;
        fac.APU_Plan_Margin__c=5;
        fac.APU_Margin_Threshold_VP_Sales__c=10;
        fac.APU_Margin_Threshold_RSM__c=5;
        fac.APU_Margin_Threshold_RSD__c=5;
        fac.Avionics_Margin_Threshold_VP_Sales__c=20;
        fac.Avionics_Plan_Margin__c=5;
        fac.Avionics_Margin_Threshold_RSM__c=5;
        fac.Avionics_Margin_Threshold_RSD__c=5;
        fac.CFE_Plan_Margin__c=5;
        fac.CFE_Margin_Threshold_VP_Sales__c=10;
        fac.CFE_Margin_Threshold_RSM__c=5;
        fac.CFE_Margin_Threshold_RSD__c=5;
        fac.HTF_Plan_Marign__c=5;
        fac.HTF_Margin_Threshold_RSM__c=10;
        fac.HTF_Margin_Threshold_RSM__c=5;
        fac.HTF_Margin_Threshold_RSD__c=5;
        fac.Interior_Plan_Margin__c=5;
        fac.Interior_Margin_Threshold_VP_Sales__c=5;
        fac.Interior_Margin_Threshold_RSM__c=5;
        fac.Interior_Margin_Threshold_RSD__c=10;
        fac.Other_Plan_Margin__c=5;
        fac.Other_Margin_Threshold_VP_Sales__c=5;
        fac.Other_Margin_Threshold_RSD__c=5;
        fac.Other_Margin_Threshold_RSM__c=5;
        fac.TFE_Plan_Margin__c=5;
        fac.TFE_Margin_Threshold_VP_Sales__c=5;
        fac.TFE_Margin_Threshold_RSM__c=10;
        fac.TFE_Margin_Threshold_RSD__c=5;
        fac.Paint_Plan_Margin__c=5;
        fac.Paint_Margin_Threshold_VP_Sales__c=5;
        fac.Paint_Margin_Threshold_RSD__c=5;
        fac.Paint_Margin_Threshold_RSM__c=5;
        
        insert fac;
        return fac;
    }
    //Data added to meet else condition of tsmQuoteRoutingController code
    public static Facility__c createFacility1(){
        Facility__c fac = new Facility__c();
        fac.Name = 'AGS';
        fac.Street__c = '123 Anywhere Drive';
        fac.City__c = 'Nashville';
        fac.State__c = 'TN';
        fac.Zip_Code__c = '37617';
        fac.Phone__c = '123-456-7891';
        fac.Fax__c = '123-456-7891';
        fac.Airport__c = 'AGS';
        fac.Airframe_Margin_Threshold_RSD__c=0.05;
        fac.Airframe_Plan_Margin__c=300;
        fac.Airframe_Margin_Threshold_VP_Sales__c =10;
        fac.Airframe_Margin_Threshold_RSM__c=10;
        fac.Airframe_Margin_Threshold_President__c=5;
        fac.APU_Plan_Margin__c=300;
        fac.APU_Margin_Threshold_VP_Sales__c=10;
        fac.APU_Margin_Threshold_RSM__c=5;
        fac.APU_Margin_Threshold_RSD__c=0.05;
        fac.Avionics_Margin_Threshold_VP_Sales__c=20;
        fac.Avionics_Plan_Margin__c=300;
        fac.Avionics_Margin_Threshold_RSM__c=5;
        fac.Avionics_Margin_Threshold_RSD__c=0.05;
        fac.CFE_Plan_Margin__c=300;
        fac.CFE_Margin_Threshold_VP_Sales__c=10;
        fac.CFE_Margin_Threshold_RSM__c=5;
        fac.CFE_Margin_Threshold_RSD__c=0.05;
        fac.HTF_Plan_Marign__c=500;
        fac.HTF_Margin_Threshold_RSM__c=10;
        fac.HTF_Margin_Threshold_RSM__c=5;
        fac.HTF_Margin_Threshold_RSD__c=0.03;
        fac.Interior_Plan_Margin__c=300;
        fac.Interior_Margin_Threshold_VP_Sales__c=5;
        fac.Interior_Margin_Threshold_RSM__c=5;
        fac.Interior_Margin_Threshold_RSD__c=0.05;
        fac.Other_Plan_Margin__c=300;
        fac.Other_Margin_Threshold_VP_Sales__c=5;
        fac.Other_Margin_Threshold_RSD__c=0.05;
        fac.Other_Margin_Threshold_RSM__c=5;
        fac.TFE_Plan_Margin__c=300;
        fac.TFE_Margin_Threshold_VP_Sales__c=0.3;
        fac.TFE_Margin_Threshold_RSM__c=0.05;
        fac.TFE_Margin_Threshold_RSD__c=5;
        fac.Paint_Plan_Margin__c=300;
        fac.Paint_Margin_Threshold_VP_Sales__c=5;
        fac.Paint_Margin_Threshold_RSD__c=0.05;
        fac.Paint_Margin_Threshold_RSM__c=5;
        
        insert fac;
        return fac;
    }
    
    public static Probability_Grouping__c createProbabilityGrouping(){    
        Probability_Grouping__c pb = New Probability_Grouping__c();
        pb.SystemProbabilityGroupingName__c = 'EAST.AGS.Avionics';
        pb.Probability_to_Use__c = 62;
        pb.Account_Area__c = 'EAST';
        pb.Facility__c = 'AGS';
        pb.Type__c = 'Avionics';
        
        insert pb;
        return pb;
    }
    
    public static Contact createContact(String acId){    
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.Lastname = 'McTesty';
        c.ContactType__c = 'Primary Contact';
        c.AccountId = acId;
        
        insert c;
        return c;
    }
    
    public static Product_Line__c createProductLine(){
        Product_Line__c  proline = new Product_Line__c();
        proline.Name ='proline';
        proline.Product_Line_Family__c= 'Aircraft';
        
        insert proline;
        return proline;
    }
    
    public static Aircraft__c createAircraft(String proLIneId, String accId){
        
        Aircraft__c craft = new Aircraft__c();
        craft.Name= 'craft Test';
        craft.Product_Line__c = proLIneId;
        craft.Account__c = accId;
        craft.Aircraft_Make__c = 'BEECH KING AIR';
        craft.Aircraft_Model_2011__c = 'BEECH KING AIR B100';
        craft.Aircraft_SN__c = 'Test';
        craft.Aircraft_Type__c = 'Aircraft';
        
        insert craft;
        return craft;
    }
    
    public static Equipment__c createEquipment(String proLIneId, String accId, String acId){
        Aircraft__c ac = new Aircraft__c();
        ac.Product_Line__c = proLIneId;
        ac.Account__c = accId;        
        ac.Name = 'NA';
        ac.aircraft_make__c = 'NA'; 
        ac.aircraft_model_2011__c = 'NA';
        ac.aircraft_SN__c = 'NA';  
        ac.Aircraft_Type__c = 'Aircraft';
        
        insert ac;
        
        Equipment__c eq = new Equipment__c();
        eq.Product_Line__c = proLIneId;
        eq.Equipment_Prefix__c= 'TFE';
        eq.Aircraft__c = acId;
        eq.EngineorAPUSN__c= '118800';
        eq.Equipment_Status__c='In-Operation';
        eq.Equipment_Type__c= 'Engine';
        eq.Account__c = accId;
        eq.Model__c = 'TFE731-20AR-1B';
        
        insert eq;
        return eq;
    }
    
    public static Sub_Type_2__c createSubType2(String plId){
        Sub_Type_2__c st2 = new Sub_Type_2__c();
        st2.Name = 'Test SubType2';
        st2.Product_Line__c = plId;
        st2.Opportunity_Sub_Type__c = 'Cabin Broadband';
        st2.Generic__c = True;
        st2.Anchor_Inspection__c = True;
        
        insert st2;
        return st2;
    }
    
    public static Opportunity createMasterOpportunity(String acntId, String acId,String equipId, String plId, String st2Id, String cId){
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id masterOppId = opportunityRecordTypeInfo .get('Master Opportunity').getRecordTypeId();
        
        Product2 prod = new Product2();
        prod.Name = 'Master Opportunity Product';
        prod.ProductCode = 'Code1';
        prod.isActive = True;
        
        insert prod;
        
        PricebookEntry pbk = new PricebookEntry();
        pbk.Pricebook2Id = Test.getStandardPricebookId();
        pbk.Product2Id = prod.Id;
        pbk.IsActive = true;
        pbk.UnitPrice = 100;
        insert pbk;
        
        Opportunity oppty = new Opportunity();
        oppty.Input_Date_Accuracy__c = 'Firm';
        oppty.Operator__c = 'FAA Part 135';
        oppty.RecordTypeId = masterOppId;
        oppty.RSM__c = 'Campbell,Tom';
        oppty.Name = 'trigger test';
        oppty.Opportunity_Name_Details__c = 'trigger test';
        oppty.StageName = 'New Opportunity';
        oppty.AccountId = acntId;
        oppty.Aircraft__c = acId;
        oppty.Amount = decimal.valueof('1471620');
        oppty.Equipment__c = equipId;
        oppty.CustomerName__c = 'World Jet, Inc.';
        oppty.Facility__c = 'AGS';
        oppty.Tier_Level__c = '1';
        oppty.CloseDate =  Date.today() +30;
        oppty.InputDate__c =  Date.today();
        oppty.OutputDate__c =  Date.today();
        oppty.Product_Line__c = plId;
        oppty.Type = 'Airframe';
        oppty.SubType__c = 'Cabin Broadband';
        oppty.SubType2__c = st2Id;
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
        oppty.Customer_Satisfaction_Survey_Contact__c = cId;
        oppty.Contact__c = cId;
        oppty.AFSM_Lookup__c = userinfo.getuserid();
        oppty.Pricebook2Id = Test.getStandardPricebookId();
        
        insert oppty;
        return oppty;
    }
    
    public static List<Opportunity> associatedOpportunities(String acntId, String acId,String equipId, String plId, String st2Id, String cId, String mId){
        
        List<Opportunity> oList = new List<Opportunity>();
        
        Opportunity mo = [Select Id, 
                          Associated_Opportunity_01__c, 
                          Associated_Opportunity_02__c, 
                          Associated_Opportunity_03__c, 
                          Associated_Opportunity_04__c, 
                          Associated_Opportunity_05__c,
                          Associated_Opportunity_06__c,
                          Associated_Opportunity_07__c,
                          Associated_Opportunity_08__c
                          from Opportunity where Id =: mId];
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id newOppId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
        
        for(Integer i = 0; i < 8; i++){
            
            String oNameDetails;
            
            if(i == 0){
                oNameDetails = 'AO trigger test';
            }else{
                oNameDetails = 'AO' + i + ' trigger test';
            }
            
            Opportunity oppty = new Opportunity(
                Input_Date_Accuracy__c = 'Firm',
                Operator__c = 'FAA Part 135',
                RecordTypeId = newOppId,
                MasterOpportunitylookup__c = mId,
                RSM__c = 'Campbell,Tom',
                Name = 'trigger test',
                Opportunity_Name_Details__c = oNameDetails,
                StageName = 'New Opportunity',
                AccountId = acntId,
                Aircraft__c = acId,
                Amount = decimal.valueof('1471620'),
                Equipment__c = equipId,
                CustomerName__c = 'World Jet, Inc.',
                Facility__c = 'AGS',
                Tier_Level__c = '1',
                CloseDate =  Date.today() +30,
                InputDate__c =  Date.today(),
                OutputDate__c =  Date.today(),
                Product_Line__c = plId,
                Type = 'Airframe',
                SubType__c = 'Cabin Broadband',
                SubType2__c = st2Id,
                LeadSource = 'CPM',
                QuoteDelivery__c = 'Hand Delivery',
                QuoteRequiredBy__c =  Date.today(),
                Base_Quote_Number__c = '1',
                QuotedDate__c =  Date.today(),
                Concession1__c = 'None',
                Agent_Representative__c = 'Not Applicable',
                Master_Opportunity__c = False,
                Competitor__c = 'Harrods Aviation',
                WinorLossReason1__c = 'Location',
                Win_Loss_Description__c = 'Test',
                Customer_Satisfaction_Survey_Contact__c = cId,
                Contact__c = cId,
                AFSM_Lookup__c = userinfo.getuserid()
            );
            oList.add(oppty);
        }
        
        system.debug('Opportunity List : ' + oList);
        
        insert oList;
        
        mo.Associated_Opportunity_01__c = oList[0].id;
        mo.Associated_Opportunity_02__c = oList[1].id;
        mo.Associated_Opportunity_03__c = oList[2].id;
        mo.Associated_Opportunity_04__c = oList[3].id;
        mo.Associated_Opportunity_05__c = oList[4].id;
        mo.Associated_Opportunity_06__c = oList[5].id;
        mo.Associated_Opportunity_07__c = oList[6].id;
        mo.Associated_Opportunity_08__c = oList[7].id;
        update mo;
        
        return oList;
    }
    
    public static Opportunity instantiateOpportunity(String acntId, String acId,String equipId, String plId, String st2Id, String cId){
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id newOppId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
        
        Opportunity oppty = new Opportunity();
        oppty.Input_Date_Accuracy__c = 'Firm';
        oppty.Operator__c = 'FAA Part 135';
        oppty.RecordTypeId = newOppId;
        oppty.RSM__c = 'Campbell,Tom';
        oppty.Name = 'trigger test';
        oppty.Opportunity_Name_Details__c = 'trigger test';
        oppty.StageName = 'New Opportunity';
        oppty.AccountId = acntId;
        oppty.Aircraft__c = acId;
        oppty.Amount = decimal.valueof('1471620');
        oppty.Equipment__c = equipId;
        oppty.CustomerName__c = 'World Jet, Inc.';
        oppty.Facility__c = 'AGS';
        oppty.Tier_Level__c = '1';
        oppty.CloseDate =  Date.today() +30;
        oppty.InputDate__c =  Date.today();
        oppty.OutputDate__c =  Date.today();
        oppty.Product_Line__c = plId;
        oppty.Type = 'Airframe';
        oppty.SubType__c = 'Cabin Broadband';
        oppty.SubType2__c = st2Id;
        oppty.LeadSource = 'CPM';
        oppty.QuoteDelivery__c = 'Hand Delivery';
        oppty.QuoteRequiredBy__c =  Date.today();
        oppty.Base_Quote_Number__c = '1';
        oppty.QuotedDate__c =  Date.today();
        oppty.Concession1__c = 'None';
        oppty.Agent_Representative__c = 'Not Applicable';
        oppty.Master_Opportunity__c = False;
        oppty.Competitor__c = 'Harrods Aviation';
        oppty.WinorLossReason1__c = 'Location';
        oppty.Win_Loss_Description__c = 'Test';
        oppty.Customer_Satisfaction_Survey_Contact__c = cId;
        oppty.Contact__c = cId;
        oppty.AFSM_Lookup__c = userinfo.getuserid();
        
        insert oppty;
        return oppty;
    }
    public static Opportunity instantiateOpportunity1(String acntId, String acId,String equipId, String plId, String st2Id, String cId){
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id newOppId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
        
        Opportunity oppty = new Opportunity();
        oppty.Input_Date_Accuracy__c = 'Firm';
        oppty.Operator__c = 'FAA Part 135';
        oppty.RecordTypeId = newOppId;
        oppty.RSM__c = 'Campbell,Tom';
        oppty.Name = 'trigger test';
        oppty.Opportunity_Name_Details__c = 'trigger test';
        oppty.StageName = 'New Opportunity';
        oppty.AccountId = acntId;
        oppty.Aircraft__c = acId;
        oppty.Amount = decimal.valueof('1471620');
        oppty.Equipment__c = equipId;
        oppty.CustomerName__c = 'World Jet, Inc.';
        oppty.Facility__c = 'AGS';
        oppty.Tier_Level__c = '1';
        oppty.CloseDate =  Date.today() +30;
        oppty.InputDate__c =  Date.today();
        oppty.OutputDate__c =  Date.today();
        oppty.Product_Line__c = plId;
        oppty.Type = 'Aircraft Purchase';
        oppty.SubType__c = 'Cabin Broadband';
        oppty.SubType2__c = st2Id;
        oppty.LeadSource = 'CPM';
        oppty.QuoteDelivery__c = 'Hand Delivery';
        oppty.QuoteRequiredBy__c =  Date.today();
        oppty.Base_Quote_Number__c = '1';
        oppty.QuotedDate__c =  Date.today();
        oppty.Concession1__c = 'None';
        oppty.Agent_Representative__c = 'Not Applicable';
        oppty.Master_Opportunity__c = False;
        oppty.Competitor__c = 'Harrods Aviation';
        oppty.WinorLossReason1__c = 'Location';
        oppty.Win_Loss_Description__c = 'Test';
        oppty.Customer_Satisfaction_Survey_Contact__c = cId;
        oppty.Contact__c = cId;
        oppty.AFSM_Lookup__c = userinfo.getuserid();
        
        insert oppty;
        return oppty;
    }
      public static Opportunity instantiateOpportunity2(String acntId, String acId,String equipId, String plId, String st2Id, String cId){
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id newOppId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
        
        Opportunity oppty = new Opportunity();
        oppty.Input_Date_Accuracy__c = 'Firm';
        oppty.Operator__c = 'FAA Part 135';
        oppty.RecordTypeId = newOppId;
        oppty.RSM__c = 'Campbell,Tom';
        oppty.Name = 'trigger test';
        oppty.Opportunity_Name_Details__c = 'trigger test';
        oppty.StageName = 'New Opportunity';
        oppty.AccountId = acntId;
        oppty.Aircraft__c = acId;
        oppty.Amount = decimal.valueof('1471620');
        oppty.Equipment__c = equipId;
        oppty.CustomerName__c = 'World Jet, Inc.';
        oppty.Facility__c = 'AGS';
        oppty.Tier_Level__c = '1';
        oppty.CloseDate =  Date.today() +30;
        oppty.InputDate__c =  Date.today();
        oppty.OutputDate__c =  Date.today();
        oppty.Product_Line__c = plId;
        oppty.Type = 'HTF';
        oppty.SubType__c = 'Cabin Broadband';
        oppty.SubType2__c = st2Id;
        oppty.LeadSource = 'CPM';
        oppty.QuoteDelivery__c = 'Hand Delivery';
        oppty.QuoteRequiredBy__c =  Date.today();
        oppty.Base_Quote_Number__c = '1';
        oppty.QuotedDate__c =  Date.today();
        oppty.Concession1__c = 'None';
        oppty.Agent_Representative__c = 'Not Applicable';
        oppty.Master_Opportunity__c = False;
        oppty.Competitor__c = 'Harrods Aviation';
        oppty.WinorLossReason1__c = 'Location';
        oppty.Win_Loss_Description__c = 'Test';
        oppty.Customer_Satisfaction_Survey_Contact__c = cId;
        oppty.Contact__c = cId;
        oppty.AFSM_Lookup__c = userinfo.getuserid();
        
        insert oppty;
        return oppty;
    }
        public static Opportunity instantiateOpportunity3(String acntId, String acId,String equipId, String plId, String st2Id, String cId){
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id newOppId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
        
        Opportunity oppty = new Opportunity();
        oppty.Input_Date_Accuracy__c = 'Firm';
        oppty.Operator__c = 'FAA Part 135';
        oppty.RecordTypeId = newOppId;
        oppty.RSM__c = 'Campbell,Tom';
        oppty.Name = 'trigger test';
        oppty.Opportunity_Name_Details__c = 'trigger test';
        oppty.StageName = 'New Opportunity';
        oppty.AccountId = acntId;
        oppty.Aircraft__c = acId;
        oppty.Amount = decimal.valueof('1471620');
        oppty.Equipment__c = equipId;
        oppty.CustomerName__c = 'World Jet, Inc.';
        oppty.Facility__c = 'AGS';
        oppty.Tier_Level__c = '1';
        oppty.CloseDate =  Date.today() +30;
        oppty.InputDate__c =  Date.today();
        oppty.OutputDate__c =  Date.today();
        oppty.Product_Line__c = plId;
        oppty.Type = 'TFE731';
        oppty.SubType__c = 'Cabin Broadband';
        oppty.SubType2__c = st2Id;
        oppty.LeadSource = 'CPM';
        oppty.QuoteDelivery__c = 'Hand Delivery';
        oppty.QuoteRequiredBy__c =  Date.today();
        oppty.Base_Quote_Number__c = '1';
        oppty.QuotedDate__c =  Date.today();
        oppty.Concession1__c = 'None';
        oppty.Agent_Representative__c = 'Not Applicable';
        oppty.Master_Opportunity__c = False;
        oppty.Competitor__c = 'Harrods Aviation';
        oppty.WinorLossReason1__c = 'Location';
        oppty.Win_Loss_Description__c = 'Test';
        oppty.Customer_Satisfaction_Survey_Contact__c = cId;
        oppty.Contact__c = cId;
        oppty.AFSM_Lookup__c = userinfo.getuserid();
        
        insert oppty;
        return oppty;
    }
            public static Opportunity instantiateOpportunity4(String acntId, String acId,String equipId, String plId, String st2Id, String cId){
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id newOppId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
        
        Opportunity oppty = new Opportunity();
        oppty.Input_Date_Accuracy__c = 'Firm';
        oppty.Operator__c = 'FAA Part 135';
        oppty.RecordTypeId = newOppId;
        oppty.RSM__c = 'Campbell,Tom';
        oppty.Name = 'trigger test';
        oppty.Opportunity_Name_Details__c = 'trigger test';
        oppty.StageName = 'New Opportunity';
        oppty.AccountId = acntId;
        oppty.Aircraft__c = acId;
        oppty.Amount = decimal.valueof('1471620');
        oppty.Equipment__c = equipId;
        oppty.CustomerName__c = 'World Jet, Inc.';
        oppty.Facility__c = 'AGS';
        oppty.Tier_Level__c = '1';
        oppty.CloseDate =  Date.today() +30;
        oppty.InputDate__c =  Date.today();
        oppty.OutputDate__c =  Date.today();
        oppty.Product_Line__c = plId;
        oppty.Type = 'CFE738';
        oppty.SubType__c = 'Cabin Broadband';
        oppty.SubType2__c = st2Id;
        oppty.LeadSource = 'CPM';
        oppty.QuoteDelivery__c = 'Hand Delivery';
        oppty.QuoteRequiredBy__c =  Date.today();
        oppty.Base_Quote_Number__c = '1';
        oppty.QuotedDate__c =  Date.today();
        oppty.Concession1__c = 'None';
        oppty.Agent_Representative__c = 'Not Applicable';
        oppty.Master_Opportunity__c = False;
        oppty.Competitor__c = 'Harrods Aviation';
        oppty.WinorLossReason1__c = 'Location';
        oppty.Win_Loss_Description__c = 'Test';
        oppty.Customer_Satisfaction_Survey_Contact__c = cId;
        oppty.Contact__c = cId;
        oppty.AFSM_Lookup__c = userinfo.getuserid();
        
        insert oppty;
        return oppty;
    }
       public static Opportunity instantiateOpportunity5(String acntId, String acId,String equipId, String plId, String st2Id, String cId){
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id newOppId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
        
        Opportunity oppty = new Opportunity();
        oppty.Input_Date_Accuracy__c = 'Firm';
        oppty.Operator__c = 'FAA Part 135';
        oppty.RecordTypeId = newOppId;
        oppty.RSM__c = 'Campbell,Tom';
        oppty.Name = 'trigger test';
        oppty.Opportunity_Name_Details__c = 'trigger test';
        oppty.StageName = 'New Opportunity';
        oppty.AccountId = acntId;
        oppty.Aircraft__c = acId;
        oppty.Amount = decimal.valueof('1471620');
        oppty.Equipment__c = equipId;
        oppty.CustomerName__c = 'World Jet, Inc.';
        oppty.Facility__c = 'AGS';
        oppty.Tier_Level__c = '1';
        oppty.CloseDate =  Date.today() +30;
        oppty.InputDate__c =  Date.today();
        oppty.OutputDate__c =  Date.today();
        oppty.Product_Line__c = plId;
        oppty.Type = 'Interior';
        oppty.SubType__c = 'Cabin Broadband';
        oppty.SubType2__c = st2Id;
        oppty.LeadSource = 'CPM';
        oppty.QuoteDelivery__c = 'Hand Delivery';
        oppty.QuoteRequiredBy__c =  Date.today();
        oppty.Base_Quote_Number__c = '1';
        oppty.QuotedDate__c =  Date.today();
        oppty.Concession1__c = 'None';
        oppty.Agent_Representative__c = 'Not Applicable';
        oppty.Master_Opportunity__c = False;
        oppty.Competitor__c = 'Harrods Aviation';
        oppty.WinorLossReason1__c = 'Location';
        oppty.Win_Loss_Description__c = 'Test';
        oppty.Customer_Satisfaction_Survey_Contact__c = cId;
        oppty.Contact__c = cId;
        oppty.AFSM_Lookup__c = userinfo.getuserid();
        
        insert oppty;
        return oppty;
    }
         public static Opportunity instantiateOpportunity6(String acntId, String acId,String equipId, String plId, String st2Id, String cId){
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id newOppId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
        
        Opportunity oppty = new Opportunity();
        oppty.Input_Date_Accuracy__c = 'Firm';
        oppty.Operator__c = 'FAA Part 135';
        oppty.RecordTypeId = newOppId;
        oppty.RSM__c = 'Campbell,Tom';
        oppty.Name = 'trigger test';
        oppty.Opportunity_Name_Details__c = 'trigger test';
        oppty.StageName = 'New Opportunity';
        oppty.AccountId = acntId;
        oppty.Aircraft__c = acId;
        oppty.Amount = decimal.valueof('1471620');
        oppty.Equipment__c = equipId;
        oppty.CustomerName__c = 'World Jet, Inc.';
        oppty.Facility__c = 'AGS';
        oppty.Tier_Level__c = '1';
        oppty.CloseDate =  Date.today() +30;
        oppty.InputDate__c =  Date.today();
        oppty.OutputDate__c =  Date.today();
        oppty.Product_Line__c = plId;
        oppty.Type = 'Paint';
        oppty.SubType__c = 'Cabin Broadband';
        oppty.SubType2__c = st2Id;
        oppty.LeadSource = 'CPM';
        oppty.QuoteDelivery__c = 'Hand Delivery';
        oppty.QuoteRequiredBy__c =  Date.today();
        oppty.Base_Quote_Number__c = '1';
        oppty.QuotedDate__c =  Date.today();
        oppty.Concession1__c = 'None';
        oppty.Agent_Representative__c = 'Not Applicable';
        oppty.Master_Opportunity__c = False;
        oppty.Competitor__c = 'Harrods Aviation';
        oppty.WinorLossReason1__c = 'Location';
        oppty.Win_Loss_Description__c = 'Test';
        oppty.Customer_Satisfaction_Survey_Contact__c = cId;
        oppty.Contact__c = cId;
        oppty.AFSM_Lookup__c = userinfo.getuserid();
        
        insert oppty;
        return oppty;
    }
    public static SBQQ__Quote__c instantiateQuote(string portalAccountId,string acId,string projId ){
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c( 
            RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId(),
            Labor_Type1__c = 'Airframe',
            SBQQ__Status__c = 'Presented',
            SBQQ__Account__c = portalAccountId,
            Aircraft__c = acId,
            Facility1__c = 'AGS',
            Project__c = projId);
        return quote;
    }
    
    public static SBQQ__QuoteLine__c instantiateQuoteline(string projId,string ProdId,string quoteid){
        SBQQ__QuoteLine__c quoteline = new SBQQ__QuoteLine__c();
        quoteline.Project__c = projId;
        quoteline.SBQQ__Product__c = prodId;
        quoteline.Job_Card_Description__c = 'Test Squawk1';
        quoteline.SBQQ__Quote__c = quoteid;
        insert quoteline;
        return quoteline;
    }
    
    public static SBQQ__QuoteDocument__c  instantiateQuoteSDocument (string projId,string quoteId){
        SBQQ__QuoteDocument__c qd = new SBQQ__QuoteDocument__c();
        qd.Name = 'Test Document';
        qd.Project_On_Quote__c = projId;
        qd.SBQQ__Quote__c = quoteId;
        qd.SBQQ__Version__c = 1;
        qd.SBQQ__Template__c = 'Squawks Template';
        qd.SBQQ__OutputFormat__c = 'PDF';
        insert qd;
        return qd;
    }
    
    public static MPM4_BASE__Milestone1_Project__c instantiateProject(string portalAccountId,
                                                                      string opptyId,string acId,
                                                                      string equipId,date opptyInputDate,
                                                                      date opptyOutputDate,string userinfo,
                                                                      string portalUser1Id,
                                                                      string portalUser2Id,
                                                                      string portalUser3Id,
                                                                      string portalUser4Id,
                                                                      string portalUser5Id,
                                                                      string portalUser6Id,
                                                                      string u3id){
                                                                          MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c();
                                                                          proj.Name = 'Project Test';
                                                                          proj.MPM4_BASE__Account__c = portalAccountId;
                                                                          proj.Opportunity__c = opptyId;
                                                                          proj.Aircraft__c = acId;
                                                                          proj.Engine__c = equipId;
                                                                          proj.Input_Date__c = opptyInputDate;
                                                                          proj.Delivery_Date__c = opptyOutputDate;
                                                                          proj.MPM4_BASE__Kickoff__c = opptyInputDate;
                                                                          proj.MPM4_BASE__Deadline__c = opptyOutputDate;
                                                                          proj.CPM__c = userInfo;
                                                                          proj.Designated_Approver__c = portalUser1Id;
                                                                          proj.Secondary_Approver__c = portalUser2Id;
                                                                          proj.X3_Approver__c = portalUser3Id;
                                                                          proj.X4_Approver__c = portalUser4Id;
                                                                          proj.X5_Approver__c = portalUser5Id;
                                                                          proj.X6_Approver__c = portalUser6Id; 
                                                                          proj.BackupCPM__c = u3id;
                                                                          proj.MPM4_BASE__Status__c = 'Active';             
                                                                          insert proj;
                                                                          return proj;
                                                                      }
    
    public static product2 createProduct(){
        Product2 prod = new Product2(
            Name = 'Unscheduled Product',
            ProductCode = 'Code1',
            isActive = True,
            SBQQ__Specifications__c = 'Test Data'
        );
        
        insert prod;
        return prod;
    }
    
    public static product2 createProductChild(){
        Product2 prodChild = new Product2(
            Name = 'AdHoc Material',
            ProductCode = 'Code1',
            isActive = True,
            SBQQ__Specifications__c = 'Test Data'
        );
        
        insert prodChild;
        return prodChild;
    }
   
    
    public static ContentDocumentLink createContentDocLink(string quoteId){
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = quoteid;
        //cdl.ContentDocumentId = documents0Id;
        cdl.shareType = 'V';
        insert cdl;
        return cdl;
    }
    
}