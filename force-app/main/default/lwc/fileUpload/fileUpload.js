import { LightningElement, api, track } from 'lwc';
import processCSV from '@salesforce/apex/Clftn_FileUpload.processCSV';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class FileUpload extends NavigationMixin(LightningElement) {

    @api recordId; // Pass recordId where file should be uploaded
    acceptedFormats = ['.csv']; // Customize as needed
    @track uploadedFiles = [];

    handleUploadFinished(event) {
       const uploadedFiles = event.detail.files;
        this.uploadedFiles = [...this.uploadedFiles, ...uploadedFiles];
        const fileId = uploadedFiles[0].contentVersionId;
        const fileName = uploadedFiles[0].name;
        // Call Apex to process the uploaded CSV file
        processCSV({ contentVersionId: fileId, sourceFileName :fileName})
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'CSV processed and records inserted.',
                        variant: 'success'
                    })
                );

                setTimeout(() => {
                    this[NavigationMixin.Navigate]({
                        type: 'comm__namedPage',
                        attributes: { pageName: 'service-document' }
                    });
                    
                }, 1500); // wait 1.5 seconds so user sees the toast

            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Failed to process CSV.',
                        variant: 'error'
                    })
                );
            });

    }
}
