({
    handleShowCreateForm: function( component,event ) {        
        let helper = this;
        var typeid;
        let pageRef = component.get( 'v.pageReference' );
        let urlParamMap = {
            'c__objectname' : '',      // object whose create form to display
            'c__recordid' : ''        // id of record where button was clicked            
        };
        for ( let key in pageRef.state ) {
            let lowerKey = key.toLowerCase();
            if ( urlParamMap.hasOwnProperty( lowerKey ) ) {
                urlParamMap[lowerKey] = pageRef.state[key];
            }
        }                
        Promise.resolve()
        .then( function() {
            if ( !$A.util.isEmpty( urlParamMap.c__recordid ) ) {
                helper.navigateToUrl( '/' + urlParamMap.c__recordid );
                //helper.navigateToSobject(urlParamMap.c__recordid );
                return new Promise( function( resolve, reject ) {
                    setTimeout( resolve, 1000 );
                });
            }
        })
        .then( function() {           
            var opp = null;            
            var action1 = component.get("c.OppRec");        
            action1.setParams({
                'Rid'  :urlParamMap.c__recordid                
            });
            action1.setCallback(this, function(result){                
                opp =  result.getReturnValue();
                helper.showCreateForm( component,event, urlParamMap, pageRef, opp, typeid);
            });         		
            $A.enqueueAction(action1);                       
        });
    },
    
    // -----------------------------------------------------------------    
    showCreateForm: function( component,event, urlParamMap, pageRef, opp, typeid ) {
        let helper = this;           
        let eventParamMap = {
            'defaultFieldValues' : {}
        }; 
        helper.enqueueAction( component, 'c.getFieldDescribeMap', {            
            'objectName' : urlParamMap.c__objectname            
        }).then($A.getCallback( function( fieldDescribeMap )
                               {                                  
                                   helper.enqueueAction( component, 'c.getRecTypeId', {
                                       'RecId'  :urlParamMap.c__recordid 
                                   }).then($A.getCallback( function(recTypeId){
                                       typeid = recTypeId;                    
                                       eventParamMap['recordTypeId'] =typeid;                                       
                                       if(opp != null){                                                
                                           eventParamMap.defaultFieldValues['Aircraft__c'] = opp.Aircraft__c; 
                                           eventParamMap.defaultFieldValues['SBQQ__Account__c'] = opp.AccountId; 
                                           eventParamMap.defaultFieldValues['SBQQ__Opportunity2__c'] = opp.Id; 
                                           eventParamMap.defaultFieldValues['Facility1__c'] = opp.Facility__c;                                
                                       }
                                       
                                       if ( !$A.util.isEmpty( urlParamMap.c__objectname ) ) {
                                           eventParamMap['entityApiName'] = urlParamMap.c__objectname;
                                       }            
                                       
                                       for ( let fieldName in eventParamMap.defaultFieldValues.keySet ) {
                                           if ( fieldDescribeMap.hasOwnProperty( fieldName ) && fieldDescribeMap[fieldName].createable ) {
                                               // avoid setting lookup fields to undefined, get Error ID: 1429293140-211986 (-590823013), assign to null instead
                                               eventParamMap.defaultFieldValues[fieldName] = pageRef.state[fieldName] || null;
                                           }
                                       }
                                       //debugger;
                                       if (fieldDescribeMap[urlParamMap.c__objectname] === false)  
                                       {
                                           var toastEvent = $A.get("e.force:showToast");
                                           toastEvent.setParams({
                                               "title": "Oops!",
                                               "type":"Info",
                                               "message": "You don't have the necessary privileges to create this record. See your administrator for help."
                                           });
                                           toastEvent.fire();
                                       }
                                       else
                                       {
                                           $A.get( 'e.force:createRecord' ).setParams( eventParamMap ).fire();
                                       }
                                       return fieldDescribeMap;
                                   })).then( $A.getCallback( function( fieldDescribeMap) {                       
                                       console.log( 'fieldDescribeMap', fieldDescribeMap );                       
                                       console.log(JSON.stringify(opp));                             
                                       return eventParamMap;
                                   })).catch( $A.getCallback( function( err ) {
                                       
                                       helper.logActionErrors( err );                                       
                                   }))}));
    },
    
    navigateToUrl: function( url ) {
        console.log( 'navigating to url', url );
        if ( !$A.util.isEmpty( url ) ) {
            $A.get( 'e.force:navigateToURL' ).setParams({ 'url': url }).fire();
        }
    },
    
    enqueueAction: function( component, actionName, params, options ) {        
        let helper = this;        
        return new Promise( function( resolve, reject ) {            
            component.set( 'v.showSpinner', true );            
            let action = component.get( actionName );            
            if ( params ) {
                action.setParams( params );
            }
            
            if ( options ) {
                if ( options.background ) { action.setBackground(); }
                if ( options.storable )   { action.setStorable(); }
            }
            
            action.setCallback( helper, function( response ) {                
                component.set( 'v.showSpinner', false );                
                if ( component.isValid() && response.getState() === 'SUCCESS' ) {                    
                    resolve( response.getReturnValue() );                    
                } else {                    
                    console.error( 'Error calling action "' + actionName + '" with state: ' + response.getState() );                    
                    helper.logActionErrors( response.getError() );                    
                    reject( response.getError() );                    
                }
            });            
            $A.enqueueAction( action );           
        });
    },
    
    logActionErrors : function( errors ) {
        if ( errors ) {
            if ( errors.length > 0 ) {
                for ( let i = 0; i < errors.length; i++ ) {
                    console.error( 'Error: ' + errors[i].message );
                }
            } else {
                console.error( 'Error: ' + errors );
            }
        } else {
            console.error( 'Unknown error' );
        }
    },
    navigateToSobject:function(recordId){        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            //"slideDevName": "related"
        });
        navEvt.fire();
    }
})