public with sharing class CreateNoteRecord {
    @AuraEnabled
    public static void createRecord(ContentNote nt, id PrentId){
        try{
            if(nt != null){
                insert nt;
                ContentDocument cd=[select id from ContentDocument where id=:nt.Id];
                ContentDocumentLink cdl=new ContentDocumentLink();
                cdl.ContentDocumentId=cd.id;
                cdl.LinkedEntityId=PrentId;
                cdl.ShareType='V';
                cdl.Visibility='AllUsers';
                insert cdl;
            }
        } catch (Exception ex){

        }
    }    
}