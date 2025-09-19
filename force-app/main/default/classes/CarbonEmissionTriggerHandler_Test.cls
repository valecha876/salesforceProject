@isTest
private class CarbonEmissionTriggerHandler_Test {

    @isTest
    static void testTriggerSubmitsRecordForApproval() {
          Emission_Source__c testSource = new Emission_Source__c(
            Name = 'Test Air Travel Source'
       );
    insert testSource;
        // 1. CREATE TEST DATA
        Carbon_Emission__c testEmission = new Carbon_Emission__c(
            Name = 'Test Private Jet',
            Amount__c = 15000, // Definitely over 1000!
            Status__c = 'New',
            Source__c = testSource.Id
        );

        // 2. PERFORM TEST (Inserting the record will fire the trigger)
        Test.startTest(); // Start the test execution context
        insert testEmission;
        Test.stopTest(); // Stop the test context

        // 3. VERIFY RESULTS (Query the Approval Process to see if it was created)
        // Query for ProcessInstance (represents an approval process)
        List<ProcessInstance> approvalProcesses = [
            SELECT Id, Status, TargetObjectId
            FROM ProcessInstance
            WHERE TargetObjectId = :testEmission.Id
        ];

        // ASSERT: Check that exactly one approval process was started
        System.assertEquals(1, approvalProcesses.size(), 'An approval process should have been started for the high-value emission.');
    }
}