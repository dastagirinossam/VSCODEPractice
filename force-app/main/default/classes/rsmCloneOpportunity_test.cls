@istest
public class rsmCloneOpportunity_test {
    
    @testSetup
    public static void method1(){

        Product_Line__c prodLine = TestDataGenerator.createProductLine();
        Account acnt = TestDataGenerator.createAccount();
        Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, acnt.Id);
        Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, acnt.Id, ac.Id);           
        Contact c = TestDataGenerator.createContact(acnt.Id);
        Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
        Opportunity oppty = TestDataGenerator.instantiateOpportunity(acnt.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
        
    }
    
    static testMethod void rsmCloneOpportunity_opportunity() { 
        Test.startTest();
        
        Opportunity o = [Select Id from Opportunity];
        
        rsmCloneOpportunity.getDetailsFromOpp(o.Id);
        rsmCloneOpportunity.getFacility();
        rsmCloneOpportunity.getOppRecordTypes();
                  
        Test.stopTest();
    }
    
    static testMethod void rsmCloneOpportunity_airframe() {
        Test.startTest();
        
        Opportunity o = [Select Id from Opportunity];
        Aircraft__c ac = [Select Id from Aircraft__c limit 1];
        
        String kw = 'CHA.300';
        
        rsmCloneOpportunity.accountAircraft(o.Id);
        rsmCloneOpportunity.aircraftEquipment(o.Id);
        rsmCloneOpportunity.aircraftEquipmentChange(ac.Id);
        rsmCloneOpportunity.fetchAircraft(kw);
        rsmCloneOpportunity.getOppAircraft(o.Id);
        
        Test.stopTest();
    }
    
    static testMethod void rsmCloneOpportunity_engine() {
        Test.startTest();
        
        Opportunity o = [Select Id from Opportunity];
        
        String kw = 'NA';
        
        rsmCloneOpportunity.fetchEquipment(kw);
        //rsmCloneOpportunity.getOppEquipment(o.Id);
                
        Test.stopTest();
    }
    
    static testMethod void rsmCloneOpportunity_st2() { 
        Test.startTest();
        
        Opportunity o = [Select Id, Product_Line__c, SubType__c from Opportunity];
        
        String kw = '1500';
        
        rsmCloneOpportunity.getOppSubType2(o.Id);
        rsmCloneOpportunity.getSubType2(o.Product_Line__c, o.SubType__c);
        rsmCloneOpportunity.SubType2List(o.Id);
        rsmCloneOpportunity.fetchSubType2(kw, o.Product_Line__c, o.SubType__c);
        
        Test.stopTest();
    }    
}