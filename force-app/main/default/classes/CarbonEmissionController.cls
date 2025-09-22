/**
 * @description Controller class for managing Carbon Emission records.
 *              Provides methods for querying, inserting, and updating emissions.
 * @author Vraddhi
 */
public with sharing class CarbonEmissionController {

    /**
     * @description Fetches the latest Carbon Emission records.
     * @return A list of Carbon_Emission__c records.
     */
    @AuraEnabled(cacheable=true)
    public static List<Carbon_Emission__c> getEmissions() {
        return [
            SELECT Id,
                   Name,
                   Amount__c,
                   Date__c,
                   Status__c,
                   High_Emission_Flag__c,
                   Source__c,
                   Carbon_Emission__c
            FROM Carbon_Emission__c
            ORDER BY Date__c DESC
            LIMIT 50
        ];
    }

    /**
     * @description Creates emission with individual parameters (for LWC).
     * @param source Emission source
     * @param amount Emission amount
     * @param emissionDate Emission date
     * @return Record ID of created emission
     */
    @AuraEnabled
    public static String createEmission(String source, Decimal amount, Date emissionDate) {
        try {
            Carbon_Emission__c newEmission = new Carbon_Emission__c(
                Source__c = source,
                Amount__c = amount,
                Date__c = emissionDate
                // ❌ REMOVED: Description__c since field doesn't exist
            );
            insert newEmission;
            return newEmission.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating emission: ' + e.getMessage());
        }
    }

    /**
     * @description Inserts a new Carbon Emission record (alternative method).
     * @param emission A Carbon_Emission__c record to insert.
     * @return The inserted record with Id populated.
     */
    @AuraEnabled
    public static Carbon_Emission__c createEmissionRecord(Carbon_Emission__c emission) {
        insert emission;
        return emission;
    }

    /**
     * @description Updates an existing Carbon Emission record.
     * @param emission A Carbon_Emission__c record to update.
     */
    @AuraEnabled
    public static void updateEmission(Carbon_Emission__c emission) {
        update emission;
    }

    /**
     * @description Example utility: flag high emissions above a threshold.
     * @param emissionId The Id of the record to check and update.
     * @param threshold The CO₂e threshold (in Amount__c) to flag as high.
     * @return The updated Carbon_Emission__c record.
     */
    @AuraEnabled
    public static Carbon_Emission__c flagHighEmission(Id emissionId, Decimal threshold) {
        Carbon_Emission__c emission = [
            SELECT Id, Amount__c, High_Emission_Flag__c
            FROM Carbon_Emission__c
            WHERE Id = :emissionId
            LIMIT 1
        ];

        if (emission.Amount__c != null && emission.Amount__c > threshold) {
            emission.High_Emission_Flag__c = true;
            update emission;
        }
        return emission;
    }
}