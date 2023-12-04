import { LightningElement, wire } from 'lwc';
import EXCEPTION_MSG_FIELD from '@salesforce/schema/CustomException__c.Exception_Message__c';
import CLASS_NAME_FIELD from '@salesforce/schema/CustomException__c.ClassName__c';
import METHOD_NAME_FIELD from '@salesforce/schema/CustomException__c.MethodName__c';
import LINE_NUMBER_FIELD from '@salesforce/schema/CustomException__c.Line_Number__c';
import DATE from '@salesforce/schema/CustomException__c.Date__c';
import getLogs from '@salesforce/apex/ucl_LogsController.getLogs';
const COLUMNS = [
    { label: 'Message', fieldName: EXCEPTION_MSG_FIELD.fieldApiName, type: 'text' },
    { label: 'Class Name', fieldName: CLASS_NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Method Name', fieldName: METHOD_NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Line Number', fieldName: LINE_NUMBER_FIELD.fieldApiName, type: 'text' },
    { label: 'Date', fieldName: DATE.fieldApiName, type: 'datetime' }
    
];
export default class ViewLogs extends LightningElement {
    columns = COLUMNS;
    @wire(getLogs)
    logs;
}
