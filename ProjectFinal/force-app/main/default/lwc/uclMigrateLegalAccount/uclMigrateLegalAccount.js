import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UclMigrateLegalAccount extends LightningElement {
    handleClick(event) {
        const toastEvent = new ShowToastEvent({
            title: "Account created",
            message: "Record ID: ",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }

}