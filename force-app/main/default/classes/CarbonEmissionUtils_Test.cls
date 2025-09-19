@isTest
private class CarbonEmissionUtils_Test {

    @isTest
    static void testConvertTonsToKg() {
        // Test the conversion from tons to kg
        Decimal result = CarbonEmissionUtils.convertToKilograms(5, 'tons');
        System.assertEquals(5000, result, '5 tons should equal 5000 kg');
    }

    @isTest
    static void testConvertPoundsToKg() {
        // Test the conversion from pounds to kg
        Decimal result = CarbonEmissionUtils.convertToKilograms(100, 'pounds');
        System.assertEquals(45.3592, result, '100 pounds should equal ~45.3592 kg');
    }

    @isTest
    static void testNoConversion() {
        // Test that kg is passed through unchanged
        Decimal result = CarbonEmissionUtils.convertToKilograms(250, 'kg');
        System.assertEquals(250, result, '250 kg should remain 250 kg');
    }
}