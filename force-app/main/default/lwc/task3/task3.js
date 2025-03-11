import { LightningElement, api } from 'lwc';

export default class Task3 extends LightningElement {
    @api myRecordId;
    imageUrls = [];
    currentPage = 1;
    itemsPerPage = 3;

    get acceptedFormats() {
        return ['.png', '.jpg', '.jpeg'];
    }

    handleUploadFinished(event) {
        console.log('Record ID:', this.myRecordId);
        const uploadedFiles = event.detail.files;

        uploadedFiles.forEach(file => {
            const fileId = file.documentId;
            const fileUrl = `/sfc/servlet.shepherd/document/download/${fileId}`;
            this.imageUrls = [...this.imageUrls, fileUrl];
        });

        console.log('Uploaded files:', uploadedFiles);
    }

    get totalPages() {
        return Math.ceil(this.imageUrls.length / this.itemsPerPage);
    }

    get paginatedImages() {
        const startIndex = (this.currentPage - 1) * this.itemsPerPage;
        return this.imageUrls.slice(startIndex, startIndex + this.itemsPerPage);
    }

    handleNextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
        }
    }

    handlePrevPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
        }
    }

    get isPrevDisabled() {
        return this.currentPage === 1;
    }

    get isNextDisabled() {
        return this.currentPage >= this.totalPages;
    }
}
