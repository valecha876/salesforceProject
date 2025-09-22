import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

// Apex imports
import getEmissions from '@salesforce/apex/CarbonEmissionController.getEmissions';
import createEmission from '@salesforce/apex/CarbonEmissionController.createEmission';

export default class CarbonFootprintTracker extends NavigationMixin(LightningElement) {
    @track isModalOpen = false;
    @track emissionSource = '';
    @track amount = 0;
    @track emissionDate = '';
    @track description = '';
    @track selectedRecordId = '';

    // 🎯 EVENTS IN LWC: Custom event dispatchers
    dispatchEmissionCreated(emissionId) {
        this.dispatchEvent(new CustomEvent('emissioncreated', {
            detail: { 
                emissionId: emissionId,
                source: this.emissionSource,
                amount: this.amount,
                timestamp: new Date().toISOString()
            },
            bubbles: true,
            composed: true
        }));
    }

    dispatchModalStateChange(isOpen) {
        this.dispatchEvent(new CustomEvent('modalstatechange', {
            detail: { isOpen: isOpen },
            bubbles: true
        }));
    }

    dispatchRowAction(action, recordId, recordName) {
        this.dispatchEvent(new CustomEvent('rowaction', {
            detail: { 
                action: action,
                recordId: recordId,
                recordName: recordName 
            },
            bubbles: true
        }));
    }

    // Get current date for default value
    get currentDate() {
        return new Date().toISOString().split('T')[0];
    }

    // Properties for HTML template
    get isLoading() {
        return this.emissions && this.emissions.loading;
    }

    get hasError() {
        return this.emissions && this.emissions.error;
    }

    get hasData() {
        return this.emissions && this.emissions.data;
    }

    get hasNoEmissions() {
        return this.hasData && this.emissions.data.length === 0;
    }

    get errorMessage() {
        return this.hasError ? this.emissions.error.body?.message : '';
    }

    // ✅ APEX WITH LWC: Columns using Apex data
    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Source', fieldName: 'Source__c', type: 'text' },
        { label: 'Amount (CO₂e)', fieldName: 'Amount__c', type: 'number' },
        { label: 'Date', fieldName: 'Date__c', type: 'date' },
        { label: 'Status', fieldName: 'Status__c', type: 'text' },
        {
            type: 'action',
            typeAttributes: { 
                rowActions: this.getRowActions,
                menuAlignment: 'left' 
            }
        }
    ];

    // Row actions for data table
    getRowActions(row, doneCallback) {
        const actions = [
            { label: 'View Details', name: 'view', iconName: 'utility:preview' },
            { label: 'Edit Record', name: 'edit', iconName: 'utility:edit' }
        ];
        doneCallback(actions);
    }

    // Source options
    sourceOptions = [
        { label: 'Transportation', value: 'Transportation' },
        { label: 'Energy', value: 'Energy' },
        { label: 'Food', value: 'Food' },
        { label: 'Waste', value: 'Waste' },
        { label: 'Other', value: 'Other' }
    ];

    // ✅ WIRE ADAPTERS: Data loading
    @wire(getEmissions)
    emissions;

    connectedCallback() {
        this.emissionDate = this.currentDate;
    }

    // Open modal with event
    openModal() {
        this.isModalOpen = true;
        this.dispatchModalStateChange(true); // 🎯 EVENT
    }

    // Close modal with event
    closeModal() {
        this.isModalOpen = false;
        this.dispatchModalStateChange(false); // 🎯 EVENT
    }

    // Handle form field changes
    handleSourceChange(event) {
        this.emissionSource = event.detail.value;
    }

    handleAmountChange(event) {
        this.amount = event.detail.value;
    }

    handleDateChange(event) {
        this.emissionDate = event.detail.value;
    }

    handleDescriptionChange(event) {
        this.description = event.detail.value;
    }

    // ✅ IMPERATIVE APEX CALLS: Form submission
    async handleSave() {
        // Validate form
        if (!this.emissionSource || !this.amount || !this.emissionDate) {
            this.showToast('Error', 'Please fill all required fields', 'error');
            return;
        }

        try {
            // 🎯 EVENT: Before save
            this.dispatchEvent(new CustomEvent('beforesave', {
                detail: { 
                    source: this.emissionSource, 
                    amount: this.amount,
                    date: this.emissionDate 
                }
            }));

            // IMPERATIVE APEX CALL
            const result = await createEmission({
                type: this.emissionSource,
                amount: parseFloat(this.amount),
                emissionDate: this.emissionDate,
            });

            // 🎯 EVENT: After save
            this.dispatchEmissionCreated(result);

            this.showToast('Success', 'Carbon emission recorded successfully!', 'success');
            this.closeModal();
            refreshApex(this.emissions);

        } catch (error) {
            // 🎯 EVENT: Error
            this.dispatchEvent(new CustomEvent('saveerror', {
                detail: { error: error.body?.message }
            }));
            this.showToast('Error', error.body?.message || 'Error creating emission', 'error');
        }
    }

    // Handle successful record creation
    handleSuccess(event) {
        this.closeModal();
        this.showToast('Success', 'Emission record created!', 'success');
        refreshApex(this.emissions);
    }

    // Handle row actions with events
    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        
        // 🎯 EVENT: Row action triggered
        this.dispatchRowAction(action.name, row.Id, row.Name);
        
        switch (action.name) {
            case 'view':
                this.viewRecord(row.Id);
                break;
            case 'edit':
                this.editRecord(row.Id);
                break;
        }
    }

    // ✅ NAVIGATION SERVICE: View record
    viewRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Carbon_Emission__c',
                actionName: 'view'
            }
        });
    }

    // ✅ NAVIGATION SERVICE: Edit record
    editRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Carbon_Emission__c',
                actionName: 'edit'
            }
        });
    }

    // ✅ NAVIGATION SERVICE: Navigate to list view
    navigateToListView() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Carbon_Emission__c',
                actionName: 'list'
            },
            state: {
                filterName: 'Recent'
            }
        });
    }

    // Refresh data
    refreshData() {
        refreshApex(this.emissions);
        this.showToast('Info', 'Data refreshed!', 'info');
    }

    // Toast message utility
    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }
}