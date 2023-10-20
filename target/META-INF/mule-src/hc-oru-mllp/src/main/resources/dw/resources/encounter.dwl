/**
 * Produces the FHIR encounter object.
 */

%dw 2.0

import mergeWith from dw::core::Objects

// Import toString Function
import mapGuid, toString, hl7ConvertDateTime from dw::resources::util

// Import the codeableconcept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

// Import the identifier library
import mapIdentifier from dw::resources::datatypes::identifier

/**
 * This function produces the FHIR encounter object with
 * the provided PV1 and PV2 objects.
 * @param data is the PV1 object.
 * @param pv2 is the PV2 object.
 * @param pid is the PID object.
 * @param id is a string with the ID to use.
 * @return A FHIR Encounter formatted object.
 */
fun mapEncounter(data:Object, pv2:Object, pid:Object, id:String) = 
	mapEncounter(data, pv2, pid, id, null)

/**
 * This function produces the FHIR encounter object with
 * the provided PV1 and PV2 objects.
 * @param data is the PV1 object.
 * @param pv2 is the PV2 object.
 * @param pid is the PID object.
 * @param id is a string with the ID to use.
 * @param subjectRef is an optional string with the subject reference.
 * @return A FHIR Encounter formatted object.
 */
fun mapEncounter(data:Object, pv2:Object, pid:Object, id:String, subjectRef) = {
    fullUrl: "urn:uuid:" ++ id,
    resource: {
        resourceType: "Encounter",
        id: id,

        // Class
        "class": mapEncounterClass(data."PV1-02"),

        // Status
        (if (!isEmpty(data."PV1-45"))
            status: "finished"
        else
            status: "unknown"
        ),

        // Location - location reference is required.
        location: 
        (
	        if (!isEmpty(mapLocation(data).location))
	        	mapLocation(data)
	        else null
	    ),

        // Type
        (if (!isEmpty(mapCodeableConcept(data."PV1-04", true, mapCodeableConceptAdmissionTypes)))
            "type": [
                mapCodeableConcept(data."PV1-04", true, mapCodeableConceptAdmissionTypes)
            ]
        else null),

        // Hospitalization
        hospitalization: mapHopitalization(data),

        // Participant
        participant: mapParticipant(data, pv2 default {}),

        // Service Type
        serviceType: mapCodeableConcept(data."PV1-10"),

        // Identifier
        identifier: mapEncounterIdentifier(data),

        // Period
        period: mapPeriod(data),

        // Reason code
        reasonCode: mapReasonCode(data),

        // Length
        length: mapLength(data),

        // Text
        text: mapText(data),

        // Priority
        priority: mapCodeableConcept(data."PV2-25", true, mapCodeableConceptEncounterPriority),

        // Account
        account: mapEncounterAccount(pid),
        
        // Subject ref
        subject:
        (if (!isEmpty(subjectRef))
        {
        	reference: subjectRef
        }
        else null),
    },
    request: {
    	method: "PUT",
    	url: "Encounter/" ++ id
    }
}

/**
 * This function creates the Encounter Class object.
 * @param pv1_02 is the PV1-01 object.
 * @return An Encounter Class object.
 */
fun mapEncounterClass(pv1_02) = 
(if (!isEmpty(pv1_02)) 
    (if (pv1_02 == 'E') 
        {
            code: "EMER",
            display: "emergency",
            system: "http://terminology.hl7.org/CodeSystem/v3-ActCode"
        }
    else if (pv1_02 == 'INPATIENT') 
        {
            code: "IMP",
            display: "inpatient encounter",
            system: "http://terminology.hl7.org/CodeSystem/v3-ActCode"
        }
    else if (pv1_02 == 'O') 
        {
            code: "AMB",
            display: "ambulatory",
            system: "http://terminology.hl7.org/CodeSystem/v3-ActCode"
        }
    else if (pv1_02 == 'P') 
        {
            code: "PRENC",
            display: "pre-admission",
            system: "http://terminology.hl7.org/CodeSystem/v3-ActCode"
        }
    else 
        {
        	code: pv1_02."CWE-01",
        	display: pv1_02."CWE-01",
        	system: "urn:undefined"
        }
    )
else null)

/**
 * Maps the encounter account reference with the provided 
 * PID object.
 * @param pid is a PID object.
 * @return An array of patient references or null if none are found.
 */
fun mapEncounterAccount(pid) = 
(if (!isEmpty(pid) and !isEmpty(pid."PID-18"."CX-01"))
	[
		{
			reference: "Account/" ++ mapGuid(pid."PID-18"."CX-01")
		}
	]
else null)

/**
 * This maps the Encounter location with the provided 
 * PV1 object.
 * @param data is the PV1 object.
 * @return A Location object.
 */
fun mapLocation(data:Object) = [
    {
        // Status
        (if (data."PV1-02"."CWE-01" == "P")
            status: "planned"
        else 
            status: "active"
        ),
        // Location
        (if (!isEmpty(data."PV1-03"))
            location: {
                reference: "Location/" ++ mapGuid(toString(data."PV1-03" default ""))
            }
        else null),
    },
    (if (!isEmpty(data."PV1-06"))
    {
        status: "completed",
        location: {
            reference: "Location/" ++ mapGuid(toString(data."PV1-06" default ""))
        }
    }
    else null)
]

/**
 * This function maps the provided code to the appropriate 
 * codeableconcept object for Encounter Admission Types. This 
 * function is provided as a pointer to mapCodeableConcept.
 * @param code is the PV1-04 CWE-01 value.
 * @return A CodeableConcept object.
 */ 
fun mapCodeableConceptAdmissionTypes(code) = 
(if (code == 'A')
    {
        code: "A",
        display: "Accident",
        system: "http://terminology.hl7.org/CodeSystem/v2-0007"
    }
else if (code == 'E')
    {
        code: "E",
        display: "Emergency",
        system: "http://terminology.hl7.org/CodeSystem/v2-0007"
    }
else if (code == 'L')
    {
        code: "L",
        display: "Labor and Delivery",
        system: "http://terminology.hl7.org/CodeSystem/v2-0007"
    }
else if (code == 'R')
    {
        code: "R",
        display: "Routine",
        system: "http://terminology.hl7.org/CodeSystem/v2-0007"
    }
else if (code == 'N')
    {
        code: "N",
        display: "Newborn (Birth in healthcare facility)",
        system: "http://terminology.hl7.org/CodeSystem/v2-0007"
    }
else if (code == 'UR')
    {
        code: "U",
        display: "Urgent",
        system: "http://terminology.hl7.org/CodeSystem/v2-0007"
    }
else if (code == 'C')
    {
        code: "C",
        display: "Elective",
        system: "http://terminology.hl7.org/CodeSystem/v2-0007"
    }
else 
    {
        code: code,
        display: code,
        system: "urn:undefined"
    }
)

/**
 * This function maps the provided code to the appropriate 
 * codeableconcept object for Encounter Readmission Indicator. This 
 * function is provided as a pointer to mapCodeableConcept.
 * @param code is the PV1-13 CWE-01 value.
 * @return A CodeableConcept object.
 */
fun mapCodeableConceptReadmissionIndicator(code) = 
(if (code == 'R')
    {
        code: "R",
        display: "Re-admission",
        system: "http://terminology.hl7.org/CodeSystem/v2-0092"
    }
else 
    {
        code: "",
        display: "",
        system: ""
    }
)

/**
 * This function maps the provided code to the appropriate
 * codeableconcept object for Encounter Priority. This 
 * function is provided as a pointer to mapCodeableConcept.
 * @param code is the PV2-25 CWE-01 value.
 * @return A CodeableConcept object.
 */
fun mapCodeableConceptEncounterPriority(code) = 
(if (code == '1')
    {
        code: "EM",
        display: "emergency",
        system: "http://terminology.hl7.org/CodeSystem/v3-ActPriority"
    }
else if (code == '2')
    {
        code: "UR",
        display: "urgent",
        system: "http://terminology.hl7.org/CodeSystem/v3-ActPriority"
    }
else if (code == '3')
    {
        code: "EL",
        display: "elective",
        system: "http://terminology.hl7.org/CodeSystem/v3-ActPriority"
    }
else 
    {
        code: "",
        display: "",
        system: ""
    }
)

/**
 * Maps the PV1 object to the Encounter hospitalization 
 * object. 
 * @param data is the PV1 object.
 * @return A hospitalization object.
 */
fun mapHopitalization(data:Object) = {
    preAdmissionIdentifier: mapIdentifier(data."PV1-05"),
    reAdmissin: mapCodeableConcept(data."PV1-13", true, mapCodeableConceptReadmissionIndicator),
    admitSource: mapCodeableConcept(data."PV1-14"),
    dischargeDisposition: mapCodeableConcept(data."PV1-36"),
    dietPreference:
    (if (!isEmpty(data."PV1-38"))
    [ mapCodeableConcept(data."PV1-38") ]
    else null)
}

/**
 * Maps the PV1 and PV2 objects to the Encounter participant 
 * object. 
 * @param data is the PV1 object.
 * @param pv2 is the PV2 object.
 * @return A participant object.
 */
fun mapParticipant(data:Object, pv2:Object) = [
    {
        "type": [
            {
                coding: [
                    {
                        (if (!isEmpty(data."PV1-07"))
                            code: "ATND"
                        else null),
                        (if (!isEmpty(data."PV1-07"))
                            system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
                        else null),
                        (if (!isEmpty(data."PV1-07"))
                            display: "attender"
                        else null),
                        (if (!isEmpty(pv2."PV1-13"))
                            code: "REF"
                        else null),
                        (if (!isEmpty(pv2."PV1-13"))
                            system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
                        else null)
                    }
                ],
                (if (!isEmpty(pv2."PV2-13"))
                    text: "referrer"
                else null)
            }
        ]
    },
    (if (!isEmpty(data."PV1-08"))
    {
        "type": [
            {
                coding: [
                    {
                        (if (!isEmpty(data."PV1-08"))
                            code: "REF"
                        else null),
                        (if (!isEmpty(data."PV1-08"))
                            system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
                        else null)
                    }
                ],
                (if (!isEmpty(data."PV1-08"))
                    text: "referrer"
                else null)
            }
        ]
    }
    else null),
    (if (!isEmpty(data."PV1-09"))
    {
        "type": [
            {
                coding: [
                    {
                        (if (!isEmpty(data."PV1-09"))
                            code: "CON"
                        else null),
                        (if (!isEmpty(data."PV1-09"))
                            system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
                        else null)
                    }
                ],
                (if (!isEmpty(data."PV1-09"))
                    text: "consultant"
                else null)
            }
        ]
    }
    else null),
    (if (!isEmpty(data."PV1-17"))
    {
        "type": [
            {
                coding: [
                    {
                        (if (!isEmpty(data."PV1-17"))
                            code: "ADM"
                        else null),
                        (if (!isEmpty(data."PV1-17"))
                            system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
                        else null)
                    }
                ],
                (if (!isEmpty(data."PV1-17"))
                    text: "admitter"
                else null)
            }
        ]
    }
    else null),
    (if (!isEmpty(data."PV1-52"))
    {
        "type": [
            {
                coding: [
                    {
                        (if (!isEmpty(data."PV1-52"))
                            code: "PART"
                        else null),
                        (if (!isEmpty(data."PV1-52"))
                            system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
                        else null)
                    }
                ],
                (if (!isEmpty(data."PV1-52"))
                    text: "Participation"
                else null)
            }
        ]
    }
    else null),
]

/**
 * Maps the PV1 object to the Encounter identifier 
 * object. 
 * @param data is the PV1 object.
 * @return An identifier object.
 */
fun mapEncounterIdentifier(data:Object) = [
    (mapIdentifier(data."PV1-19") default {}) mergeWith( 
    {
        "type": {
            coding: [
                {
                    (if (!isEmpty(data."PV1-19"))
                        system: "http://terminology.hl7.org/CodeSystem/v2-0203"
                    else null)
                }
            ],
            (if (!isEmpty(data."PV1-19"))
                text: "visit number"
            else null)
        }
    }),
    mapIdentifier(data."PV1-50"[0] default {})
]

/**
 * Maps the PV1 object to the Encounter period 
 * object. 
 * @param data is the PV1 object.
 * @return A period object.
 */
fun mapPeriod(obj:Object) = {
    start: hl7ConvertDateTime(obj."PV1-44") default null,
    end: hl7ConvertDateTime(obj."PV1-45") default null
}

/**
 * Maps the PV1 object to the Encounter reason code  
 * list. 
 * @param data is the PV1 object.
 * @return An reasson code list.
 */
fun mapReasonCode(obj:Object) = 
(if (!isEmpty(obj."PV2-03"))
[
    mapCodeableConcept(obj."PV2-03")
]
else null)

/**
 * Maps the PV1 object to the Encounter length 
 * object. 
 * @param data is the PV1 object.
 * @return A length object.
 */
fun mapLength(obj:Object) = 
(if (!isEmpty(obj."PV2-11"))
{
    value: obj."PV2-11",
    unit: "d",
    system: "http://unitsofmeasure.org/"
}
else null)

/**
 * Maps the PV1 object to the Encounter text 
 * object. 
 * @param data is the PV1 object.
 * @return A text object.
 */
fun mapText(obj:Object) = 
(if (!isEmpty(obj."PV2-12"))
{
    div: obj."PV2-12"
}
else null)

/**
 * Maps a FHIR Encounter object with just the subject 
 * information with the provide reference string and 
 * id.
 * @param ref is a ref string with Encounter/<cx-01>
 * @param id is a string with the ID to use.
 */
fun mapEncounterSubject(ref:String, id:String) = {
	fullUrl: "urn:uuid:" ++ id,
	resource: {
        resourceType: "Encounter",
        id: id,
        subject: {
            reference: ref
        },
        class: {
        	code: "undefined",
        	display: "undefined",
        	system: "urn:undefined"
        },
        status: "unknown"
    },
    request: {
    	method: "PUT",
    	url: "Encounter/" ++ id
    }
}

/**
 * Maps the encounter diagnosis object with the provided 
 * information.
 * @param id is a string with the ID.
 * @param ref is a string with the encounter reference.
 * @return An encounter diagnosis object.
 */
fun mapEncounterDiagnosis(id, ref) = {
	fullUrl: "urn:uuid:" ++ id,
    resource: {
        resourceType: "Encounter",
        id: id,
        diagnosis: [
            {
                condition: {
                    reference: ref
                }
            }
        ],
        class: {
        	code: "undefined",
        	display: "undefined",
        	system: "urn:undefined"
        },
        status: "unknown"
    },
    request: {
    	method: "PUT",
    	url: "Encounter/" ++ id
    }
}