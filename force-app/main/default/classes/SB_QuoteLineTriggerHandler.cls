public with sharing class SB_QuoteLineTriggerHandler {
    
    
    
    public static void populateSpecification(List<SBQQ__QuoteLine__c> quotelineListNew,
                            Map<Id,SBQQ__QuoteLine__c> newQuoteLineMap,boolean isUpdate,boolean isInsert){
		
                               
        Map<Id, List<SBQQ__QuoteLine__c>> productIdQuoteLineListMap = new Map<Id, List<SBQQ__QuoteLine__c>>();
        List<SBQQ__QuoteLine__c> qlList = null;
        
		    Set<Id> quoteIdSet = new Set<Id>();
        SB_Metatype__mdt sbMetatype = [Select OpportunityStageToSync__c,DescriptionforOptionalProducts__c
                                       from SB_Metatype__mdt 
                                       where DeveloperName='custom_settings'];
                                
        system.debug('-check metatype trigger--'+sbMetatype.DescriptionforOptionalProducts__c);
      	                    
        for(SBQQ__QuoteLine__c ql : quotelineListNew){
            
            qlList = productIdQuoteLineListMap.get(ql.SBQQ__Product__c);

            if(qlList == null){
                qlList = new List<SBQQ__QuoteLine__c>();

            }
            qlList.add(ql);
            
            quoteIdSet.add(ql.SBQQ__Quote__c);

            productIdQuoteLineListMap.put(ql.SBQQ__Product__c,qlList);

            // fill for customer price

            //IF( OR(AND (TEXT(Product_Pricing__c) = 'Warranty', NOT(ISBLANK(TEXT(Warranty_Program__c )))),) , 0, SBQQ__NetTotal__c )
            if(((ql.Product_Pricing__c == 'Warranty' && ql.Warranty_Program__c != null)||
                 ql.IsHiddenForTemplates__c ||
                 ql.ExcludeFromExecutiveSummary__c)){
                     
                ql.Customer_Price__c = 0;

            } else{

                ql.Customer_Price__c = ql.SBQQ__NetTotal__c;
            }
            
           /* if(isInsert && ql.ExcludeFromExecutiveSummary__c && ql.SBQQ__RequiredBy__c == null){
                ql.CheckForExcludeChange__c = true;
            }*/
        }
                                
        if(productIdQuoteLineListMap.isEmpty()){
            return;
        }
     
        system.debug('--check-'+productIdQuoteLineListMap.keySet());

        
        Map<Id,Product2> productIdMap = new Map<Id,Product2>([Select Id, SBQQ__Specifications__c,
                                                                    ExcludeFromExecutiveSummary__c
                                                            From Product2
                                                            where id in :productIdQuoteLineListMap.keySet()]);
        

        for(Product2 prd : productIdMap.values()){

            qlList = productIdQuoteLineListMap.get(prd.id);

            if(qlList != null){

                for(SBQQ__QuoteLine__c ql: qlList){
                    if(ql.Specification__c == null && prd.SBQQ__Specifications__c!=null){
                        ql.Specification__c = prd.SBQQ__Specifications__c.trim();
                    }
                    if(isInsert && prd.ExcludeFromExecutiveSummary__c){
                       
                        ql.ExcludeFromExecutiveSummary__c = prd.ExcludeFromExecutiveSummary__c;
                    
                        if(ql.Specification__c == null){
                            ql.Specification__c = sbMetatype.DescriptionforOptionalProducts__c.trim();
                        }else{
                            if(prd.SBQQ__Specifications__c != null){
                                ql.Specification__c = String.format('{0}<br><br>{1}',
                                                            new List<String>{prd.SBQQ__Specifications__c.trim(),sbMetatype.DescriptionforOptionalProducts__c.trim()});
                              }
                        }
                        
                    }
                    if(isInsert && ql.SBQQ__PriorQuantity__c != null){

                        ql.OriginalSpecification__c = ql.Specification__c;
                    }
                } 
            }
        }
		
    } 

   
    

    
    
}