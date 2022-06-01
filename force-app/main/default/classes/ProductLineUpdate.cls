public class ProductLineUpdate {
    
    @InvocableMethod
    public static void ProductLineUpdate(List<Id> ProductLineId){

        Product_Line__c pL = [Select Id, Engines_With_Confirmed_Intervals__c, Product_Line_Family__c, Engine_Type__c, Number_of_Engines_Per_Model__c, Number_Of_Engines_Per_Type__c, Number_of_Engines_In_SFDC__c from Product_Line__c where Id =: ProductLineId];
        
        List<AggregateResult> acModelCount = new List<AggregateResult>();
        List<AggregateResult> acSFDCCount = new List<AggregateResult>();
               
        if(pl.Product_Line_Family__c == 'Engine'){
            
            Map<Id, Id> modMap = new Map<Id, Id>();
            List<Equipment__c> model = [SELECT Id, Aircraft__c, Aircraft__r.Product_Line__r.Name FROM Equipment__c where Product_Line__c =: ProductLineId and Equipment_Status__c =: 'In-Operation'];
            for(Equipment__c m : model){
                if(m.Aircraft__c != null && m.Aircraft__r.Product_Line__r.Name != 'Other Aircraft')
                    modMap.put(m.Id, m.Aircraft__r.Product_Line__c);
            }
            
            List<AggregateResult> typeCount = [SELECT Count(Id) FROM Equipment__c where Product_Line__r.Engine_Type__c =: pL.Engine_Type__c];   
            List<AggregateResult> confirmedCount = [SELECT Count(Id) FROM Equipment__c where Product_Line__c =: ProductLineId and Interval_Confirmed__c =: 'True'];
            List<AggregateResult> engineCount = [SELECT Count(Id) FROM Equipment__c];        
            acModelCount = [Select Count(Id) from Aircraft__c where Product_Line__r.Engine_Type__c =: pl.Engine_Type__c and Product_Line__r.Product_Line_Family__c = 'Aircraft'];                       
            acSFDCCount = [SELECT Count(Id) FROM Aircraft__c];
            
            pL.Number_of_Engines_In_SFDC__c = (decimal)engineCount[0].get('expr0');
            pL.Number_Of_Engines_Per_Type__c = (decimal)typeCount[0].get('expr0');
            pL.Engines_With_Confirmed_Intervals__c = (decimal)confirmedCount[0].get('expr0');
            pL.Number_of_Engines_Per_Model__c = decimal.valueof(model.Size());
            
        }else if(pl.Product_Line_Family__c == 'Aircraft'){
        
            acModelCount = [SELECT Count(Id) FROM Aircraft__c where Product_Line__c =: ProductLineId];
            acSFDCCount = [SELECT Count(Id) FROM Aircraft__c];
            
        }
        
        pL.Number_of_Aircraft_In_SFDC__c = (decimal)acSFDCCount[0].get('expr0');
        pL.Number_of_Aircraft_Per_Model__c = (decimal)acModelCount[0].get('expr0');
        
        update pL;        
    }
}