public class updateMasterAmounttoZero {
    
    public static void addNegativeProduct(List<Opportunity> opps){
        List<Opportunity> oppts = new List<Opportunity>();
         id recrdId = Schema.Sobjecttype.opportunity.getRecordTypeInfosByName().get('Master Opportunity').getRecordTypeId();
        for(Opportunity o:opps){
            System.debug(' -- record type ' +o.RecordTypeId);
           
            if(o.RecordTypeId == recrdId){
                oppts.add(o);
            }
        }
        System.debug(' -----'+oppts.size());
        if(oppts.size()>0){
            List<OpportunityLineItem> oli = new List<OpportunityLineItem>();
            
            Product2 prd = [SELECT Id, Name, ProductCode FROM Product2 where Name='Master Opportunity Product' limit 1];
            
            for(Opportunity opp:oppts){
                if(opp.Amount>0 || opp.Amount<0){
                    OpportunityLineItem opli = new OpportunityLineItem();
                    opli.UnitPrice= -opp.Amount;
                    opli.Quantity=1;
                    opli.OpportunityId=opp.Id;
                    opli.product2Id=prd.Id;
                    oli.add(opli);
                }
            }
            System.debug(' ---- '+oli.size());
            if(oli.size()>0){
                insert oli;
            }
        }
        
    }
}