import { LightningElement, api } from 'lwc';

export default class ComponentC extends LightningElement {
    @api imageUrl;
    @api imageHeight;
    @api imageWidth;
    @api imageAlignment;
    @api imageMargin;
    @api label;
    @api description;
    @api textSize;
    @api textFont;
    @api textColor;
    @api textAlignment;

    // get imageStyle() {
    //     return `background-image: url(${this.imageUrl}); ${this.imageCss}`;
    // }

    get containerCss() {
        return `text-align: ${this.imageAlignment};`;
    }

    get imageCss() {
        console.log(`height: ${this.imageHeight}; width: ${this.imageWidth}; margin: ${this.imageMargin};`);
        return `height: ${this.imageHeight}; width: ${this.imageWidth}; margin: ${this.imageMargin};`;
    }

    get textCss() {
        return `font-size: ${this.textSize}; font-family: ${this.textFont}; color: ${this.textColor}; text-align: ${this.textAlignment};`;
    }

    get labelStyle() {
        return `color: ${this.imageCss};`;
    }
}