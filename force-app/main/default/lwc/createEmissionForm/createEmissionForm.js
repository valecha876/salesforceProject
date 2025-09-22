import { LightningElement, wire, track } from 'lwc';
import getEmissions from '@salesforce/apex/CarbonEmissionController.getEmissions';

export default class CarbonFootprintTracker extends LightningElement {
    @track isModalOpen = false;
    emissions;
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Amount (CO₂e)', fieldName: 'Amount__c', type: 'number' },
        { label: 'Date', fieldName: 'Date__c', type: 'date' },
        { label: 'Status', fieldName: 'Status__c' }
    ];

    @wire(getEmissions)
    wiredEmissions(result) {
        this.emissions = result;
        console.log('Emissions data:', result);
    }

    openModal() {
        this.isModalOpen = true;
        console.log('Modal would open now');
    }
}