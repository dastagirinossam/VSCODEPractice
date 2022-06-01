@isTest
public class TestProcessBuilderApexClass {
    
    static testMethod void pardotReachedDate(){                
        //Create Account
        Account portalAccount = TestDataGenerator.createAccount();
        Product_Line__c prodLine = TestDataGenerator.createProductLine();
        Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
        Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id); 
        Contact c = TestDataGenerator.createContact(portalAccount.Id);
        
        Opportunity oppt = new Opportunity(Name ='New mAWS Deal',
                                           Aircraft__c = ac.Id,
                                           Equipment__c = equip.Id,
                                           RSM__c = 'Account unassigned',
                                           Type = 'TFE731',
                                           Facility__c = 'AGS',
                                           Tier_Level__c = '1',
                                           contact__c = c.id,                 
                                           Operator__c= 'FAA Part 91',
                                           SubType__c = 'TFE731',
                                           InputDate__c = System.today(),
                                           OutputDate__c = System.today(),
                                           AccountId = portalAccount.ID,
                                           StageName = 'Customer Won',
                                           Amount = 3000,
                                           CloseDate =System.today()+30,
                                           Opportunity_Name_Details__c ='asdfsddfggfhfghfgh'
                                          );        
        
        Opportunity oppt2 = new Opportunity(Name ='New mAWS Deal',
                                            Aircraft__c = ac.Id,
                                            Equipment__c = equip.Id,
                                            RSM__c = 'Account unassigned',
                                            Type = 'TFE731',
                                            Facility__c = 'AGS',
                                            Tier_Level__c = '1',
                                            Operator__c= 'FAA Part 91',
                                            SubType__c = 'TFE731 - REP',
                                            contact__c = c.id,
                                            InputDate__c = System.today().addMonths(12),
                                            OutputDate__c = System.today().addMonths(13),
                                            CloseDate = System.today().addMonths(11),
                                            ReachedDate__c = true,
                                            AccountId = portalAccount.ID,
                                            StageName = 'Customer Won',
                                            Amount = 3000,
                                            Opportunity_Name_Details__c ='asdfsddfggfhfghfgh'
                                           ); 
        
        Opportunity oppt3 = new Opportunity(Name ='New mAWS Deal',
                                            Aircraft__c = ac.Id,
                                            Equipment__c = equip.Id,
                                            RSM__c = 'Account unassigned',
                                            Type = 'TFE731',
                                            Facility__c = 'AGS',
                                            Tier_Level__c = '1',
                                            Operator__c= 'FAA Part 91',
                                            SubType__c = 'TFE731 - REP',
                                            contact__c = c.id,
                                            InputDate__c = System.today().addMonths(24),
                                            OutputDate__c = System.today().addMonths(25),
                                            CloseDate = System.today().addMonths(23),
                                            ReachedDate__c = true,
                                            AccountId = portalAccount.ID,
                                            StageName = 'Tracking Only',
                                            Amount = 3000,
                                            Opportunity_Name_Details__c ='asdfsddfggfhfghfgh'
                                           );   
                
        List<Opportunity> OppList= new List<Opportunity>();
        OppList.add(oppt);
        OppList.add(oppt2);
        OppList.add(oppt3);
        
        insert OppList;
        
        test.startTest();
        ProcessBuilderScheduleClass pbsc = new ProcessBuilderScheduleClass();
        String sch = '20 30 8 10 2 ?';
        
        system.schedule('Test', sch, pbsc);
        test.stopTest();
    }
    
}