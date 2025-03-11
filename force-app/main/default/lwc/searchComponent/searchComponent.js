import { LightningElement } from 'lwc';
import searchRecords from '@salesforce/apex/SearchController.searchRecords';

export default class SearchComponent extends LightningElement {
    searchKeyword = '';
    selectedObjects = [];
    searchResults = [];
    
    objectOptions = [
        { label: 'Account', value: 'Account' },
        { label: 'Contact', value: 'Contact' },
        { label: 'Lead', value: 'Lead' },
        { label: 'Opportunity', value: 'Opportunity' }
    ];

    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Id', fieldName: 'Id', type: 'text' }
    ];

    handleKeywordChange(event) {
        this.searchKeyword = event.target.value;
    }

    handleObjectChange(event) {
        this.selectedObjects = event.detail.value;
    }

    handleSearch() {
        if (!this.searchKeyword || this.selectedObjects.length === 0) {
            alert('Please enter a search keyword and select at least one object.');
            return;
        }

        searchRecords({ searchKeyword: this.searchKeyword, objectNames: this.selectedObjects })
            .then(result => {
                this.searchResults = Object.keys(result).map(objName => ({
                    objectName: objName,
                    records: result[objName]
                }));
            })
            .catch(error => {
                console.error('Error fetching search results:', error);
            });
    }
}
