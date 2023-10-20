/**
 * Maps the FHIR Procedure object.
 */

%dw 2.0

// Import the needed util library functions
import hl7ConvertDateTime, toEpochSeconds, fromEpochSeconds, mapGuid from dw::resources::util

// Import the codeableconcept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

/**
 * Maps the provided PR1 segment to a FHIR Procedure object.
 * @param data is a HL7 PR1 object.
 * @param id is a string with the ID.
 * @return A FHIR Procedure object.
 */
fun mapProcedure(data, id) = mapProcedure(data, id, null)

/**
 * Maps the provided PR1 segment to a FHIR Procedure object.
 * @param data is a HL7 PR1 object.
 * @param id is a string with the ID.
 * @param subjectRef is an optional string with the subject reference.
 * @return A FHIR Procedure object.
 */
fun mapProcedure(data, id, subjectRef) = {
    fullUrl: "urn:uuid:" ++ id,
    resource: {
        // Resource type
        resourceType: "Procedure",

        // ID
        id: id,

        // Code
        (if (isEmpty(data."PR1-03"."CNE-09"))
        code: {
            text: data."PR1-04"."PR1-04"
        }
        else null),

        // Performed date time
        (if (isEmpty(data."PR1-07"))
        performedDateTime: hl7ConvertDateTime(data."PR1-05")
        else null),

        // Performed period
        (if (!isEmpty(data."PR1-05") and !isEmpty(data."PR1-07"))
        performedPeriod: {
            start: hl7ConvertDateTime(data."PR1-05"),
            end: fromEpochSeconds(
                toEpochSeconds(data."PR1-05") 
                + ((data."PR1-07" as Number default 0)*60)
            )
        }
        else null),

        // Category
        (if (!isEmpty(data."PR1-06"))
            category: mapCodeableConcept(data."PR1-06")
        else null),

        // Reason code
        (if (!isEmpty(data."PR1-15"))
            reasonCode: [
                mapCodeableConcept(data."PR1-15")
            ]
        else null),

        // Identifier
        (if (!isEmpty(data."PR1-19"))
            identifier: [
                {
                    value: data."PR1-19"."EI-01"
                }
            ]
        else null),

        // Location reference
        (if (!isEmpty(data."PR1-23"))
            location: {
                reference: "Location/" ++ mapGuid(data."PR1-23")
            }
        else null),

        // Status (required)
        status: "unknown",

        // Subject (requred)
        (
        	if (!isEmpty(subjectRef))
        	subject: {
	            reference: subjectRef
	        }
	        else
	        subject: {
	            reference: "Patient/example"
	        }
        )
    },
    request: {
        method: "PUT",
        url: "Procedure/" ++ id
    }
}

/**
 * Maps the provided reference and ID into a procedure subject object.
 * @param ref is a reference string.
 * @param id is a string with the ID.
 * @return A FHIR Procedure object.
 */
fun mapProcedureSubject(ref, id) = {
	fullUrl: "urn:uuid:" ++ id,
    resource: {
        resourceType: "Procedure",
        id: id,
        subject: {
            reference: ref
        },
        status: "unknown",
        code: {
			coding: [
				{
					code: "undefined",
					display: "undefined",
					system: "urn:undefined"
				}
			]	
		},
    },
    request: {
        method: "PUT",
        url: "Procedure/" ++ id
    }
}