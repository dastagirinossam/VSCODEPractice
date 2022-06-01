trigger TriggerOnAgentOpprtunityNotes1 on ContentVersion (After Insert,After Update) {
     
    if(trigger.isAfter && trigger.isUpdate){
        set<Id> cdId = new set<Id>();
        set<Id> clId = new set<Id>();
        set<Id> oppId = new set<Id>();
        set<Id> userId = new set<Id>();
        
        Id agentOppId;
        
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        string noteContent;
        for(ContentVersion c:trigger.new){
            cdId.add(c.ContentDocumentId);
        }       
        
        for(ContentNote cn:[select Id, content from ContentNote where Id IN : cdId]){
            noteContent = cn.Content.toString();     
        }
        
        if(noteContent != Null){
            User usr = [SELECT ID, firstName FROM User WHERE ID = :UserInfo.getUserId()];
            noteContent = noteContent.replace('<p>', ' ');          
            noteContent = noteContent.replace('</p>',' - ' + usr.FirstName +'\n');
        }  
        
        system.debug('noteContent>>'+noteContent);
        
        for(ContentDocumentLink cl: [select Id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where ContentDocumentId IN : cdId]){
            String s=cl.LinkedEntityId;
            if(s.startsWith('a3a') || s.startsWith('a4L')){
                system.debug('entityId>>>>'+ cl.LinkedEntityId); 
                clId.add(cl.LinkedEntityId);
            }            
        }
        
        for(Agent_Opportunity__c ag:[select Id, Opportunity__c, ownerId, CreatedById from Agent_Opportunity__c where Id IN : clId ]){
            oppId.add(ag.Opportunity__c);
            system.debug('>>>'+ag.id);
            
            agentOppId = ag.Id;
            
            userId.add(ag.ownerId);
            userId.add(ag.CreatedById);
        }
        
        string dialouge;
        for(Opportunity p:[select Id, Next_Step_Dialogue__c, name, Primary_Contact__c,ownerId From Opportunity WHERE ID IN : oppId]){
            system.debug('p>>>'+p);
            system.debug('test'+noteContent);
            //Opportunity Owner Does not Need to Be Included in the Email
            //userId.add(p.ownerId);
            p.Next_Step_Dialogue__c = (System.now()).date().format()+ ' - '  + noteContent+  p.Next_Step_Dialogue__c   ;
            p.Next_Step_Dialogue__c = p.Next_Step_Dialogue__c.replaceAll('null','');
            dialouge = p.Next_Step_Dialogue__c;
            oppToUpdate.add(p);
        } 
        
        update oppToUpdate;
        
        String agentOppName;
        List<Agent_Opportunity__c> agntListToUpdate = new List<Agent_Opportunity__c>();
        for(Agent_Opportunity__c ag:[select Id, Opportunity__c, Name, Next_Step_Dialogue__c from Agent_Opportunity__c where Id IN : clId ]){
            ag.Next_Step_Dialogue__c = dialouge;
            agentOppName = ag.Name;
            agntListToUpdate.add(ag);                                 
        }
        
        update agntListToUpdate;
        
        if(!userId.isEmpty()){
            List<string> emails = new List<string>();
            list<User> usrlist = [SELECT ID, firstName, email FROM User WHERE ID IN: userId];
            
            String fName;           
            for(user u: usrlist){
                
                if(u.Id != userinfo.getUserId())
                    fName = u.FirstName;
                
                emails.add(u.email); 
            }
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(emails);
            message.subject = 'New Note On Agent Opportunity: ' + agentOppName;
            message.htmlBody = fName + ':' + 
                '<br/><br/>A new note has been added to ' + agentOppName + '. <br/><br/>' +
                'Click <a href="https://www.mystandardaero.com/Customer/s/relatedlist/'+ agentOppId +'/AttachedContentNotes ">here</a> to goto Agent Opportunity.<br/><br/>' + 
                'Regards,<br/><br/>' +
                userinfo.getName() + '<br/>' +
                userinfo.getUserEmail() + '<br/>'; 
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        }
    }
}