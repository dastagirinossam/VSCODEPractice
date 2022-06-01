public class AddWorkStatusHelper{
    
    public static void updateFieldsFromProject(List<SBQQ__QuoteLine__c> ql){
        system.debug('entered this method for creating quotelines');
        Set<Id> quoteId = new Set<Id>();
        Set<Id> prodId = new Set<Id>();
        Map<Id, Set<Id>> projId = new Map<Id, Set<Id>>();        
        Map<Id, MPM4_BASE__Milestone1_Project__c> projectMap = new Map<Id, MPM4_BASE__Milestone1_Project__c>();
        
        for(SBQQ__QuoteLine__c q: ql){
            quoteId.add(q.SBQQ__Quote__c);
            prodId.add(q.SBQQ__Product__c);
        }
        
        for(SBQQ__Quote__c qte : [Select id, Project__c from SBQQ__Quote__C where Id In: quoteId]){
            if(qte.Project__c != null){               
                if(projId.containskey(qte.project__c)){
                    projId.get(qte.Project__c).add(qte.Id); 
                }else{
                    projId.put(qte.Project__c, new Set<Id>{qte.Id});
                }
            }else{
                break;
            }
        }
        
        if(projId.IsEmpty())
            return;
        
        for(MPM4_BASE__Milestone1_Project__c p : [Select Id, Administrator__c, Designated_Approver__c, Secondary_Approver__c, X3_Approver__c, X4_Approver__c, X5_Approver__c,  X6_Approver__c, CPM__c, Crew_Chief__c, BackupCPM__c from MPM4_BASE__Milestone1_Project__c where Id =: projId.keyset()]){
            for(Id i : projId.get(p.Id)){
                projectMap.put(i, p);
            }
        } 
        
        Map<Id, Product2> prodMap = new Map<Id, Product2>([Select Id, Name from Product2 where Id In: prodId]);
        
        for(SBQQ__QuoteLine__c q : ql){
            system.debug('Project Before Trigger :' + projectMap.get(q.SBQQ__Quote__c).Id);
            String jobCard = q.Job_Card_Description__c;
            
            q.Project__c = projectMap.get(q.SBQQ__Quote__c).Id;
            q.Designated_Approver__c = projectMap.get(q.SBQQ__Quote__c).Designated_Approver__c;
            q.BackupCPM__c = projectMap.get(q.SBQQ__Quote__c).BackupCPM__c;
            q.CPM__c = projectMap.get(q.SBQQ__Quote__c).CPM__c; 
            q.Administrator__c = projectMap.get(q.SBQQ__Quote__c).Administrator__c; 
            q.Secondary_Approver__c = projectMap.get(q.SBQQ__Quote__c).Secondary_Approver__c;
            q.X3_Approver__c = projectMap.get(q.SBQQ__Quote__c).X3_Approver__c;
            q.X4_Approver__c = projectMap.get(q.SBQQ__Quote__c).X4_Approver__c;
            q.X5_Approver__c = projectMap.get(q.SBQQ__Quote__c).X5_Approver__c;
            q.X6_Approver__c = projectMap.get(q.SBQQ__Quote__c).X6_Approver__c;
            q.Product_Name_Value__c = prodMap.get(q.SBQQ__Product__c).Name;
             
            if(jobCard != null){
                q.Job_Card_Description_Section_1__c = jobCard.mid(0, 249);               
                /*q.Job_Card_Description_Section_2__c = jobCard.mid(250, 499);
                q.Job_Card_Description_Section_3__c = jobCard.mid(500, 749);
                q.Job_Card_Description_Section_4__c = jobCard.mid(750, 999);
                q.Job_Card_Description_Section_5__c = jobCard.mid(1000, 1249);
                q.Job_Card_Description_Section_6__c = jobCard.mid(1250, 1499);
                q.Job_Card_Description_Section_7__c = jobCard.mid(1500, 1749);
                q.Job_Card_Description_Section_8__c = jobCard.mid(1750, 2000);*/
            }          
        }              
    }
    
    public static void updateFieldsOnProject(map<Id, SBQQ__QuoteLine__c> sqkMap){
        
        Set<Id> projectIds = new Set<Id>();
        
        for(SBQQ__QuoteLine__c ql : sqkMap.values()){
            if(ql.Project__c != null){
                projectIds.add(ql.Project__c);
            }else{
                break;
            }
        }
        
        if(projectIds.isEmpty())
            return;
        
        Map<Id, MPM4_BASE__Milestone1_Project__c> projectsToUpdate = new Map<Id, MPM4_BASE__Milestone1_Project__c>(); 
        
        Map<id, Decimal> projSqks = new Map<id, Decimal>(); 
        Map<id, Decimal> estTotal = new Map<id, Decimal>();
        Map<id, Decimal> estElhTotal = new Map<id, Decimal>();
        Map<id, Decimal> appTotal = new Map<id, Decimal>();
        Map<id, Decimal> elhTotal = new Map<id, Decimal>();
        
        for(AggregateResult ar : [select project__c, count(Id) pendingSqks, Add_Work_Status__c, sum(AddWork_Estimated_Total__c) estTotal, sum(Estimated_Labor_Hours__c) elhTotal from SBQQ__QuoteLine__c  where project__c In: projectIds and (Add_Work_Status__c =: 'Pending' or Add_Work_Status__c =: 'Approved') group by project__c, Add_Work_Status__c]){
            
            if( ar.get('Add_Work_Status__c') == 'Pending'){
                projSqks.put((Id)ar.get('project__c'), (Decimal)ar.get('pendingSqks'));  
                estTotal.put((Id)ar.get('project__c'), (Decimal)ar.get('estTotal')); 
                estElhTotal.put((Id)ar.get('project__c'), (Decimal)ar.get('elhTotal')); 
            }
            
            if( ar.get('Add_Work_Status__c') == 'Approved' ){
                appTotal.put((Id)ar.get('project__c'), (Decimal)ar.get('estTotal'));
              elhTotal.put((Id)ar.get('project__c'), (Decimal)ar.get('elhTotal'));
            }
        }
        
        system.debug('Project Squawks: ' + projSqks);
        system.debug('Estimated Total: ' + estTotal);
        system.debug('Approved Total: ' + appTotal);
        system.debug('Estimated Labor Hours Pending: ' + estElhTotal);
        system.debug('Estimated Labor Hours Total: ' + elhTotal);
        
        for(MPM4_BASE__Milestone1_Project__c p : [Select Id, MPM4_BASE__Status__c, Pending_Squawks__c, Pending_Total__c, Approved_Total__c, Estimated_Labor_Hours__c, Pending_Estimated_Labor_Hours__c FROM MPM4_BASE__Milestone1_Project__c where Id IN: projectIds]){
            if(p.MPM4_BASE__Status__c == 'Active' || p.MPM4_BASE__Status__c == 'On Hold' || p.MPM4_BASE__Status__c == 'Completed'){
                p.Pending_Squawks__c = projSqks.get(p.Id); 
                p.Pending_Total__c = estTotal.get(p.id);
                p.Approved_Total__c = appTotal.get(p.id);
                p.Estimated_Labor_Hours__c = elhTotal.get(p.id);
                p.Pending_Estimated_Labor_Hours__c = estElhTotal.get(p.id);
                projectsToUpdate.put(p.Id, p);
            }
        }
        
        if(!projectsToUpdate.IsEmpty())
            update projectsToUpdate.Values();
    }
    
    public static void populateSpecification(List<SBQQ__QuoteLine__c> quotelineListNew, Map<Id,SBQQ__QuoteLine__c> newQuoteLineMap,boolean isUpdate,boolean isInsert){
        system.debug('entered forlop of specification of quotelinitem');
        Map<Id, List<SBQQ__QuoteLine__c>> productIdQuoteLineListMap = new Map<Id, List<SBQQ__QuoteLine__c>>();
        List<SBQQ__QuoteLine__c> qlList = null;
        Set<Id> quoteIdSet = new Set<Id>();
        system.debug('entered This method');
        
        SB_Metatype__mdt sbMetatype = [Select OpportunityStageToSync__c,DescriptionforOptionalProducts__c
                                       from SB_Metatype__mdt 
                                       where DeveloperName='custom_settings'];
        
        system.debug('-check metatype trigger--'+sbMetatype.DescriptionforOptionalProducts__c);
        
        for(SBQQ__QuoteLine__c ql : quotelineListNew){
            
            qlList = productIdQuoteLineListMap.get(ql.SBQQ__Product__c);
            
            if(qlList == null)
                qlList = new List<SBQQ__QuoteLine__c>();
            
            qlList.add(ql);
            
            quoteIdSet.add(ql.SBQQ__Quote__c);
            
            productIdQuoteLineListMap.put(ql.SBQQ__Product__c,qlList);
            
            // fill for customer price
            if((ql.Product_Pricing__c == 'Warranty' && ql.Warranty_Program__c != null)|| ql.IsHiddenForTemplates__c || ql.ExcludeFromExecutiveSummary__c){
                ql.Customer_Price__c = 0;
            } else{
                ql.Customer_Price__c = ql.SBQQ__NetTotal__c;
            }
            
            //Update SHow On Quote Field Used in Quote Rollup
            system.debug('Show On Quote: ' + ql.Show_on_Customer_Quote__c);
            if(ql.Show_on_Customer_Quote__c == true){
                
                ql.Show_on_Quote__c = true;
            }else{
                ql.Show_on_Quote__c = false;
            }
            
            if(ql.ExcludeFromSummaryFormula__c == true){
                ql.SBQQ__Optional__c = true;
                ql.ExcludeFromExecutiveSummary__c = true;
            }else{
                ql.SBQQ__Optional__c = false;
                ql.ExcludeFromExecutiveSummary__c = false;                 
            }
            
        }
        
        if(productIdQuoteLineListMap.isEmpty())
            return;
        
        system.debug('--check-'+productIdQuoteLineListMap.keySet());
        
        Map<Id,Product2> productIdMap = new Map<Id,Product2>([Select Id, SBQQ__Specifications__c,
                                                              ExcludeFromExecutiveSummary__c
                                                              From Product2
                                                              where id in :productIdQuoteLineListMap.keySet()]);
        
        for(Product2 prd : productIdMap.values()){
            
            qlList = productIdQuoteLineListMap.get(prd.id);
            
            if(qlList != null){
                for(SBQQ__QuoteLine__c ql: qlList){
                    
                    if(ql.Specification__c == null && prd.SBQQ__Specifications__c != null)
                        ql.Specification__c = prd.SBQQ__Specifications__c.trim();
                    
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
                    
                    if(isInsert && ql.SBQQ__PriorQuantity__c != null)
                        ql.OriginalSpecification__c = ql.Specification__c;
                    
                    //Update Specifications formatting
                    if(isUpdate && ql.Specification__c != null){
                        system.debug('entered spec in quote line item');
                        String spec = ql.Specification__c;
                        system.debug('New Spec before in quitelineItem Trigger: ' + spec);
                        
                        spec = spec.replaceAll('<br/>','<br>');
                        spec = spec.replaceAll('</br>','<br>');  
                        
                        spec = spec.replaceAll('</p><p><br>', '~~~');
                        spec = spec.replaceAll('</div><div><br>','~~~');
                        
                        spec = spec.replaceAll('</p><p>', '~~~');
                        spec = spec.replaceAll('</div><div>', '~~~');
                        
                        spec = spec.replaceAll('<p>', ''); 
                        spec = spec.replaceAll('<div>',''); 
                        
                        spec = spec.replaceAll('</p>', '');                   
                        spec = spec.replaceAll('</div>','');
                                                                   
                        spec = spec.replaceAll('~~~', '<br>');
                        
                        //spec = spec.replaceAll('<br><br><br><br>', '<br><br>');
                        //spec = spec.replaceAll('<br><br><br>', '<br><br>');
                       
                        system.debug('After New Spec in quitelineItem Trigger: ' + spec);
                        
                        ql.Specification__c = spec;                                   
                    }                            
                } 
            }
        }    
    }    
}