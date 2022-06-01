@IsTest
public class myOpportinutyViewCompController_Test {
static testMethod void TestMethod1()
    
    {
        test.startTest();
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
   
      //   UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
      //  insert r1;
        
        User u2 = new User(
            Alias = 'nUser21',
          //  UserRoleId = r1.Id,
            Email='newuser21@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com');
        insert u2;
        
          //Create Account
            Account portalAccount = new Account();
            portalAccount.Name = 'test name';
            portalAccount.BillingStreet = '1600 Amphitheatre Parkway';
            portalAccount.BillingCity = 'Mountain View';
            portalAccount.BillingState = 'CA';
            portalAccount.BillingPostalCode = '94043';
            portalAccount.BillingCountry = 'United States';
            insert portalAccount;
            
             //Create Product Line
            Product_Line__c prodLine = new Product_Line__c(
                Product_Line_Family__c = 'Aircraft',
                Name = 'new'
            );
        
            insert prodLine;
        
            //Create Equipment
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.Id,
                Account__c = portalAccount.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                Model__c = 'HTF7000'
            );
            insert equip;
            
            //Create Aircraft
            Aircraft__c ac = new Aircraft__c();
            ac.Product_Line__c = prodLine.Id;
            ac.Aircraft_Make__c = 'LEARJET';
            ac.Aircraft_Model_2011__c = 'LEAR 45';
            ac.Aircraft_SN__c = '213';
            ac.ACReg__c = 'N9551H';
            ac.name = 'new';
            ac.Aircraft_Type__c = 'Aircraft';
            ac.OwnerId = UserInfo.getUserId();
            insert ac;        
        
         //Create Opportunity
          Opportunity oppt = new Opportunity(Name ='New mAWS Deal',
                           Aircraft__c = ac.Id,
                           Equipment__c = equip.Id,
                           RSM__c = 'Account unassigned',
                           Type = 'TFE731 - REP',
                           Facility__c = 'AGS',
                           Tier_Level__c = '1',
                           Operator__c= 'FAA Part 91',
                           SubType__c = 'TFE731 - REP',
                           InputDate__c = System.today(),
                           OutputDate__c = System.today(),
                           AccountId = portalAccount.ID,
                            StageName = 'Customer Won',
                            Amount = 3000,
                            CloseDate = System.today(),
                            Opportunity_Name_Details__c ='asdfsddfggfhfghfgh'
                            //SubType2__c,Sub_Type_2_Required__c
                            );

        insert oppt;
        
        //Create Agent Opportunity
        Agent_Opportunity__c agentOpp = new Agent_Opportunity__c();
        agentOpp.Opportunity__c = oppt.Id;
        agentOpp.Aircraft__c = ac.Id;
        agentOpp.Account__c = portalAccount.Id;
        agentOpp.Equipment__c = equip.Id;
        insert agentOpp;
        

    //Create ContentVersion
    ContentVersion contentVersion = new ContentVersion(
     Title = 'Test',
     PathOnClient = 'Test.pdf',
    VersionData = Blob.valueOf('Test Content'),
    IsMajorVersion = true
    );
    insert contentVersion;    
        
    //Create ContentNote
    ContentNote cn = new ContentNote(
     Title = 'test Note',
   Content = Blob.valueOf('Test Content')
    );

  insert cn ;  
  
   //Get Content Documents
    Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion .Id].ContentDocumentId;
 
    //Create ContentDocumentLink record
    ContentDocumentLink cdl = New ContentDocumentLink();
    cdl.LinkedEntityId = agentOpp.Id;
    cdl.ContentDocumentId = cn.Id;
    //cdl.ContentDocumentId = conDocId;
    cdl.shareType = 'V';
    Insert cdl;
   
        myOpportinutyViewCompController.getoppRecs(u2.Id);
        myOpportinutyViewCompController.getaccRecs(portalAccount.Id);
        myOpportinutyViewCompController.createRecord (cn,agentOpp.Id);
        test.stopTest();
        
}
}