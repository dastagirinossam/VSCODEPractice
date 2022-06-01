public without sharing class BuyerSellerSquawks {
    
    @AuraEnabled
    public static List <SBQQ__QuoteLine__c> getSellerProjectQuoteLines(List <Id> lstRecordId) {   
        return [Select id, Name, fxSquawkNo__c, IsRTS__c, Add_Work_Status__c, Job_Card_Description_Section__c, Designated_Approver__c,
                	Designated_Approver__r.Name, RTS__c, Job_Card_Description__c, Project__r.Name, 
                	Project__c, CreatedBy.Name, CreatedBy.Id 
                from SBQQ__QuoteLine__c 
                where Project__r.Buyer_Inspection__c =: lstRecordId and 
                	Add_Work_Status__c != null and 
                	SBQQ__ProductCode__c!= 'UnscheduledBundle' and 
                	SBQQ__Quote__r.SBQQ__Status__c = 'Presented' and  
                	//Add_Work_Status__c != 'Declined' and
                	Share_w_Buyer__c = True 
                Order BY Job_Card__c asc
               ];   
    }
    
    @AuraEnabled
    public static List <SBQQ__QuoteLine__c> getBuyerProjectQuoteLines(List <Id> lstRecordId) {   
        return [Select id, Name, fxSquawkNo__c, IsRTS__c, Add_Work_Status__c, Job_Card_Description_Section__c, Designated_Approver__c,
                	Designated_Approver__r.Name, RTS__c, Job_Card_Description__c, Project__r.Name, 
                	Project__c, CreatedBy.Name, CreatedBy.Id 
                from SBQQ__QuoteLine__c 
                where Project__r.Seller_Inspection__c =: lstRecordId and 
                	Add_Work_Status__c != null and 
                	SBQQ__ProductCode__c!= 'UnscheduledBundle' and 
                	SBQQ__Quote__r.SBQQ__Status__c = 'Presented'  
                	//Add_Work_Status__c != 'Declined' 
                Order BY Job_Card__c asc
               ];   
    }

}