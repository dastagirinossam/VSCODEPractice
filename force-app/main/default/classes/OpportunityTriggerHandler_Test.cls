@isTest
public class OpportunityTriggerHandler_Test{
    @testSetup 
    static void setup(){
        
        Product_Line__c pl = TestDataGenerator.createProductLine();
        Probability_Grouping__c pg = TestDataGenerator.createProbabilityGrouping();
        Facility__c fac = TestDataGenerator.createFacility();
        Account acc = TestDataGenerator.createAccount();
        Aircraft__c arc = TestDataGenerator.createAircraft(pl.id, acc.id);
        Equipment__c eqp = TestDataGenerator.createEquipment(pl.id, acc.id, arc.id);
        Sub_Type_2__c st2 = TestDataGenerator.createSubType2(pl.id);
        Contact con = TestDataGenerator.createContact(acc.Id);
        
        Opportunity masterOpp = TestDataGenerator.createMasterOpportunity(acc.Id, arc.Id, eqp.Id, pl.Id, st2.Id, con.Id);
        List<Opportunity> ao = TestDataGenerator.associatedOpportunities(acc.Id, arc.Id, eqp.Id, pl.Id, st2.Id, con.Id, masterOpp.Id);            
    }
    
    static testMethod void ChangeFacility() {
        test.startTest();
        Opportunity mo = [SELECT Id, Associated_Opportunity_01__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        
        system.debug('Opportunities: ' + myOpp.Name);
        
        myOpp.Probability = 82;
        myOpp.Facility__c = 'AGS';
        
        update myOpp;
        test.stopTest();
        
        Opportunity Opp = [SELECT Id, Probability FROM Opportunity where Id =: myOpp.Id];
        System.assertEquals(82, Opp.Probability);
    }
    
    static testMethod void testOpportunityTriggers_UpdateOpenOverride() {
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_01__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        myOpp.Probability = 21;
        myOpp.Probability_To_Use__c = 57;
        myOpp.Probability_Grouping_Override__c = True;
        
        update myOpp;
        test.stopTest();
        
        Opportunity Opp = [SELECT Id, Probability, Probability_To_Use__c FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        System.assertEquals(21, Opp.Probability);
        System.assertEquals(57, Opp.Probability_To_Use__c);
    }
    
    static testMethod void testOpportunityTriggers_UpdateWon() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('RFS').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_01__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'RFS';
        myOpp.Probability_To_Use__c = 82;
        myOpp.Probability_Grouping_Override__c = True;
        
        update myOpp;
        test.stopTest();
        
        Opportunity Opp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        System.assertEquals(100, Opp.Probability);
    }
    
    //RFS Master
    static testMethod void testOpportunityTriggers_UpdateMaster_RFS() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('RFS').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, StageName, RecordTypeId, Associated_Opportunity_01__c, Associated_Opportunity_02__c,
                          Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c,
                          Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c
                          FROM Opportunity where Master_Opportunity__c = true];
        mo.RecordTypeId = rtId;
        mo.StageName = 'RFS';
        
        update mo;
        test.stopTest();
        
        Opportunity Opp = [SELECT Id, StageName, RecordTypeId, Associated_Opportunity_01__r.StageName,Associated_Opportunity_02__r.StageName,
                           Associated_Opportunity_03__r.StageName,Associated_Opportunity_04__r.StageName,Associated_Opportunity_05__r.StageName,
                           Associated_Opportunity_06__r.StageName,Associated_Opportunity_07__r.StageName,Associated_Opportunity_08__r.StageName 
                           FROM Opportunity where Master_Opportunity__c= true];
        
        System.assertEquals('RFS', Opp.Associated_Opportunity_01__r.StageName);
        System.assertEquals('RFS', Opp.Associated_Opportunity_02__r.StageName);
        System.assertEquals('RFS', Opp.Associated_Opportunity_03__r.StageName);
        System.assertEquals('RFS', Opp.Associated_Opportunity_04__r.StageName);
        System.assertEquals('RFS', Opp.Associated_Opportunity_05__r.StageName);
        System.assertEquals('RFS', Opp.Associated_Opportunity_06__r.StageName);
        System.assertEquals('RFS', Opp.Associated_Opportunity_07__r.StageName);
        System.assertEquals('RFS', Opp.Associated_Opportunity_08__r.StageName);
    }
    
    //LD Master
    static testMethod void testOpportunityTriggers_UpdateMaster_LossDebrief() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Loss Debrief').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, StageName, RecordTypeId, Associated_Opportunity_01__c, Associated_Opportunity_02__c,
                          Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c,
                          Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c
                          FROM Opportunity where Master_Opportunity__c = true];
        mo.RecordTypeId = rtId;
        mo.StageName = 'Loss Debrief';
        
        update mo;
        test.stopTest();
        
        Opportunity Opp = [SELECT Id, StageName, RecordTypeId, Associated_Opportunity_01__r.StageName,Associated_Opportunity_02__r.StageName,
                           Associated_Opportunity_03__r.StageName,Associated_Opportunity_04__r.StageName,Associated_Opportunity_05__r.StageName,
                           Associated_Opportunity_06__r.StageName,Associated_Opportunity_07__r.StageName,Associated_Opportunity_08__r.StageName 
                           FROM Opportunity where Master_Opportunity__c= true];
        
        System.assertEquals('Loss Debrief', Opp.Associated_Opportunity_01__r.StageName);
        System.assertEquals('Loss Debrief', Opp.Associated_Opportunity_02__r.StageName);
        System.assertEquals('Loss Debrief', Opp.Associated_Opportunity_03__r.StageName);
        System.assertEquals('Loss Debrief', Opp.Associated_Opportunity_04__r.StageName);
        System.assertEquals('Loss Debrief', Opp.Associated_Opportunity_05__r.StageName);
        System.assertEquals('Loss Debrief', Opp.Associated_Opportunity_06__r.StageName);
        System.assertEquals('Loss Debrief', Opp.Associated_Opportunity_07__r.StageName);
        System.assertEquals('Loss Debrief', Opp.Associated_Opportunity_08__r.StageName);
    }
    
    //Cancelled Master
    static testMethod void testOpportunityTriggers_UpdateMaster_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, StageName, RecordTypeId, Associated_Opportunity_01__c, Associated_Opportunity_02__c,
                          Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c,
                          Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c
                          FROM Opportunity where Master_Opportunity__c = true];
        mo.RecordTypeId = rtId;
        mo.StageName = 'Cancelled';
        
        update mo;
        test.stopTest();
        
        Opportunity Opp = [SELECT Id, StageName, RecordTypeId, Associated_Opportunity_01__r.StageName,Associated_Opportunity_02__r.StageName,
                           Associated_Opportunity_03__r.StageName,Associated_Opportunity_04__r.StageName,Associated_Opportunity_05__r.StageName,
                           Associated_Opportunity_06__r.StageName,Associated_Opportunity_07__r.StageName,Associated_Opportunity_08__r.StageName 
                           FROM Opportunity where Master_Opportunity__c= true];
        
        System.assertEquals('Cancelled', Opp.Associated_Opportunity_01__r.StageName);
        System.assertEquals('Cancelled', Opp.Associated_Opportunity_02__r.StageName);
        System.assertEquals('Cancelled', Opp.Associated_Opportunity_03__r.StageName);
        System.assertEquals('Cancelled', Opp.Associated_Opportunity_04__r.StageName);
        System.assertEquals('Cancelled', Opp.Associated_Opportunity_05__r.StageName);
        System.assertEquals('Cancelled', Opp.Associated_Opportunity_06__r.StageName);
        System.assertEquals('Cancelled', Opp.Associated_Opportunity_07__r.StageName);
        System.assertEquals('Cancelled', Opp.Associated_Opportunity_08__r.StageName);
    }
    
    static testMethod void testOpportunityTriggers_UpdateWonNoOverride(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('RFS').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_01__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'RFS';
        myOpp.Probability_To_Use__c = 82;
        
        update myOpp;
        test.stopTest();
        
        Opportunity Opp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        System.assertEquals(100, Opp.Probability);
    }
    
    static testMethod void testOpportunityTriggers_UpdateLoss() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_01__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, RecordTypeId, StageName, Name, Probability, Probability_To_Use__c,Probability_Grouping_Override__c FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
        myOpp.Probability_To_Use__c = 82;
        myOpp.Probability_Grouping_Override__c = True;
        
        update myOpp;
        test.stopTest();
        
        Opportunity Opp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        System.assertEquals(0, Opp.Probability);
    }
    
    static testMethod void testOpportunityTriggers_UpdateLossNoOverride() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        Opportunity mo = [SELECT Id, Associated_Opportunity_01__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
        myOpp.Probability_To_Use__c = 82;
        
        update myOpp;
        test.stopTest();
        
        Opportunity Opp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        System.assertEquals(0, Opp.Probability);
        
    }  
    
    static testMethod void testOpportunityTriggers_AO_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_01__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
        update myOpp;
        
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name FROM Opportunity where Master_Opportunity__c = True];       
        
        System.assertEquals(null, oppty.Associated_Opportunity_01__c );        
        
        test.stopTest();
    }
    
    static testMethod void testOpportunityTriggers_AO1_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_01__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
        update myOpp;
        
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       
        
        System.assertEquals(null, oppty.Associated_Opportunity_01__c );        
        
        test.stopTest();
    }
    
    static testMethod void testOpportunityTriggers_AO2_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_02__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_02__c];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
        update myOpp;
        
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       
        
        System.assertEquals(null, oppty.Associated_Opportunity_02__c );        
        
        test.stopTest();
    }
    
    static testMethod void testOpportunityTriggers_AO3_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_03__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_03__c];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
        update myOpp;
        
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       
        
        System.assertEquals(null, oppty.Associated_Opportunity_03__c );        
        
        test.stopTest();
    }
    
    static testMethod void testOpportunityTriggers_AO4_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_04__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_04__c];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
        update myOpp;
        
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       
        
        System.assertEquals(null, oppty.Associated_Opportunity_04__c );        
        
        test.stopTest();
    }
    
    static testMethod void testOpportunityTriggers_AO5_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_05__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_05__c];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
        update myOpp;
        
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       
        
        System.assertEquals(null, oppty.Associated_Opportunity_05__c );        
        
        test.stopTest();
    }
    
    static testMethod void testOpportunityTriggers_AO6_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_06__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity myOpp = [SELECT Id, Name, Probability FROM Opportunity where Id =: mo.Associated_Opportunity_06__c];
        
        myOpp.RecordTypeId = rtId;
        myOpp.StageName = 'Cancelled';
        update myOpp;
        
        Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];       
        
        System.assertEquals(null, oppty.Associated_Opportunity_06__c );        
        
        test.stopTest();
    }
    
    static testMethod void testOpportunityTriggers_AO7_Cancel() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('Cancelled').getRecordTypeId();
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_07__c FROM Opportunity where Master_Opportunity__c= true];
        List<Opportunity> myOpp = [SELECT Id, MasterOpportunitylookup__r.Name, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c FROM Opportunity where Id =: mo.Associated_Opportunity_07__c];
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
        
        //Opportunity oppty = [SELECT Id, Oppty_Trigger_Update__c, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where Master_Opportunity__c = True];     
        List<Opportunity> assocOppsList = [SELECT Id, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name FROM Opportunity where Id In: assocOpps];
        List<Opportunity> myOp = [SELECT Id, MasterOpportunitylookup__r.Name, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c FROM Opportunity where id =: mo.Associated_Opportunity_07__c];
        
        System.assertEquals(null, myOp[0].MasterOpportunitylookup__c); 
        System.assertEquals(null, myOp[0].Associated_Opportunity_01__c ); 
        System.assertEquals(null, myOp[0].Associated_Opportunity_02__c ); 
        System.assertEquals(null, myOp[0].Associated_Opportunity_03__c ); 
        System.assertEquals(null, myOp[0].Associated_Opportunity_04__c ); 
        System.assertEquals(null, myOp[0].Associated_Opportunity_05__c ); 
        System.assertEquals(null, myOp[0].Associated_Opportunity_06__c ); 
        System.assertEquals(null, myOp[0].Associated_Opportunity_07__c ); 
        
        //System.assertEquals(null, oppty.Associated_Opportunity_08__c ); 
        
        test.stopTest();
        
    }
    
    static testMethod void testOpportunityTrigger_AO() {      
        
        test.startTest();
        
        Opportunity oppty = [SELECT Id, Associated_Opportunity_01__c, Associated_Opportunity_02__c, Associated_Opportunity_03__c, Associated_Opportunity_04__c, Associated_Opportunity_05__c, Associated_Opportunity_06__c, Associated_Opportunity_07__c, Associated_Opportunity_08__c FROM Opportunity where Master_Opportunity__c = True];       
        
        oppty.Associated_Opportunity_01__c = null;
        update oppty;
        
        Opportunity oppty1 = [SELECT Id, Associated_Opportunity_01__r.Name, Associated_Opportunity_02__r.Name, Associated_Opportunity_03__r.Name, Associated_Opportunity_04__r.Name, Associated_Opportunity_05__r.Name, Associated_Opportunity_06__r.Name, Associated_Opportunity_07__r.Name, Associated_Opportunity_08__r.Name FROM Opportunity where id =: oppty.Id];       
        
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
        
        system.debug('Opportunity AO2 Name: ' + oppty2.Associated_Opportunity_02__r.Name);
        
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
    
    static testMethod void testOpportunityTrigger_Master_RFQassigned() {  
        
        test.startTest();
        
        Opportunity oppty = [SELECT Id FROM Opportunity where Master_Opportunity__c = True];       
        
        oppty.StageName = 'RFQ Assigned';
        update oppty;
        
        Opportunity oppty1 = [SELECT Id, Associated_Opportunity_01__r.StageName, Associated_Opportunity_02__r.StageName, Associated_Opportunity_03__r.StageName, Associated_Opportunity_04__r.StageName, Associated_Opportunity_05__r.StageName, Associated_Opportunity_06__r.StageName, Associated_Opportunity_07__r.StageName, Associated_Opportunity_08__r.StageName FROM Opportunity where Id =: oppty.Id];       
        
        //System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_01__r.StageName);        
        System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_02__r.StageName);
        System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_03__r.StageName);
        System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_04__r.StageName);
        System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_05__r.StageName);
        System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_06__r.StageName);
        System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_07__r.StageName);
        System.assertEquals('RFQ Assigned', oppty1.Associated_Opportunity_08__r.StageName);  
        test.stopTest();
    }
    
    static testMethod void testOpportunityTrigger_Master_RFQ_OpertaionsReview() {  
        
        test.startTest();
        
        Opportunity oppty = [SELECT Id FROM Opportunity where Master_Opportunity__c = True];       
        
        oppty.StageName = 'RFQ - Operations Review';
        update oppty;
        
        Opportunity oppty1 = [SELECT Id, Associated_Opportunity_01__r.StageName, Associated_Opportunity_02__r.StageName, Associated_Opportunity_03__r.StageName, Associated_Opportunity_04__r.StageName, Associated_Opportunity_05__r.StageName, Associated_Opportunity_06__r.StageName, Associated_Opportunity_07__r.StageName, Associated_Opportunity_08__r.StageName FROM Opportunity where Id =: oppty.Id];       
        
        //System.assertEquals('RFQ - Operations Review', oppty1.Associated_Opportunity_01__r.StageName);        
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
        Opportunity mo = [SELECT Id, Associated_Opportunity_01__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity oppty = [SELECT Id, MasterOpportunitylookup__c FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];        
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
        Opportunity mo = [SELECT Id, Associated_Opportunity_01__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity oppty = [SELECT Id, MasterOpportunitylookup__c FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];       
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
    
    static testMethod void testOpportunityTrigger_Master_RFQ_Submitted() {  
        
        test.startTest();
        
        Opportunity oppty = [SELECT Id FROM Opportunity where Master_Opportunity__c = True];       
        
        oppty.StageName = 'RFQ Submitted';
        update oppty;
        
        Opportunity oppty1 = [SELECT Id, Associated_Opportunity_01__r.StageName, Associated_Opportunity_02__r.StageName, Associated_Opportunity_03__r.StageName, Associated_Opportunity_04__r.StageName, Associated_Opportunity_05__r.StageName, Associated_Opportunity_06__r.StageName, Associated_Opportunity_07__r.StageName, Associated_Opportunity_08__r.StageName FROM Opportunity where Id =: oppty.Id];       
        
        //System.assertEquals('RFQ Submitted', oppty1.Associated_Opportunity_01__r.StageName);        
        System.assertEquals('RFQ Submitted', oppty1.Associated_Opportunity_02__r.StageName);
        System.assertEquals('RFQ Submitted', oppty1.Associated_Opportunity_03__r.StageName);
        System.assertEquals('RFQ Submitted', oppty1.Associated_Opportunity_04__r.StageName);
        System.assertEquals('RFQ Submitted', oppty1.Associated_Opportunity_05__r.StageName);
        System.assertEquals('RFQ Submitted', oppty1.Associated_Opportunity_06__r.StageName);
        System.assertEquals('RFQ Submitted', oppty1.Associated_Opportunity_07__r.StageName);
        System.assertEquals('RFQ Submitted', oppty1.Associated_Opportunity_08__r.StageName);  
        test.stopTest();
    }
    
    //RFS Stage Change
    static testMethod void testOpportunityTriggerRFS_AO_Master() {  
        
        test.startTest();
        
        Opportunity mo = [SELECT Id, Associated_Opportunity_01__c FROM Opportunity where Master_Opportunity__c= true];
        Opportunity oppty = [SELECT Id, MasterOpportunitylookup__c FROM Opportunity where Id =: mo.Associated_Opportunity_01__c];       
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
    
    private static testMethod void crec() {
        CheckRecursive.runAfterOnce();
        CheckRecursive.runBeforeInsertOnce();
        CheckRecursive.runBeforeUpdateOnce();
    }
}