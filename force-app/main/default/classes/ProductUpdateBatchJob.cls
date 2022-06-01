global class ProductUpdateBatchJob implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        DateTime dte = Datetime.now().addDays(-1);                         
        return Database.getQueryLocator([SELECT Id, Product2Id, UnitPrice, LastModifiedDate, LastModifiedBy.Name FROM PriceBookEntry WHERE LastModifiedDate >: dte]);
    }
    
    global void execute(Database.BatchableContext BC, List<PriceBookEntry> scope) {
        
        Map<Id, PriceBookEntry> pbeMap = new Map<Id, PriceBookEntry>();
        
        system.debug(scope);
        
        for(PriceBookEntry pbe : scope){
            if (pbe.Product2Id != Null){
                pbeMap.put(pbe.Product2Id, pbe);
            }
        } 
        
        List<Product2> products = [Select Id, List_Price_Last_Updated__c, Family from Product2 where Id in: pbeMap.keySet()];
        List<Product2> productUpdate = new List<Product2>();
        
        For(Product2 prod : products){
            system.debug('Product Family: ' + prod.Family);
            if(prod.Family == 'Materials'){
            	PriceBookEntry pbe = pbeMap.get(prod.Id);
            	prod.List_Price_Last_Updated__c = '$' + pbe.UnitPrice + ' by ' + pbe.LastModifiedBy.Name + ' - ' + pbe.LastModifiedDate.Month() + '/' + pbe.LastModifiedDate.Day() + '/' + pbe.LastModifiedDate.Year();
            	productUpdate.add(prod);
            }
        }
               
        if(productUpdate.size() > 0){
            update productUpdate;
        }     
    }
    
    global void finish(Database.BatchableContext BC) {
    }
    
}