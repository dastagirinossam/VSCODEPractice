public class customLookUpController{
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        Profile p = [select Id,name from Profile where name = :'Customer Community Plus Login - Opportunity Agent' ];
        string prfil = p.Id;
        List < sObject > returnList = new List < sObject > ();
        //ProfileId =:prfil AND
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name,ProfileId,Email from ' +ObjectName + ' where  Name LIKE: searchKey order by createdDate DESC limit 20';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    @AuraEnabled
    public static Boolean createAgentRec(Id RecordId,User u) {
        system.debug('u>>'+u);
        boolean strng;
        list<string> mailList = new List<string>();
        Pattern p = Pattern.compile('(?s).{0,80}'); 
        mailList.add(u.Email);
        Opportunity opp = [select id,name,AccountId,Additional_Workscope1_Sub_Type_2__c,Additional_Workscope2_Sub_Type_2__c, 
                           Aircraft__c,Associated_Opportunity_01__c,Associated_Opportunity_02__c ,Associated_Opportunity_03__c ,Associated_Opportunity_04__c ,
                           Associated_Opportunity_05__c ,Associated_Opportunity_06__c,Associated_Opportunity_07__c,Associated_Opportunity_08__c ,closeDate ,Contact__c,CustomerName__c,                        
                           Design_Activity_Status__c,Designer_Name__c ,Equipment__c,Facility__c,New_Probability__c ,InputDate__c ,Last_Customer_Communication_Date__c,                
                           Management_Company__c,MasterOpportunitylookup__c,Operator__c,OutputDate__c ,Product_Line__c,QuoteDelivery__c,Quote_Expected_Delivery_Date__c,QuoterName__c,
                           Base_Quote_Number__c ,QuoteRequiredBy__c,Rental_Needed_Date__c,RFQStatus__c,RFQ_Submitted_Date__c,StageName,SubType__c,SubType2__c,Sub_Type_3__c,Type,What_s_Needed_to_Win__c  
                           from Opportunity 
                           where Id =: RecordId];
        list<Agent_Opportunity__c> aos = [select Id,name from Agent_Opportunity__c where Opportunity__c =: RecordId ];
        system.debug('opp.Name.length()>>'+ opp.Name.length());
        
        if(aos.isEmpty()){
            strng = True;
            Agent_Opportunity__c aop = new Agent_Opportunity__c();
            aop.OwnerId = u.Id;
            aop.Account__c = opp.AccountId;
            aop.Additional_Workscope1_Sub_Type_2__c    =    opp.Additional_Workscope1_Sub_Type_2__c  ;
            aop.Additional_Workscope2_Sub_Type_2__c    =    opp.Additional_Workscope2_Sub_Type_2__c  ;
            aop.Aircraft__c                            =    opp.Aircraft__c                          ;
            aop.Associated_Opportunity_01__c           =    opp.Associated_Opportunity_01__c         ;
            aop.Associated_Opportunity_02__c  =             opp.Associated_Opportunity_02__c         ;
            aop.Associated_Opportunity_03__c =              opp.Associated_Opportunity_03__c         ;
            aop.Associated_Opportunity_04__c =              opp.Associated_Opportunity_04__c         ;
            aop.Associated_Opportunity_05__c =              opp.Associated_Opportunity_05__c         ;
            aop.Associated_Opportunity_06__c=               opp.Associated_Opportunity_06__c         ;
            aop.Associated_Opportunity_07__c=               opp.Associated_Opportunity_07__c         ;
            aop.Associated_Opportunity_08__c =              opp.Associated_Opportunity_08__c         ;
            aop.Close_Date__c =                             opp.closeDate                            ;
            aop.Contact__c  =                               opp.Contact__c                           ;
            aop.CustomerName__c=                            opp.CustomerName__c                      ;
            aop.Design_Activity_Status__c=                  opp.Design_Activity_Status__c            ;
            aop.Designer_Name__c =                          opp.Designer_Name__c                     ;
            aop.Equipment__c =                              opp.Equipment__c                         ;
            aop.Facility__c=                                opp.Facility__c                          ;
            aop.New_Probability__c       =                  opp.New_Probability__c                   ;
            aop.Input_Date__c             =                 opp.InputDate__c                         ;
            aop.Last_Customer_Communication_Date__c =       opp.Last_Customer_Communication_Date__c  ;
            aop.Management_Company__c                 =     opp.Management_Company__c                ;
            aop.Master_Opportunity_Name__c             =    opp.MasterOpportunitylookup__c           ;
            aop.Operator__c                             =   opp.Operator__c                          ;
            aop.Opportunity__c                         =    opp.Id                                   ;
            if(opp.Name.length() > 80){
            aop.Name                                   =    opp.Name.substring(0, 80)                ;
            }else{
                aop.Name                                   =    opp.Name;
            }
                    
            aop.OutputDate__c =                             opp.OutputDate__c                        ;
            aop.Product_Line__c                       =     opp.Product_Line__c                      ;
            aop.Quote_Delivery__c					=		opp.QuoteDelivery__c					 ;						
            aop.Quote_Expected_Delivery_Date__c        =    opp.Quote_Expected_Delivery_Date__c      ;
            aop.Quote_Name__c                          =    opp.QuoterName__c                        ;
            aop.Quote_Number__c                        =    opp.Base_Quote_Number__c                 ;
            aop.Quote_Required_By__c                   =    opp.QuoteRequiredBy__c                   ;
            aop.Rental_Needed_Date__c                  =    opp.Rental_Needed_Date__c                ;
            aop.RFQ_Status__c                          =    opp.RFQStatus__c                         ;
            aop.RFQ_Submitted_Date__c                  =    opp.RFQ_Submitted_Date__c                ;
            aop.Stage__c                               =    opp.StageName                            ;
            aop.Sub_Type__c                            =    opp.SubType__c                           ;
            aop.Sub_Type_2__c                          =    opp.SubType2__c                          ;
            aop.Sub_Type_3__c                          =    opp.Sub_Type_3__c                        ;
            aop.Type__c                                =    opp.Type                                 ;
            aop.What_s_Needed_to_Win__c                =    opp.What_s_Needed_to_Win__c              ;
            insert aop;
            string sBody = '<html><body><p>https://www.mystandardaero.com/Customer/s/opportunity-detail-page/'+aop.Id +' </p></n><p> Name :'+ aop.Name   +'</p></body></html>';
            system.debug('Agent Opportunity Record>>>'+aop);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(mailList);
            message.subject = 'Opportunity is assigned you as owner';
            message.plainTextBody = 'Opportunity Record is assigned Refer link below for more details';
            message.htmlBody = u.Name + ':' + 
                '<br/><br/>An Opportunity is assigned to you ' + aop.name + '. <br/><br/>' +
                'Click <a href="https://www.mystandardaero.com/Customer/s/opportunity-detail-page/'+ 'aop.Id ">here</a> to goto Agent Opportunity.<br/><br/>' + 
                'Regards,<br/><br/>' +
                userinfo.getName() + '<br/>' +
                userinfo.getUserEmail() + '<br/>'; 
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
        } else{
            strng = false;
        }
        return strng;
    }
}