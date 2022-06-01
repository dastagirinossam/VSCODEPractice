trigger ProductTrigger on Product2 (before insert, before update) {
    
    system.debug('recurse>>> '); 
    
    if( ProdTriggerRecursive.isFirstTime == True){      
        if(trigger.isBefore &&(trigger.isInsert || trigger.IsUpdate)){                     
            
            ProdTriggerRecursive.isFirstTime = False;
            
            for(Product2 p : Trigger.new ){                
                
                String spec = p.SBQQ__Specifications__c;
                String prodCode = null; 
                system.debug('<<<<<<<spec>>>>>>>before'+ spec); 
                if(spec != null){
                    
                    spec = spec.replaceAll('<br/>','<br>');
                    spec = spec.replaceAll('</br>','<br>');  
                    
                    spec = spec.replaceAll('</p><p><br>', '~~~');
                    spec = spec.replaceAll('</p><p>', '~~~');
                    spec = spec.replaceAll('<p>', '');
                    spec = spec.replaceAll('</p>', '');
                                        
                    spec = spec.replaceAll('~~~', '<br>');
                    
                    if(p.Family == 'Bundle'){
                        prodCode = p.Name + ' - ' + spec;
                        prodCode = prodCode.replaceAll('<[^>]+>',' ');
                        
                        if(prodCode.length() > 150)
                            prodCode = prodCode.substring(0, 150);
                                              
                        p.ProductCode = prodCode;
                    }
                    system.debug('<<<<<<<spec>>>>>>>after'+ spec);
                    
                    p.SBQQ__Specifications__c = spec;                    
                }
            }
        }
    } 
}