global class PPE_Form {
    
    public MPM4_BASE__Milestone1_Project__c proj {get; private set; }
    private static Integer FIRST_BREAK = 11;
    private static Integer SUBSEQ_BREAKS = 11; 
    public List<SBQQ__QuoteLine__c[]> pageBrokenSquawkLines {get; private set; }
    public List<SBQQ__QuoteLine__c> sqk {get;set;}
    private String soql {get;set;}
    
    public PPE_Form(ApexPages.StandardController controller) {
        this.proj = (MPM4_BASE__Milestone1_Project__c)controller.getRecord();        
    }
    
    public static List <SBQQ__QuoteLine__c> getSellerProjectQuoteLines() {   
        return [Select id, Name, Add_Work_Status__c, Job_Card_Description__c, Approved_By__c, SBQQ__Quote__r.Name
                from SBQQ__QuoteLine__c 
                where Project__c =: ApexPages.currentPage().getParameters().get('id') and (Add_Work_Status__c !=  '' and Add_Work_Status__c != 'Deffered to Buyer') Order BY Name asc
               ];  
    }
    
    public static List <SBQQ__QuoteLine__c> getBuyerProjectQuoteLines() {   
        return [Select id, Name, Add_Work_Status__c, Job_Card_Description__c, Approved_By__c, SBQQ__Quote__r.Name
                from SBQQ__QuoteLine__c 
                where Project__r.Seller_Inspection__c =: ApexPages.currentPage().getParameters().get('id') and Add_Work_Status__c !=  '' Order BY Name asc
               ];  
    }
    
    public PageReference pdf(){
        PageReference pr = new PageReference('/apex/PPE_Form');
        pr.getParameters().put('id', proj.Id);
        return pr;
    }
    
    //splits the quote lines into an approximate number of rows that can be displayed per page
    public void prepareSquawkLinesForPrinting(){
        pageBrokenSquawkLines = new List<SBQQ__QuoteLine__c[]>();
        
        SBQQ__QuoteLine__c[] pageOfSquawks = new SBQQ__QuoteLine__c[]{};
            Integer counter = 0;
        
        boolean firstBreakFound = false;
        //  if(test.isRunningTest()){sqk=new List<SBQQ__QuoteLine__c>(); sqk.add(); }
        if(sqk != null){
            //debug added
            system.debug('sqk'+sqk);
            for(SBQQ__QuoteLine__c s : sqk){
                if(!firstBreakFound){
                    if(counter < FIRST_BREAK){
                        pageOfSquawks.add(s);
                        counter++;  
                    }
                    if(counter == FIRST_BREAK){
                        firstBreakFound = true;
                        counter = 0;
                        pageBrokenSquawkLines.add(pageOfSquawks);
                        pageOfSquawks = new SBQQ__QuoteLine__c[]{};
                            }
                }else{
                    if(counter < SUBSEQ_BREAKS){
                        pageOfSquawks.add(s);
                        counter++;
                    }
                    if(counter == SUBSEQ_BREAKS){
                        counter = 0;
                        pageBrokenSquawkLines.add(pageOfSquawks);
                        pageOfSquawks = new SBQQ__QuoteLine__c[]{};
                            }   
                }
            }
        }
        
        
        if(!pageOfSquawks.isEmpty())
            pageBrokenSquawkLines.add(pageOfSquawks);        
    }
    
    //added by anil
    webservice static void sendEmailToBrokers(String projId) {
        
        String pdfName ='';
        
        if (projId !=NULL) {
            
            PageReference pdf = Page.PPE_Form;
            pdf.getParameters().put('id',projId);
            
            
            pdfName = 'PPE Form' + DateTime.now();
            // the contents of the attachment from the pdf
            Blob body;
            
            try {
                
                // returns the output of the page as a PDF
                body = pdf.getContentAsPDF();
                
            } catch (VisualforceException e) {
                
                body = Blob.valueOf('Some Text');
            }
            /* Attachment attach = new Attachment();
attach.Body = body;
attach.Name = pdfName;
attach.IsPrivate = false;
attach.ParentId = projId;
attach.ContentType  = 'application/pdf';
insert attach;*/
            
            
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment fmail = new Messaging.EmailFileAttachment();
            
            
            
            fmail.setFileName('PPEForm.pdf');
            fmail.setBody(body);
            
            mail.setSubject('PPE FORM ');
            MPM4_BASE__Milestone1_Project__c broker = [Select Broker__c,aircraft__r.Name,CPM__r.Name from MPM4_BASE__Milestone1_Project__c where id =:projId limit 1];
            if(broker.Broker__c !=null){ 
                EmailTemplate template = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName =: 'PPE_Form_Notification'];
                String body1 = template.Body;
                String subject = template.Subject;
                
                body1 = body1.replace('{!aircraftName}', broker.aircraft__r.Name);
                body1 = body1.replace('{!CPM}', broker.CPM__r.Name);
                
                List<String> toadd= new List<String>();
                
                //for testing
                //toadd.add ('Drew.Chandler@standardaero.com');
                
                for(User u : [Select id,name,email,contact.AccountId from user where contact.AccountId = :broker.Broker__c and isActive=True]){
                    toadd.add(u.email);
                }
                
                mail.setToAddresses(toadd);
                
                mail.setPlainTextBody(body1);
                
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {fmail});
                
                Messaging.sendEmail(new Messaging.Email[] {mail});
            }
            
            
            //system.debug(attach);
            
        } else system.debug('tried to run twice');
    }
    
}