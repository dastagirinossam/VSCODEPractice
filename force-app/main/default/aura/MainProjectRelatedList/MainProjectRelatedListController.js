({
   doInit : function(component, event, helper) {
      $A.createComponent(
         "c:ProjectRelatedList",
         {

         },
         function(newCmp){
            if (component.isValid()) {
               component.set("v.body", newCmp);
            }
         }
      );
   },
   NavigateComponent : function(component,event,helper) {
      $A.createComponent(
         "c:ProjectsNotesAndAttachmentsRelatedList",
         {
           "project" : event.getParam("project")
         },
         function(newCmp){
            if (component.isValid()) {
                component.set("v.body", newCmp);
            }
         }
      );
   }
})