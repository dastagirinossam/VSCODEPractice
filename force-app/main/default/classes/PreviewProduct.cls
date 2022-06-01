public class PreviewProduct {
    
    public PreviewProduct(ApexPages.StandardController controller) {
        
    }
    
    public PageReference autoRun(){
        Id prodId = ApexPages.currentPage().getParameters().get('id');
        Id rtId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Standard Proposal').getRecordTypeId();
        Integer i = 2;
        
        Organization org = [Select InstanceName from Organization where Id =: UserInfo.getOrganizationId()];        
        Product2 prod = [Select Name, Description, Family_Type__c, SBQQ__Specifications__c from Product2 where Id =: prodId];  
        SBQQ__Cost__c prodCost = [Select Id from SBQQ__Cost__c where SBQQ__Product__c =: prodId];
        Pricebook2 pb = [Select Id from Pricebook2 where Name =:'CPQ Price Book'];
        
        Map<Id, Id> prodMap = new Map<Id, Id>();
        Map<Id, SBQQ__Cost__c> prodCostMap = new Map<Id, SBQQ__Cost__c>();
        Map<Id, PricebookEntry> prodPbMap = new Map<Id, PricebookEntry>();
        
        List<SBQQ__QuoteLine__c> newQuoteLines = new List<SBQQ__QuoteLine__c>();
        List<SBQQ__ProductOption__c> prodOptions = [Select ID, 
                                                    SBQQ__Quantity__c,
                                                    SBQQ__OptionalSKU__c,
                                                    SBQQ__OptionalSKU__r.Name,
                                                    SBQQ__OptionalSKU__r.Family,
                                                    Product_Description__c,
                                                    SBQQ__Number__c from SBQQ__ProductOption__c where SBQQ__ConfiguredSKU__c =: prodId and SBQQ__Selected__c = true order by SBQQ__Number__c asc];
        
        for(SBQQ__ProductOption__c p : prodOptions){
            prodMap.put(p.Id, p.SBQQ__OptionalSKU__c);        
        }
        
        //Get Product Options Cost
        for(SBQQ__Cost__c c : [Select Id, SBQQ__UnitCost__c, SBQQ__Product__c from SBQQ__Cost__c where SBQQ__Product__c In: prodMap.values()]){
            prodCostMap.put(c.SBQQ__Product__c, c);
        }
        
        //Get Products Unit Price
        for(PricebookEntry pbe : [SELECT Id, Product2ID, UnitPrice FROM PricebookEntry where Product2Id In: prodMap.values() and PriceBook2.Name = 'CPQ Price Book']){
            prodPbMap.put(pbe.Product2Id, pbe);
        }
        
        SBQQ__QuoteTemplate__c tempId = [Select Id from SBQQ__QuoteTemplate__c where name = 'Products Preview'];
        
        SBQQ__Quote__c newQuote = new SBQQ__Quote__c(
            RecordTypeId = rtId,
            Labor_Type1__c = prod.Family_Type__c,
            SBQQ__QuoteTemplateId__c = tempId.Id,
            Facility1__c = 'SPI',
            SBQQ__PriceBook__c = pb.Id,
            SBQQ__PricebookId__c = pb.Id,
            Product_Preview__c = True          
        );
        
        insert newQuote;
        
        SBQQ__QuoteLine__c newQuoteLine = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = newQuote.Id,
            SBQQ__Product__c = prodId,
            SBQQ__Quantity__c = 1,
            SBQQ__Number__c = 1,
            SBQQ__Bundle__c = True,
            Product_Name__c = prod.Name,
            SBQQ__PricingMethod__c = 'List',
            SBQQ__Cost__c = prodCost.Id,
            Product_Description__c = prod.Description,
            Specification__c = prod.SBQQ__Specifications__c,
            SBQQ__CustomerPrice__c = decimal.valueOf('0.00'),
            SBQQ__ListPrice__c = decimal.valueOf('0.00'),
            SBQQ__NetPrice__c = decimal.valueOf('0.00'),   
            SBQQ__SpecialPrice__c = decimal.valueOf('0.00'),
            SBQQ__RegularPrice__c = decimal.valueOf('0.00'),
            SBQQ__UnitCost__c = decimal.valueOf('0.00')
        );

        insert newQuoteLine;
                
        For(SBQQ__ProductOption__c po : prodOptions){
            
            SBQQ__QuoteLine__c newPOQL = new SBQQ__QuoteLine__c();
            newPOQL.SBQQ__Quote__c = newQuote.Id;
            newPOQL.SBQQ__Product__c = po.SBQQ__OptionalSKU__c;
            newPOQL.SBQQ__Quantity__c = po.SBQQ__Quantity__c;
            newPOQL.SBQQ__ProductOption__c = po.Id;
            newPOQL.SBQQ__RequiredBy__c = newQuoteLine.Id;
            newPOQL.Product_Description__c = po.Product_Description__c;            
            if(po.SBQQ__OptionalSKU__r.Family == 'Labor'){
                newPOQL.Product_Pricing__c = 'Retail Less Discount';
            }else{
                newPOQL.Product_Pricing__c = 'Firm Price';
                newPOQL.Desired_Margin__c = 1000;
            }
            
            newPOQL.SBQQ__Number__c = i;
            newPOQL.SBQQ__Cost__c = prodCostMap.get(po.SBQQ__OptionalSKU__c).Id;
            newPOQL.Product_Name__c = po.SBQQ__OptionalSKU__r.Name;
            newPOQL.SBQQ__CustomerPrice__c = prodPbMap.get(po.SBQQ__OptionalSKU__c).UnitPrice;
            newPOQL.SBQQ__NetPrice__c = prodPbMap.get(po.SBQQ__OptionalSKU__c).UnitPrice;     
            newPOQL.SBQQ__SpecialPrice__c = prodPbMap.get(po.SBQQ__OptionalSKU__c).UnitPrice;
            newPOQL.SBQQ__RegularPrice__c = prodPbMap.get(po.SBQQ__OptionalSKU__c).UnitPrice;
            newPOQL.SBQQ__ListPrice__c = prodPbMap.get(po.SBQQ__OptionalSKU__c).UnitPrice;
            newPOQL.SBQQ__UnitCost__c = prodCostMap.get(po.SBQQ__OptionalSKU__c).SBQQ__UnitCost__c;
            
            newQuoteLines.add(newPOQL);
            
            i = i + 1;           
        }
        
        if(newQuoteLines.Size() > 0){
            insert newQuoteLines;
        }
        
        PageReference pageRef = new PageReference(URLUtils.getQuotingURLforVisualForce()+'/apex/PreviewDocument?id=' + newQuote.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    @InvocableMethod
    public static void QuoteDelete(List<Id> QuoteId){
        List<SBQQ__Quote__c> quote = [Select Id from SBQQ__Quote__c where Id In: QuoteId];
        delete quote;
    }
    
}