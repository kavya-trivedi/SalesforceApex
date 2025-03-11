import { LightningElement, api } from 'lwc';

export default class Pagination extends LightningElement {
    @api items = [];
    @api pageSize = 5;

    currentPage = 1;
    paginatedItems = [];

    get totalPages() {
        return Math.ceil(this.items.length / this.pageSize);
    }

    get disablePrev() {
        return this.currentPage === 1;
    }

    get disableNext() {
        return this.currentPage === this.totalPages || this.totalPages === 0;
    }

    connectedCallback() {
        this.updatePaginatedItems();
    }

    @api refreshPagination() {
        this.currentPage = 1;
        this.updatePaginatedItems();
    }

    updatePaginatedItems() {
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        this.paginatedItems = this.items.slice(start, end);

        // Dispatch event to parent to update displayed items
        this.dispatchEvent(new CustomEvent("update", { detail: this.paginatedItems }));
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updatePaginatedItems();
        }
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updatePaginatedItems();
        }
    }
}
