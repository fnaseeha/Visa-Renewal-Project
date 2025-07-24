import { LightningElement, wire,track } from 'lwc';
import getRecentDocuments from '@salesforce/apex/ServiceDocumentController.getRecentDocuments';

export default class RecentDocuments extends LightningElement {
    @track documents;
    error;

    @wire(getRecentDocuments)
    wiredDocs({ data, error }) {
        if (data) {
            this.documents = data;
            console.log(data);
            
            console.log(JSON.stringify(this.documents));
            
        } else if (error) {
            this.error = error;
        }
    }
}
