public class URLUtils {
    public static String getQuotingURLforVisualForce()
    { 
        String instanceName;
        boolean isSandbox;
        List<Organization> orgList = [select InstanceName,isSandbox from Organization limit 1];
        if (orgList.size()>0)
        { 
            instanceName = orgList[0].instanceName;
            isSandbox =  orgList[0].isSandbox;
            if( IsSandbox == true) // If anything special needs to be done for sandbox
            {
                String org = URL.getSalesforceBaseUrl().toExternalForm().substringAfter('--').substringBefore('--');
                System.debug('==='+org);
                return  'https://standardaero--'+ org +'--sbqq.' + instanceName.toLowerCase() + '.visual.force.com';
            }
            else
            {
                return  'https://standardaero--sbqq.'+ instanceName.toLowerCase() + '.visual.force.com';
            }
        }
        return  'https://standardaero--sbqq.na79.visual.force.com';
    }
    
    public static String getCommunityURLforCommunity(String networkId)
    {
        String instanceName;
        boolean isSandbox;
        List<Organization> orgList = [select InstanceName,isSandbox from Organization limit 1];
        
        if (orgList.size()>0)
        { 
            instanceName = orgList[0].instanceName;
            isSandbox =  orgList[0].isSandbox;
            String org = URL.getSalesforceBaseUrl().toExternalForm().substringAfter('--').substringBefore('.');
            if (isSandbox == true)
            { 
                System.debug('https://standardaero--'+org.toLowerCase()+'.lightning.force.com/servlet/networks/switch?networkId='+networkId);
                return 'https://standardaero--'+org.toLowerCase()+'.lightning.force.com/servlet/networks/switch?networkId='+networkId.substring(0,15);
            }
            else
                return 'https://standardaero.lightning.force.com/servlet/networks/switch?networkId='+networkId.substring(0,15);
        }
        return 'https://standardaero.lightning.force.com/servlet/networks/switch?networkId='+networkId.substring(0,15);
    }
}