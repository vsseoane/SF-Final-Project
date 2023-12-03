import { LightningElement } from 'lwc';
 import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import migrateAllLegalAccounts from '@salesforce/apex/ucl_LegalAdvisorsService.migrateAllLegalAccounts';
//import sendEmailNotification from '@salesforce/apex/ucl_Utils.sendEmailNotification'; 

export default class UclMigrateLegalAccount extends LightningElement {
    handleClick() {
        migrateAllLegalAccounts()
            .then(response => {
                console.log('response came: ' + response);

                if (!response || response ==  null || response === '' || response === "") {
                   throw new Error("There was an error");
                }
                const toastEvent = new ShowToastEvent({
                    title: "Migration Successful",
                    message: "The legal accounts were imported!",
                    variant: "success"
                });
               
               this.dispatchEvent(toastEvent);
               // sendEmailNotification(true, null, 'vsseoane@gmail.com');

            })
            .catch(error => {
                console.error('Error:', error);
            //sendEmailNotification(false, error.message, 'vsseoane@gmail.com');
                const toastEvent = new ShowToastEvent({
                    title: "Migration Fail",
                    message: " The migration couldn't be created.",
                    variant: "error"
                });
                this.dispatchEvent(toastEvent);
            });
    }
}
