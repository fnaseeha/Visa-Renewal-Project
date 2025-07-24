/**
 * @description       : 
 * @author            : Naseeha
 * @group             : 
 * @last modified on  : 07-24-2025
**/
global class DocumentRenewalReminderBatch implements Database.Batchable<SObject>, Database.Stateful{//Schedulable {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.today();
        Date fiveDays = today.addDays(5);
        Date tenDays = today.addDays(10);

        String query = 'SELECT Id, Name, Expiry_Date__c,Next_Renewal_Date__c,Renewal_Type__c, Source_File_Name__c,'+
                       ' Account_Number__c, Bank_Name__c, Owner.Email ' +
                       'FROM Service_Document__c ' +
                       'WHERE Next_Renewal_Date__c =:fiveDays OR '+
                       'Next_Renewal_Date__c = :tenDays or Next_Renewal_Date__c = :today';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Service_Document__c> records) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Service_Document__c doc : records) {
            if (doc.Owner.Email != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { doc.Owner.Email });
                mail.setSubject('📌 Document Renewal Reminder');

                String emailBody = 'Dear '+doc.Owner.Name+',\n\n' +
            'This is a friendly reminder that the document "' + doc.Name + '" is approaching its renewal period.\n\n' +
            '📄 Document Details:\n' +
            '• Expiry Date: ' + String.valueOf(doc.Expiry_Date__c) + '\n' +
            '• Next Renewal Date: ' + String.valueOf(doc.Next_Renewal_Date__c) + '\n' +
            '• Renewal Type: ' + doc.Renewal_Type__c + '\n' +
            '• Source File: ' + doc.Source_File_Name__c + '\n' +
            '• Account Number: ' + doc.Account_Number__c + '\n' +
            '• Bank Name: ' + doc.Bank_Name__c + '\n\n' +
            'Please take the necessary steps to ensure a timely renewal.\n\n' +
            'Best Regards,\n' +
            'Support Team';

               mail.setPlainTextBody(emailBody);
               emails.add(mail);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Batch completed: Document renewal reminders sent.');
    }

    // global void execute(SchedulableContext sc) {
    //     DocumentRenewalReminderBatch batch = new DocumentRenewalReminderBatch();
    //     Database.executeBatch(batch, 50); // Set batch size as needed
    // }

}
