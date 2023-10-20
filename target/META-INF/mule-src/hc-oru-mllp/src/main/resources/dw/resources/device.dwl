/**
 * Produces the FHIR Device object.
 */

%dw 2.0

// Import the date/ datetime format conversion library
import hl7ConvertDate, hl7ConvertDateTime from dw::resources::util

// Import the EI identifier library
import mapEIIdentifier from dw::resources::datatypes::eiidentifier

/**
 * This function produces the FHIR Device object with
 * the provided ptr object.
 * @param prt is the prt device object.
 * @param id is a string with the ID to use.
 * @return A object with the mapped Device.
 */
fun mapDevice(prt, id) = 
{
    fullUrl: "urn:uuid:" ++ id,
    resource: {
        resourceType: "Device",
        id: id,	

        (if (!isEmpty(prt."PRT-10"))
        "identifier":
        [
        	
            //prt."PRT-10" reduce ($ ++ $$)  map (prtItem, prtIndex)  ->
            (mapEIIdentifier(prt."PRT-10"[0]))
        ] else null),
        "manufactureDate": prt."PRT-17",  
        (if (!isEmpty(prt."PRT-18")) 
        	"expirationDate":hl7ConvertDateTime(prt."PRT-18")
        else null),
        "lotNumber": prt."PRT-19",
        "serialNumber":prt."PRT-20",             
    },
    "request":{
        "method":"PUT",
        "url":"Device/" ++ id,
    }
}