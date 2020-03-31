@isTest
public class StripeTaxRateObjTest {

    @isTest
    private static void testStripeTaxRateObj(){
        
        String jsonStr='{"id":"txr_1Fz10RGAJHaJ7JBv4Ikn79eV","object":"tax_rate","active":true,"created":1578576299,"description":"VAT Germany","display_name":"VAT","inclusive":false,"jurisdiction":"DE","livemode":false,"metadata":{},"percentage":19}';
    	
        StripeTaxRateObj stripeTaxRate=JsonToStripeObject.jsonToTaxRate((Map<String,Object>)JSON.deserializeUntyped(jsonStr));
        
    }
}