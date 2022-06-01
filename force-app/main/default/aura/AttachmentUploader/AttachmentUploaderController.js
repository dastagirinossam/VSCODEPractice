({
    handleUploadFinished : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        
        for(var i = 0; i < uploadedFiles.length; i++){
            console.log(uploadedFiles[i].name);
        }
        
        var toastEvent = $A.get("e.force:showToast");
        for(var i = 1; i < uploadedFiles.length; i++){
            fileName = fileName + ','+''+ uploadedFiles[i].name;
        }
        
        toastEvent.setParams({
            "title": "File Upload Success",
            "message": "File " + fileName +" Uploaded successfully.",
            "type" : "SUCCESS"
        });
        
        toastEvent.fire();

        var attachmentUploaderEvent = component.getEvent("AttachmentUploaderEvent");
        attachmentUploaderEvent.setParam("Uploaded", "Success");
        attachmentUploaderEvent.fire();
              
        var updateAttachmentsAppEvent = component.getEvent("updateAttachmentsAppEvent");
        updateAttachmentsAppEvent.fire();   
        
        $A.get('e.force:refreshView').fire();
    }
})