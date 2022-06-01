public without sharing class QuotaController {
    
    @AuraEnabled
    public static  QuotaWrapper QPerformance()
    {
        String usrId = UserInfo.getUserId() ;
        Map<String, Schema.SObjectField> objfieldMap = Performance__c.sObjectType.getDescribe().fields.getMap();
        String strfieldName = ''; 
        for(Schema.SObjectField Field : objfieldMap.Values())
        {
            Schema.DescribeFieldResult fieldResult = Field.getDescribe();
            strfieldName += fieldResult.getName() + ',';
        }
        
        
        strfieldName = strfieldName.substring(0, strfieldName.length()-1);
        strfieldName +=' , Quota_Sales_Employee__r.Name ';
        strfieldName +=', Quota_Master__r.Name';
        
        System.debug('===strfieldName==='+strfieldName);
         List<Performance__c> perList = new List<Performance__c>();
        
        
         perList = Database.query('select ' + strfieldName + 
                                                      ' from Performance__c where '+ 'Quota_Sales_Employee__r.User__c =: usrId' );
        System.debug('======'+perList); 
        
        QuotaWrapper pw = new QuotaWrapper();
        pw.perf = perList;
        return pw;
    }  
    @AuraEnabled
    public static  QuotaWrapper QPerformanceRecord(String perId){
        
        Map<String, Schema.SObjectField> objfieldMap = Performance__c.sObjectType.getDescribe().fields.getMap();
        String strfieldName = ''; 
        for(Schema.SObjectField Field : objfieldMap.Values())
        {
            Schema.DescribeFieldResult fieldResult = Field.getDescribe();
            strfieldName += fieldResult.getName() + ',';
        } 
        strfieldName = strfieldName.substring(0, strfieldName.length()-1);    
        strfieldName +=' , Quota_Sales_Employee__r.Name ';
        strfieldName +=', Quota_Master__r.Name';
        List<Performance__c> perList2 = Database.query('select ' + strfieldName + 
                                                       ' from Performance__c where '+ 'ID =: perId');
        System.debug('===perList2==='+perList2);
        QuotaWrapper pr = new QuotaWrapper();
        pr.perf2 = perList2;
        return pr;
        
    } 
    @AuraEnabled
    public static  QuotaWrapper QEmpRecord(String empId){
        
        Map<String, Schema.SObjectField> objfieldMap = Quota_Sales_Employee__c.sObjectType.getDescribe().fields.getMap();
        String strfieldName = ''; 
        for(Schema.SObjectField Field : objfieldMap.Values())
        {
            Schema.DescribeFieldResult fieldResult = Field.getDescribe();
            strfieldName += fieldResult.getName() + ',';
        } 
        strfieldName = strfieldName.substring(0, strfieldName.length()-1);    
        strfieldName +=', Quota_Sales_Region__r.Name';
        List<Quota_Sales_Employee__c> empList = Database.query('select ' + strfieldName + 
                                                               ' from Quota_Sales_Employee__c where '+ 'ID =: empId');
        System.debug('===empList==='+empList);
        QuotaWrapper em = new QuotaWrapper();
        em.emp = empList;
        return em;
        
    } 
    @AuraEnabled
    public static  QuotaWrapper QPerformance1(String year)
    {
        String usrId = UserInfo.getUserId() ;
        
        Map<String, Schema.SObjectField> objfieldMap = Performance__c.sObjectType.getDescribe().fields.getMap();
        String strfieldName = ''; 
        for(Schema.SObjectField Field : objfieldMap.Values())
        {
            Schema.DescribeFieldResult fieldResult = Field.getDescribe();
            strfieldName += fieldResult.getName() + ',';
        }
        
        strfieldName = strfieldName.substring(0, strfieldName.length()-1);
        strfieldName +=' , Quota_Sales_Employee__r.Name ';
        strfieldName +=', Quota_Master__r.Name';
        
        System.debug('===strfieldName==='+strfieldName);
        List<Performance__c> perList = new List<Performance__c>();
        
        if(year == 'All' || year == null){
            
        perList= Database.query('select ' + strfieldName + 
                                                      ' from Performance__c where '+ 'Quota_Sales_Employee__r.User__c =: usrId ');
        }
        else{
            

        perList = Database.query('select ' + strfieldName + 
                                                      ' from Performance__c where '+ 'Quota_Sales_Employee__r.User__c =: usrId and Year__c=:year' );
        }
        System.debug('======'+perList); 
        
        QuotaWrapper pw = new QuotaWrapper();
        pw.perf = perList;
        return pw;
    }
      @AuraEnabled
     Public static List<QuotaAnuallWrapper> quotaPerformanceYearly(string year){
       
        List<QuotaAnuallWrapper> QAWList= new List<QuotaAnuallWrapper>();
        
        
        String usrId = UserInfo.getUserId() ;
        user u = [select Id,Name from User where Id =:usrId];
        system.debug('usrId>>'+ usrId);
        Map<String, Schema.SObjectField> objfieldMap = Performance__c.sObjectType.getDescribe().fields.getMap();
        String strfieldName = ''; 
        for(Schema.SObjectField Field : objfieldMap.Values())
        {
            Schema.DescribeFieldResult fieldResult = Field.getDescribe();
            strfieldName += fieldResult.getName() + ',';
        }
        
        strfieldName = strfieldName.substring(0, strfieldName.length()-1);
        strfieldName +=' , Quota_Sales_Employee__r.Name ';
        strfieldName +=', Quota_Master__r.Name';
        
        
        List<Performance__c> perList = new List<Performance__c>();
        
        if(year == 'All' || year == null){
            QuotaAnuallWrapper QAW = new QuotaAnuallWrapper();    
            
            AggregateResult[] perList1= [SELECT Quota_Sales_Employee__c,SUM(Actual_Revenue_Engines__c) ARES,sum(Quota_Revenue_Engines__c) QRES,sum(Performance_Revenue_Engines__c) PRES,
                                         sum(Actual_Margin_Engines__c) AMES,sum(Performance_Margin_Engines__c)PMES,
                                         sum(Actual_Margin_Non_Engine__c) AMNES,sum(Quota_Margin_Non_Engine__c) QMNES,sum(Performance_Margin_Non_Engine__c) PMNES,
                                         sum(Performance_Revenue_Non_Engine__c) PRNES,sum(Actual_Revenue_TPE_All__c) ARTAS,sum(Quota_Revenue_TPE_All__c) QRTA,
                                         sum(Performance_Revenue_TPE_All__c) PETSA,sum(Actual_Margin_TPE_All__c) AMTSA,sum(Quota_Margin_TPE_All__c) QMTAS,
                                         sum(Performance_Margin_TPE_ALL__c) PMTAS,sum(Actual_Revenue_Total__c) ARTS,sum(Quota_Revenue_Total__c) QRTS,
                                         sum(Performance_Revenue_Total__c) PRTS,sum(Actual_Margin_Total__c) AMTS,sum(Quota_Margin_Total__c) QMTS,sum(Performance_Margin_Total__c) pmt                                         
                                         FROM  Performance__c where Quota_Sales_Employee__r.User__c =: usrId  GROUP BY Quota_Sales_Employee__c];
            
            system.debug('perList1>>'+ perList1);
            for(AggregateResult perf : perList1){
                QAW.Name = 'TEST';
                QAW.ActualRevenueEngines  =(Decimal) perf.get('ARES') ;
                QAW.QuotaRevenueEngines =  (Decimal)perf.get('QRES');
                QAW.PerformanceRevenueEngines =(Decimal)perf.get('PRES');
                
                QAW.ActualMarginEngines = (Decimal)perf.get('AMES'); 
                QAW.QuotaMarginEngines = (Decimal)perf.get('PMES');
                QAW.PerformanceMarginEngines =(Decimal) perf.get('AMNES');
                
                QAW.ActualMarginNonEngine = (Decimal)perf.get('QMNES'); 
                QAW.QuotaMarginNonEngine = (Decimal)perf.get('PMNES'); 
                QAW.PerformanceMarginNonEngine = (Decimal)perf.get('PRNES');
                QAW.PerformanceMarginTotal= (Decimal)perf.get('pmt');
                
                QAW.ActualRevenueNonEngine =(Decimal) perf.get('ARTAS'); 
                QAW.QuotaRevenueNonEngine = (Decimal)perf.get('QRTA'); 
                QAW.PerformanceRevenueNonEngine = (Decimal)perf.get('PETSA'); 
                
                QAW.ActualRevenueTPEAll = (Decimal)perf.get('AMTSA');
                QAW.QuotaRevenueTPEAll = (Decimal)perf.get('QMTAS');
                QAW.PerformanceRevenueTPEAll =(Decimal) perf.get('PMTAS');
                
                QAW.ActualMarginTPEAll =(Decimal) perf.get('ARTS');
                QAW.QuotaMarginTPEAll =(Decimal) perf.get('QRTS'); 
                QAW.PerformanceMarginTPEAll  =(Decimal) perf.get('PRTS');
                
                QAW.ActualRevenueTotal = (Decimal)perf.get('AMTS');
                QAW.QuotaRevenueTotal = (Decimal)perf.get('QMTS');
             system.debug('revenue' + perf.get('PRTS'));   
            }
            
            
            QAWList.add(QAW); 
            
        }
        else{
            QuotaAnuallWrapper QAW = new QuotaAnuallWrapper();  
            Quota_Sales_Employee__c qutslemp = [select Id,name from Quota_Sales_Employee__c where User__c =: usrId AND Year__c =: year];
         /*   perList = Database.query('select ' + strfieldName + 
                                     ' from Performance__c where '+ 'Quota_Sales_Employee__r.User__c =: usrId and Year__c=:year' );*/
            AggregateResult[] perList1 = [SELECT Quota_Sales_Employee__c,
                                          SUM(Actual_Revenue_Engines__c) ARES,
                                          sum(Quota_Revenue_Engines__c) QRES,
                                          sum(Performance_Revenue_Engines__c) PRES,                              
                                          sum(Quota_Margin_Engines__c) QMES,
                                          sum(Actual_Margin_Engines__c) AMES,
                                          sum(Performance_Margin_Engines__c)PMES,							  
                                          sum(Actual_Revenue_Non_Engine__c) ARNES,
                                          sum(Quota_Revenue_Non_Engine__c) QRNES,
                                          sum(Performance_Revenue_Non_Engine__c) PRNES,                                         
                                          sum(Actual_Margin_Non_Engine__c) AMNES,
                                          sum(Quota_Margin_Non_Engine__c) QMNES,
                                          sum(Performance_Margin_Non_Engine__c) PMNES,							   
                                          sum(Actual_Revenue_TPE_All__c) ARTA,
                                          sum(Quota_Revenue_TPE_All__c) QRTA,
                                          sum(Performance_Revenue_TPE_All__c) PETSA,							  
                                          sum(Actual_Margin_TPE_All__c) AMTSA,
                                          sum(Quota_Margin_TPE_All__c) QMTAS,
                                          sum(Performance_Margin_TPE_ALL__c) PMTAS,							  
                                          sum(Actual_Revenue_Total__c) ARTS,
                                          sum(Quota_Revenue_Total__c) QRTS,
                                          sum(Performance_Revenue_Total__c) PRTS,							  
                                          sum(Actual_Margin_Total__c) AMTS,
                                          sum(Quota_Margin_Total__c) QMTS,
                                          sum(Performance_Margin_Total__c) pmt  ,
                                          Sum(Actual_Revenue_TFE_731__c) ARTFE731,
                                          SUM(Quota_Revenue_TFE731__c)  QRTFE731,
                                          SUM(Performance_Revenue_TFE731__c) PRTFE731,							   
                                          SUM(Actual_Margin_TFE_731__c) AMTFE731,
                                          sum(Quota_Margin_TFE731__c) QMTFE731, 
                                          sum(Performance_Margin_TFE731__c) PMTFE731,							   
                                          sum(Actual_Revenue_Airframe__c) ARA,
                                          sum(Quota_Revenue_Airframe__c) QRA,
                                          sum(Performance_Revenue_Airframe__c) PRA,							   
                                          sum(Actual_Margin_Airframe__c) AMA,
                                          sum(Quota_Margin_Airframe__c) QMA,
                                          sum(Performance_Margin_Airframe__c) PMA,							   
                                          sum(Actual_Revenue_HTF__c) ARHTF,
                                          sum(Quota_Revenue_HTF__c) QRHTF,
                                          sum(Performance_Revenue_HTF__c) PRHTF,							   
                                          sum(Actual_Margin_HTF__c) AMHTF,
                                          sum(Quota_Margin_HTF__c) QMHTF,
                                          sum(Performance_Margin_HTF__c)PMHTF,							   
                                          sum(Actual_Revenue_CFE__c) ARCFE,
                                          sum(Quota_Revenue_CFE738__c) QRCFE,
                                          sum(Performance_Revenue_CFE738__c) PRCFE,							   
                                          sum(Actual_Margin_CFE__c) AMCFE,
                                          sum(Quota_Margin_CFE738__c) QMCFE,
                                          sum(Performance_Margin_CFE738__c) PMCFE,							   
                                          sum(Actual_Revenue_TPE_331__c) ARTPE,
                                          sum(Quota_Revenue_TPE_All__c) QRTPE,
                                          sum(Performance_Revenue_TPE_All__c) PRTPE,							   
                                          sum(Actual_Margin_TPE_All__c) AMTPE,
                                          sum(Quota_Margin_TPE_All__c) QMTPE,
                                          sum(Performance_Margin_TPE_ALL__c) PMTPE,							   
                                          sum(Actual_Revenue_PW_300__c) ARPW300,
                                          sum(Quota_Revenue_PWC__c) QRPWC,
                                          sum(Performance_Revenue_PWC__c) PRPWC,							   
                                          sum(Actual_Margin_PW_300__c) AMPW300,
                                          sum(Quota_Margin_PWC__c) QMPWC,
                                          sum(Performance_Margin_PWC__c) PMPWC,							   
                                          sum(Actual_Revenue_PW300_Offload__c) ARPWOFF300,
                                          sum(Quota_Revenue_PW300_Offload__c) QRPWOFF,
                                          sum(Performance_Revenue_PW300_Offload__c) PRPWOFF,							   
                                          sum(Actual_Margin_PW300_Offload__c) AMPWOFF300,
                                          sum(Quota_Margin_PW300_Offload__c) QMPWOFF,
                                          sum(Performance_Margin_PW300_Offload__c) PMPWVOFF,							   
                                          sum(Actual_Revenue_Other_Engines__c) AROE,
                                          sum(Quota_Revenue_Other_Engine__c) QROE,
                                          sum(Performance_Revenue_Other_Engine__c) PROE,							   
                                          sum(Actual_Margin_Other_Engines__c) AMOE,
                                          sum(Quota_Margin_Other_Engine__c) QMOE,
                                          sum(Performance_Margin_Other_Engine__c) PMOE,							   
                                          sum(Actual_Revenue_APU__c) ARAPU,
                                          sum(Quota_Revenue_APU__c) QRAPU,
                                          sum(Performance_Revenue_APU__c) PRAPU,               
                                          sum(Actual_Margin_APU__c) AMAPU,
                                          sum(Quota_Margin_APU__c) QMAPU,
                                          sum(Performance_Margin_APU__c) PMAPU,							   
                                          sum(Actual_Revenue_AE3007__c) ARAE3007,
                                          sum(Quota_Revenue_AE3007__c) QRAE3007,
                                          sum(Performance_Revenue_AE3007__c) PRAR3007
                                          FROM  Performance__c
                                          where Quota_Sales_Employee__r.User__c =: usrId and Year__c=:year
                                          GROUP BY Quota_Sales_Employee__c,Quota_Sales_Employee__r.User__c ];
            
            AggregateResult[] perList2 = [SELECT Quota_Sales_Employee__c,
                                          sum(Actual_Margin_AE3007__c) AMAE3007,
                                          sum(Quota_Margin_AE3007__c) QMAE3007,
                                          sum(Performance_Margin_AE3007__c) PMAE3007,                 
                                          sum(Actual_Revenue_Engine_Exchange__c) AREE,
                                          sum(Quota_Revenue_Engine_Exchange__c) QREE,
                                          sum(Performance_Revenue_Engine_Exchange__c) PREE,                              
                                          sum(Actual_Margin_Engine_Exchange__c) AMEE,
                                          sum(Quota_Margin_Engine_Exchange__c) QMEE,
                                          sum(Performance_Margin_Engine_Exchange__c) PMEE,                              
                                          sum(Actual_Revenue_Avionics__c) ARA,
                                          sum(Quota_Revenue_Avionics__c) QRA,
                                          sum(Performance_Revenue_Avionics__c) PRA,                               
                                          sum(Actual_Margin_Avionics__c) AMA,
                                          sum(Quota_Margin_Avionics__c) QMA,
                                          sum(Performance_Margin_Avionics__c) PMA,                             
                                          sum(Actual_Revenue_Engines_Split__c) ARES,
                                          sum(Actual_Revenue_Non_Engine_Splits__c) ARNES,
                                          sum(Actual_Revenue_Other__c) ARO,
                                          Sum(Actual_Revenue_Interior_Mod__c) ARIM,
                                          sum(Quota_Revenue_Interior_Mods__c) QRIM,
                                          sum(Performance_Revenue_Interior_Mods__c) PRIM,                             
                                          sum(Actual_Margin_Engines_Splits__c) AMES,
                                          sum(Actual_Margin_Non_Engine_Splits__c) AMNES,
                                          sum(Actual_Margin_Other__c) AMO,
                                          sum(Actual_Margin_Interior_Mod__c) AMIM,
                                          sum(Quota_Margin_Interior_Mods__c) QMIM,
                                          sum(Performance_Margin_Interior_Mods__c) PMIM,                              
                                          sum(Actual_Revenue_Paint__c) ARP,
                                          sum(Quota_Revenue_Paint__c) QRP,
                                          sum(Performance_Revenue_Paint__c) PRP,                              
                                          sum(Actual_Margin_Paint__c)AMP,
                                          sum(Quota_Margin_Paint__c) QMP,
                                          sum(Performance_Margin_Paint__c) PMP,                             
                                          sum(Actual_Revenue_ODA__c) ARODA,
                                          sum(Quota_Revenue_ODA__c) QRODA,
                                          sum(Performance_Revenue_ODA__c) PRODA,                             
                                          sum(Actual_Margin_ODA__c) AMODA,
                                          sum(Quota_Margin_ODA__c) QMODA,
                                          sum(Performance_Margin_ODA__c)PMODA,
                                          sum(Actual_Revenue_PPE__c) ARPPE,
                                          sum(Quota_Revenue_PPE__c) QRPPE,
                                          sum(Performance_Revenue_PPE__c) PRPPE,                             
                                          sum(Actual_Margin_PPE__c) AMPPE,
                                          sum(Quota_Margin_PPE__c)QMPPE,
                                          sum(Performance_Margin_PPE__c) PMPPE
                                          FROM  Performance__c 
                                          where Quota_Sales_Employee__r.User__c =: usrId and Year__c=:year
                                          GROUP BY Quota_Sales_Employee__c,Quota_Sales_Employee__r.User__c];
          
           QAW.Name = u.Name + ' ' + Year;
            QAW.Year = Year;
            QAW.salesEMPName = qutslemp.Name;
            QAW.salesId = qutslemp.Id;
            QAW.ActualMarginAE3007= (Decimal) perList2[0].get('AMAE3007');
                QAW.QuotaMarginAE3007= (Decimal) perList2[0].get('QMAE3007');
                QAW.PerformanceMarginAE3007 = (Decimal) perList2[0].get('PMAE3007'); 
                
                QAW.ActualRevenueEngineExchange= (Decimal) perList2[0].get('AREE');
                QAW.QuotaRevenueEngineExchange= (Decimal) perList2[0].get('QREE');
                QAW.PerformanceRevenueEngineExchange= (Decimal) perList2[0].get('PREE');
                    
                QAW.ActualMarginEngineExchange= (Decimal) perList2[0].get('AMEE');
                QAW.QuotaMarginEngineExchange= (Decimal) perList2[0].get('QMEE');
                QAW.PerformanceMarginEngineExchange = (Decimal) perList2[0].get('PMEE');
                
               QAW.ActualRevenueAvionics=(Decimal) perList2[0].get('ARA');
               QAW.QuotaRevenueAvionics=(Decimal) perList2[0].get('QRA');
               QAW.PerformanceRevenueAvionics=(Decimal) perList2[0].get('PRA');
                 
              QAW.ActualMarginAvionics=(Decimal) perList2[0].get('AMA');
              QAW.QuotaMarginAvionics=(Decimal) perList2[0].get('QMA');
              QAW.PerformanceMarginAvionics =(Decimal) perList2[0].get('PMA');
                
             QAW.ActualRevenueEngineSplits=(Decimal) perList2[0].get('ARES');
             QAW.ActualRevenueNonEngineSplits=(Decimal) perList2[0].get('ARNES');
             QAW.ActualRevenueOther=(Decimal) perList2[0].get('ARO');
                
             QAW.ActualMarginEnginesSplits=(Decimal) perList2[0].get('AMES');
             QAW.ActualMarginNonEngineSplits=(Decimal) perList2[0].get('AMNES');
             QAW.ActualMarginOther=(Decimal) perList2[0].get('AMO');    
                 
             QAW.ActualRevenueInteriorMods=(Decimal) perList2[0].get('ARIM');
             QAW.QuotaRevenueInteriorMods=(Decimal) perList2[0].get('QRIM');
             QAW.PerformanceRevenueInteriorMods=(Decimal) perList2[0].get('PRIM');
                 
             QAW.ActualMarginInteriorMods=(Decimal) perList2[0].get('AMIM');
             QAW.QuotaMarginInteriorMods=(Decimal) perList2[0].get('QMIM');
             QAW.PerformanceMarginInteriorMods=(Decimal) perList2[0].get('PMIM');
                
             QAW.ActualRevenuePaint=(Decimal) perList2[0].get('ARP');
             QAW.QuotaRevenuePaint=(Decimal) perList2[0].get('QRP');
             QAW.PerformanceRevenuePaint=(Decimal) perList2[0].get('PRP');
                 
             QAW.ActualMarginPaint=(Decimal) perList2[0].get('AMP');
             QAW.QuotaMarginPaint=(Decimal) perList2[0].get('QMP');
             QAW.PerformanceMarginPaint=(Decimal) perList2[0].get('PMP'); 
                 
             QAW.ActualRevenueODA=(Decimal) perList2[0].get('ARODA');
             QAW.QuotaRevenueODA=(Decimal) perList2[0].get('QRODA');
             QAW.PerformanceRevenueODA=(Decimal) perList2[0].get('PRODA');
                 
             QAW.ActualMarginODA=(Decimal) perList2[0].get('AMODA');
             QAW.QuotaMarginODA=(Decimal) perList2[0].get('QMODA');
             QAW.PerformanceMarginODA=(Decimal) perList2[0].get('PMODA');
                 
             QAW.ActualRevenuePPE=(Decimal) perList2[0].get('ARPPE');
             QAW.QuotaRevenuePPE=(Decimal) perList2[0].get('QRPPE');
             QAW.PerformanceRevenuePPE=(Decimal) perList2[0].get('PRPPE');
             
             QAW.ActualMarginPPE=(Decimal) perList2[0].get('AMPPE');
             QAW.ActualMarginPPE=(Decimal) perList2[0].get('QMPPE');
             QAW.PerformanceMarginPPE=(Decimal) perList2[0].get('PMPPE');    
                
                
             
                QAW.ActualRevenueEngines  =(Decimal)  perList1[0].get('ARES') ;
                QAW.QuotaRevenueEngines =  (Decimal) perList1[0].get('QRES');
                QAW.PerformanceRevenueEngines =(Decimal) perList1[0].get('PRES');
                
                QAW.ActualMarginEngines = (Decimal) perList1[0].get('AMES'); 
                QAW.QuotaMarginEngines = (Decimal) perList1[0].get('PMES');
                QAW.PerformanceMarginEngines =(Decimal)  perList1[0].get('AMNES');
                
                QAW.ActualMarginNonEngine = (Decimal) perList1[0].get('QMNES'); 
                QAW.QuotaMarginNonEngine = (Decimal) perList1[0].get('PMNES');  
                QAW.PerformanceMarginNonEngine = (Decimal) perList1[0].get('PRNES');
                QAW.PerformanceMarginTotal= (Decimal) perList1[0].get('pmt');
                
                QAW.ActualRevenueNonEngine =(Decimal)  perList1[0].get('ARTA'); 
                QAW.QuotaRevenueNonEngine = (Decimal) perList1[0].get('QRTA'); 
                QAW.PerformanceRevenueNonEngine = (Decimal) perList1[0].get('PETSA'); 
                
                QAW.ActualRevenueTPEAll = (Decimal) perList1[0].get('AMTSA');
                QAW.QuotaRevenueTPEAll = (Decimal) perList1[0].get('QMTAS');
                QAW.PerformanceRevenueTPEAll =(Decimal)  perList1[0].get('PMTAS');
                
                QAW.ActualMarginTPEAll =(Decimal)  perList1[0].get('ARTS');
                QAW.QuotaMarginTPEAll =(Decimal)  perList1[0].get('QRTS'); 
                QAW.PerformanceMarginTPEAll  =(Decimal)  perList1[0].get('PRTS'); 
                
                QAW.ActualRevenueTotal = (Decimal) perList1[0].get('AMTS');
                QAW.QuotaRevenueTotal = (Decimal) perList1[0].get('QMTS');
                QAW.PerformanceRevenueTotal= (Decimal) perList1[0].get('PRTS');
                
                QAW.ActualMarginTotal= (Decimal) perList1[0].get('AMTS');
                QAW.QuotaMarginTotal=(Decimal) perList1[0].get('QMTS');
                QAW.PerformanceMarginTotal= (Decimal) perList1[0].get('PMT');
                
                QAW.ActualRevenueTFE731= (Decimal) perList1[0].get('ARTFE731');
                QAW.QuotaRevenueTFE731=(Decimal) perList1[0].get('QRTFE731');
                QAW.PerformanceRevenueTFE731=(Decimal) perList1[0].get('PRTFE731');
                
                QAW.ActualMarginTFE731=(Decimal) perList1[0].get('AMTFE731');
                QAW.QuotaMarginTFE731=(Decimal) perList1[0].get('QMTFE731');
                QAW.PerformanceMarginTFE731=(Decimal) perList1[0].get('PMTFE731');
                
                QAW.ActualRevenueAirframe=(Decimal) perList1[0].get('ARA');
                QAW.QuotaRevenueAirFrame=(Decimal) perList1[0].get('QRA');
                QAW.PerformanceRevenueAirframe=(Decimal) perList1[0].get('PRA');
                
                QAW.ActualMarginAirframe=(Decimal) perList1[0].get('AMA');
                QAW.QuotaMarginAirframe=(Decimal) perList1[0].get('QMA');
                QAW.PerformanceMarginAirframe=(Decimal) perList1[0].get('PMA');
                
                QAW.ActualRevenueHTF=(Decimal) perList1[0].get('ARHTF');
                QAW.QuotaRevenueHTF=(Decimal) perList1[0].get('QRHTF');
                QAW.PerformanceRevenueHTF=(Decimal) perList1[0].get('PRHTF');
                
                QAW.ActualMarginHTF=(Decimal) perList1[0].get('AMHTF');
                QAW.QuotaMarginHTF=(Decimal) perList1[0].get('QMHTF');
                QAW.PerformanceMarginHTF=(Decimal) perList1[0].get('PMHTF');
                 
               QAW.ActualRevenueCFE738=(Decimal) perList1[0].get('ARCFE');
               QAW.QuotaRevenueCFE738=(Decimal) perList1[0].get('QRCFE');
               QAW.PerformanceRevenueCFE738=(Decimal) perList1[0].get('PRCFE');
                    
               QAW.ActualMarginCFE738=(Decimal) perList1[0].get('AMCFE');
               QAW.QuotaMarginCFE738=(Decimal) perList1[0].get('QMCFE');
               QAW.PerformanceMarginCFE738=(Decimal) perList1[0].get('PMCFE');
                    
               QAW.ActualRevenueTPEAll=(Decimal) perList1[0].get('ARTPE');
               QAW.QuotaRevenueTPEAll=(Decimal) perList1[0].get('QRTPE');
               QAW.PerformanceRevenueTPEAll=(Decimal) perList1[0].get('PRTPE');
                
               QAW.ActualMarginTPEAll=(Decimal) perList1[0].get('AMTPE');
               QAW.QuotaMarginTPEAll=(Decimal) perList1[0].get('QMTPE');
               QAW.PerformanceRevenueTPEAll=(Decimal) perList1[0].get('PMTPE');
                
               QAW.ActualRevenuePW300=(Decimal) perList1[0].get('ARPW300');
               QAW.QuotaRevenuePW300=(Decimal) perList1[0].get('QRPWC');
               QAW.PerformanceRevenuePW300=(Decimal) perList1[0].get('PRPWC');
                   
               QAW.ActualMarginPW300=(Decimal) perList1[0].get('AMPW300');
               QAW.QuotaMarginPW300=(Decimal) perList1[0].get('QRPWC');
               QAW.PerformanceMarginPW300=(Decimal) perList1[0].get('PRPWC');
                   
               QAW.ActualRevenuePW300Offload=(Decimal) perList1[0].get('ARPWOFF300');
               QAW.QuotaRevenuePW300Offload=(Decimal) perList1[0].get('QRPWOFF');
               QAW.PerformanceRevenuePW300Offload=(Decimal) perList1[0].get('PRPWOFF');
               
                                                                    
              QAW.ActualMarginPW300Offload=(Decimal) perList1[0].get('AMPWOFF300');
              QAW.QuotaMarginPW300Offload=(Decimal) perList1[0].get('QMPWOFF');
              QAW.PerformanceMarginPW300Offload =(Decimal) perList1[0].get('PRPWOFF');
                
             QAW.ActualRevenueOtherEngine=(Decimal) perList1[0].get('AROE');
             QAW.QuotaRevenueOtherEngine=(Decimal) perList1[0].get('QROE');
             QAW.PerformanceRevenueOtherEngine=(Decimal) perList1[0].get('PROE');
                 
             QAW.ActualMarginOtherEngine=(Decimal) perList1[0].get('AMOE');
             QAW.QuotaMarginOtherEngine=(Decimal) perList1[0].get('QMOE');
             QAW.PerformanceMarginOtherEngine=(Decimal) perList1[0].get('PMOE');
                 
             QAW.ActualRevenueAPU=(Decimal) perList1[0].get('ARAPU');
             QAW.QuotaRevenueAPU=(Decimal) perList1[0].get('QRAPU');
             QAW.PerformanceRevenueAPU=(Decimal) perList1[0].get('PRAPU');
                 
             QAW.ActualMarginAPU=(Decimal) perList1[0].get('AMAPU');
             QAW.QuotaMarginAPU=(Decimal) perList1[0].get('QMAPU');
             QAW.PerformanceMarginAPU=(Decimal) perList1[0].get('PMAPU');
             
             QAW.ActualRevenueAE3007=(Decimal) perList1[0].get('ARAE3007');
             QAW.QuotaRevenueAE3007=(Decimal) perList1[0].get('QRAE3007');
             QAW.PerformanceRevenueAE3007 =(Decimal) perList1[0].get('PRAR3007');  
                
                                                    
            
            system.debug(QAW);
            QAWList.add(QAW);
            
        }
        
        system.debug('QAWList>>'+ QAWList);
        return QAWList;
        
        
    }
    
}