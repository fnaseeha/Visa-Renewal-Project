# 🔁 Salesforce Document Renewal Reminder

This Salesforce automation project enables users to upload CSV files containing visa or document details, including expiry dates and renewal types. The system extracts and processes the data, then schedules automated email reminders to document owners for upcoming expirations (0, 5, or 10 days). Built with Apex, Batch Apex, and scheduled jobs, it supports bulk processing, ensures timely renewals, and follows Salesforce best practices for compliance and error handling.

## 📌 Features

- ⏱️ Scheduled job to run daily using CRON expression.
- 📦 Batch Apex to handle large volumes of records.
- 📧 Email reminders to document owners with expiry and renewal details.
- ✅ Follows Salesforce best practices for bulk processing and error handling.

---

## ⚙️ Technologies Used

- Salesforce Apex
- Batch Apex
- Schedulable Apex
- SOQL
- Email Services (`Messaging.SingleEmailMessage`)
- Salesforce Scheduler (CRON jobs)

---

## 📄 Logic Summary

### SOQL Query
Retrieves `Service_Document__c` records with:
- `Next_Renewal_Date__c = Today`
- `Next_Renewal_Date__c = Today + 5 days`
- `Next_Renewal_Date__c = Today + 10 days`

### Email Body
Includes:
- Document Name
- Expiry Date
- Next Renewal Date
- Renewal Type
- Source File Name
- Account Number
- Bank Name

---

## 🔧 Setup Instructions

### 1. Deploy Apex Class

Deploy the class `ServiceDocumentRenewalBatch` to your org.

```apex
global class ServiceDocumentRenewalBatch implements Database.Batchable<SObject>, Schedulable {
    // Implementation here...
}

2. Schedule the Batch Job
Open Developer Console > Anonymous Window and run:

String cronExp = '0 0 9 * * ?'; // Runs daily at 9 AM
ServiceDocumentRenewalBatch scheduler = new ServiceDocumentRenewalBatch();
System.schedule('Daily Document Renewal Batch', cronExp, scheduler);


✅ Example Output
An email sent to the record owner will look like this:

Subject: 📌 Upcoming Document Renewal Reminder – Contract ABC123

Dear User,

This is a friendly reminder that the document "Contract ABC123" is approaching its renewal period.

📄 Document Details:
• Expiry Date: 2025-08-01
• Next Renewal Date: 2025-07-31
• Renewal Type: Annual
• Source File: contract_abc.pdf
• Account Number: 123456
• Bank Name: Clifton Bank

Please take the necessary steps to ensure a timely renewal.

Best Regards,  
Clifton Services Support Team
