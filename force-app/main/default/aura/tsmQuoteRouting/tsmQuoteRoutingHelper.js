({
    fetchTypePicklist : function(component, event, helper){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'nullRequired': true // includes --None--
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set("v.caPicklist", a.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    },
    
    fetchQuoteMargins : function(component, event, helper){
        var prodTypes = [];
        var cc = [];
        var email = [];
        var approvers = [];
        
        var quoteId = component.get("v.recordId");        
        var action = component.get("c.getMargins");
        
        var engineWork = false;
        var airframeWork = false;
        var avionicsWork = false;
        
        action.setParams({
            'quoteId': quoteId 
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var margins = a.getReturnValue();           
                var results = JSON.stringify(margins);
                
                component.set("v.directors", margins.Directors);
                if(margins.Directors != null){
                    for(var i = 0; i < JSON.parse(JSON.stringify(margins.Directors)).length; i++){                      
                		cc.push(JSON.parse(JSON.stringify(margins.Directors))[i].Email);
                        console.log(JSON.parse(JSON.stringify(margins.Directors))[i].Email);
                    }
                }
                  
                var oOwner = Object.values(JSON.parse(JSON.stringify(margins.oppOwner)))
                component.set("v.oppOwner", oOwner[0]);
                
                var oRsd = Object.values(JSON.parse(JSON.stringify(margins.oppRSD)))
                component.set("v.oppRSD", oRsd[0]);

                component.set("v.quoteId", margins.quoteId);
                
                component.set("v.CreditAnalyst", "NA");
                component.set("v.mstLead", "NA");
                
                component.set("v.vpgm", margins.vpgm);
                cc.push(margins.vpgm);
                
                component.set("v.president", margins.president);
                component.set("v.vp", Object.values(JSON.parse(JSON.stringify( margins.vp))));
                component.set("v.vpf", margins.vpf);
                component.set("v.doqs", margins.doqs);
                
                //Trade Compliance
                console.log('Trade Compliance: ' + Object.values(JSON.parse(JSON.stringify(margins.tradecompliance))));
                var tc = Object.values(JSON.parse(JSON.stringify(margins.tradecompliance)));
                component.set("v.tradecompliance", margins.tradecompliance);
                
                if(margins.tcReq == true){
                    component.set("v.selTcValue", 'true');
                    
                    if(email.indexOf(tc[0]) == -1)
                        email.push(tc[0]);
                }
                
                var mstApp = Object.values(JSON.parse(JSON.stringify(margins.mstApprover)));
                component.set("v.MST", mstApp[0]);
 
                var acApp = Object.values(JSON.parse(JSON.stringify(margins.antiCorruption)));
                component.set("v.antiCorruption", margins.antiCorruption);
                
                var govApp = Object.values(JSON.parse(JSON.stringify(margins.government)));
                component.set("v.government", margins.government);
                
                var legApp = Object.values(JSON.parse(JSON.stringify(margins.legal)));
                component.set("v.legal", margins.legal);
                
                var frmlApp = Object.values(JSON.parse(JSON.stringify(margins.frMatLab)));
                component.set("v.frMatLab", margins.frMatLab);
                
                component.set("v.engineShopDirector", margins.engineShopDirector);                
                component.set("v.engineScheduler", margins.engineScheduler);
                             
                component.set("v.airframeShopDirector", margins.airframeShopDirector);
                component.set("v.airframeScheduler", margins.airframeScheduler);
                component.set("v.avionicsScheduler", margins.avionicsScheduler);
                
                component.set("v.amount", margins.amount);
                component.set('v.facility', margins.facility);
                
                component.set("v.htfQuotedMargin", margins.htfMargin);
                component.set("v.tfeQuotedMargin", margins.tfeMargin);
                component.set("v.cfeQuotedMargin", margins.cfeMargin);
                component.set("v.apuQuotedMargin", margins.apuMargin);
                component.set("v.avionicsQuotedMargin", margins.avionicsMargin);
                component.set("v.airframeQuotedMargin", margins.airframeMargin);
                component.set("v.interiorQuotedMargin", margins.interiorMargin);
                component.set("v.paintQuotedMargin", margins.paintMargin);
                component.set("v.otherQuotedMargin", margins.otherMargin);
                
                component.set("v.Competitor", margins.Competitor);
                component.set("v.Quoted_Downtime", margins.Quoted_Downtime);
                component.set("v.InputDate", margins.InputDate);
                component.set("v.ExpectedRevenue", margins.ExpectedRevenue);
                component.set("v.EstimatedMarginPercent", margins.EstimatedMarginPercent);
                component.set("v.EstimatedHours", margins.EstimatedHours);
                                                  
                //Avionics Scheduler
                var avScheduler = Object.values(JSON.parse(JSON.stringify(margins.avionicsScheduler)));
                component.set("v.avionicsScheduler", avScheduler[0]);
                
                //Airframe Scheduler
                var afScheduler = Object.values(JSON.parse(JSON.stringify(margins.airframeScheduler)));
                component.set("v.airframeScheduler", afScheduler[0]);
                
                //Engine Scheduler                   
                var engineScheduler = Object.values(JSON.parse(JSON.stringify(margins.engineScheduler)));
                component.set("v.engineScheduler", engineScheduler[0]);
     
                //TFE
                if(margins.tfeApprover != null){
                    prodTypes.push('TFE');
                    component.set("v.engRadioValue", 'true');
                    
                    //TFE Approver
                    var tfeApp = Object.values(JSON.parse(JSON.stringify(margins.tfeApprover)))
                    component.set("v.tfeApprover", tfeApp[0]);
                    
                    if(approvers.indexOf(margins.tfeApprover) == -1)
                    	approvers.push(margins.tfeApprover);
                    
                    if(email.indexOf(tfeApp[0]) == -1)
                    	email.push(tfeApp[0]);

                    if(approvers.indexOf(margins.engineScheduler) == -1)
                        approvers.push(margins.engineScheduler);
                    
                    if(email.indexOf(engineScheduler[0]) == -1)
                        email.push(engineScheduler[0]);
                    
                    //Engine Shop Director
                    if(cc.indexOf(margins.engineShopDirector) == -1)
                        cc.push(margins.engineShopDirector);  
                }                   
                
                //CFE
                if(margins.cfeApprover != null){
                    prodTypes.push('CFE');
                    component.set("v.engRadioValue", 'true');
                    
                    //CFE Approver
                    var cfeApp = Object.values(JSON.parse(JSON.stringify(margins.cfeApprover)))
                    component.set("v.cfeApprover", cfeApp[0]);
                    
                    if(approvers.indexOf(margins.cfeApprover) == -1)
                        approvers.push(margins.cfeApprover);
                    
                    if(email.indexOf(cfeApp[0]) == -1)
                    	email.push(cfeApp[0]);
                    
                    if(approvers.indexOf(margins.engineScheduler) == -1)
                        approvers.push(margins.engineScheduler);
                    
                    if(email.indexOf(engineScheduler[0]) == -1)
                        email.push(engineScheduler[0]);
                    
                    //Engine Shop Director
                    if(cc.indexOf(margins.engineShopDirector) == -1)
                        cc.push(margins.engineShopDirector);  
                }
                
                //HTF
                if(margins.htfApprover != null){
                    prodTypes.push('HTF');
                    component.set("v.engRadioValue", 'true');
                    
                    //HTF Approver
                    var htfApp = Object.values(JSON.parse(JSON.stringify(margins.htfApprover)))
                    component.set("v.htfApprover", htfApp[0]);
                    
                    if(approvers.indexOf(margins.htfApprover) == -1)
                        approvers.push(margins.htfApprover);
                    
                    if(email.indexOf(htfApp[0]) == -1)
                    	email.push(htfApp[0]);

                    if(approvers.indexOf(margins.engineScheduler) == -1)
                        approvers.push(margins.engineScheduler);
                    
                    if(email.indexOf(engineScheduler[0]) == -1)
                        email.push(engineScheduler[0]);
                    
                    //Engine Shop Director
                    if(cc.indexOf(margins.engineShopDirector) == -1)
                        cc.push(margins.engineShopDirector);  
                }
                               
                //Apu
                if(margins.apuApprover != null){
                    prodTypes.push('APU');
                    component.set("v.engRadioValue", 'true');
                    
                    //Apu Approver
                    var apuApp = Object.values(JSON.parse(JSON.stringify(margins.apuApprover)))
                    component.set("v.apuApprover", apuApp[0]);
                    
                    if(approvers.indexOf(margins.apuApprover) == -1)
                        approvers.push(margins.apuApprover);
                    
                    if(email.indexOf(apuApp[0]) == -1)
                    	email.push(apuApp[0]);
                                                            
                    if(approvers.indexOf(margins.engineScheduler) == -1)
                        approvers.push(margins.engineScheduler);
                    
                    if(email.indexOf(engineScheduler[0]) == -1)
                        email.push(engineScheduler[0]);
                    
                    //Engine Shop Director
                    if(cc.indexOf(margins.engineShopDirector) == -1)
                        cc.push(margins.engineShopDirector);  
                }
                
                //Avionics                                                                  
                if(margins.avionicsApprover != null){
                    prodTypes.push('Avionics');
                    component.set("v.avRadioValue", 'true');
                    
                    //Avionics Approver
                    var avApp = Object.values(JSON.parse(JSON.stringify(margins.avionicsApprover)));
                    component.set("v.avionicsApprover", avApp[0]);
                    
                    if(approvers.indexOf(margins.avionicsApprover) == -1)
                        approvers.push(margins.avionicsApprover);
                    
                    if(email.indexOf(avApp[0]) == -1)
                    	email.push(avApp[0]);
                    
                    if(approvers.indexOf(margins.avionicsScheduler) == -1)
                        approvers.push(margins.avionicsScheduler);                   
                    
                    if(email.indexOf(avScheduler[0]) == -1)
                        email.push(avScheduler[0]);
                               
                    //Airframe Shop Director
                    if(cc.indexOf(margins.airframeShopDirector) == -1)
                        cc.push(margins.airframeShopDirector);  
                }
                
                //Airframe                
                if(margins.airframeApprover != null){
                    prodTypes.push('Airframe');  
                    component.set("v.afRadioValue", 'true');
                    
                    //Airframe Approvers
                    var afApp = Object.values(JSON.parse(JSON.stringify(margins.airframeApprover)));  
                    component.set("v.airframeApprover", afApp[0]);
                    
                    if(approvers.indexOf(margins.airframeApprover) == -1)
                        approvers.push(margins.airframeApprover);
                    
                    if(email.indexOf(afApp[0]) == -1)
                        email.push(afApp[0]);
                                                           
                    if(approvers.indexOf(margins.airframeScheduler) == -1)
                        approvers.push(margins.airframeScheduler);
                    
                    if(email.indexOf(afScheduler[0]) == -1)
                        email.push(afScheduler[0]);
                    
                    //Airframe Shop Director
                    if(cc.indexOf(margins.airframeShopDirector) == -1)
                        cc.push(margins.airframeShopDirector);  
                }
                
                //Interior - Review
                if(margins.interiorApprover != null){
                    component.set("v.afRadioValue", 'true');
                    
                    var intApp = Object.values(JSON.parse(JSON.stringify(margins.interiorApprover)));
                    component.set("v.interiorApprover", intApp[0]);
                    prodTypes.push('Interior');
                    
                    if(approvers.indexOf(margins.interiorApprover) == -1)
                        approvers.push(margins.interiorApprover);
                    
                    if(email.indexOf(intApp[0]) == -1)
                    	email.push(intApp[0]);
                                        
                    if(approvers.indexOf(margins.airframeScheduler) == -1)
                        approvers.push(margins.airframeScheduler);
                    
                    if(email.indexOf(afScheduler[0]) == -1)
                        email.push(afScheduler[0]);
                    
                    //Airframe Shop Director
                    if(cc.indexOf(margins.airframeShopDirector) == -1)
                        cc.push(margins.airframeShopDirector);  
                }
                               
                //Paint - Review
                if(margins.paintApprover != null){
                    component.set("v.afRadioValue", 'true');
                    
                    var pntApp = Object.values(JSON.parse(JSON.stringify(margins.paintApprover)));
                    component.set("v.paintApprover", pntApp[0]);
                    prodTypes.push('Paint');
                    
                    if(approvers.indexOf(margins.paintApprover) == -1)
                        approvers.push(margins.paintApprover);
                    
                    if(email.indexOf(pntApp[0]) == -1)
                    	email.push(pntApp[0]);
                                        
                    if(approvers.indexOf(margins.airframeScheduler) == -1)
                        approvers.push(margins.airframeScheduler);
                    
                    if(email.indexOf(afScheduler[0]) == -1)
                        email.push(afScheduler[0]);
                    
                    //Airframe Shop Director
                    if(cc.indexOf(margins.airframeShopDirector) == -1)
                        cc.push(margins.airframeShopDirector);  
                }
                                
                //Other Group - Review
                if(margins.otherApprover != null){
                    var otherApp = Object.values(JSON.parse(JSON.stringify(margins.otherApprover)));
                    component.set("v.otherApprover", otherApp[0]);
                    console.log('Other Approver: ' + otherApp[0]);
                    
                    prodTypes.push('Other');

                    if(approvers.indexOf(margins.otherApprover) == -1)
                        approvers.push(margins.otherApprover);
                    
                    if(email.indexOf(otherApp[0]) == -1)
                    	email.push(otherApp[0]);
                }
                
                prodTypes = JSON.stringify(prodTypes).replace(/[^a-zA-Z0-9\s]/g, " ").replace(/\s\s/g, " ");
                component.set('v.prodTypes', prodTypes);
                
                //Opportunity Owner Email into List
                if(email.indexOf(Object.values(JSON.parse(JSON.stringify(margins.oppOwner)))) == -1)
                    cc.push(Object.values(JSON.parse(JSON.stringify(margins.oppOwner))));
                               
                //Remove CC if in Email list
                for (var i = 0; i < email.length; i++) {
                    for (var j = 0; j < cc.length; j++) {
                        if (email[i]  == cc[j]) 
                            cc.splice(j, 1);
                    }
                }
                       
                //Set Approver List
                component.set("v.Approvers", approvers); 
                
                //Set Email List
                var emailList = JSON.parse(JSON.stringify(email)).toString();
                var ccList = JSON.parse(JSON.stringify(cc)).toString();
                
                component.set("v.Email", email);  
                component.set("v.EmailList", emailList);
                
                component.set("v.CC", cc);   
                component.set("v.ccList", ccList);
                               
            }else{
                console.log('Error:' + JSON.stringify(a.getReturnValue()));
            } 
        });
        $A.enqueueAction(action);
        component.set("v.spinner", false);
    },
    
    getFacilityValues : function(component, event, helper){
        var quoteId = component.get("v.recordId");      
        var action = component.get("c.getFacility");
        action.setParams({
            'quoteId': quoteId 
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var facValues = a.getReturnValue();
                var facMap = JSON.stringify(facValues);
                component.set("v.facFields", facValues);
            }else{
                console.log('Error Facility!');
            } 
        });
        $A.enqueueAction(action);
    }
    
})