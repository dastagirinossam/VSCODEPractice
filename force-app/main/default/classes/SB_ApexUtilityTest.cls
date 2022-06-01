/**
*@author - Krunal Pala
*@Date - 24/2/2017
*Purpose - Test Class for SB_ApexUtility
*/

@isTest
private class SB_ApexUtilityTest {
	
	@isTest static void testQueryBuilder() {
		SB_ApexUtility sbApexUtility = SB_ApexUtility.getInstance();
		String query = sbApexUtility.queryBuilder('SBQQ__Quote__c');
		system.assertNotEquals(query, null);
	}
	
	
	
}