/**
 * Maps the extended telecommunication number object.
 */

%dw 2.0

import mapTelecomUseCode from dw::resources::codesystem::telecomusecode

import mapTelecomEquipmentType from dw::resources::codesystem::telecomequipmenttype

/**
 * Maps the extended telecommunication number with the 
 * provided xtn object.
 * @param xtn is the provided object to map.
 * @return An ExtendedTelecommunicationNumber object.
 */
fun mapExtendedTelecommunicationNumber (xtn) =
(if (!isEmpty(xtn))
{
	"value": xtn."XTN-01",	
	"system": 
	(
		// System is required if value is set. cpt-2
		if (isEmpty(mapTelecomEquipmentType(xtn."XTN-03").code))
			"other"
		else
			mapTelecomEquipmentType(xtn."XTN-03").code
	),
	(
		if (!isEmpty((xtn."XTN-02")))
			(
				if (!isEmpty(mapTelecomUseCode(xtn."XTN-02").code))
		    		"use": mapTelecomUseCode(xtn."XTN-02").code
		    	else null
		    ) 
    	else null 
    ),
    (if ((!isEmpty(xtn."XPN-13")) or (!isEmpty(xtn."XPN-14")))
	"period":
	{
	    "start": xtn."XTN-13",
	    "end": xtn."XTN-14"
	}else null),
	"rank": xtn."XTN-18",     
}
else null)