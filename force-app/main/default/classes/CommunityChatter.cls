public class CommunityChatter {
    
    @AuraEnabled
    public static void PostComment(String  UserPost) {
        
        User contact = [Select ContactId from User where Id =: Userinfo.getUserId()];
        
    	ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();      
    	ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
    
    	messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
    	//parse @[User Name]
    	//use pattern matching group ()  so we can easily extract name later*
    	Pattern p = Pattern.compile('\\@\\[([a-z|A-Z|0-9].*?)\\]'); 
    	
        //use regex to split all all non-mentions into segments
    	String [] textSegments = p.split(userpost, -1);
    
    	//create a pattern matcher object
    	Matcher pm = p.matcher( userpost );
    
        //all @[mentions] in order
    	List<String> mentionedNames = new List<String>{};   
    	Map<String,ConnectApi.MentionSegmentInput> nameToInputMap = new Map<String,ConnectApi.MentionSegmentInput>{};
    
       	//iterate through each @mention and build a map of unique @mentions 
    	if( pm.find() ){
        	do {
            	//now we can extract the pattern matching group defined earlier*
            	String mentionName = pm.group(1);
            	
                //use lowercase to ensure case neutrality later***
            	String lcName = mentionName.toLowerCase();
            	if(!nameToInputMap.containsKey(lcName)){
                	nameToInputMap.put(lcName, new ConnectApi.MentionSegmentInput());               
            	}
                
            	mentionedNames.add(lcName);
        	} while(pm.find());
    	}
    	
        ConnectApi.MentionSegmentInput[] mentions = new ConnectApi.MentionSegmentInput[]{};
    
        //check the @[chatter names] against user Names
    	for(User u: [SELECT Id, Name FROM User WHERE name IN: mentionedNames]){
        	ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        	//making sure to fetch using lowercased name***
        	nameToInputMap.get(u.Name.toLowerCase()).id = u.id;
        	mentionSegmentInput.id = u.id;   
    	}
        
    	//check the @[chatter names] against Chatter group Names (aka CollaborationGroup)
    	for(CollaborationGroup cg: [SELECT Id, Name FROM CollaborationGroup WHERE name IN: mentionedNames]){
        	ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        
            //making sure to fetch using lowercased name***
        	nameToInputMap.get(cg.Name.toLowerCase()).id = cg.id;
        	mentionSegmentInput.id = cg.id;  
    	}
        
    	//shuffle the mentions back in with the text segments
    	for(Integer i=0;i<textSegments.size();i++){
        	ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        	textSegmentInput.text = textSegments[i];
        	messageBodyInput.messageSegments.add(textSegmentInput);
        	
            //due to splitting, there should always be one less mention than text segments
        	if(mentionedNames.size() > i){
            	// now "sandwich" the @mentions into the text Segments in their original order
            	messageBodyInput.messageSegments.add(nameToInputMap.get(mentionedNames[i]));
        	}
    	}
        
    	feedItemInput.body = messageBodyInput;
    	feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemInput.subjectId = contact.contactId;         
        
    	ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);                                            
	}
    
    @AuraEnabled
    public static void RecordPostComment(String  UserPost, String RecordId) {
       
    	ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();      
    	ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
    
    	messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
    	//parse @[User Name]
    	//use pattern matching group ()  so we can easily extract name later*
    	Pattern p = Pattern.compile('\\@\\[([a-z|A-Z|0-9].*?)\\]'); 
    	
        //use regex to split all all non-mentions into segments
    	String [] textSegments = p.split(userpost, -1);
    
    	//create a pattern matcher object
    	Matcher pm = p.matcher( userpost );
    
        //all @[mentions] in order
    	List<String> mentionedNames = new List<String>{};   
    	Map<String,ConnectApi.MentionSegmentInput> nameToInputMap = new Map<String,ConnectApi.MentionSegmentInput>{};
    
       	//iterate through each @mention and build a map of unique @mentions 
    	if( pm.find() ){
        	do {
            	//now we can extract the pattern matching group defined earlier*
            	String mentionName = pm.group(1);
            	
                //use lowercase to ensure case neutrality later***
            	String lcName = mentionName.toLowerCase();
            	if(!nameToInputMap.containsKey(lcName)){
                	nameToInputMap.put(lcName, new ConnectApi.MentionSegmentInput());               
            	}
                
            	mentionedNames.add(lcName);
        	} while(pm.find());
    	}
    	
        ConnectApi.MentionSegmentInput[] mentions = new ConnectApi.MentionSegmentInput[]{};
    
        //check the @[chatter names] against user Names
    	for(User u: [SELECT Id, Name FROM User WHERE name IN: mentionedNames]){
        	ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        	//making sure to fetch using lowercased name***
        	nameToInputMap.get(u.Name.toLowerCase()).id = u.id;
        	mentionSegmentInput.id = u.id;   
    	}
        
    	//check the @[chatter names] against Chatter group Names (aka CollaborationGroup)
    	for(CollaborationGroup cg: [SELECT Id, Name FROM CollaborationGroup WHERE name IN: mentionedNames]){
        	ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        
            //making sure to fetch using lowercased name***
        	nameToInputMap.get(cg.Name.toLowerCase()).id = cg.id;
        	mentionSegmentInput.id = cg.id;  
    	}
        
    	//shuffle the mentions back in with the text segments
    	for(Integer i=0;i<textSegments.size();i++){
        	ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        	textSegmentInput.text = textSegments[i];
        	messageBodyInput.messageSegments.add(textSegmentInput);
        	
            //due to splitting, there should always be one less mention than text segments
        	if(mentionedNames.size() > i){
            	// now "sandwich" the @mentions into the text Segments in their original order
            	messageBodyInput.messageSegments.add(nameToInputMap.get(mentionedNames[i]));
        	}
    	}
        
    	feedItemInput.body = messageBodyInput;
    	feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemInput.subjectId = RecordId;  
        
    	ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);                                            
	}
}