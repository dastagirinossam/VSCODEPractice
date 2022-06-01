@istest
public class StatusUpdateController_test {
    
    @testSetup
    public static void method1(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];    
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        User u2 = new User(
            Alias = 'nUser21',
            UserRoleId = r.Id,
            Email='newuser21@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com');
        
        System.runAs(u2){
            
            Product_Line__c prodLine = TestDataGenerator.createProductLine();
			Account portalAccount = TestDataGenerator.createAccount();
			Aircraft__c ac = TestDataGenerator.createAircraft(prodLine.Id, portalAccount.Id);
            Equipment__c equip = TestDataGenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
            Product2 prod = TestDataGenerator.createProduct();            
            Contact c = TestDataGenerator.createContact(portalAccount.Id);
            Sub_Type_2__c st2 = TestDataGenerator.createSubType2(prodLine.Id);
            Opportunity oppty = TestDataGenerator.instantiateOpportunity(portalAccount.Id, ac.Id, equip.Id, prodLine.Id, st2.Id, c.Id);
                    
            //Create User
            User portalUser = new User(
                ProfileId = [Select Id from profile where name = 'Customer Community Plus Login User - Custom'].Id,
                PortalRole = 'Executive',
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testUser123',
                IsActive = true,
                ContactId = c.id
            );
            insert portalUser;
            
            //Create Project
            MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c();
            proj.Name = 'Project Test';
            proj.MPM4_BASE__Account__c = portalAccount.Id;
            proj.Opportunity__c = oppty.Id;
            proj.Aircraft__c = ac.Id;
            proj.Engine__c = equip.Id;
            proj.Input_Date__c = oppty.InputDate__c;
            proj.Delivery_Date__c = oppty.OutputDate__c;
            proj.MPM4_BASE__Kickoff__c = oppty.InputDate__c;
            proj.MPM4_BASE__Deadline__c = oppty.OutputDate__c;
            proj.CPM__c = userInfo.getUserId();
            proj.Designated_Approver__c = portalUser.Id;
            proj.MPM4_BASE__Status__c = 'Active';
            proj.Same_Labor_Rate_Applied__c = True;
            insert proj;
            
            Status_Update__c su = new Status_Update__c();
            su.Project__c = proj.Id;
            su.Type__c = 'Airframe';
            insert su;
            
        /*    ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;  
            
            List<ContentDocument> documents = [SELECT Id, Title, FileType FROM ContentDocument];
            system.debug('Documents: ' + documents);
            
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = proj.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            cdl.Visibility = 'AllUsers'; 
            insert cdl;           */           
        }
    }
        
    static testMethod void StatusUpdateTest() {        
        Test.startTest();
        
          ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;  
        
        MPM4_BASE__Milestone1_Project__c proj = [Select id from MPM4_BASE__Milestone1_Project__c];
        
         List<ContentDocument> documents = [SELECT Id, Title, FileType FROM ContentDocument];
            system.debug('Documents: ' + documents);
            
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = proj.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            cdl.Visibility = 'AllUsers'; 
            insert cdl;  
        
        Status_Update__c su = [Select Id from Status_Update__c];
                
        List<String> files = new List<String>();
        String projId = proj.Id;
        String fileMap = JSON.serialize(documents);
         opportunity opp=[select id from opportunity limit 1];
        StatusUpdateController.sendOpportunityEmail('test@invaid.com', 'test','This is test email',null, opp.Id);
        StatusUpdateController.getRecordValues(opp.id);
        StatusUpdateController.LogACall(opp.id,'This is test email');
        StatusUpdateController.getAttachments(projId);
        try{
                    StatusUpdateController.sendEmailApex(su.Id, fileMap);

        }
        catch(exception ex){
            system.debug('exception'+ex.getMessage());
        }
        StatusUpdateController.getRecordValues(projId);
       
        Test.stopTest();           
    }     
}