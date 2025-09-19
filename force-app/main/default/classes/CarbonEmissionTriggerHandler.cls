public class CarbonEmissionTriggerHandler {

    public static void handleAfterInsertUpdate(List<Carbon_Emission__c> newRecords) {
        // List to hold records that qualify for approval
        List<Carbon_Emission__c> recordsForApproval = new List<Carbon_Emission__c>();

        // Loop through the triggered records and check the criteria
        for (Carbon_Emission__c record : newRecords) {
            if (record.Amount__c > 1000 && record.Status__c != 'Approved') {
                recordsForApproval.add(record);
            }
        }

        // If we found any qualifying records, process them for approval
        if (!recordsForApproval.isEmpty()) {
            submitRecordsForApproval(recordsForApproval);
        }
    }

    private static void submitRecordsForApproval(List<Carbon_Emission__c> records) {
        // Create a list of approval requests
        List<Approval.ProcessSubmitRequest> approvalRequests = new List<Approval.ProcessSubmitRequest>();

        for (Carbon_Emission__c record : records) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(record.Id); // Point the request to the specific record
            approvalRequests.add(req);
        }

        // Submit all approval requests
        try {
            List<Approval.ProcessResult> results = Approval.process(approvalRequests);
            // You can loop through 'results' to check if each was successful
        } catch (Exception e) {
            // Exception handling: Log the error so an admin can see it
            System.debug('Approval submission failed: ' + e.getMessage());
        }
    }
}