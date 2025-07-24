import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class HomePageTiles extends NavigationMixin(LightningElement) {

    navigateToUpload() {
        // Navigate to Upload Files page or component
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: { pageName: 'file-upload' } // customize as needed
        });
    }

    navigateToDocuments() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: { pageName: 'service-document' }
        });
    }

    navigateToFAQ() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: { pageName: 'faq' }
        });
    }
}
