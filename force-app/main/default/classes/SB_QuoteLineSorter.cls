global class SB_QuoteLineSorter implements Comparable {

	public SBQQ__QuoteLine__c quoteLine;


	public SB_QuoteLineSorter() {
		
	}

	public SB_QuoteLineSorter(SBQQ__QuoteLine__c ql) {
		quoteLine = ql;
	}

	
	global Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        //system.debug('--compareTo -- '+compareTo.)
        SB_QuoteLineSorter compareToBundle = (SB_QuoteLineSorter)compareTo;

        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
       /* if (quoteLine.Name > compareToBundle.quoteLine.Name) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (quoteLine.Name < compareToBundle.quoteLine.Name) {
            // Set return value to a negative value.
            returnValue = -1;
        }*/

        if (quoteLine.SBQQ__Number__c > compareToBundle.quoteLine.SBQQ__Number__c) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (quoteLine.SBQQ__Number__c < compareToBundle.quoteLine.SBQQ__Number__c) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }


}