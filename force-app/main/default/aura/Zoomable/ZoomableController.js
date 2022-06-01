({
    scriptsLoaded : function(component, event, helper) {
        var resourceUrl=window.location.protocol +'//'+ window.location.host + $A.get('$Resource.zoomple');
        var blank = resourceUrl + '/blank.gif';
        var loader = resourceUrl + '/loader.gif';
        var cursor = resourceUrl + '/cursor.png';
		        
        $(document).ready(function() { 	            
            var url={ 
                bgColor : '#90D5D9',
                offset : {x:-150,y:-150},
                zoomWidth : 300,  
                zoomHeight : 300,
                roundedCorners : true
            };
            url.blankURL=blank;
            url.loaderURL=loader;
            url.cursorURL=cursor;
            $('.zoomple').zoomple(url);
            
            var url1={ 
                bgColor : '#90D5D9',
                offset : {x:-10,y:-10},
                zoomWidth : 300,  
                zoomHeight : 300,
                roundedCorners : true
            };
            url1.blankURL=blank;
            url1.loaderURL=loader;
            url1.cursorURL=cursor;
            $('.zoomplecross').zoomple(url1); 
        }); 
    },
    //doInit: function(cmp, event, helper) 
    //{
      //cmp.set("v.source", "https://standardaero--fullcopy1--c.cs20.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=SVGZ&versionId=068m0000000gKaW&contentId=05Tm0000002b02O");
      // cmp.set("v.source","https://standardaero--c.na79.content.force.com/servlet/servlet.ImageServer?id=0151O000004FOwI&amp;oid=00D00000000hfim");  //06839000003L6ApAAK
		//cmp.set("v.source","https://standardaero--c.na79.content.force.com/servlet/servlet.ImageServer?id=0151O000004FOwI&oid=00D00000000hfim");
        //cmp.set("v.source","https://standardaero.my.salesforce.com/0691O00000CVyyF");
       // $A.get('e.lightning:openFiles').fire({
//        			recordIds: ['069000000005vEoAAI']
    	//		});
       /*var navService = cmp.find("navService");
        var pageReference = {
            type: 'comm__namedPage',
            attributes: {
                pageName: 'filePreview',
            },
            state : {
                recordIds: ['068m0000000gKaW'],
                selectedRecordId:'068m0000000gKaW'
            }
        }
         cmp.set("v.pageReference", pageReference);
        // Set the URL on the link or use the default if there's an error
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                cmp.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                cmp.set("v.url", defaultUrl);
            }));
        
        //event.preventDefault();
        navService.navigate(pageReference);*/
        
		//alert( component.get("v.source"));
    //},
    doInit : function(component, event, helper) {
        component.set('v.nbaaInviteBack', 
                              'https://standardaero--c.na79.content.force.com/servlet/servlet.ImageServer?id=0151O000004FOwI&oid=00D00000000hfim'
                             );
        component.set("v.ImageRendition", "https://standardaero--c.na79.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&amp;versionId=0681O00000DB5D2&amp;operationContext=CHATTER&amp;contentId=05T1O00000cpIm7");

        
        
        component.set("v.source","https://standardaero--c.na79.content.force.com/servlet/servlet.ImageServer?id=0151O000004FOwI&oid=00D00000000hfim");
    }
})