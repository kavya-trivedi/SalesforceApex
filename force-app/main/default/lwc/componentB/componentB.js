import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ComponentB extends NavigationMixin(LightningElement) {
    @api recordId;
    imageUrl;
    imageHeight;
    imageWidth;
    imageAlignment;
    imageMargin;
    label;
    description;
    textSize;
    textFont;
    textColor;
    textAlignment;

    @track isImageSelected = false;
    @track isTextWritten = false;

    get acceptedFormats() {
        return ['.jpg', '.png', '.jpeg'];
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;

        if (uploadedFiles.length > 0) {
            const fileId = uploadedFiles[0].documentId;
            this.imageUrl = `/sfc/servlet.shepherd/document/download/${fileId}`;
        }
        console.log('Uploaded files:', uploadedFiles);

        this.isImageSelected = true;

        const event1 = new CustomEvent('preview', {
            detail: { imageUrl: this.imageUrl }
        });
        this.dispatchEvent(event1);
    }

    handleImageHeight(event) {
        this.imageHeight = event.target.value;

        const event1 = new CustomEvent('imageheight', {
            detail: { imageHeight: this.imageHeight }
        });
        this.dispatchEvent(event1);
    }

    handleImageWidth(event) {
        this.imageWidth = event.target.value;

        const event1 = new CustomEvent('imagewidth', {
            detail: { imageWidth: this.imageWidth }
        });
        this.dispatchEvent(event1);
    }

    handleImageAlignment(event) {
        this.imageAlignment = event.target.value;

        const event1 = new CustomEvent('imagealignment', {
            detail: { imageAlignment: this.imageAlignment }
        });
        this.dispatchEvent(event1);
    }

    handleImageMargin(event) {
        this.imageMargin = event.target.value;

        const event1 = new CustomEvent('imagemargin', {
            detail: { imageMargin: this.imageMargin }
        });
        this.dispatchEvent(event1);
    }

    handleTextSizeChange(event) {
        this.textSize = event.target.value;

        const event1 = new CustomEvent('textsize', {
            detail: { textSize: this.textSize }
        });
        this.dispatchEvent(event1);
    }

    handleTextFontChange(event) {
        this.textFont = event.target.value;

        const event1 = new CustomEvent('textfont', {
            detail: { textFont: this.textFont }
        });
        this.dispatchEvent(event1);
    }

    handleTextColorChange(event) {
        this.textColor = event.target.value;

        const event1 = new CustomEvent('textcolor', {
            detail: { textColor: this.textColor }
        });
        this.dispatchEvent(event1);
    }

    handleTextAlignmentChange(event) {
        this.textAlignment = event.target.value;

        const event1 = new CustomEvent('textalignment', {
            detail: { textAlignment: this.textAlignment }
        });
        this.dispatchEvent(event1);
    }

    handleLabelChange(event) {
        try {
            this.label = event.target.value;

            if (this.label!='' || this.description!='') {
                this.isTextWritten = true;
            } else {
                this.isTextWritten = false;
            }

            const event1 = new CustomEvent('label', {
                detail: { label: this.label }
            });
            this.dispatchEvent(event1);
        } catch (error) {
            console.error('Error in handleLabelChange:', error);
        }
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
        if (this.description!='' || this.label!='') {
            this.isTextWritten = true;
        } else {
            this.isTextWritten = false;
        }

        const event1 = new CustomEvent('description', {
            detail: { description: this.description }
        });
        this.dispatchEvent(event1);
    }

}