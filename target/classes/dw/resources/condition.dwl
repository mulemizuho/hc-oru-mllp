/**
 * Maps the condition object.
 */

%dw 2.0

import mergeWith from dw::core::Objects

// Import the codeableconcept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

// Import the needed util library functions
import hl7ConvertDateTime, mapGuid from dw::resources::util


/**
 * Maps the condition object with the provided DG1 segment.
 * @param data is a DG1 segment object.
 * @param pid is a PID segment object.
 * @param id is a string with the ID.
 * @return A object with the mapped Condition or null if no object is provided.
 */
fun mapCondition(data, pid, id) = mapCondition(data, pid, id, null)

/**
 * Maps the condition object with the provided DG1 segment.
 * @param data is a DG1 segment object.
 * @param pid is a PID segment object.
 * @param id is a string with the ID.
 * @param subjectRef is a string with the optional subject reference.
 * @return A object with the mapped Condition or null if no object is provided.
 */
fun mapCondition(data, pid, id, subjectRef) = {
	fullUrl: "urn:uuid:" ++ id,
    resource: {
        // Resource type
        resourceType: "Condition",

        // ID
        id: id,

        // Code
        (if (!isEmpty(data."DG1-03"))
            code: (
            	mapCodeableConcept(data."DG1-03")
                mergeWith({ text: data."DG1-04"."DG1-04" })    
            )
        else null),

        // Onset datetime
        onsetDateTime: getOnsetDateTime(data."DG1-05"),

        // Recorded datetime
        recordedDate: getRecordedDate(data."DG1-19"),

        // Identifier
        identifier: mapConditionIdentifier(data),

        // Verification status
        verificationStatus: mapVerificationStatus(data),

        // Subject
        (
        if (!isEmpty(subjectRef))
        	subject: {
	            reference: subjectRef
	        }
        else if (!isEmpty(pid."PID-03"[0]."CX-01"))
	        subject: {
	            reference: "Patient/" ++ mapGuid(pid."PID-03"[0]."CX-01")
	        }
        else null),
    },
    request: {
        method: "PUT",
        url: "Condition/" ++ id
    }
}

/**
 * Maps the condition subject object with the provided 
 * information.
 * @param id is a string with the ID.
 * @param ref is a string with the condition reference.
 * @return An condition object.
 */
fun mapConditionSubject(id, ref) = {
	fullUrl: "urn:uuid:" ++ id,
    resource: {
        resourceType: "Condition",
        id: id,
        subject: {
            reference: ref
        }
    },
    request: {
        method: "PUT",
        url: "Condition/" ++ id
    }
}

/**
 * Gets the onset datetime formatted as FHIR datetime or 
 * null if no field is provided.
 * @param dt is the DG1-05 datetime value.
 * @return A FHIR datetime formatted value or null if nothing is provided.
 */
fun getOnsetDateTime(dt) = 
(if (!isEmpty(dt))
    hl7ConvertDateTime(dt)
else null)

/**
 * Gets the record datetime formatted as FHIR datetime or 
 * null if no field is provided.
 * @param dt is the DG1-19 datetime value.
 * @return A FHIR datetime formatted value or null if nothing is provided.
 */
fun getRecordedDate(dt) = 
(if (!isEmpty(dt))
    hl7ConvertDateTime(dt)
else null)

/**
 * Maps the condition identifier with the provided DG1 segment.
 * @param is a DG1 segment object.
 * @return an identifier array or null if no object is provided.
 */
fun mapConditionIdentifier(data) = 
(if (!isEmpty(data."DG1-20"))
[
    {
        value: data."DG1-20"."EI-01"
    }
]
else null)

/**
 * Maps the verification status with the provided DG1 segment.
 * @param is a DG1 segment object.
 * @return an identifier array or null if no object is provided.
 */
fun mapVerificationStatus(data) = 
(if (!isEmpty(data."DG1-21"))
{
    coding: [
        {
            code: "entered-in-error",
            system: "http://terminology.hl7.org/CodeSystem/condition-ver-status"
        }
    ]
}
else null)
