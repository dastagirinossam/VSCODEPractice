public class fslAccountLookupController {
       
    public Contact contact{get;set;}
    public string AccountId{get; set;}
    
    public PageReference gotoAccountSummary() {
        
        if(AccountId != null){
            final PageReference target = new PageReference(Site.getBaseSecureUrl() + '/apex/AccountSummary?id=' + AccountId);
            target.setRedirect(true);
            // This is a permanent redirection
            target.setRedirectCode(301);
            return target;
        }else{
            return null;
        }
    }
      
    public fslAccountLookupController() {
        
    }
    
}