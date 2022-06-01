@isTest
public class GetRecordLockStatus_Test {

    @isTest
    public static void createLockedRecordTest() {

        Product_Line__c pl = TestDataGenerator.createProductLine();      
        Account acc = TestDataGenerator.createAccount();
        Aircraft__c arc = TestDataGenerator.createAircraft(pl.id, acc.id);
        Equipment__c eqp = TestDataGenerator.createEquipment(pl.id, acc.id, arc.id);
        Sub_Type_2__c st2 = TestDataGenerator.createSubType2(pl.id);
        Contact con = TestDataGenerator.createContact(acc.Id);
        
        Opportunity opp = TestDataGenerator.instantiateOpportunity(acc.Id, arc.Id, eqp.Id, pl.Id, st2.Id, con.Id);

        List<Opportunity> oppList = [Select Id from Opportunity];
        List<String> recordIds = new List<String>();
        
        For(Opportunity o : oppList){
            recordIds.add(o.Id);
        }
        
        system.debug('Opportunity Id: ' + opp.Id);
        Approval.lock(opp.Id);
              
        GetRecordLockStatus.GetRecordStatus(recordIds);
   
    }
    
}