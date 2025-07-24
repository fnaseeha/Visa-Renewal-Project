/**
 * @description       : ServiceDocument view , update , delete functions
 * @author            : Naseeha
 * @group             : 
 * @last modified on  : 07-21-2025
**/
public without sharing class ServiceDocumentController {
   @AuraEnabled(cacheable=true)
    public static List<Service_Document__c> getServiceDocuments() {
        return [
            SELECT Id, Name, Expiry_Date__c, Renewal_Type__c, Next_Renewal_Date__c,
                   Verification_Status__c, Start_Date__c, Source_File_Name__c,
                   Account_Number__c, Bank_Name__c
            FROM Service_Document__c
            ORDER BY CreatedDate DESC
        ];
    }

     @AuraEnabled(cacheable=true)
    public static List<Service_Document__c> getRecentDocuments() {
        return [
            SELECT Id, Name, Expiry_Date__c, Renewal_Type__c, Next_Renewal_Date__c,
                   Verification_Status__c, Start_Date__c, Source_File_Name__c,
                   Account_Number__c, Bank_Name__c
            FROM Service_Document__c where Next_Renewal_Date__c> TODAY
            ORDER BY Next_Renewal_Date__c ASC LIMIT 5
        ];
    }
    
    // private static String convertDate(Date inDate){
    //   //  Date inputDate = Date.parse(inDate);
    //     String formattedDate = inDate.format('MM/dd/yyyy');
    //     return formattedDate;
    // }

    @AuraEnabled
    public static void updateServiceDocument(Service_Document__c doc) {
        System.debug(doc);
            if(doc.Expiry_Date__c != null) {
                
             // doc.Expiry_Date__c = Date.parse(doc.Expiry_Date__c);
            }
              if(doc.Start_Date__c != null) {
             //  doc.Start_Date__c = Date.parse(doc.Start_Date__c);
            }
              if(doc.Next_Renewal_Date__c != null) {
             //   doc.Next_Renewal_Date__c = Date.parse(doc.Next_Renewal_Date__c);
            }

            try {
                update doc;
            } catch (DmlException e) {
                System.debug('Update failed: ' + e.getMessage());
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    System.debug('Record that failed: ' + e.getDmlFields(i));
                    System.debug('Error: ' + e.getDmlMessage(i));
                }
            }

    }

    @AuraEnabled
    public static void deleteDocument(Id docId) {
    try {
        delete [SELECT Id FROM Service_Document__c WHERE Id = :docId LIMIT 1];
    } catch (Exception e) {
        throw new AuraHandledException('Failed to delete record: ' + e.getMessage());
    }
}


}