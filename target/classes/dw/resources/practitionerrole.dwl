/**
 * Produces the FHIR PractitionerRole object.
 */

%dw 2.0

// Import the codeableconcept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

// Import the needed util library functions
import mapGuid, toString, hl7ConvertDateTime from dw::resources::util

// Import contact point to map telecom.
import mapContactPoint from dw::resources::datatypes::contactpoint

/**
 * Maps the provided PTR segment to a FHIR PractitionerRole object.
 * @param data is a HL7 PTR object.
 * @param id is a string with the ID.
 * @return A FHIR Observation object.
 */
fun mapPractitionerRole(data, id) = {
    fullUrl: "urn:uuid:" ++ id,
    resource: {
        // Resource type
        resourceType: "PractitionerRole",
        id: id,
        
        // Code
        code: [ mapCodeableConcept(data."PRT-04") ],
        
        // Specialty
        specialty: [ mapCodeableConcept(data."PRT-06") ],
        
        // Location
        location: 
        (if (!isEmpty(data."PRT-09"))
        [
        	{
        		reference: "Location/" ++ mapGuid(toString(data."PRT-09"))
        	}	
        ]
        else null),
        
        // Period
        period: mapPractitionerRolePeriod(data),
        
        // Telecom
        telecom: mapPractitionerRoleTelecom(data)
     },
    request: {
        method: "PUT",
        url: "PractitionerRole/" ++ id
    }
}

/**
 * Maps the practitioner role period with the provided PRT 
 * object.
 * @param data is a PRT object.
 * @return A FHIR period object or null if both start 
 * and end datetime values are empty.
 */
fun mapPractitionerRolePeriod(data) = 
(if (!isEmpty(data."PRT-11") or !isEmpty(data."PRT-12"))
	{
		start: hl7ConvertDateTime(data."PRT-11"),
		end: hl7ConvertDateTime(data."PRT-12")
	}
else null)

/**
 * Maps the practitioner role telecom objects with the provided PRT 
 * object.
 * @param data is a PRT object.
 * @return A list of FHIR telecom objects or null if none are found.
 */
fun mapPractitionerRoleTelecom(data) = 
(if (!isEmpty(data."PRT-15"))
	data."PRT-15" map (telecomItem, telecomIndex) -> 
		mapContactPoint(telecomItem)
else null)
