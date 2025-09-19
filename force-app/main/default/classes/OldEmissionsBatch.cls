global class OldEmissionsBatch implements Database.Batchable<SObject> {

    // Query locator to gather all the records to process
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Name, High_Emission_Flag__c FROM Carbon_Emission__c ' +
                       'WHERE CreatedDate < LAST_N_DAYS:30 ' +
                       'AND Status__c != \'Approved\' ' +
                       'AND Amount__c > 1000';
        return Database.getQueryLocator(query);
    }

    // The actual processing logic for each "chunk" of data
    global void execute(Database.BatchableContext bc, List<Carbon_Emission__c> scope) {
        for (Carbon_Emission__c record : scope) {
            record.High_Emission_Flag__c = true; // Flag the record
        }
        update scope; // Update all records in this batch
    }

    // Post-processing logic (e.g., send an email)
    global void finish(Database.BatchableContext bc) {
        // You can send an email here to notify an admin the job is done.
        // Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // ... (email setup code) ...
        // Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
    }
}