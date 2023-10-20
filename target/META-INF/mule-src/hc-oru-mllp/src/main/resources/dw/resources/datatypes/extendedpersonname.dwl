/**
 * Maps the extended person name object.
 */

%dw 2.0

// Import the date/ datetime format conversion library
import hl7ConvertDate, hl7ConvertDateTime from dw::resources::util

// Import the gender library
import mapNameType from dw::resources::codesystem::nametype

/**
 * Maps the extended person name with the provided XPN object.
 * @param xpn is an XPN object.
 * @return An ExtendedPersonName object or null if xpn is null.
 */
fun mapExtendedPersonName(xpn) = 
(if (!isEmpty(xpn))
{
	"family": xpn."XPN-01"."FN-01",
	(if ((!isEmpty(xpn."XPN-02")) or (!isEmpty(xpn."XPN-03")))
	"given":
	[
	    xpn."XPN-02",
	    xpn."XPN-03",
	]else null),
	(if ((!isEmpty(xpn."XPN-04")) or (!isEmpty(xpn."XPN-06")) or (!isEmpty(xpn."XPN-14")))
	"suffix":
	[
	    xpn."XPN-04",
	    xpn."XPN-06",
	    xpn."XPN-14",
	]else null),
	(if (!isEmpty(xpn."XPN-05"))
	"prefix":
	[
	    xpn."XPN-05"
	]else null),
	

	(if (!isEmpty(xpn."XPN-07"))
		"use": mapNameType(xpn."XPN-07").code 
	else null),

    
	(if ((!isEmpty(xpn."XPN-12")) or (!isEmpty(xpn."XPN-13")) or 
		(!isEmpty(xpn."XPN-10"))
	)
	"period":
	{
	    "start": hl7ConvertDateTime(xpn."XPN-10"."DR-01"),
	    "start": hl7ConvertDateTime(xpn."XPN-12"),
	    "end": hl7ConvertDateTime(xpn."XPN-10"."DR-02"),
	    "end": hl7ConvertDateTime(xpn."XPN-13"),
	}else null),
}  else null)