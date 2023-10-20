/**
 * Maps the FHIR contact point object.
 */

%dw 2.0

// Import the contactpointuse library
import mapContactPointUse from dw::resources::codesystem::contactpointuse

// Import util functions
import hl7ConvertDateTime from dw::resources::util

/**
 * Maps the ORC-23 object to a FHIR contact point object.
 * @param obj is an ORC-23 object to map.
 * @return A FHIR ContactPoint object or null if no object is provided.
 */
fun mapContactPoint(obj) = 
(if (!isEmpty(obj))
{
	value: obj."XTN-01" as String,
    (if (!isEmpty(obj."XTN-01"))
        use: mapContactPointUse(obj."XTN-02").code
    else null),
    (
    	if (!isEmpty(obj."XTN-03"))
    		system: mapContactPointSystem(obj."XTN-03")
    	else null
    ),
    (if (!isEmpty(obj."XTN-13") or !isEmpty(obj."XTN-14"))
        {
            start: hl7ConvertDateTime(obj."XTN-13" as String),
            end: hl7ConvertDateTime(obj."XTN-14" as String)
        }
    else null),
    rank: obj."XTN-18"
}
else null)

/**
 * Maps the ContactPoint system code with the provided 
 * XTN-03 code.
 * @param code is the XTN-03 code to map.
 * @return A ContactPoint system code.
 */
fun mapContactPointSystem(code) = (
	if (code == 'PH')
    	"phone"
    else if (code == 'FX')
    	"fax"
    else if (code == 'MD')
    	"other"
    else if (code == 'CP')
    	"phone"
    else if (code == 'BP')
    	"pager"
    else if (code == 'Internet')
    	"email"
    else if (code == 'X.400')
    	"email" 
    else
    	"other"
)