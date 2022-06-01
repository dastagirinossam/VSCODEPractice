@isTest
public class testURLUtils { 
    @isTest
    public static void  getQuotingURLforVisualForcetest()
    {
        String instanceName;
        boolean isSandbox;
        List<Organization> orgList = [select InstanceName,isSandbox from Organization limit 1];
        if (orgList.size()>0)
        { 
            String URLforQuote = URLUtils.getQuotingURLforVisualForce();
            instanceName = orgList[0].instanceName;
            isSandbox =  orgList[0].isSandbox;
            if( IsSandbox == true) // If anything special needs to be done for sandbox
            {
                if(URLforQuote.contains('fullcopy1'))
                    System.assertEquals('https://standardaero--fullcopy1--sbqq.'+ instanceName.toLowerCase() + '.visual.force.com', URLforQuote);
                else if(URLforQuote.contains('VenkDev'))
                    System.assertEquals('https://standardaero--VenkDev.cs23.my.salesforce.com--sbqq.'+ instanceName.toLowerCase() + '.visual.force.com', URLforQuote);
                else if(URLforQuote.contains('DevCom'))
                    System.assertEquals('https://standardaero--DevCom.cs68.my.salesforce.com--sbqq.'+instanceName.toLowerCase() +'.visual.force.com', URLforQuote);
                
            }
            else
            {
                System.assertEquals('https://standardaero--sbqq.'+ instanceName.toLowerCase() + '.visual.force.com', URLforQuote);
            } 
            
        }
    }
    
    @isTest
    public static void getCommunityURLforCommunitytest(){
        String instanceName;
        boolean isSandbox;
        String expected;
        List<Organization> orgList = [select InstanceName,isSandbox from Organization limit 1];
        if (orgList.size()>0){
            Network myNetwork = [SELECT Id FROM Network where name='Customer Community' limit 1];
            String URLforCommunity = URLUtils.getCommunityURLforCommunity(myNetwork.id);
            instanceName = orgList[0].instanceName;
            isSandbox =  orgList[0].isSandbox;
            String networkid =myNetwork.id;
            if (isSandbox == true)
            { 
                
                // 'https://standardaero--venkdev.lightning.force.com/servlet/networks/switch?networkId='+networkId.substring(0,15);
                
                if(URLforCommunity.contains('fullcopy1'))
                    System.assertEquals('https://standardaero--fullcopy1.lightning.force.com/servlet/networks/switch?networkId='+networkId.substring(0,15), URLforCommunity);
                else if(URLforCommunity.contains('VenkDev'))
                    System.assertEquals('https://standardaero--venkdev.lightning.force.com/servlet/networks/switch?networkId='+networkId.substring(0,15), URLforCommunity);
                else if(URLforCommunity.contains('DevCom'))
                    System.assertEquals('https://standardaero--devcom.lightning.force.com/servlet/networks/switch?networkId='+networkId.substring(0,15), URLforCommunity);
                
            }
            else{
                String expectedValue = 'https://standardaero.lightning.force.com/servlet/networks/switch?networkId='+networkid.substring(0,15);
                System.assertEquals(expectedValue, URLforCommunity);
            }
            
        }
        
    }
}