import { LightningElement, api } from 'lwc';
import reassignOwners from '@salesforce/apex/ReassignRecordsController.reassignOwners';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ReassignRecords extends LightningElement {
    @api recordId;
    @api objectApiName;

    @api invoke(){
        reassignOwners({ recordId: this.recordId, objectApiName: this.objectApiName })
        .then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Records reassigned successfully!',
                variant: 'success'
            }));
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body?.message || 'Unexpected error',
                variant: 'error'
            }));
        });
    }
}
