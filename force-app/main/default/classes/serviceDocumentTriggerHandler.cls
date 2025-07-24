/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-20-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class serviceDocumentTriggerHandler {
  public static void updateServiceDocument(List<Service_Document__c> newList) {
        Date today = Date.today();

        for (Service_Document__c doc : newList) {
            // Null checks
            if (doc.Start_Date__c == null || doc.Expiry_Date__c == null || 
                String.isBlank(doc.Renewal_Type__c)) {
                doc.Next_Renewal_Date__c = null;
                continue;
            }

            // Skip if expired
            if (today > doc.Expiry_Date__c) {
                doc.Next_Renewal_Date__c = null;
                continue;
            }

            Date nextRenewal = doc.Start_Date__c;

            // Add months or years until nextRenewal is after today and within expiry
            while (nextRenewal <= today && nextRenewal <= doc.Expiry_Date__c) {
                if (doc.Renewal_Type__c.toLowerCase() == 'month') {
                    nextRenewal = nextRenewal.addMonths(1);
                } else if (doc.Renewal_Type__c.toLowerCase() == 'year') {
                    nextRenewal = nextRenewal.addYears(1);
                } else {
                    // Invalid renewal type
                    nextRenewal = null;
                    break;
                }
            }

            // Final check
            if (nextRenewal != null && nextRenewal <= doc.Expiry_Date__c) {
                doc.Next_Renewal_Date__c = nextRenewal;
            } else {
                doc.Next_Renewal_Date__c = null;
            }
        }
    }
}