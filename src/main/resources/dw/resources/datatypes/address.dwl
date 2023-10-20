/**
 * Maps the FHIR address object.
 */

%dw 2.0

// Import mapAddressType
import mapAddressType from dw::resources::codesystem::addresstype

/**
 * Maps the provided object to the FHIR address.
 * @param obj is an object with XAD fields that can be mapped to an address. (ORC-22, RXA-28 ...)
 * @return A FHIR formatted Address object.
 */
fun mapAddress (obj) = 
(if (!isEmpty(obj))
{
	
	(if ((!isEmpty(obj."XAD-01")) or (!isEmpty(obj."XAD-02")) or (!isEmpty(obj."XAD-19")) or (!isEmpty(obj."XAD-07")))
	
	"line":
	[
	    obj."XAD-01"."SAD-01",
	    obj."XAD-01"."SAD-02",
	    obj."XAD-01"."SAD-03",
	    obj."XAD-02",
	    obj."XAD-19",
	]else null),
	
	"city": obj."XAD-03",
	"state": obj."XAD-04",
	"postalCode": obj."XAD-05",
	"country": obj."XAD-06",
	
	(if ((!isEmpty(obj."XAD-07") or (obj."XAD-07" == "M") or (obj."XAD-07" == "SH")))
		"type": 
		(if (!isEmpty(mapAddressType(obj."XAD-07").code))
			mapAddressType(obj."XAD-07").code			
			else null)
	else null)
}
else null)