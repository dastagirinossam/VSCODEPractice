public class CreateCustomerUser{

    public Id ContactId {get;set;}
    public Profile custComPlusLoginProfile = [Select Id, Name from Profile where Name =: 'Customer Community Plus Login User - Custom'];
    Public UserLicense custComPlusLicense = [Select Id, Name from UserLicense where Name =: 'Customer Community Plus Login'];
    
    public CreateCustomerUser (ApexPages.StandardController controller) {}
    
    // Factor your PageReference as a full GET/SET
    public PageReference prFinishLocation() {
        
        String userRecord = null;             
        ContactId =  ApexPages.currentPage().getParameters().get('id');      
        User u = null;
        
        Contact c = [Select Email, Title, Phone, Fax, MobilePhone, FirstName, LastName,
                     MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry,
                     Customer_Community_Role__c from Contact where Id =: ContactId];
        
        UserRole custUserRole = null;
        String custUR = null;
        String custComPLId = custComPlusLicense.Id; 
        String custComPLP = custComPlusLoginProfile.Id;
        String street;
        
        /*if (c.MailingStreet!= null)
        {
            street = c.MailingStreet;
            //street = EncodingUtil.urldecode   (street, 'UTF-8');
            //street = EncodingUtil.urlEncode(c.MailingStreet.replace('\r\n', '&#13;&#10;'),'utf8');
			street = c.MailingStreet;
            system.debug(street);
        }*/
        	             
        String userURL = ApexPages.currentPage().getHeaders().get('Referer');
        system.debug(userURL);
   
        try{
            custUserRole = [Select Id, Name from UserRole where Name =: c.Customer_Community_Role__c];
            custUR = custUserRole.Id;
        }catch (Exception e){
            system.debug(e.getMessage());
        }
        
        try{
            u = [Select Id from User where ContactId =: ContactId];
        }catch (Exception e){
            system.debug(e.getMessage());
        }
        
        if(u == null){
            if (!userURL.contains('lightning')){
                //UserInfo.getUiThemeDisplayed() =='Theme3'){
                userRecord = '/005/e?ut=C' +
                	'&retURL=%2F' + ContactId + 
                	'%3Fnoredirect%3D1%26isUserEntityOverride%3D1' +
					'&saveURL=%2F'+ ContactId +
                    '&name_firstName=' + c.FirstName +
                    '&user_license_id=' + custComPLId.substring(0,15) +
                    '&name_lastName=' + c.LastName +
                    '&Profile=' + custComPLP.substring(0,15) +
                    '&Alias=custcom' +  
                    '&dev_context_menu=0' + 
                    '&UserPermissions_7=0' +
                    '&no_content_send_emails=0' +
                    '&cntc=' + ContactId +
                    '&Email=' + c.Email +
                    '&Username=' + c.Email +
                    '&CommunityNickname=' + c.FirstName + '.' + c.LastName +     
                    '&Title=' + c.Title +               
                    '&Phone=' + c.Phone +
                    '&Fax=' + c.Fax +
                    '&MobilePhone=' + c.MobilePhone +                         
                    '&Addresscity=' + c.MailingCity +
                    '&Addressstate=' + c.MailingState +
                    '&Addresszip=' + c.MailingPostalCode +
                    '&Addresscountry=' + c.MailingCountry +                  
                    '&receiveApprovalsEmails=SEND_NONE' + 
                    '&new_password=1';
                if (custUR!=null)
                	userRecord +='&UserRole=' + custUR.substring(0,15) ;
            }else{
                System.debug('URL: ' + userURL);  
                userRecord = '/lightning/setup/ManageUsers/page?' +
                    'address=%2F005%2Fe%3F' +
                    'active%3D1' +
                    '%26retURL%3D' + '%2Flightning%2Fr%2F'+ContactId+'%2Fview' +
                    '%26saveURL%3D' + '%2Flightning%2Fr%2F'+ContactId+'%2Fview'+ 
                    '%26name_firstName%3D' + c.FirstName +
                    '%26name_lastName%3D' + c.LastName +
                    '%26Alias%3Dcustcom' +
                    '%26Email%3D' + c.Email +
                    '%26Username%3D' + c.Email +
                    '%26Addresscity%3D' + c.MailingCity +
                    '%26Addresscountry%3D' + c.MailingCountry + 
                    '%26Addressstate%3D' + c.MailingState + 
                    '%26Addresszip%3D' + c.MailingPostalCode +
                    '%26cntc%3D' + ContactId +
                    '%26CommunityNickname%3D' + c.FirstName + '.' + c.LastName +
                    '%26content_email_no_digest%3D0'+
                    '%26Fax%3D' + c.Fax + 
                    '%26isUserEntityOverride%3D1' + 
                    '%26no_content_send_emails%3D0' +  
                    '%26Phone%3D' + c.Phone +
                    '%26Profile%3D' + custComPLP.substring(0,15) +
                    '%26receiveApprovalsEmails%3DSEND_NONE' +
                    
                    '%26noredirect%253D1%2526isUserEntityOverride%253D1' +
                    '%26salesforce1_user%3D0' +
                    '%26Title%3D' + c.Title +
                    '%26user_license_id%3D' + custComPLId.substring(0,15) + 
                    '%26UserPermissions_7%3D0' +  
                    '%26ut%3DC'+
                    //'%26sfdcIFrameOrigin%3D' + 
                    //'https%253A%252F%252Fstandardaero--fullcopy1.lightning.force.com'+
                    '%26new_password%3D1';
                if (custUR!=null)
                	userRecord +='%26UserRole%3D' + custUR.substring(0,15) ;
                    
            }         
            system.debug('URL: ' + userRecord);
        }else{
            userRecord = '/' + u.Id +
                '/e?isUserEntityOverride=1' + 
                '&cntc=' + ContactId +
                '&ut=C' +
                '&retURL=%2F' + ContactId + 
                '&saveURL=%2F' + ContactId +
                '%3Fnoredirect%3D1%26isUserEntityOverride%3D1' +
                '&Title=' + c.Title +
                '&Phone=' + c.Phone +
                '&Fax=' + c.Fax +
                '&UserPermissions_7=0' +
                '&no_content_send_emails=0' +
                '&content_email_no_digest=0' +
                '&salesforce1_user=0' +
                '&Addresscity=' + c.MailingCity +
                '&Addressstate=' + c.MailingState +
                '&Addresszip=' + c.MailingPostalCode +
                '&Addresscountry=' + c.MailingCountry +
                '&CommunityNickname=' + c.FirstName + '.' + c.LastName +
                '&user_license_id=' + custComPLId.substring(0,15) +
                '&Profile=' + custComPLP.substring(0,15) + 
                '&UserRole=' + custUR.substring(0,15) +
                '&receiveApprovalsEmails=SEND_NONE' +
                '&UserRole=' + custUR.substring(0,15) + 
                '&active=1';               
        }
        
        PageReference prRef = new PageReference(UserRecord);
        prRef.setRedirect(true);
        return prRef;   
    }
    
}