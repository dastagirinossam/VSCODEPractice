@isTest
public class testLM_CommunityView {
    @isTest
    public static void getCommunityUrlTest(){
        String communityUrl = LM_CommunityView.getCommunityUrl();
        Network myNetwork = [SELECT Id FROM Network where name='Customer Community' limit 1];
		String url = URLUtils.getCommunityURLforCommunity(myNetwork.id);
        System.assertEquals(url, communityUrl);
      }
}