import { LightningElement, api } from 'lwc';

export default class Task2 extends LightningElement {
    @api myRecordId;
    imageUrl;

    get acceptedFormats() {
        return ['.png', '.jpg', '.jpeg'];
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;

        if (uploadedFiles.length > 0) {
            const fileId = uploadedFiles[0].documentId;
            this.imageUrl = `/sfc/servlet.shepherd/document/download/${fileId}`;
        }
        console.log('Uploaded files:', uploadedFiles);
    }
}
