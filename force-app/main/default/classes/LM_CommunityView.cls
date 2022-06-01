public class LM_CommunityView {
    
    @AuraEnabled
    public static String getCommunityUrl(){
        Network myNetwork = [SELECT Id FROM Network where name='Customer Community' limit 1];
        
        //String loginUrl = Network.getLoginUrl(myNetwork.id);
        // loginUrl = loginUrl.subStringBefore('/login');
        //return loginUrl;
        return URLUtils.getCommunityURLforCommunity(myNetwork.id);
        //return Network.getLoginUrl(myNetwork.id).subStringBefore('/login');
    }
    
}