({
    doInit: function(component, event, helper) {
        helper.fetchTypePicklist(component);
        helper.getFacilityValues(component);
        helper.fetchQuoteMargins(component);
    },
    
    showCreditAnalyst : function(component, event, helper) {
        
        var ca = component.get("v.selCA");
        var sca = component.get("v.CreditAnalyst");
        var Email = component.get("v.Email");
        
        console.log('Selected Credit Analyst: ' + sca);
        
        if(Email.indexOf(ca) == -1 && sca != 'NA'){
            for (var i = 0; i < Email.length; i++) {
                console.log('Email i:' + Email[i]);
                console.log('sca: ' + sca.Email);
                if (Email[i]  === sca.Email) {
                    Email.splice(i, 1);
                    console.log('After Email: ' + Email);
                }
            }
        }
        
        var action = component.get('c.getQuoteCreditAnalyst');
        
        action.setParams({"so": ca});
        action.setCallback(this, function(s) {
            
            if(s.getReturnValue() != null){
                component.set("v.CreditAnalyst", {id: s.getReturnValue().Id, Email : s.getReturnValue().Email});
                
                if(Email.indexOf(s.getReturnValue().Email) == -1)
                    Email.push(s.getReturnValue().Email);               
            }
            else{
                component.set("v.CreditAnalyst", "NA");
            }
            
            var emailList = JSON.parse(JSON.stringify(Email)).toString();
            
            component.set("v.Email", Email);  
            component.set("v.EmailList", emailList);  
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    handleMST : function(component, event, helper) {
        
        var mst = component.get("v.mstValue");
        
        var mstLead = component.get("v.mstLead");
        var mstApprover = component.get("v.MST");
        
        var Email = component.get("v.Email");
        var CC = component.get("v.CC");
        
        console.log('Selected MST: ' + mst);
        
        if(CC.indexOf(mst) == -1 && mstLead != 'NA'){
            for (var i = 0; i < CC.length; i++) {
                
                if(CC[i] === mstLead.Email) 
                    CC.splice(i, 1);
                
            }
        }
        
        if(Email.indexOf(mst) == -1 && mstLead != 'NA'){
            for (var i = 0; i < Email.length; i++) {
                
                console.log('Email i:' + Email[i]);
                console.log('MST:' + mstApprover);
                
                if(Email[i] === mstApprover)
                    Email.splice(i, 1);                                
            }
        }
        
        console.log('After Email: ' + Email);
        
        var action = component.get('c.getMST');
        
        action.setParams({"lead": mst});
        action.setCallback(this, function(s) {
            
            if(s.getReturnValue() != null){
                component.set("v.mstLead", {
                    id: s.getReturnValue().Id, 
                    Email : s.getReturnValue().Email
                });
                
                if(CC.indexOf(s.getReturnValue().Email) == -1){
                    CC.push(s.getReturnValue().Email);  
                    Email.push(mstApprover);  
                }
            }
            
            var emailList = JSON.parse(JSON.stringify(Email)).toString();
            var ccList = JSON.parse(JSON.stringify(CC)).toString();
            
            component.set("v.Email", Email);  
            component.set("v.CC", CC);  
            
            component.set("v.EmailList", emailList); 
            component.set("v.ccList", ccList);
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    handleChange : function(component, event, helper){
        var approver = component.get('v.Approvers');
        
        var email = [];
        var cc = [];
        
        var pres = component.get('v.president');
        var vp = component.get('v.vp');
        var vpf = component.get('v.vpf');
        var doqs = component.get('v.doqs');
        var rsd = component.get('v.oppRSD');
        
        var vpgm = component.get("v.vpgm");
        cc.push(vpgm);
        
        var avSch = component.get('v.avionicsScheduler');
        var afSch = component.get('v.airframeScheduler');
        var afShopDir = component.get('v.airframeShopDirector');
        var engSch =  component.get('v.engineScheduler');
        var engShopDir = component.get('v.engineShopDirector');
        var tc = component.get('v.tradecompliance');
        var ac = component.get('v.antiCorruption');
        var legal = component.get('v.legal');
        var government = component.get('v.government');
        var frMatLab = component.get('v.frMatLab');
        
        //AirframeApprover
        var afApprover = component.get('v.airframeApprover');
        if(afApprover != 'NA' && email.indexOf(afApprover) == -1){
            email.push(afApprover);
            
            if(email.indexOf(afSch) == -1)
                email.push(afSch);
            
            if (cc.indexOf(afShopDir) == -1)
                cc.push(afShopDir);
        }
        
        //AvionicsApprover
        var avApprover = component.get('v.avionicsApprover');
        if(avApprover != 'NA' && email.indexOf(avApprover) == -1){
            email.push(avApprover);
            
            if(email.indexOf(avSch) == -1)
                email.push(avSch);
            
            if(cc.indexOf(afShopDir) == -1)
                cc.push(afShopDir);
        }
        
        //InteriorApprover
        var intApprover = component.get('v.interiorApprover');
        if(intApprover != 'NA' && email.indexOf(intApprover) == -1){
            email.push(intApprover);
            
            if(email.indexOf(afSch) == -1)
                email.push(afSch);
            
            if (cc.indexOf(afShopDir) == -1)
                cc.push(afShopDir);
        }
        
        //PaintApprover
        var paintApprover = component.get('v.paintApprover');
        if(paintApprover != 'NA' && email.indexOf(paintApprover) == -1){
            email.push(paintApprover);
            
            if(email.indexOf(afSch) == -1)
                email.push(afSch);
            
            if (cc.indexOf(afShopDir) == -1)
                cc.push(afShopDir);
        }
        
        //APUApprover
        var apuApprover = component.get('v.apuApprover');
        if(apuApprover != 'NA' && email.indexOf(apuApprover) == -1){
            email.push(apuApprover);
            
            if(email.indexOf(engSch) == -1)
                email.push(engSch);
            
            if(cc.indexOf(engShopDir) == -1)
                cc.push(engShopDir);
        }
        
        //HtfApprover
        var htfApprover = component.get('v.htfApprover');
        if(htfApprover != 'NA' && email.indexOf(htfApprover) == -1){
            email.push(htfApprover);
                    
            if(email.indexOf(engSch) == -1)
                email.push(engSch);
            
            if(cc.indexOf(engShopDir) == -1)
                cc.push(engShopDir);
        }
        
        //TfeApprover
        var tfeApprover = component.get('v.tfeApprover');
        if(tfeApprover != 'NA' && email.indexOf(tfeApprover) == -1){
            email.push(tfeApprover);
        
        if(email.indexOf(engSch) == -1)
                email.push(engSch);
            
            if(cc.indexOf(engShopDir) == -1)
                cc.push(engShopDir);
        }
        
        //CfeApprover
        var cfeApprover = component.get('v.cfeApprover');
        if(cfeApprover != 'NA' && email.indexOf(cfeApprover) == -1){
            email.push(cfeApprover);
            
            if(email.indexOf(engSch) == -1)
                email.push(engSch);
            
            if(cc.indexOf(engShopDir) == -1)
                cc.push(engShopDir);
        }
        
        //OtherApprover
        var otherApprover = component.get('v.otherApprover');
        if(otherApprover != 'NA' && email.indexOf(otherApprover) == -1)
            email.push(otherApprover);
        
        //MST 
        var mst = component.get("v.mstValue");
        var mstLead = component.get("v.mstLead");
        var mstApprover = component.get("v.MST");
        
        if(mstLead != '' && mstLead != 'NA'){
            if(cc.indexOf(Object.values(JSON.parse(JSON.stringify(mstLead)))[1]) == -1)
                cc.push(Object.values(JSON.parse(JSON.stringify(mstLead)))[1]);
            
            if(email.indexOf(mstApprover) == -1)
                email.push(mstApprover);
        }
        
        //Credit Analyst
        var ca = component.get('v.CreditAnalyst');
        console.log('Credit Analyst Email: ' + ca.Email);
        console.log('Credit Analyst Id: ' + ca.Id);
        if(ca != '' && ca != 'NA'){
            if(email.indexOf(Object.values(JSON.parse(JSON.stringify(ca)))[1]) == -1)
                email.push(Object.values(JSON.parse(JSON.stringify(ca)))[1]);
        }
        
        //TradeCompliance
        var tradeCompliance = component.get('v.selTcValue');
        if(tradeCompliance == 'true'){
            if(email.indexOf(Object.values(JSON.parse(JSON.stringify(tc)))) == -1)
                email.push(Object.values(JSON.parse(JSON.stringify(tc))));
        }
        
        //antiCorruption
        var antiCorrupt = component.get('v.x3rdPartyValue');
        if(antiCorrupt == 'true'){
            for(var key in ac){
                if(email.indexOf(Object.values(JSON.parse(JSON.stringify(ac)))) == -1)
                    email.push(Object.values(JSON.parse(JSON.stringify(ac))));
            } 
        }
        
        //government
        var gov = component.get('v.govControlValue');
        if(gov == 'true'){
            if(email.indexOf(Object.values(JSON.parse(JSON.stringify(government)))) == -1)
                email.push(Object.values(JSON.parse(JSON.stringify(government))));                      
        }
        
        //legal        
        var lv = component.get('v.legalValue');
        if(lv == 'true'){
            if(email.indexOf(Object.values(JSON.parse(JSON.stringify(legal)))) == -1)
                email.push(Object.values(JSON.parse(JSON.stringify(legal))));       
        }
        
        //flatrate material - labor       
        var fr = component.get('v.frmlValue');
        if(fr == 'true'){       
            if(email.indexOf(Object.values(JSON.parse(JSON.stringify(frMatLab)))) == -1)
                email.push(Object.values(JSON.parse(JSON.stringify(frMatLab))));
        }
        
        //1 Million - 5 Million      
        var x1m = component.get('v.X1mlValue');
        var x5m = component.get('v.X5mlValue');
        if(x1m == 'true' || x5m == 'true'){
            if(email.indexOf(Object.values(JSON.parse(JSON.stringify(pres)))) == -1)
                email.push(Object.values(JSON.parse(JSON.stringify(pres))));
            
            //vp
            if(cc.indexOf(vp) == -1 && vp != null && email.indexOf(vp) == -1)
                cc.push(vp);
            
            //vpf
            if(cc.indexOf(vpf) == -1 && vpf != null && email.indexOf(vpf) == -1)
                cc.push(vpf);
            
            //rsd
            if(cc.indexOf(rsd) == -1 && rsd != null && email.indexOf(rsd) == -1)
                cc.push(rsd);
            
            //Director of Quoting 
            if(cc.indexOf(doqs) == -1 && doqs != null && email.indexOf(doqs) == -1)
                cc.push(doqs);           
        }
        
        //airframe scheduler/director
        var af = component.get('v.afRadioValue');
        if(af == 'true'){
            if(email.indexOf(afSch) == -1)
                email.push(afSch);
            
            if (cc.indexOf(afShopDir) == -1)
                cc.push(afShopDir);
        }
        
        //avionics scheduler/director
        var av = component.get('v.avRadioValue');
        if(av == 'true'){
            if(email.indexOf(avSch) == -1)
                email.push(avSch);
            
            if(cc.indexOf(afShopDir) == -1)
                cc.push(afShopDir);
        }
        
        //engine scheduler/director
        var eq = component.get('v.engRadioValue');
        if(eq == 'true'){           
            if(email.indexOf(engSch) == -1)
                email.push(engSch);
            
            if(cc.indexOf(engShopDir) == -1)
                cc.push(engShopDir);
        }
        
        //Opportunity Owner
        var oppOwner = component.get('v.oppOwner');
        if(email.indexOf(oppOwner) == -1 && cc.indexOf(oppOwner) == -1)
            cc.push(oppOwner);
        
        var directors = component.get('v.directors');
        if(directors != null){
            for(var i = 0; i < JSON.parse(JSON.stringify(directors)).length; i++){                      
                cc.push(JSON.parse(JSON.stringify(directors))[i].Email);
                console.log(JSON.parse(JSON.stringify(directors))[i].Email);
            }
        }
        
        //Additional Emails
        var email1 = component.get('v.email1');
        if(email1 != '' && email.indexOf(email1) == -1 && cc.indexOf(email1) == -1)
            cc.push(email1);
        
        var email2 = component.get('v.email2'); 
        if(email2 != '' && email.indexOf(email2) == -1 && cc.indexOf(email2) == -1)
            cc.push(email2);
        
        var email3 = component.get('v.email3');
        if(email3 != '' && email.indexOf(email3) == -1 && cc.indexOf(email3) == -1)
            cc.push(email3);
        
        //Remove CC if in Email list
        for (var i = 0; i < email.length; i++) {
            for (var j = 0; j < cc.length; j++) {
                console.log('Email: ' + email[i] + ' CC: ' + cc[j]);
                if (email[i]  == cc[j]) 
                    cc.splice(j, 1);
            }
        }
        
        var emailList = JSON.parse(JSON.stringify(email)).toString();
        var ccList = JSON.parse(JSON.stringify(cc)).toString();
        
        component.set("v.Email", email);  
        component.set("v.EmailList", emailList);
        
        component.set("v.CC", cc);   
        component.set("v.ccList", ccList);
        
        console.log('Email List: ' + emailList);
    },
    
    sendQuote : function(component, event, helper){
        component.set("v.spinner", true);
        
        var files = component.get("v.selected");
        var fileMap = JSON.stringify(files);
        var emailList = component.get('v.EmailList');
        var ccList = component.get('v.ccList');
        var quoteId = component.get('v.quoteId');
        var prodTypes = component.get('v.prodTypes');
        var fac = component.get('v.facFields.Name');
        var eRev = component.get('v.ExpectedRevenue');
        var eMP = component.get('v.EstimatedMarginPercent');
        var eHrs = component.get('v.EstimatedHours');
        var inputDate = component.get('v.InputDate');
        var qDownTime = component.get('v.Quoted_Downtime');
        var competitor = component.get('v.Competitor');
        var cmpNote = component.get('v.myText');
        
        var pres = component.get('v.president');
        var tc = component.get('v.tradecompliance');
        var ac = component.get('v.antiCorruption');
        var legal = component.get('v.legal');
        var government = component.get('v.government');
        var frMatLab = component.get('v.frMatLab');
        
        var additionalNotes = component.get('v.notes');
        
        /*var notes = [];        
        notes = additionalNotes.split('\n');
        console.log('Notes: ' + notes);
        
        additionalNotes = JSON.stringify(notes);
        console.log('AD: ' + additionalNotes);*/
        
        var notes = component.get('v.notes');
        
        var approvers = component.get('v.Approvers');
        var approverIds = [];                  
        var i = 0;
        var a = JSON.parse(JSON.stringify(approvers));
        var idString = '';
        
        for(var key in approvers){
            var id = Object.keys(JSON.parse(JSON.stringify(a[i])));
            if(approverIds.indexOf(id) == -1){
                idString += id + ',';                
                approverIds.push(id);
            }
            i = i + 1;
        } 
        
        //Credit Analyst
        var ca = component.get("v.CreditAnalyst");
        console.log('Credit Analyst Id: ' + ca.id + ' Credit Analyst Email: ' + ca.Email);
        if(ca != 'NA'){
            approverIds.push(ca.Id);
            idString += Object.keys(JSON.parse(JSON.stringify(ca))) + ',';           
        }
        
        //International
        var tradeCompliance = component.get('v.selTcValue');
        if(tradeCompliance != 'true'){
            if(approverIds.indexOf(Object.keys(JSON.parse(JSON.stringify(tc)))) == -1){
                approverIds.push(Object.keys(JSON.parse(JSON.stringify(tc))));
                idString += Object.keys(JSON.parse(JSON.stringify(tc))) + ',';               
            }
        }
        
        //antiCorruption
        var antiCorrupt = component.get('v.x3rdPartyValue');
        if(antiCorrupt == 'true'){
            if(approverIds.indexOf(Object.keys(JSON.parse(JSON.stringify(ac)))) == -1){
                approverIds.push(Object.keys(JSON.parse(JSON.stringify(ac))));
                idString += Object.keys(JSON.parse(JSON.stringify(ac))) + ',';               
            }
        }
        
        //government
        var gov = component.get('v.govControlValue');
        if(gov == 'true'){
            if(approverIds.indexOf(Object.keys(JSON.parse(JSON.stringify(government)))) == -1){
                approverIds.push(Object.keys(JSON.parse(JSON.stringify(government))));
                idString += Object.keys(JSON.parse(JSON.stringify(government))) + ',';               
            }
        }
        
        //legal        
        var lv = component.get('v.legalValue');
        if(lv == 'true'){
            if(approverIds.indexOf(Object.keys(JSON.parse(JSON.stringify(legal)))) == -1){
                approverIds.push(Object.keys(JSON.parse(JSON.stringify(legal))));
                idString += Object.keys(Object.keys(JSON.parse(JSON.stringify(legal)))) + ',';               
            }
        }
        
        //flatrate material - labor       
        var fr = component.get('v.frmlValue');
        if(fr == 'true'){
            if(approverIds.indexOf(Object.keys(JSON.parse(JSON.stringify(frMatLab)))) == -1){
                approverIds.push(Object.keys(JSON.parse(JSON.stringify(frMatLab))));
                idString += Object.keys(JSON.parse(JSON.stringify(frMatLab))) + ',';               
            }
        }
        
        //1 Million - 5 Million      
        var x1m = component.get('v.X1mlValue');
        var x5m = component.get('v.X5mlValue');
        if(x1m == 'true' || x5m == 'true'){ 
            if(approverIds.indexOf(Object.keys(JSON.parse(JSON.stringify(pres)))) == -1){
                approverIds.push(Object.keys(JSON.parse(JSON.stringify(pres))));
                idString += Object.keys(JSON.parse(JSON.stringify(pres))) + ',';               
            }
        }
        
        idString = idString.substring(0, idString.length - 1);
        
        console.log('Ids: ' + idString);
        console.log('Approver Ids: ' + approverIds);      
        console.log('Email: ' + emailList);
        console.log('CC: ' + ccList);
        
        var action = component.get('c.EmailQuoteDetails');
        var resultsToast = $A.get("e.force:showToast");
        
        action.setParams({"email" : emailList,
                          "cc" : ccList,
                          "approvers" : idString,
                          "quoteId" : quoteId,
                          "prodTypes" : prodTypes,
                          "fac" : fac,
                          "eRev" : eRev,
                          "eMP" : eMP,
                          "eHrs" : eHrs,
                          "inputDate" : inputDate,
                          "qDownTime" : qDownTime,
                          "competitor" : competitor,
                          "notes" : notes,
                          "fileMap" : fileMap 
                         });
        
        action.setCallback(this, function(s) {
            var state = s.getState();
            if (state === "SUCCESS"){
                
                resultsToast.setParams({
                    duration:' 4000',
                    key: 'info_alt',
                    mode : 'pester',
                    type : "success",
                    title : "Backsheet Routing Success",
                    message : "Quote was successfully routed for approval"           
                });
                
                resultsToast.fire();
                $A.get("e.force:closeQuickAction").fire();
                
            }else if(state === "ERROR"){

                component.set("v.spinner", false);
                
                var errors = JSON.stringify(s.getError());

                resultsToast.setParams({
                    duration:' 4000',
                    key: 'info_alt',
                    mode : 'pester',
                    type : "error",
                    title : "Backsheet Routing Error",
                    message : "Error Occurred with Backsheet Routing, Contact your Salesforce Administrator For Help"         
                });
                
                resultsToast.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    },
    
    cancel: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    
    toOpenAttachments : function(component, event, helper) {
        console.log("Opened small modal to select attachments");
        component.set("v.open", true);
    },
    
    selectedAction : function(component, event, helper) {
        console.log("Opened selectedAction");
        
        var select = event.getParam("selectedIds");
        component.set("v.selected", select);
        console.log('Selected Files: ' + select);
        
    },
    
    handleRemoveOnly : function(component, event, helper) {
        console.log("in remove");
        var sel = event.getSource().get("v.name");
        console.log(JSON.stringify(sel));
        var lis = component.get("v.selected");
        console.log(JSON.stringify(lis));
        for(var i = 0; i < lis.length; i++){
            console.log(JSON.stringify(lis[i]));
            console.log(lis[i].Id);
            console.log(sel.Id);
            console.log(lis[i].Id == sel.Id);
            if(lis[i].Id == sel.Id){
                
                lis.splice(i,1);
            }
        }
        
        component.set("v.selected", lis);
        console.log(JSON.stringify(lis));
    },
    
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },
    
    hideSpinner : function(component,event,helper){  
        component.set("v.spinner", false);
    }
})