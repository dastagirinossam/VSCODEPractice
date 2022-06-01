public class ListViewPrinter {
    static ApexPages.StandardSetController controller1;
    public static PageReference print()
 
    {
 
        schema.sObjectType sObjType = Schema.getGlobalDescribe().get(controller1.getRecord().getSObjectType().getDescribe().getName());
        Schema.DescribeSObjectResult r = sObjType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        PageReference p1 = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+  '/'+ keyPrefix+'/x?fcf='+controller1.getFilterId().substring(0,15)+'&rolodexIndex=-1&page=1');
        p1.setRedirect(false);
       //PageReference p1 = new PageReference('javascript:window.open(\"/003/x?fcf=00B70000007Nf2S&rolodexIndex=-1&page=1\",\"_blank\")');
        return p1;
    }
    
    public ListViewPrinter(ApexPages.StandardSetController controller)
    {
       controller1=controller;
 
    }
}