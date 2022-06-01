@isTest
public class testAircraftTriggers{  
    
    @testSetup 
    static void CreateAccounts(){
        
        //Create Product Line
        Product_Line__c prodLine = new Product_Line__c(
            Product_Line_Family__c = 'Aircraft',
            Name = 'new',
            SFDC_Name_Prefix__c = 'F7X.'
        );
        insert prodLine;
        
        //Create Account
        Account acnt = new Account();
        acnt.Name = 'test name';
        acnt.BillingStreet = '1600 Amphitheatre Parkway';
        acnt.BillingCity = 'Mountain View';
        acnt.BillingState = 'CA';
        acnt.BillingPostalCode = '94043';
        acnt.BillingCountry = 'United States';
        insert acnt;
                
        Account acnt1 = new Account();
        acnt1.Name = 'test name2';
        acnt1.BillingStreet = '1600 Amphitheatre Parkway';
        acnt1.BillingCity = 'Mountain View';
        acnt1.BillingState = 'CA';
        acnt1.BillingPostalCode = '94043';
        acnt1.BillingCountry = 'United States';
        insert acnt1;
               
        //Create Aircraft        
        Aircraft__c ac = new Aircraft__c();
        ac.Name = 'NA';
        ac.Product_Line__c = prodLine.Id;
        ac.Account__c = acnt.Id;
        ac.aircraft_make__c = 'NA'; 
        ac.aircraft_model_2011__c = 'NA';
        ac.aircraft_SN__c = 'NA';  
        ac.Aircraft_Type__c = 'Aircraft';
        insert ac;
        
        //Create Engine
        Equipment__c equip = new Equipment__c(
            Product_Line__c = prodLine.Id,
            Account__c = acnt.id,
            Aircraft__c = ac.Id,
            Equipment_Prefix__c = 'HTF',
            EngineorAPUSN__c = '123',
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'HTF7000'
        );
        insert equip;
        
        //Create Engine
        Equipment__c equip2 = new Equipment__c(
            Product_Line__c = prodLine.Id,
            Account__c = acnt.id,
            Aircraft__c = ac.Id,
            Equipment_Prefix__c = 'HTF',
            EngineorAPUSN__c = '234',
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'HTF7000'
        );
        insert equip2;
        
        //Create Engine
        Equipment__c equip3 = new Equipment__c(
            Product_Line__c = prodLine.Id,
            Account__c = acnt.id,
            Aircraft__c = ac.Id,
            Equipment_Prefix__c = 'HTF',
            EngineorAPUSN__c = '345',
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'HTF7000'
        );
        insert equip3;
        
        //Create Engine
        Equipment__c equip4 = new Equipment__c(
            Product_Line__c = prodLine.Id,
            Account__c = acnt.id,
            Aircraft__c = ac.Id,
            Equipment_Prefix__c = 'HTF',
            EngineorAPUSN__c = '456',
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'HTF7000'
        );
        insert equip4;
        
        //Create Engine
        Equipment__c equip5 = new Equipment__c(
            Product_Line__c = prodLine.Id,
            Account__c = acnt.id,
            Equipment_Prefix__c = 'HTF',
            EngineorAPUSN__c = '789',
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'HTF7000'
        );
        insert equip5;
        
        //Create apu
        Equipment__c APU = new Equipment__c(
            Product_Line__c = prodLine.Id,
            Account__c = acnt.id,
            Aircraft__c = ac.Id,
            Equipment_Prefix__c = 'APU',
            EngineorAPUSN__c = '123',
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'GTCP36-150F2M'
        );
        insert APU;
        
        //Create contact
        Contact contact = new Contact(
            AccountId = acnt.Id,
            FirstName = 'Test',
            Lastname = 'McTesty',
            ContactType__c = 'Primary Contact',
            Do_Not_Survey_Customer_Satisfaction__c = true               
        );
        insert contact;
        
        Contact contact2 = new Contact(
            AccountId = acnt1.Id,
            FirstName = 'Test2',
            Lastname = 'McTesty',
            ContactType__c = 'Primary Contact',
            Do_Not_Survey_Customer_Satisfaction__c = true               
        );
        insert contact2;
    }
    
    static testMethod void testPrefixName(){
        test.startTest();
        Product_Line__c prodLine = [select Id from Product_Line__c];
        Account acnt = [Select Id from Account where Name =: 'test name'];        
        Aircraft__c ac = new Aircraft__c();
        ac.Account__c = acnt.Id;
        ac.aircraft_make__c = 'FALCON'; 
        ac.aircraft_model_2011__c = 'FALCON 7X';
        ac.aircraft_SN__c = '123456789'; 
        ac.Product_Line__c = prodLine.Id;
        ac.Aircraft_Type__c = 'Aircraft';
        ac.Name = 'test';
        insert ac;
        
        Aircraft__c ac1 = [Select Name from Aircraft__c where Id =: ac.Id];
        
        System.assertEquals('F7X.123456789',ac1.name);
        test.stopTest();
    }
    
    static testMethod void testAircraftEngines(){ 
        test.startTest();
        Product_Line__c prodline = [select Id from Product_Line__c];
        Account acnt = [Select Id from Account where name =: 'test name'];
        Account acnt2 = [Select Id from Account where name =: 'test name2'];
        
        Aircraft__c ac = new Aircraft__c();
        ac.Product_Line__c = prodLine.id;
        ac.Account__c= acnt.Id;
        ac.Aircraft_Type__c= 'Aircraft';
        ac.aircraft_make__c = 'Falcon'; 
        ac.aircraft_model_2011__c = 'FALCON 7X';
        ac.aircraft_SN__c = '123456789';
        ac.Name = 'test';
        insert ac;
        
        List<Equipment__c> eqList = [Select Id, Aircraft__c from Equipment__c Order By Name asc];
        List<Equipment__c> equipList = new List<Equipment__c>();
        for(Equipment__c equip : eqList){
            equip.Aircraft__c = ac.Id;
            equipList.add(equip);
        }
        update equipList;
        
        Aircraft__c ac1 = [Select Id from Aircraft__c where Id =: ac.Id];
        ac1.account__c = acnt2.id;
        
        update ac1;  
        
        Aircraft__c ac2 = [Select Id, APU__c, Engine_1__c, Engine_2__c, Engine_3__c, Engine_4__c from Aircraft__c where Id =: ac.Id];
        
        System.assertEquals(eqList[1].id, ac2.Engine_1__c);
        System.assertEquals(eqList[2].id, ac2.Engine_2__c);
        System.assertEquals(eqList[3].id, ac2.Engine_3__c);
        System.assertEquals(eqList[4].id, ac2.Engine_4__c);
        System.assertEquals(eqList[0].Id, ac2.APU__c);
        test.stopTest();        
    }
    
    static testMethod void testAircraftNoEngines(){
        test.startTest();
        Account acnt = [Select Id from Account where name =: 'test name'];
        Product_Line__c prodLine = [select Id from Product_Line__c];        
        Aircraft__c ac = new Aircraft__c();
        ac.Account__c= acnt.Id;
        ac.Aircraft_Type__c= 'Aircraft';
        ac.aircraft_make__c = 'Falcon'; 
        ac.aircraft_model_2011__c = 'FALCON 7X';
        ac.aircraft_SN__c = '123456789';
        ac.Name = 'test';
        ac.Product_Line__c = prodLine.Id;
        insert ac;
        
        Aircraft__c ac1 = [Select Id, Name from Aircraft__c where Id =: ac.Id];
        update ac1; 
        test.stopTest();
    }
    
    static testMethod void testContactAccountChange(){
        test.startTest();
        
        Account acnt = [Select Id from Account where name =: 'test name'];
        Contact c = [Select Id from Contact where FirstName =: 'Test2'];    
		c.AccountId = acnt.Id;
        update c;

        test.stopTest();
    }
    
}