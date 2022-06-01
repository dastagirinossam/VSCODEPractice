public class RedirectExtension {
    
    public RedirectExtension(ApexPages.StandardController controller)
    {
        
    }
	public static PageReference	doSubmit()
        {
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p1;
        if(theme == 'Theme3'){
            p1 = new PageReference('/01t');
        }else
             p1 = new PageReference('/lightning/n/Product_List_View');
        
          return p1;  
        }
       
}