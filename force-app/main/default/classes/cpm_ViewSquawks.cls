public class cpm_ViewSquawks {  
    
    //generate PDF
    public String PDFData {get; set;} 
        
    public cpm_ViewSquawks(){
        PDFData = '';
    }
    
    public PageReference downloadPDF(){
        System.PageReference pageRef = new System.PageReference('/apex/PDFGenerator');
        
        //ensure pdf downloads and is assigned with defined name
        pageRef.getHeaders().put('content-disposition', 'attachment; filename=TestPDF.pdf');
        
        return pageRef;
    }
     
    //Lighting Component
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getSquawks(String projId){
        
        String soqlProjectQuoteLinesQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__QuoteLine__c');
        String queryProjectIdstr = String.valueOf('\'') + projId + String.valueOf('\'');
        queryProjectIdstr = '(' + queryProjectIdstr + ')';
        
        List<SBQQ__QuoteLine__c> qlList = Database.query(soqlProjectQuoteLinesQuery + ' where Project__c in ' + queryProjectIdstr + ' and SBQQ__ProductCode__c != \'UnscheduledBundle\' Order By fxItemNo__c asc');  
        return qlList;          
    }
    
    @AuraEnabled
    public static wrapperClass getAmounts(String projId){
        
        wrapperClass wc = new wrapperClass();
        
        Decimal lat = 0;
        Decimal mat = 0;
        Decimal tlm = 0;
        
        for(SBQQ__QuoteLine__c ql : [SELECT Labor_Amount__c, Material_Amount__c FROM SBQQ__QuoteLine__c where Project__c =: projId and SBQQ__ProductCode__c !=: 'UnscheduledBundle']){
            if(ql.Labor_Amount__c != null)
                lat += ql.Labor_Amount__c;
            
            if(ql.Material_Amount__c != null)
                mat += ql.Material_Amount__c;
            
            if(ql.Labor_Amount__c != null && ql.Material_Amount__c != null)
                tlm += ql.Labor_Amount__c + ql.Material_Amount__c;
        }
        
        wc.laborAmount = lat;
        wc.materialAmount = mat;
        wc.totalAmount = tlm;
        
        return wc;          
    }
    
    public class wrapperClass{
        @AuraEnabled public Decimal laborAmount;
        @AuraEnabled public Decimal materialAmount;
        @AuraEnabled public Decimal totalAmount;        
    }
    
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getSquawkStatus(String projId, List<String> status){
        
        String soqlProjectQuoteLinesQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__QuoteLine__c');
        String queryProjectIdstr = String.valueOf('\'') + projId + String.valueOf('\'');
        queryProjectIdstr = '(' + queryProjectIdstr + ')';
        
        String queryString = '(\'';
        
        for(String s : status)
            queryString += s + '\',\'';
        
        queryString = queryString.removeEnd(',\'') +')';
        queryString = queryString.replace('null',  '');
        system.debug('Query String: ' + queryString);
        
        List<SBQQ__QuoteLine__c> qlList = Database.query(soqlProjectQuoteLinesQuery + 
                                                         ' where Project__c in ' + queryProjectIdstr + 
                                                         ' and SBQQ__ProductCode__c != \'UnscheduledBundle\' and Add_Work_Status__c in ' + queryString + ' Order By fxItemNo__c asc');              
        return qlList;          
    }
    
    @AuraEnabled
    public static wrapperClass getStatusAmounts(String projId, List<String> status){
        
        wrapperClass wc = new wrapperClass();
        
        Decimal lat = 0;
        Decimal mat = 0;
        Decimal tlm = 0;
        
        String soqlProjectQuoteLinesQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__QuoteLine__c');
        String queryProjectIdstr = String.valueOf('\'') + projId + String.valueOf('\'');
        queryProjectIdstr = '(' + queryProjectIdstr + ')';
        
        String queryString = '(\'';
        
        for(String s : status)
            queryString += s + '\',\'';
        
        queryString = queryString.removeEnd(',\'') +')';
        queryString = queryString.replace('null',  '');
        system.debug('Query String: ' + queryString);
        
        List<SBQQ__QuoteLine__c> qlList = Database.query(soqlProjectQuoteLinesQuery + 
                                                         ' where Project__c in ' + queryProjectIdstr + 
                                                         ' and SBQQ__ProductCode__c != \'UnscheduledBundle\' and Add_Work_Status__c in ' + queryString + ' Order By fxItemNo__c asc'); 
        
        for(SBQQ__QuoteLine__c ql : qlList){
            if(ql.Labor_Amount__c != null)
                lat += ql.Labor_Amount__c;
            
            if(ql.Material_Amount__c != null)
                mat += ql.Material_Amount__c;
            
            if(ql.Labor_Amount__c != null && ql.Material_Amount__c != null)
                tlm += ql.Labor_Amount__c + ql.Material_Amount__c;
        }
        
        wc.laborAmount = lat;
        wc.materialAmount = mat;
        wc.totalAmount = tlm;
        
        return wc;          
    }
    
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getSquawkSearch(String projId, String squawkNo, String description){
        
        String soqlProjectQuoteLinesQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__QuoteLine__c');
        String queryProjectIdstr = String.valueOf('\'') + projId + String.valueOf('\'');
        queryProjectIdstr = '(' + queryProjectIdstr + ')';
        
        String queryString = soqlProjectQuoteLinesQuery + ' where Project__c in ' + queryProjectIdstr + ' and SBQQ__ProductCode__c != \'UnscheduledBundle\'';
        
        if(squawkNo != '' && squawkNo != null){
            system.debug('Squawk No: ' + squawkNo);
            queryString = queryString + ' and Name like \'%' + String.escapeSingleQuotes(squawkNo) + '%\'';
        }
        
        if(description != '' && description != null){
            system.debug('Squawk Description: ' + description);
            queryString = queryString + ' and (Job_Card_Search_1__c like \'%' + String.escapeSingleQuotes(description) + '%\'';
            queryString = queryString + ' or Job_Card_Search_2__c like \'%' + String.escapeSingleQuotes(description) + '%\')';
        }
        
        queryString += ' Order By fxItemNo__c asc';
        
        system.debug(queryString);
        List<SBQQ__QuoteLine__c> qlList = Database.query(queryString);              
        return qlList;          
    }
    
    @AuraEnabled
    public static wrapperClass getSquawkSearchAmount(String projId, String squawkNo, String description){
        
        wrapperClass wc = new wrapperClass();
        
        Decimal lat = 0;
        Decimal mat = 0;
        Decimal tlm = 0;
        
        String soqlProjectQuoteLinesQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__QuoteLine__c');
        String queryProjectIdstr = String.valueOf('\'') + projId + String.valueOf('\'');
        queryProjectIdstr = '(' + queryProjectIdstr + ')';
        
        String queryString = soqlProjectQuoteLinesQuery + ' where Project__c in ' + queryProjectIdstr + ' and SBQQ__ProductCode__c != \'UnscheduledBundle\'';
        
        if(squawkNo != '' && squawkNo != null){
            system.debug('Squawk No: ' + squawkNo);
            queryString = queryString + ' and Name like \'%' + String.escapeSingleQuotes(squawkNo) + '%\'';
        }
        
        if(description != '' && description != null){
            system.debug('Squawk Description: ' + description);
            queryString = queryString + ' and (Job_Card_Search_1__c like \'%' + String.escapeSingleQuotes(description) + '%\'';
            queryString = queryString + ' or Job_Card_Search_2__c like \'%' + String.escapeSingleQuotes(description) + '%\')';
        }
        
        queryString += ' Order By fxItemNo__c asc';
        
        system.debug(queryString);
        List<SBQQ__QuoteLine__c> qlList = Database.query(queryString); 
        
        for(SBQQ__QuoteLine__c ql : qlList){
            if(ql.Labor_Amount__c != null)
                lat += ql.Labor_Amount__c;
            
            if(ql.Material_Amount__c != null)
                mat += ql.Material_Amount__c;
            
            if(ql.Labor_Amount__c != null && ql.Material_Amount__c != null)
                tlm += ql.Labor_Amount__c + ql.Material_Amount__c;
        }
        
        wc.laborAmount = lat;
        wc.materialAmount = mat;
        wc.totalAmount = tlm;
        
        return wc;            
    }
           
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getQuoteSquawks(String quoteId){
        
        String soqlQuoteLinesQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__QuoteLine__c');
        String queryQuoteIdstr = String.valueOf('\'') + quoteId + String.valueOf('\'');
        queryQuoteIdstr = '(' + queryQuoteIdstr + ')';
        
        List<SBQQ__QuoteLine__c> qlList = Database.query(soqlQuoteLinesQuery + ' where SBQQ__Quote__c in ' + queryQuoteIdstr + ' and SBQQ__ProductCode__c != \'UnscheduledBundle\' Order By fxItemNo__c asc');  
        return qlList;          
    }
}