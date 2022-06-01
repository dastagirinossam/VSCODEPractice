public class createProjectQuote{

    public createProjectQuote(ApexPages.StandardController controller) {
    }

    //Public String org = URL.getSalesforceBaseUrl().getHost().substringAfter('.').substringBefore('.');

    // Instanciate the Flow for use by the Controller
    public Flow.Interview.ProjectCreateQuote Create_Quote{get;set;}

    // Factor your PageReference as a full GET/SET
    public PageReference prFinishLocation {
                     
        get {
            
            PageReference prRef = new PageReference(URLUtils.getQuotingURLforVisualForce()+ '/apex/sb?scontrolCaching=1&id=' + strQuoteVariable + '#/product/pc?qId=' + strQuoteVariable + '&aId=' + strCustomActionVariable + '&pId=' + strProductVariable + '&redirectUrl=LineEditor&open=0');
            prRef.setRedirect(true);
            return prRef;
        }
        set { prFinishLocation = value; }
    }

    // Factor your Flow output variable pull as a full GET / SET
    public String strQuoteVariable {
        get {
            String strQuote = '';

            if(Create_Quote != null) {
                strQuote = string.valueOf(Create_Quote.getVariableValue('varQuoteId'));               
            }

                return strQuote;
            }

        set { strQuoteVariable = value; }
    }
    
    public String strProductVariable {
        get {
            String strProduct = '';

            if(Create_Quote != null) {
                strProduct = string.valueOf(Create_Quote.getVariableValue('varProductId'));               
            }

                return strProduct;
            }

        set { strProductVariable = value; }
    }
    
    public String strCustomActionVariable {
        get {
            String strCustomAction = '';

            if(Create_Quote != null) {
                strCustomAction = string.valueOf(Create_Quote.getVariableValue('varCustomActionId'));               
            }

                return strCustomAction;
            }

        set { strCustomActionVariable = value; }
    }
    
}