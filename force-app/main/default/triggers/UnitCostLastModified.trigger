trigger UnitCostLastModified on SBQQ__Cost__c (after insert, after update ) {

    Map<Id, String> CostToIDMap = new Map<Id, String>();
    for (SBQQ__Cost__c c: Trigger.New)
    {
        String ls = '$' + c.SBQQ__UnitCost__c + ' by ' + c.LastModifiedById + ' - ' + c.LastModifiedDate.Month() + '/' + c.LastModifiedDate.Day() + '/' + c.LastModifiedDate.Year();
        CostToIDMap.put(c.SBQQ__Product__c, ls);
    }
    List<Product2> products = [Select Id, Unit_Cost_Last_Updated__c, Family from Product2 where Id in: CostToIDMap.keySet()];
        List<Product2> productUpdate = new List<Product2>();
        
        For(Product2 prod : products){
            if(prod.Family == 'Materials'){
            	prod.Unit_Cost_Last_Updated__c = CostToIDMap.get(prod.Id);
            	productUpdate.add(prod);
            }
        }
               
        if(productUpdate.size() > 0){
            update productUpdate;
        }
}