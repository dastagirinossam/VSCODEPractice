public without sharing class Resetpwd {
  @AuraEnabled
    public static void resetPassword() {
        System.debug(userinfo.getUserId());
        System.resetPassword(userinfo.getUserId(), true);
          
    }  
}