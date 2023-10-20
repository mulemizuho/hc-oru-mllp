/**
 * Maps a FHIR Observation object.
 */

%dw 2.0

// Import the quantity library
import mapCweQuantity from dw::resources::datatypes::quantity

// Import the ratio library
import mapSnRatio from dw::resources::datatypes::ratio

// Import the range library
import mapSnRange from dw::resources::datatypes::range

// Import the codeableconcept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

// Import the needed util library functions
import hl7ConvertDateTime, replacePair, removeNull from dw::resources::util


/**
 * Maps the provided OBX segment to a FHIR Observation object.
 * @param data is a HL7 OBX object.
 * @param id is a string with the ID.
 * @return A FHIR Observation object.
 */
fun mapObservation(data, id) = mapObservation(data, id, null)

/**
 * Maps the provided OBX segment to a FHIR Observation object.
 * @param data is a HL7 OBX object.
 * @param id is a string with the ID.
 * @param deviceReference is an optional device reference string.
 * @return A FHIR Observation object.
 */
fun mapObservation(data, id, deviceReference) = mapObservation(data, id, deviceReference, null)

/**
 * Maps the provided OBX segment to a FHIR Observation object.
 * @param data is a HL7 OBX object.
 * @param id is a string with the ID.
 * @param deviceReference is an optional device reference string.
 * @param subjectReference is an optional subject reference string.
 * @return A FHIR Observation object.
 */
fun mapObservation(data, id, deviceReference, subjectReference) = {
    fullUrl: "urn:uuid:" ++ id,
    resource: {
        // Resource type
        resourceType: "Observation",

        // ID
        id: id,

        // Code
        (if (!isEmpty(data."OBX-03"))
            code: 
            (if (!isEmpty(mapCodeableConcept(data."OBX-03")))
            	{
            		coding: [
            			replacePair(
            				mapCodeableConcept(data."OBX-03").coding[0],
            				"system",
            				"http://loinc.org"
            			)
            		]
            	}
            else null)
        else null),

        // Interpretation
        interpretation: mapInterpretation(data),

        // Status
        status: mapObservationStatus(data."OBX-11").code,

        // Effective date time
        effectiveDateTime: hl7ConvertDateTime(data."OBX-14"),

        // Method - this is empty so skipping for now.

		// Device
		device:
		(if (!isEmpty(deviceReference))
		{
			reference: deviceReference
		}
		else null),

        // Body site
        bodySite: 
        (if (!isEmpty(mapCodeableConcept(data."OBX-20")))
        	{
        		coding: [
        			replacePair(
        				mapCodeableConcept(data."OBX-20").coding[0],
        				"system",
        				"http://snomed.info/sct"
        			)
        		]
        	}
        else null),

        // Identifier
        identifier: mapObservationIdentifier(data."OBX-21"."EI-01"),

        // Component
        component: 
        (if (!isEmpty(removeNull(mapComponent(data))))
        	mapComponent(data)
        else null),

        // Performer
        performer: (if (!isEmpty(data."OBX-16"."ST-01"))
            "PractitionerRole/" ++ data."OBX-16"."ST-01"
        else null),
        
        // Value quantity
        valueQuantity: 
        	(if (!isEmpty(removeNull(mapValueQuantity(data)))) 
        		replacePair(
        			mapValueQuantity(data),
        			"system",
        			"http://unitsofmeasure.org"
        		)
        	else null
        ),

        // Value string
        valueString: mapValueString(data),

        // Value codeable concept
        valueCodeableConcept: mapValueCodeableConcept(data),

        // Value period
        valuePeriod: mapValuePeriod(data),

        // Value datetime
        valueDateTime: mapValueDateTime(data),

        // Value time
        valueTime: mapValueTime(data),

        // Value ratio
        valueRatio: mapValueRatio(data),

        // Value range
        valueRange: mapValueRange(data),
        
        // Subject
        (if (!isEmpty(subjectReference))
        subject: {
            reference: subjectReference
        }
        else null),
    },
    request: {
        method: "PUT",
        url: "Observation/" ++ id
    }
}

/**
 * Maps the observation subject object with the provided 
 * information.
 * @param data is an OBX object.
 * @param id is a string with the ID.
 * @param ref is a string with the observation reference.
 * @return An observation object.
 */
fun mapObservationSubject(data, id, ref) = {
	fullUrl: "urn:uuid:" ++ id,
    resource: {
        resourceType: "Observation",
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
        url: "Observation/" ++ id
    }
}

/**
 * Maps the value quantity object with the provided 
 * HL7 OBX object. 
 * @param data is a HL7 OBX object.
 * @return A FHIR Observation valueQuantity object.
 */
fun mapValueQuantity(data) = (
    {
        (if (data."OBX-02" == "NM")
            value: data."OBX-05"."OBX-05"[0] as Number default 0
        else null)
    }

    ++ (if (
        data."OBX-02" == "SN" 
        or data."OBX-02" == "NA" 
        or data."OBX-02" == "NM"
    ) 
    mapCweQuantity(data."OBX-06")
    else {})
)

/**
 * Maps the value string field with the provided 
 * HL7 OBX object.
 * @param data is a HL7 OBX object.
 * @return A valueString field.
 */
fun mapValueString(data) = 
(if (data."OBX-02" == "ST" or data."OBX-02" == "FT" or data."OBX-02" == "TX")
    data."OBX-05".."OBX-05"[0]
else null)

/**
 * Maps the codeable concept value with the provided
 * HL7 OBX object.
 * @param data is a HL7 OBX object.
 * @return A FHIR CodeableConcept object or null if no object is provided.
 */
fun mapValueCodeableConcept(data) = 
(if (
        data."OBX-02" == "CF" 
        or data."OBX-02" == "CNE" 
        or data."OBX-02" == "CWE"
        or data."OBX-02" == "CE"
    )
    mapCodeableConcept(data."OBX-05"[0])
else null)

/**
 * Maps the period value with the provided
 * HL7 OBX object.
 * @param data is a HL7 OBX object.
 * @return A FHIR period object or null if no object is provided.
 */
fun mapValuePeriod(data) = 
(if (data."OBX-02" == "DR")
    {
        start: hl7ConvertDateTime(data."OBX-05"[0]."OBX-05-01"),
        end: hl7ConvertDateTime(data."OBX-05"[0]."OBX-05-02")
    }
else null)

/**
 * Maps the datetime value with the provided HL7 OBX object.
 * @param data is the HL7 OBX object.
 * @return A datetime value or null if no object is provided.
 */
fun mapValueDateTime(data) = 
(if (
        data."OBX-02" == "DT"
        or data."OBX-02" == "DTM"
    )
    data."OBX-05".."OBX-05"[0]
else null)

/**
 * Maps the time value with the provided HL7 OBX object.
 * @param data is the HL7 OBX object.
 * @return A time value or null if no object is provided.
 */
fun mapValueTime(data) = 
(if (data."OBX-02" == "TM")
    data."OBX-05"
else null)

/**
 * Maps the ratio value with the provided HL7 OBX object.
 * @param data is the HL7 OBX object.
 * @return A ratio value object or null.
 */
fun mapValueRatio(data) = 
(if (data."OBX-02" == "SN")
    {}
    ++ (if (
        data."OBX-05"."OBX-03"[0] == ":"
        or data."OBX-05"."OBX-03"[0] == "/"
    )
    mapSnRatio(data."OBX-05")
    else {})

    ++ (if (data."OBX-05"."OBX-03"[0] == ":" or data."OBX-05"."OBX-03"[0] == "/") {
        
        numerator: mapCweQuantity(data."OBX-06"),
        denominator: mapCweQuantity(data."OBX-06")
    }
    else {})
else null)

/**
 * Maps the range value with the provided HL7 OBX object.
 * @param data is the HL7 OBX object.
 * @return A range value object or null.
 */
fun mapValueRange(data) = 
(if (data."OBX-02" == "SN")
{
    (if (!isEmpty(data))
        mapSnRange(data."OBX-05")
    else {})
}

    ++ (if (data."OBX-05"."OBX-03"[0] == "-")
    {
        low: mapCweQuantity(data."OBX-06"),
        high: mapCweQuantity(data."OBX-06")
    }
    else {})

else null)

/**
 * Maps the interpretation array with the provided HL7 OBX object.
 * @param data is the HL7 OBX object.
 * @return An array with the interpretation objects or null.
 */
fun mapInterpretation(data) = 
(if (!isEmpty(data."OBX-08"))
[
    mapCodeableConcept(data."OBX-08"[0], true, mapObservationInterpretationCode)
]
else null)

/**
 * This function is meant to be passed to mapCodeableConcept 
 * and will provide the mapping based upon the provided code.
 * @param code is a string with the code to map.
 * @return an object with the mapped code, or null if not found.
 */
fun mapObservationInterpretationCode(code) = 
(
    if (code == "< ")
    {
        code: "<",
        display: "Off scale low",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "> ")
    {
        code: ">",
        display: "Off scale high",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "A")
    {
        code: "A",
        display: "Abnormal",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "AA")
    {
        code: "AA",
        display: "Critically abnormal",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "AC")
    {
        code: "AC",
        display: "Anti-complementary substances present",
        system: "Get the pattern/value"
    } else if (code == "B")
    {
        code: "B",
        display: "Better",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "CAR")
    {
        code: "CAR",
        display: "Carrier",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "D")
    {
        code: "D",
        display: "Significant change down",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "DET")
    {
        code: "DET",
        display: "Detected",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "E")
    {
        code: "E",
        display: "Equivocal",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "EX")
    {
        code: "EX",
        display: "outside threshold",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "EXP")
    {
        code: "EXP",
        display: "Expected",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "H")
    {
        code: "H",
        display: "High",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "HH")
    {
        code: "HH",
        display: "Critically high",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "HU")
    {
        code: "HU",
        display: "Significantly high",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "I")
    {
        code: "I",
        display: "Intermediate",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "IE")
    {
        code: "IE",
        display: "Insufficient evidence",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "IND")
    {
        code: "IND",
        display: "Indeterminate",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "L")
    {
        code: "L",
        display: "Low",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "LL")
    {
        code: "LL",
        display: "Critical low",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "LU")
    {
        code: "LU",
        display: "Significantly low",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "N")
    {
        code: "N",
        display: "Normal",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "NCL")
    {
        code: "NCL",
        display: "No CLSI defined breakpoint",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "ND")
    {
        code: "ND",
        display: "Not detected",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "NEG")
    {
        code: "NEG",
        display: "Negative",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "NR")
    {
        code: "NR",
        display: "Non-reactive",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "NS")
    {
        code: "NS",
        display: "Non-susceptible",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "POS")
    {
        code: "POS",
        display: "Positive",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "R")
    {
        code: "R",
        display: "Resistant",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "RR")
    {
        code: "RR",
        display: "Reactive",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "S")
    {
        code: "S",
        display: "Susceptible",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "SDD")
    {
        code: "SDD",
        display: "Susceptible-dose dependent",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "SYN-S")
    {
        code: "SYN-S",
        display: "Synergy - susceptible",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "U")
    {
        code: "U",
        display: "Significant change up",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "UNE")
    {
        code: "UNE",
        display: "Unexpected",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "W")
    {
        code: "W",
        display: "Worse",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else if (code == "WR")
    {
        code: "WR",
        display: "Weakly reactive",
        system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
    } else {
    	code: code,
    	display: code,
    	system: "urn:undefined"
    } 
)

/**
 * This function takes the provided code and maps the 
 * observation status (codeableconcept).
 * @param code is a string with the code to map.
 * @return an object with the mapped code, or null if not found.
 */
fun mapObservationStatus(code) = 
(
    if (code == "A")
    {
        code: "ammended",
        display: "Ammended",
        system: "http://hl7.org/fhir/observation-status"
    } else if (code == "C")
    {
        code: "corrected",
        display: "Corrected",
        system: "http://hl7.org/fhir/observation-status"
    } else if (code == "D")
    {
        code: "entered-in-error",
        display: "Entered in Error",
        system: "http://hl7.org/fhir/observation-status"
    } else if (code == "F")
    {
        code: "final",
        display: "Final",
        system: "http://hl7.org/fhir/observation-status"
    } else if (code == "I")
    {
        code: "registered",
        display: "Registered",
        system: "http://hl7.org/fhir/observation-status"
    } else if (code == "P")
    {
        code: "preliminary",
        display: "Preliminary",
        system: "http://hl7.org/fhir/observation-status"
    } else if (code == "S")
    {
        code: "preliminary",
        display: "Preliminary",
        system: "http://hl7.org/fhir/observation-status"
    } else if (code == "W")
    {
        code: "entered-in-error",
        display: "Entered in Error",
        system: "http://hl7.org/fhir/observation-status"
    } else
    {
    	code: "unknown",
    	display: "unknown",
    	system: "http://hl7.org/fhir/observation-status"
    }
)

/**
 * Maps the identifier for observation with the provided 
 * OBX-21 field.
 * @param val is a string with the OBX-21 field.
 * @return A identifier array or null if no value is provided.
 */
fun mapObservationIdentifier(val) = 
(if (!isEmpty(val))
[
    {
        value: val
    },
    {
        "type": {
            coding: [
                {
                    code: "FILL"
                }
            ]
        }
    }
]
else null)

/**
 * Maps the component list with the provided OBX object.
 * @param data is an OBX object.
 * @return A component list or null if no object is provided.
 */
fun mapComponent(data) = 
(if (!isEmpty(data))
[
    {
        // Code - This is set to urn:undefined. The reason is since 
        // this code is the same as the one in the main part of the object 
        // fhir validation will fail.
        code: (if (!isEmpty(mapCodeableConcept(data."OBX-03")))
        	{
        		coding: [
        			replacePair(
        				mapCodeableConcept(data."OBX-03").coding[0],
        				"system",
        				"urn:undefined"
        			)
        		]
        	}
        else null),

        // Value quantity
        valueQuantity: (if (!isEmpty(removeNull(mapValueQuantity(data)))) 
        		replacePair(
        			mapValueQuantity(data),
        			"system",
        			"http://unitsofmeasure.org"
        		)
        	else null
        ),

        // Value string
        valueString: mapValueString(data),

        // Value period
        valuePeriod: mapValuePeriod(data),

        // Value datetime
        valueDateTime: mapValueDateTime(data),

        // Value time
        valueTime: mapValueTime(data),

        // Value ratio
        valueRatio: mapValueRatio(data),

        // Value range
        valueRange: mapValueRange(data),

        // Reference range
        referenceRange: 
        (if (!isEmpty(data."OBX-07"))
	        [
	            {
	                text: data."OBX-07"
	            }
	        ]
        else null),

        // Interpretation
        interpretation: mapInterpretation(data),
    }
]
else null)