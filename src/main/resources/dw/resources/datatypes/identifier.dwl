/**
 * Maps the FHIR identifier object.
 */

%dw 2.0

// Import the contact role library
import mapIdTypes from dw::resources::codesystem::idtypes

/**
 * Maps the provided object to the FHIR identifier object.
 * @param cx is the input object to map.
 * @return An identifier object.
 */
fun mapIdentifier(cx) = 
(if (!isEmpty(cx))
{
    value: cx."CX-01",

    (if (!isEmpty(cx."EI-01"))
        value: cx."EI-01"
    else if (!isEmpty(cx."EI-02"))
        value: cx."EI-02"
    else null),
    
    (if (!isEmpty(cx."CX-05"))  
      	(if (!isEmpty(mapIdTypes(cx."CX-05").code)) 
	    "type": {
	        coding: [
	            {
	                code: mapIdTypes(cx."CX-05").code,
	                system: mapIdTypes(cx."CX-05").system
	            }
	        ],
	        text: cx."CX-05"
	    }
		else null)    
    else null), 
    
    
    (if (!isEmpty(cx."CX-07") or !isEmpty(cx."CX-08"))
    period: {
        (start: cx."CX-07") if (!isEmpty(cx."CX-07")),
        (end: cx."CX-08") if ((
        	!isEmpty(cx."CX-07")
        	and !isEmpty(cx."CX-08")
        	and cx."CX-07" as DateTime <= cx."CX-08" as DateTime
        ) or (isEmpty(cx."CX-07") and !isEmpty(cx."CX-08")))
    }
    else null)
}
else null)