({
    listAction : function(component, event, helper) {
        //change the image names,header,description etc as required
        var name=['Facility_AGS','Houston','Springfield', 'Fleetlands'];
        var header=['Augusta (AGS) Facility','Houston (IAH) Facility','Springfield (SPI) Facility','Fleetlands, UK Facility'];
        var ImageUrl=['https://standardaero.com/Portals/0/Documents/Overviews/StandardAero%20-%20Business%20Aviation%20SiteFacts%20-%20Augusta%20Georgia.pdf',
                      'https://standardaero.com/Portals/0/Documents/Overviews/StandardAero%20-%20Business%20Aviation%20SiteFacts%20-%20Houston%20Texas.pdf',
                      'https://standardaero.com/Portals/0/Documents/Overviews/SPIFacilityOverviewDatasheet.pdf',
                      'https://standardaero.com/Portals/0/Documents/Overviews/FTL%20Facility%20Overview%20Datasheet.pdf'
                     ];
        var b=['1','2','3','4','5','6'];
        var list1=[];
        var a=name.length;
        
        for(var i=0;i<a;i++){
            list1.push({image:$A.get('$Resource.'+name[i]),
                        Header:header[i],
                        //Description:description[i],
                        //AlterText:AlternativeText[i],
                        id:ImageUrl[i]}) ;         
        }
        component.set("v.lstimg",list1);
    },
    
    onClick : function(component, event, helper) {
        var urlval = event.getSource().get("v.id");
        console.log('Url: ' + urlval);
        window.open(urlval, '_blank');
    }
})