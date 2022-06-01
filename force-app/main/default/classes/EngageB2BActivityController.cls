public with sharing class EngageB2BActivityController {
    
    public SObject record {get; set;}
    
    public EngageB2BActivityController(ApexPages.StandardController controller) {
        this.record = controller.getRecord();    
    }

    
    public String crmOrgID  {get; set;}
    public String crmSyncID {get; set;}
    
    public void buildValues() {
        
        String aux, link;
        //String objectType = this.record.getSObjectType();
        //currentPage().getParameters().get('object');
        //String Id         = ApexPages.currentPage().getParameters().get('id');
        String Id = String.valueOf(this.record.get('Id'));
        
        if (this.record.getsObjectType() == Account.sObjectType) {
            Contact personAccount = [    SELECT Id 
                                         FROM Contact 
                                         WHERE AccountId =: Id
                                    ];
            aux = personAccount.Id;
            Id  = aux.substring(0, aux.length() - 3); 
        }else{
          Id  = Id.substring(0, Id.length() - 3);  
        }
        crmOrgID  = UserInfo.getOrganizationId().substring(0, UserInfo.getOrganizationId().length() - 3);
        
        crmSyncID = Id;
    }

}