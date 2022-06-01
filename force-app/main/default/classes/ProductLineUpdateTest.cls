@isTest
public class ProductLineUpdateTest {

    @testSetup 
    static void CreateAccounts(){

		//Create Product Line
        Product_Line__c prodLine = new Product_Line__c(
        	Product_Line_Family__c = 'Aircraft',
            Name = 'new Aircraft'
        );
        insert prodLine;
        
        Product_Line__c prodLine2 = new Product_Line__c(
        	Product_Line_Family__c = 'Engine',
            Name = 'new Engine'
        );
        insert prodLine2;
        
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
        
        //Create Engine
        Equipment__c equip = new Equipment__c(
            Product_Line__c = prodLine.Id,
            Account__c = acnt.id,
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
            Equipment_Prefix__c = 'HTF',
            EngineorAPUSN__c = '456',
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'HTF7000'
        );
        insert equip4;
        
        //Create apu
        Equipment__c APU = new Equipment__c(
            Product_Line__c = prodLine.Id,
            Account__c = acnt.id,
            Equipment_Prefix__c = 'APU',
            EngineorAPUSN__c = '123',
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'GTCP36-150F2M'
        );
        insert APU;
    }
       
    static testMethod void testProductLineUpdateAircraft(){
        List<Product_Line__c> pl = [Select Id from Product_Line__c where Product_Line_Family__c = 'Aircraft'];
        List<Id> plId = new List<Id>();
        For(Product_Line__c p:pl){
            plId.add(p.Id);
        }
        
        Test.startTest();
		ProductLineUpdate.ProductLineUpdate(plId);
		Test.stopTest();
    }
    
	static testMethod void testProductLineUpdateEngine(){
        List<Product_Line__c> pl = [Select Id from Product_Line__c where Product_Line_Family__c = 'Engine'];
        List<Id> plId = new List<Id>();
        For(Product_Line__c p:pl){
            plId.add(p.Id);
        }
        
        Test.startTest();
		ProductLineUpdate.ProductLineUpdate(plId);
		Test.stopTest();
    } 
}