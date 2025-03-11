import { LightningElement } from 'lwc';
import getRecords from '@salesforce/apex/WizardController.getRecords';
import sendMail from '@salesforce/apex/EmailManager.sendMail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class WizardComponent extends LightningElement {
    step = 1;
    selectedObject = '';
    records = [];
    selectedRecords = [];
    emailSubject = '';
    emailBody = '';

    objectOptions = [
        { label: 'Lead', value: 'Lead' },
        { label: 'Account', value: 'Account' },
        { label: 'Contact', value: 'Contact' }
    ];

    columns = [
        { label: 'ID', fieldName: 'id' },
        { label: 'Name', fieldName: 'name' },
        { label: 'Email', fieldName: 'email' }
    ];

    handleObjectChange(event) {
        this.selectedObject = event.target.value;
        this.fetchRecords();
    }

    async fetchRecords() {
        if (!this.selectedObject) return;
        try {
            const result = await getRecords({ objectName: this.selectedObject });
            this.records = result.map(rec => ({
                id: rec.Id,
                name: rec.Name,
                email: rec.Email || rec.Email__c || ''
            }));
        } catch (error) {
            console.error('Error fetching records', error);
        }
    }

    handleCheckboxChange(event) {
        const recordId = event.detail.config.value;

        const targetAction = event.detail.config.action;

        const selected = this.records.find(rec => rec.id === recordId);

        if (targetAction == 'rowSelect') {
            this.selectedRecords.push(selected);
        } else if (targetAction == 'rowDeselect') {
            this.selectedRecords = this.selectedRecords.filter(rec => rec.id !== recordId);
        } else if (targetAction == 'selectAllRows') {
            this.selectedRecords = [...this.records];
        } else if (targetAction == 'deselectAllRows') {
            this.selectedRecords = [];
        }
    }

    nextStep() {
        if (this.step === 1 && this.selectedRecords.length === 0) {
            this.showToast('Error', 'Please select at least one record', 'error');
            return;
        }
        this.step++;
    }

    prevStep() {
        this.step--;
    }

    get stepOneVisible() {
        return this.step === 1;
    }

    get stepTwoVisible() {
        return this.step === 2;
    }

    get stepThreeVisible() {
        return this.step === 3;
    }

    get isPreviousDisabled() {
        return this.step === 1;
    }

    get isNextDisabled() {
        return this.step === 3;
    }

    handleInputChange(event) {
        const field = event.target.name;
        if (field === 'subject') {
            this.emailSubject = event.target.value;
        } else if (field === 'body') {
            this.emailBody = event.target.value;
        }
    }

    async handleSendEmail() {
        try {
            const emails = this.selectedRecords.map(rec => rec.email).filter(email => email);
            if (emails.length === 0) {
                this.showToast('Error', 'No valid email addresses found', 'error');
                return;
            }
            await sendMail({
                addresses: emails,
                subject: this.emailSubject,
                body: this.emailBody
            });
            this.showToast('Success', 'Email Sent Successfully', 'success');
            this.resetWizard();
        } catch (error) {
            console.error('Error sending email', error);
            this.showToast('Error', 'Email Sending Failed', 'error');
        }
    }

    resetWizard() {
        this.step = 1;
        this.selectedObject = '';
        this.records = [];
        this.selectedRecords = [];
        this.emailSubject = '';
        this.emailBody = '';
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
