({
    convertArrayOfObjectsToCSV : function(component,objectRecords){
              
        var csvStringResult, counter, keys, columnDivider, lineDivider, cValue, renamedKeys, nValue, newcsvStringResult;
            
        if (objectRecords == null || !objectRecords.length) 
            return null;
               
        columnDivider = ',';
        lineDivider =  '\n';
        
        keys = ['fxSquawkNo__c','Non_Routine__c','Add_Work_Status__c','Job_Card_Description__c','AddWork_Estimated_Total__c','Material_Amount__c', 'Material_Type__c', 'Labor_Amount__c', 'Add_Work_Labor_Type__c', 'RTS__c'];
        renamedKeys = ['Squawk No.','NonRoutine No.','Status','Description','Est Total','Material Amount', 'Material Type', 'Labor Amount', 'Labor Type', 'RTS'];
        
        csvStringResult = '';
        csvStringResult += renamedKeys.join(columnDivider);
        csvStringResult += lineDivider;

        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
                        
            for(var sTempkey in keys) {
                
                var skey = keys[sTempkey] ;  
                if(counter > 0){ 
                    csvStringResult += columnDivider;                                        
                }

				csvStringResult += '"' + objectRecords[i][skey] + '"';
                
                counter++;  

            }

            csvStringResult += lineDivider;
        }
        
        return csvStringResult;        
    }
})