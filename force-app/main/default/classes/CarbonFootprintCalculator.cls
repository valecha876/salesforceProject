public class CarbonFootprintCalculator {
    
    // Calculate carbon emissions from electricity consumption
    public static Decimal calculateElectricityEmissions(Decimal kWh, String countryCode) {
        // Emission factors (kg CO2 per kWh) - real-world data
        Map<String, Decimal> emissionFactors = new Map<String, Decimal>{
            'US' => 0.45,   // USA average
            'GB' => 0.25,   // UK average  
            'DE' => 0.35,   // Germany average
            'FR' => 0.08,   // France (nuclear)
            'CN' => 0.60,   // China average
            'IN' => 0.70,   // India average
            'Default' => 0.50
        };
        
        Decimal factor = emissionFactors.get(countryCode);
        if (factor == null) factor = emissionFactors.get('Default');
        
        Decimal emissions = kWh * factor;  // FIXED: Use * not x
        System.debug('Electricity emissions: ' + kWh + ' kWh × ' + factor + ' = ' + emissions + ' kg CO2');  // FIXED: System.debug not stem.debug
        
        return emissions;
    }
    
    // Calculate transportation emissions
    public static Decimal calculateTransportEmissions(Decimal distanceKm, String vehicleType) {
        Map<String, Decimal> vehicleFactors = new Map<String, Decimal>{
            'car-petrol' => 0.20,
            'car-diesel' => 0.18,
            'car-electric' => 0.05,
            'truck' => 0.60,
            'plane' => 0.25,
            'train' => 0.05,
            'ship' => 0.01,
            'Default' => 0.30
        };
        
        Decimal factor = vehicleFactors.get(vehicleType.toLowerCase());
        if (factor == null) factor = vehicleFactors.get('Default');
        
        return distanceKm * factor;  // FIXED: Use * not x
    }
     // ✅ ADD THIS MISSING METHOD
    public static Decimal calculateTotalFootprint(Decimal electricityKwh, Decimal transportKm, Decimal heatingTherms, String countryCode) {
        Decimal electricityEmissions = calculateElectricityEmissions(electricityKwh, countryCode);
        Decimal transportEmissions = calculateTransportEmissions(transportKm, 'car-petrol'); // Default vehicle
        Decimal heatingEmissions = calculateHeatingEmissions(heatingTherms);
        
        return electricityEmissions + transportEmissions + heatingEmissions;
    }
    
    // ✅ ADD THIS SUPPORTING METHOD
    public static Decimal calculateHeatingEmissions(Decimal therms) {
        // Heating emission factor (kg CO2 per therm)
        Decimal factor = 5.3;
        return therms * factor;
    }
}