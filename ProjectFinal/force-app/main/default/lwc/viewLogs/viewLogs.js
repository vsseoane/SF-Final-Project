import { LightningElement, wire } from 'lwc';
import EXCEPTION_MSG_FIELD from '@salesforce/schema/CustomException__c.Exception_Message__c';
import CLASS_NAME_FIELD from '@salesforce/schema/CustomException__c.ClassName__c';
import METHOD_NAME_FIELD from '@salesforce/schema/CustomException__c.MethodName__c';
import LINE_NUMBER_FIELD from '@salesforce/schema/CustomException__c.Line_Number__c';
import getLogs from '@salesforce/apex/LogsController.getLogs';
const COLUMNS = [
    { label: 'Exception Message', fieldName: EXCEPTION_MSG_FIELD.fieldApiName, type: 'text' },
    { label: 'Class Name', fieldName: CLASS_NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Method Name', fieldName: METHOD_NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Line Number', fieldName: LINE_NUMBER_FIELD.fieldApiName, type: 'text' }
];
export default class ViewLogs extends LightningElement {
    columns = COLUMNS;
    @wire(getLogs)
    logs;
}
