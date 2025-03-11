import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import LMS_CHANNEL from '@salesforce/messageChannel/lmsChannel__c';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class AccountDropdown extends LightningElement {
    selectedAccountId;
    accountOptions = [];

    @wire(MessageContext) messageContext;

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accountOptions = data.map(acc => ({ label: acc.Name, value: acc.Id }));
        } else {
            console.error('Error fetching accounts', error);
        }
    }

    handleAccountChange(event) {
        this.selectedAccountId = event.detail.value;
        publish(this.messageContext, LMS_CHANNEL, { accountId: this.selectedAccountId });
    }
}
