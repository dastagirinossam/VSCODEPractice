public with Sharing Class CreateQuoteController{

    // Constructor - only matters if the autoRun function doesn't work right
    private final MPM4_BASE__Milestone1_Project__c p;
    public CreateQuoteController(ApexPages.StandardController stdController) {
        this.p = (MPM4_BASE__Milestone1_Project__c)stdController.getRecord();
    }
     
    // Code Invoked On Navigation To Visualforce Page
    public PageReference autoRun() {
    
        String projId = ApexPages.currentPage().getParameters().get('id');
        String engModel = null;                 

        List<MPM4_BASE__Milestone1_Project__c> projFields = [Select Opportunity__c, MPM4_BASE__Account__r.Name, MPM4_BASE__Account__c, Aircraft__c, Aircraft__r.Aircraft_Model_2011__c, Aircraft__r.ACReg__c, Aircraft__r.Aircraft_SN__c, Engine__r.Name, Engine__r.Model__c, Crew_Chief__c, CPM_Name__c, CPM__c, Work_Order__c from MPM4_BASE__Milestone1_Project__c where Id =: projId];
                
        RecordType addworkRT = [Select Id from RecordType where name = 'Add Work Quote'];
        Pricebook2 pricebook = [Select Id from Pricebook2 where name = 'CPQ Price Book'];
        SBQQ__CustomAction__c AddProducts = [Select Id from SBQQ__CustomAction__c where name = 'Add Products'];
        Product2 prod = [Select Id from Product2 where name = 'Unscheduled Bundle'];
        Organization org = [SELECT InstanceName FROM Organization];
                  
        if(projFields[0].Engine__r.Name =='NA'){
            engModel = 'NA';
        }else{
            engModel = projFields[0].Engine__r.Model__c;
        } 
                       
            SBQQ__Quote__c quote = new SBQQ__Quote__c(           
                RecordTypeId = addworkRT.id,
                SBQQ__PricebookId__c = pricebook.id,
                Project__c = projId,
                SBQQ__Opportunity2__c = projFields[0].Opportunity__c,
                Add_Work_Work_Order__c = projFields[0].Work_Order__c,
                Account_Name__c = projFields[0].MPM4_BASE__Account__r.Name,
                SBQQ__Account__c = projFields[0].MPM4_BASE__Account__c,
                Add_Work_Aircraft_Model__c = projFields[0].Aircraft__r.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = projFields[0].Aircraft__r.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = projFields[0].Aircraft__r.Aircraft_SN__c, 
                Aircraft__c = projFields[0].Aircraft__c,
                Crew_Chief__c = projFields[0].Crew_Chief__c, 
                CPM_Name__c = projFields[0].CPM_Name__c, 
                CPM__c = projFields[0].CPM__c,                               
                Add_Work_Engine_Model__c = engModel                                                                                                                         
            );
    
            insert quote;
            
            ID quoteID = quote.ID;
 
        // Redirect the user back to the original page
        PageReference pageRef = new PageReference(URLUtils.getQuotingURLforVisualForce()+'/apex/sb?scontrolCaching=1&id=' + quoteId + '#/product/pc?qId=' + quoteId + '&aId=' + AddProducts.Id + '&pId=' + prod.Id + '&redirectUrl=LineEditor&open=0');
            pageRef.setRedirect(true);
        return pageRef;
 
    }
 
}