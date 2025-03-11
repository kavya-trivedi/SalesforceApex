import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import LMS_CHANNEL from '@salesforce/messageChannel/lmsChannel__c';
import getContactsAndOpportunities from '@salesforce/apex/AccountController.getContactsAndOpportunities';

export default class RelatedData extends LightningElement {
    contacts = [];
    opportunities = [];
    
    @wire(MessageContext) messageContext;
    subscription = null;

    connectedCallback() {
        this.subscription = subscribe(this.messageContext, LMS_CHANNEL, (message) => {
            if (message.accountId) {
                this.fetchData(message.accountId);
            }
        });
    }

    async fetchData(accountId) {
        try {
            const data = await getContactsAndOpportunities({ accountId });
            this.contacts = data.contacts;
            this.opportunities = data.opportunities;
        } catch (error) {
            console.error('Error fetching related data', error);
        }
    }
}
