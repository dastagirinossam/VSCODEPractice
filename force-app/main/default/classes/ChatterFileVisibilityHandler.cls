public class ChatterFileVisibilityHandler {

    private static String sfdcInstance = [select InstanceName from Organization].InstanceName;   
    private static Id customerCommunity = [Select Id from Profile where Name =: 'Customer Community Plus - Custom'].Id;   
       
	public static void Project(List<FeedItem> fi){
        Id feedItem = null;
        List<FeedItem> updateFeeds = new List<FeedItem>();
        Map<Id, FeedItem> parentId = new Map<Id, FeedItem>();
            
        for(FeedItem f : fi){            
            parentId.put(f.ParentId, f);
            feedItem = f.id;
        	FeedItem fiToUpdate = new FeedItem(
            	Id = f.Id,
                Visibility = 'AllUsers'
            );
            updateFeeds.add(fiToUpdate);                                          
        }
        
        if((updateFeeds != null || !updateFeeds.isEmpty()) && userInfo.getProfileId() != customerCommunity){           
        	update updateFeeds;
        }
       
        if(userInfo.getProfileId() == customerCommunity){ 
            String userName = userInfo.getFirstName() + ' ' + userInfo.getLastName();
            
			for(MPM4_BASE__Milestone1_Project__c p : [Select Id, Name, CPM__c, CPM__r.FirstName from MPM4_BASE__Milestone1_Project__c where Id In: parentId.keyset()]){                                           
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] {p.CPM__c};
                message.optOutPolicy = 'FILTER';
                message.subject = userName + ' Posted Comment On Project: ' + p.name;
                message.HTMLBody = '<b>' + p.CPM__r.FirstName + ':</b></br>' +
                    	'<br/><b>Your customer ' + userName + ' has posted a comment on Project: </b><HTML><a href="https://' + sfdcInstance + '.salesforce.com/' + feedItem + '">' + p.Name + '</a></HTML>' +
                    	'<br/><b>" </b>' + parentId.get(p.Id).body + '<b> "</b></br>' +
                		'<br/><b>Regards,</b></br>' + 
                        '<br/><b>myStandardAero.com</b>';
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);              
            }
		}
	}
    
	public static void Contact(List<FeedItem> fi){
        Id feedItem = null;
        String comment = null;
        List<FeedItem> updateFeeds = new List<FeedItem>();
         
        for(FeedItem f : fi){   
            feedItem = f.Id;
        	FeedItem fiToUpdate = new FeedItem(
            	Id = f.Id,
                Visibility = 'AllUsers'
            );
            updateFeeds.add(fiToUpdate);
            comment = f.Body;
        }
        
        if((updateFeeds != null || !updateFeeds.isEmpty()) && userInfo.getProfileId() != customerCommunity)
        	update updateFeeds;
        
        if(userInfo.getProfileId() == customerCommunity){
            String userName = userInfo.getFirstName() + ' ' + userInfo.getLastName();
            
            User u = [Select ContactId, Contact.Name from User where Id =: userinfo.getUserId()];            
            comment = comment.replace('<p>','');
        	comment = comment.replace('</p>','');
            
            for(MPM4_BASE__Milestone1_Project__c p : [Select Id, Name, CPM__c, CPM__r.FirstName from MPM4_BASE__Milestone1_Project__c where 
                (Designated_Approver__c =: userinfo.getUserId() or
                    Secondary_Approver__c =: userinfo.getUserId() or
                    X3_Approver__c =: userinfo.getUserId() or
                    X4_Approver__c =: userinfo.getUserId() or
                    X5_Approver__c =: userinfo.getUserId() or
                    X6_Approver__c =: userinfo.getUserId()) Order By
                    Delivery_Date__c desc limit 1]){ 
                        
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] {p.CPM__c};
                message.optOutPolicy = 'FILTER';
                message.subject = userName + ' Made A Comment In Community';
                message.HTMLBody = '<b>' + p.CPM__r.FirstName + ':</b></br>' +
                    '<br/><b>Your customer ' + userName + ' has commented from the Community: </b><HTML><a href="https://' + sfdcInstance + '.salesforce.com/' + feedItem + '">' + u.Contact.Name + '</a></HTML>' +
                    '<br/><b>' + userInfo.getFirstName() + ' said : " </b>' + comment + '<b> "</b></br>' +
                    '<br/><b>Regards,</b></br>' + 
                    '<br/><b>myStandardAero.com</b>';
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);           
                        
            }
		}
	}
    
	public static void Quote(List<FeedItem> fi){
        Id feedItem = null;
        List<FeedItem> updateFeeds = new List<FeedItem>();
        Map<Id, FeedItem> parentId = new Map<Id, FeedItem>();
            
        for(FeedItem f : fi){
			feedItem = f.Id;            
            parentId.put(f.ParentId, f);          
        	FeedItem fiToUpdate = new FeedItem(
            	Id = f.Id,
                Visibility = 'AllUsers'
            );
            updateFeeds.add(fiToUpdate);  
                                         
        }
        
        if((updateFeeds != null || !updateFeeds.isEmpty()) && userInfo.getProfileId() != customerCommunity)
        	update updateFeeds;

        
        if(userinfo.getProfileId() == customerCommunity){ 
            String userName = userInfo.getFirstName() + ' ' + userInfo.getLastName();
            
			for(SBQQ__Quote__c q : [Select Id, Name, Project__c, Project__r.Name,  Project__r.CPM__c, Project__r.CPM__r.FirstName  from SBQQ__Quote__c where Id In: parentId.keyset()]){                                           
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] {q.Project__r.CPM__c};
                message.optOutPolicy = 'FILTER';
                message.subject = userName + ' Posted Comment On Quote: ' + q.name;
                message.HTMLBody = '<b>' + q.Project__r.CPM__r.FirstName + ':</b></br>' +
                    	'<br/><b>Your customer ' + userName + ' has posted a comment on Quote: </b><HTML><a href="https://' + sfdcInstance + '.salesforce.com/' + feedItem + '">' + q.Name + '</a></HTML>' +                       
                    	'<br/><b>" </b>' + parentId.get(q.Id).body + '<b> "</b></br>'+
                		'<br/><b>Regards,</b></br>' + 
                        '<br/><b>myStandardAero.com</b>';
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);             
            }
		}
	}
    
	public static void QuoteLinePost(List<FeedItem> fi){
        Id feedItem = null;
		Set<Id> userId = new Set<Id>();
        Map<Id, FeedItem> parentId = new Map<Id, FeedItem>();       
        List<FeedItem> updateFeeds = new List<FeedItem>();
    	List<SBQQ__QuoteLine__c> quoteLine = new List<SBQQ__QuoteLine__c>();
         
        for(FeedItem f : fi){   
            feedItem = f.Id;
            parentId.put(f.ParentId, f);          
        	FeedItem fiToUpdate = new FeedItem(
            	Id = f.Id,
                Visibility = 'AllUsers'
            );
            updateFeeds.add(fiToUpdate);  
         
            if(f.Type == 'ContentPost'){
            	SBQQ__QuoteLine__c qlToUpdate = new SBQQ__QuoteLine__c(
                	Id = f.ParentId,
                    Has_Attachment__c = True
				);
                quoteLine.add(qlToUpdate);
			}                                
        }
        
        if((updateFeeds != null || !updateFeeds.isEmpty()) && userInfo.getProfileId() != customerCommunity)
        	update updateFeeds;
         
		if((quoteLine != null || !quoteLine.isEmpty()) && userInfo.getProfileId() != customerCommunity)
        	update quoteLine; 
       
        if(userinfo.getProfileId() == customerCommunity){ 
        	String userName = userInfo.getFirstName() + ' ' + userInfo.getLastName();
            
			for(SBQQ__QuoteLine__c ql : [Select Id, Job_Card_Description__c, Name, Project__c, Project__r.Name, SBQQ__Quote__c, SBQQ__Quote__r.Name, CPM__r.Email, CPM__r.FirstName, Labor_Amount__c, Add_Work_Labor_Type__c, Material_Amount__c, Material_Type__c from SBQQ__QuoteLine__c where Id In: parentId.keyset()]){                                           
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] {ql.CPM__c};
                message.optOutPolicy = 'FILTER';
                message.subject = userName + ' Posted Comment On Squawk: ' + ql.name;
                message.HTMLBody = '<b>' + ql.CPM__r.FirstName + ':</b></br>' +
                    	'<br/><b>Your customer ' + userName + ' has posted a comment on Squawk: </b><HTML><a href="https://' + sfdcInstance + '.salesforce.com/' + feedItem + '">' + ql.Name + '</a></HTML>' +                    
						'<br/><b>Squawk Description: </b>' + ql.Job_Card_Description__c +                                 
                    	'<br/><b>" </b>' + parentId.get(ql.Id).body + '<b> "</b></br>'+
                		'<br/><b>Regards,</b></br>' + 
                        '<br/><b>myStandardAero.com</b>';
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);              
            }
		}
	}
    
	public static void ChatterFileVisibility(List<FeedItem> fi){
        List<FeedItem> updateFeeds = new List<FeedItem>();
        Map<Id, FeedItem> parentId = new Map<Id, FeedItem>();
            
        for(FeedItem f : fi){          
            parentId.put(f.ParentId, f);          
        	FeedItem fiToUpdate = new FeedItem(
            	Id = f.Id,
                Visibility = 'AllUsers'
            );
            updateFeeds.add(fiToUpdate);                                          
        }
        
        if((updateFeeds != null || !updateFeeds.isEmpty()) && userInfo.getProfileId() != customerCommunity)
        	update updateFeeds;
    }
}