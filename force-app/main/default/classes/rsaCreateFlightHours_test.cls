@isTest
public class rsaCreateFlightHours_test {
    
   @testSetup
    static void setup(){
        
        //Create Product Line
        Product_Line__c prodLine = new Product_Line__c(
            Product_Line_Family__c = 'Aircraft',
            Name = 'new'
        );
        insert prodLine;
        
        //Create Account
        Account portalAccount = new Account();
        portalAccount.Name = 'test name 123456789';
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
        ac.Aircraft_Type__c = 'Aircraft';
        ac.Aircraft_Status__c = 'In-Operation';
        ac.OwnerId = UserInfo.getUserId();
        insert ac;
        
        //Create Engine
        Equipment__c equip = new Equipment__c(
            Product_Line__c = prodLine.Id,
            Account__c = portalAccount.id,
            Equipment_Prefix__c = 'TFE',
            EngineorAPUSN__c = 'ABC',
            Aircraft__c = ac.Id,
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'HTF7000'
        );
        insert equip;
    }
           
    //Test Equipment
    private static testmethod void engineFlightHour(){  
        test.startTest();
        Equipment__c equip = [Select Id from Equipment__c];
        
        rsaCreateFlightHours.eqFlightHours(equip.Id);
        
        Test.stopTest();          
    }
    
    //Test Aircraft
    private static testmethod void aircraftFlightHour(){  
        test.startTest();
        Aircraft__c ac = [Select Id from Aircraft__c];
        
        rsaCreateFlightHours.acFlightHours(ac.Id);
        
        Test.stopTest();          
    }

}