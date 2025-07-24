/**
 * @description       : Upload csv file, exact data and insert to Service_Document__c
 * @author            : Naseeha
 * @group             : 
 * @last modified on  : 07-20-2025
**/
public without sharing class Clftn_FileUpload {
   public class FileData {
        public String Name;
        public Date startDate;
        public Date expiryDate;
        public String renewalType;
        public Date nextRenewalDate;
        public String verificationStatus;
       	public String sourceFileName;
        public String accountNumber;
        public String bankName;
    }

    /**
    * @description 
    * @author Naseeha | 07-18-2025 
    * @param contentVersionId 
    **/
    @AuraEnabled
    public static void processCSV(Id contentVersionId,String sourceFileName) {
        try{
                ContentVersion cv = [SELECT Id, VersionData,FileExtension FROM ContentVersion WHERE Id = :contentVersionId LIMIT 1];
        		String csvContent = cv.VersionData.toString();

        if (cv.FileExtension != 'csv') {
            throw new AuraHandledException('Only .csv files are allowed.');
        }

        List<FileData> DataList = parseCSV(csvContent);
        for (FileData data : DataList) {
        
            // Call Mock Verification API
            data.verificationStatus = callMockVerificationAPI(data);
            data.sourceFileName = sourceFileName;
        }

        insertRecords(DataList);
            
        }catch(Exception e){
                      throw new AuraHandledException('An error has ocurred: ' + e.getMessage());
         }
    }

    private static List<FileData> parseCSV(String csvContent) {
        List<FileData> file_list = new List<FileData>();
        List<String> rows = csvContent.split('\n');
        for (Integer i = 1; i < rows.size(); i++) { // skip header
            List<String> cols = rows[i].split(',');
            if (cols.size() >= 4) {
                FileData v = new FileData();
                v.Name = cols[0].trim();
                v.accountNumber = cols[1].trim();
                v.bankName = cols[2].trim();
                v.startDate =  Date.parse(cols[3].trim());
                v.expiryDate = Date.parse(cols[4].trim());
                v.renewalType = cols[5].trim();
                file_list.add(v);
            }
        }
        return file_list;
    }
  

    private static String callMockVerificationAPI(FileData data) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://mocki.io/v1/a0158e6b-ca93-431a-8625-8f4e05736f9b');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
       
        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                return 'Verified';
            }
        } catch (Exception e) {
            System.debug('API Error: ' + e.getMessage());
        }
        return 'Failed';
    }

    private static void insertRecords(List<FileData> file_list) {
        List<Service_Document__c> records = new List<Service_Document__c>();
        for (FileData data : file_list) {
            records.add(new Service_Document__c(
                Name = data.Name,
                Expiry_Date__c = data.expiryDate,
                Start_Date__c = data.startDate,
                Renewal_Type__c = data.renewalType,
                Next_Renewal_Date__c = data.nextRenewalDate,
                Verification_Status__c = data.verificationStatus,
                Source_File_Name__c = data.sourceFileName,
                Account_Number__c = data.accountNumber,
                Bank_Name__c = data.bankName
            ));
        }
        insert records;
    }

}