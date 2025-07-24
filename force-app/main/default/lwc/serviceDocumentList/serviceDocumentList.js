import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getServiceDocuments from '@salesforce/apex/ServiceDocumentController.getServiceDocuments';
import updateServiceDocument from '@salesforce/apex/ServiceDocumentController.updateServiceDocument';
import deleteDocument from '@salesforce/apex/ServiceDocumentController.deleteDocument';
import { refreshApex } from '@salesforce/apex';

export default class ServiceDocumentList extends LightningElement {
    @track serviceData;
     @track isModalOpen = false;

    renewalOptions = [
        { label: 'Month', value: 'month' },
        { label: 'Year', value: 'year' }
    ];

    connectedCallback() {
        this.loadDocuments();
    }

    async loadDocuments() {
        try {
            const result = await getServiceDocuments();

            // Transform fields for UI
            this.serviceData = result.map(item => ({
                ...item,
                id: item.Id,
                Start_Date: item.Start_Date__c,
                Expiry_Date: item.Expiry_Date__c,
                Renewal_Type: item.Renewal_Type__c,
                Next_Renewal_Date: item.Next_Renewal_Date__c,
                Verification_Status: item.Verification_Status__c,
                Source_File_Name: item.Source_File_Name__c,
                Account_Number: item.Account_Number__c,
                Bank_Name: item.Bank_Name__c
            }));

        } catch (error) {
            console.error('Error loading documents:', error);
        }

    }



   handleEdit(event) {
        const recordId = event.target.dataset.id;
        const record = this.serviceData.find(item => item.id === recordId);
        
        this.editRecord = { ...record }; // clone for editing
        this.isModalOpen = true;
        
    }

    async handleDelete(event) {
        const recordId = event.target.dataset.id;

        try {
            this.serviceData = this.serviceData.filter(item => item.Id !== recordId);
          
            await deleteDocument({ docId: recordId });

            this.dispatchEvent(new ShowToastEvent({
                title: 'Deleted',
                message: 'Record deleted successfully',
                variant: 'success'
            }));
              
               
        } catch (error) {
            console.error('Error deleting record', error);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body.message || 'Failed to delete record',
                variant: 'error'
            }));
        }
        
    }

    closeModal() {
        this.isModalOpen = false;
    }

    handleFieldChange(event) {
        const field = event.target.dataset.field;
        this.editRecord[field] = event.detail.value;
    }


    async saveRecord() {
        try {
            const updatedDoc = {
                Id: this.editRecord.Id,
                Name: this.editRecord.Name,
                Bank_Name__c: this.editRecord.Bank_Name,
                Account_Number__c: this.editRecord.Account_Number,
                Start_Date__c: this.editRecord.Start_Date,
                Expiry_Date__c: this.editRecord.Expiry_Date,
                Renewal_Type__c: this.editRecord.Renewal_Type,
                Verification_Status__c: this.editRecord.Verification_Status
            };
            
const index = this.serviceData.findIndex(item => item.Id === this.editRecord.Id);

    if (index !== -1) {
      // Replace the record in the array with the updated one
      this.serviceData = [
        ...this.serviceData.slice(0, index),
        {...this.editRecord},              // updated record
        ...this.serviceData.slice(index + 1)
      ];
    }
         
            
            await updateServiceDocument({ doc: updatedDoc });

            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Record updated successfully',
                variant: 'success'
            }));

            this.isModalOpen = false;
            this.loadDocuments();

        } catch (error) {
            console.error('Update failed save record', error);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error updating record',
                message: error.body.message,
                variant: 'error'
            }));
        }
    }


}
