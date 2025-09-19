public class CarbonEmissionUtils {

    // A method to convert different units to kilograms
    public static Decimal convertToKilograms(Decimal amount, String unit) {
        if (unit == 'tons') {
            return amount * 1000; // Convert tons to kg
        } else if (unit == 'pounds') {
            return amount * 0.453592; // Convert pounds to kg
        } else {
            return amount; // Assume it's already kg
        }
    }

    // You can add more utility methods here later
}