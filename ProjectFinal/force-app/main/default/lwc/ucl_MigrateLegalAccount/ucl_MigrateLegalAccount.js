/* eslint-disable @salesforce/lightning/valid-apex-method-invocation */
import { LightningElement } from 'lwc';
 import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import migrateAllLegalAccounts from '@salesforce/apex/ucl_LegalAdvisorsService.migrateAllLegalAccounts';
import sendEmailNotification from '@salesforce/apex/ucl_Utils.sendEmailNotification'; 

export default class ucl_MigrateLegalAccount extends LightningElement {
    handleClick() {
        migrateAllLegalAccounts()
            .then(response => {
                console.log('response came: ' + response);

                if (!response || response ==  null || response === '' || response === "") {
                   throw new Error("There was an error");
                }

                sendEmailNotification(true, null);
                const toastEvent = new ShowToastEvent({
                    title: "Migration Successful",
                    message: "The legal accounts were imported!",
                    variant: "success"
                });
               
               this.dispatchEvent(toastEvent);
                

            })
            .catch(error => {
                console.error('Error:', error);
                sendEmailNotification(false, error.message);
                const toastEvent = new ShowToastEvent({
                    title: "Migration Fail",
                    message: " The migration couldn't be created.",
                    variant: "error"
                });
                this.dispatchEvent(toastEvent);
            });
    }
}
