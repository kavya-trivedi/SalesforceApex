import { LightningElement,track } from 'lwc';

export default class Test extends LightningElement {
    @track tiles = []; // Array of all tiles
    @track displayedTiles = []; // Array of tiles to display
    @track currentPage = 1;
    @track pageSize = 8;
    
    connectedCallback() {
        // Initialize tiles data (20 tiles in this example)
        for (let i = 1; i <= 20; i++) {
            this.tiles.push({ id: i, label: `Tile ${i}` });
        }
        // Initial display of tiles
        this.displayTiles();
    }
    
    displayTiles() {
        const startIndex = (this.currentPage - 1) * this.pageSize;
        const endIndex = startIndex + this.pageSize;
        this.displayedTiles = this.tiles.slice(startIndex, endIndex);
    }
    
    get disablePrevious() {
        return this.currentPage === 1;
    }
    
    get disableNext() {
        return this.currentPage === Math.ceil(this.tiles.length / this.pageSize);
    }
    
    handlePrevious() {
        if (!this.disablePrevious) {
            this.currentPage--;
            this.displayTiles();
        }
    }
    
    handleNext() {
        if (!this.disableNext) {
            this.currentPage++;
            this.displayTiles();
        }
    }
}