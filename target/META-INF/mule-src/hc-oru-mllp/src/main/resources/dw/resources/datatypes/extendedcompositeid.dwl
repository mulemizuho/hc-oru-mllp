/**
 * Maps the extended composite ID object.
 */

%dw 2.0
import hl7ConvertDateTime from dw::resources::util
import mapIdTypes from dw::resources::codesystem::idtypes

/**
 * Maps the extended composite ID object with the provided 
 * cx object.
 * @param cx is a CX object to map.
 * @return An ExtendedCompositeID object.
 */
fun mapExtendedCompositeID(cx) = {
	 
	"value": cx."CX-01",
	
	(if (!isEmpty(cx."CX-05"))
	"type":
		{
		    "coding":
		    [
		        {
		            "code": mapIdTypes(cx."CX-05").code,
		            "system":mapIdTypes(cx."CX-05").system
		        }
		    ],
		}
	
	else null),
	
	(if ((!isEmpty(cx."CX-07")) or (!isEmpty(cx."CX-08")))
	"period":
		{
		    "start":hl7ConvertDateTime(cx."CX-07"),
		    "end":hl7ConvertDateTime(cx."CX-08"),
		}
	 else null) 
 
}