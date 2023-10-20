/**
 * Maps the address type object.
 */

%dw 2.0

/**
 * Maps the provided XAD-07 field to the proper address type object.
 * @param code is a XAD-07 field to map.
 * @return An address type object.
 */
fun mapAddressType(code) = 
{
    (
	    if (code == 'M')
	    {
	        "code" : "postal",
	        "display" : "Postal",
	        "system" : "http://hl7.org/fhir/address-type",
	    } else if (code == 'SH')
	    {
	        "code" : "postal",
	        "display" : "Postal",
	        "system" : "http://hl7.org/fhir/address-type",
	    } else 
	    {
	    	code: "physical",
	    	display: "physical",
	    	system: "http://hl7.org/fhir/address-type"
	    }
    )
}