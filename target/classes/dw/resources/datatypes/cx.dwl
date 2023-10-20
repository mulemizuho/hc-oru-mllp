/**
 * Maps the CX quantity object.
 */

%dw 2.0
import mapIdTypes from dw::resources::codesystem::idtypes
import hl7ConvertDateTime from dw::resources::util
/**
 * Maps the CQ quantity object with the provided SPM-31
 * object.
 * @param cx is a TQ1-02 object to map.
 * @return A mapped CX object.
 */
fun mapCX(cx) = 
	(if (!isEmpty(cx))
	{	
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
	else null)
