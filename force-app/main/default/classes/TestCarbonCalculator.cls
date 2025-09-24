@isTest
public class TestCarbonCalculator {
    
    @isTest
    static void testElectricityCalculations() {
        // Test electricity emissions for different countries
        Decimal usEmissions = CarbonFootprintCalculator.calculateElectricityEmissions(1000, 'US');
        Decimal frEmissions = CarbonFootprintCalculator.calculateElectricityEmissions(1000, 'FR');
        
        System.assert(usEmissions > 0, 'US emissions should be calculated');
        System.assert(frEmissions > 0, 'France emissions should be calculated');
        System.debug('US: ' + usEmissions + ' kg, France: ' + frEmissions + ' kg');
    }
    
    @isTest
    static void testTransportCalculations() {
        Decimal carEmissions = CarbonFootprintCalculator.calculateTransportEmissions(100, 'car-petrol');
        Decimal truckEmissions = CarbonFootprintCalculator.calculateTransportEmissions(100, 'truck');
        
        System.assert(carEmissions > 0, 'Car emissions should be calculated');
        System.assert(truckEmissions > carEmissions, 'Truck should emit more than car');
        System.debug('Car: ' + carEmissions + ' kg, Truck: ' + truckEmissions + ' kg');
    }
    
    @isTest
    static void testTotalFootprint() {
        Decimal total = CarbonFootprintCalculator.calculateTotalFootprint(
            500,    // electricity kWh
            200,    // transport km
            10,     // heating therms
            'US'    // country
        );
        
        System.assert(total > 0, 'Total footprint should be calculated');
        System.debug('Total footprint: ' + total + ' kg CO2');
    }
}