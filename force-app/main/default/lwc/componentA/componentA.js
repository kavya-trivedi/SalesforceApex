import { LightningElement } from 'lwc';

export default class ComponentA extends LightningElement {
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

    handlePreview(event) {
        this.imageUrl = event.detail.imageUrl;
    }

    handleImageHeight(event) {
        this.imageHeight = event.detail.imageHeight;
    }

    handleImageWidth(event) {
        this.imageWidth = event.detail.imageWidth;
    }

    handleImageAlignment(event) {
        this.imageAlignment = event.detail.imageAlignment;
    }

    handleImageMargin(event) {
        this.imageMargin = event.detail.imageMargin;
    }

    handleLabel(event) {
        this.label = event.detail.label;
    }

    handleDescription(event) {
        this.description = event.detail.description;
    }

    handleTextSize(event) {
        this.textSize = event.detail.textSize;
    }

    handleTextFont(event) {
        this.textFont = event.detail.textFont;
    }

    handleTextColor(event) {
        this.textColor = event.detail.textColor;
    }

    handleTextAlignment(event) {
        this.textAlignment = event.detail.textAlignment;
    }
}