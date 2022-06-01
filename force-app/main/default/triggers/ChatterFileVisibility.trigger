trigger ChatterFileVisibility on FeedItem (after insert) {

    if(trigger.isAfter){       
        if (Trigger.isInsert) { 
			for(FeedItem fi: Trigger.new){ 
                Id objId = fi.ParentId;
				String objectName = objId.getSObjectType().getDescribe().getName();
                
                if(objectName == 'MPM4_BASE__Milestone1_Project__c'){
                	ChatterFileVisibilityHandler.Project(trigger.new);
                }
                else if(objectName == 'Contact'){
                	ChatterFileVisibilityHandler.Contact(trigger.new);
				}
                else if(objectName == 'SBQQ__Quote__c'){
                	ChatterFileVisibilityHandler.Quote(trigger.new);
                }
                else if(objectName == 'SBQQ__QuoteLine__c'){
                	ChatterFileVisibilityHandler.QuoteLinePost(trigger.new);
                }
                else if(objectName == 'Contract_Change_Order__c' || objectName == 'Log_Book_Entry__c'){
                	ChatterFileVisibilityHandler.ChatterFileVisibility(trigger.new);
                }
            }                                   
        }
    }    
}