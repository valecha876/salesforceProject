@RestResource(urlMapping='/carbon/emissions/*')
global with sharing class CarbonEmissionAPI {
    
    // GET all carbon emissions
    @HttpGet
    global static String getEmissions() {
        try {
            List<Carbon_Emission__c> emissions = [SELECT Id, Name, Amount__c, Date__c, Status__c 
                                                  FROM Carbon_Emission__c 
                                                  LIMIT 10];
            return JSON.serialize(emissions);
        } catch (Exception e) {
            return '{"error": "' + e.getMessage() + '"}';
        }
    }
    
    // POST to create a new carbon emission
    @HttpPost
    global static String createEmission(String emissionName, Decimal amount, String status) {
        try {
            Carbon_Emission__c newEmission = new Carbon_Emission__c(
                Name = emissionName,
                Amount__c = amount,
                Status__c = status,
                Date__c = Date.today()
            );
            insert newEmission;
            return '{"status": "success", "id": "' + newEmission.Id + '"}';
        } catch (Exception e) {
            return '{"status": "error", "message": "' + e.getMessage() + '"}';
        }
    }
}