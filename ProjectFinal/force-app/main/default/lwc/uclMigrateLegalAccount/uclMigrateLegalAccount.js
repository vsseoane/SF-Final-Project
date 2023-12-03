import { LightningElement } from 'lwc';
 import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import migrateAllLegalAccounts from '@salesforce/apex/ucl_LegalAdvisors.migrateAllLegalAccounts';
import sendEmailNotification from '@salesforce/apex/ucl_Utils.sendEmailNotification'; 

export default class UclMigrateLegalAccount extends LightningElement {
    handleClick(event) {
        migrateAllLegalAccounts()
            .then(response => {

                if(!response) throw Exception("there was an error");
                sendEmailNotification(true, null, 'vsseoane@gmail.com');
                const toastEvent = new ShowToastEvent({
                    title: "Migration Successful",
                    message: "The legal accounts were imported",
                    variant: "success"
                });
               
                this.dispatchEvent(toastEvent);
            })
            .catch(error => {
                console.error('Error:', error);
                sendEmailNotification(false, error.message, 'vsseoane@gmail.com');
                const toastEvent = new ShowToastEvent({
                    title: "Migration Fail",
                    message: " The migration couldn't be created.",
                    variant: "error"
                });
                this.dispatchEvent(toastEvent);
            });
    }
}
