/**
 * This module is responsible for converting a SIU-S12 HL7 
 * message into a FHIR Appointment object.
 */

%dw 2.0

// Import needed libraries
import hl7ConvertDateTime from dw::resources::util
import mapCodeableConcept from dw::resources::datatypes::codeableconcept
import mapIdentifier from dw::resources::datatypes::identifier

/**
 * Maps the FHIR Appointment object with the provided 
 * SCH HL7 segment.
 * @param id is a string with the GUID.
 * @param obj is a SCH segment.
 * @param pid is the PID segment list.
 * @param nte is a list of NTE segments.
 * @param ais is a list of AIS segments.
 * @param serviceNte is a list of NTE segments from the SERVICE node.
 * @param aig is a list of AIG segments.
 * @param aip is a list of AIP segments.
 * @return A FHIR formatted Appointment object.
 */
fun mapAppointment(id, obj, pid, nte, ais, serviceNte, aig, aip) = {
	fullUrl: "urn:uuid:" ++ id,
    resource: {
        // Resource type
        resourceType: "Appointment",

        // ID
        id: id,
	 
		// Identifier
		(if (!isEmpty(obj."SCH-01") and !isEmpty(obj."SCH-02"))
	        identifier: [
	            (if (!isEmpty(obj."SCH-01"))
	                mapIdentifier(obj."SCH-01")
	            else null),
	            (if (!isEmpty(obj."SCH-02"))
	                mapIdentifier(obj."SCH-02")
	            else null),
	        ]
	    else null),
		
		// ReasonCode
		(
	        if (!isEmpty(obj."SCH-07"))
			    reasonCode: [ mapCodeableConcept(obj."SCH-07") ]
	        else if (!isEmpty(ais."AIS-03"))
	            reasonCode: [ ais."AIS-03"."CWE-01" ]
		    else null
	    ),
	
	    // AppointmentType
	    (if (!isEmpty(obj."SCH-07"))
			appointmentType: mapCodeableConcept(obj."SCH-07")
		else null),
	
	    // Participants
	    participant: mapParticipants(obj, pid, ais, aig, aip),
	    
	    // Status
	    (if (!isEmpty(obj."SCH-25"."CWE-01"))
	        status: mapAppointmentStatus(obj."SCH-25"."CWE-01")
	    else null),
	
	    // BasedOn
	    (if (!isEmpty(obj."SCH-26"."EL-01") or !isEmpty(obj."SCH-27"."EL-01"))
	        basedOn: [
	            (
	                if (!isEmpty(obj."SCH-26"."EL-01"))
	                {
	                    reference: "ServiceRequest/" ++ obj."SCH-26"."EL-01"
	                }
	                else if (!isEmpty(obj."SCH-27"."EL-01"))
	                {
	                    reference: "ServiceRequest/" ++ obj."SCH-27"."EL-01"
	                }
	                else null
	            )
	        ]
	    else null),
	    
	    // Comment
	    (if (!isEmpty(nte."NTE-03") or !isEmpty(serviceNte."NTE-03"))
	        comment: ""
	        ++ (if (!isEmpty(nte."NTE-03"))
	            (flatten(nte."NTE-03") default []) joinBy '\n'
	        else "")
	        ++ (if (!isEmpty(serviceNte."NTE-03"))
	            (flatten(serviceNte."NTE-03") default []) joinBy '\n'
	        else "")
	    else null),
	
	    // ServiceType
	    (
	        if (!isEmpty(ais."AIS-03"))
	            serviceType: [ mapCodeableConcept(ais."AIS-03") ]
	        else null
	    ),
		
        // Start
        (if (!isEmpty(ais."AIS-04"))
            start: hl7ConvertDateTime(ais."AIS-04")
        else null),
        
        // End
        (if (!isEmpty(ais."AIS-04"))
	        end: getEndTime(ais)
	    else null),
        
        // MinutesDuration
        (
        	if (!isEmpty(ais."AIS-04"))
        		minutesDuration: (getEndTime(ais) - hl7ConvertDateTime(ais."AIS-04")).minutes
        	else if (!isEmpty(obj."SCH-09"))
		    	minutesDuration: (obj."SCH-09" as Number)
        	else null
        ),
	},
    request: {
        method: "PUT",
        url: "Appointment/" ++ id
    }
}

/**
 * Gets the end datetime for the appointment with the 
 * provided AIS segment.
 * @return a formatted date or null if not possible.
 */
fun getEndTime(ais) = 
	// No units specified, assuming minutes.
	if (!isEmpty(ais."AIS-07") and isEmpty(ais."AIS-08"))
	    hl7ConvertDateTime(ais."AIS-04") + ("PT" ++ ais."AIS-07" ++ "M")
	else if (
	    !isEmpty(ais."AIS-07") and !isEmpty(ais."AIS-08")
	    and (lower(ais."AIS-08"."CNE-02") == "hours")
	)
	    hl7ConvertDateTime(ais."AIS-04") + ("PT" ++ ais."AIS-07" ++ "H")
	else if (
	    !isEmpty(ais."AIS-07") and !isEmpty(ais."AIS-08")
	    and (lower(ais."AIS-08"."CNE-02") == "minutes")
	)
	    hl7ConvertDateTime(ais."AIS-04") + ("PT" ++ ais."AIS-07" ++ "M")
	else if (
	    !isEmpty(ais."AIS-07") and !isEmpty(ais."AIS-08")
	    and (lower(ais."AIS-08"."CNE-02") == "seconds")
	)
	    hl7ConvertDateTime(ais."AIS-04") + ("PT" ++ ais."AIS-07" ++ "S")
	else
	    // Duration is uncertain, set end time same as start
	    hl7ConvertDateTime(ais."AIS-04")


/**
 * Maps the provided HL7 SCH-25 value to 
 * the appropriate FHIR status value.
 * @param val is the HL7 SCH-25 value.
 * @return the FHIR formatted status value.
 */
fun mapAppointmentStatus(val) = 
(
    if (lower(val) == "blocked")
        "entered-in-error"
    else if (lower(val) == "booked")
        "booked"
    else if (lower(val) == "cancelled")
        "cancelled"
    else if (lower(val) == "complete")
        "checked-in"
    else if (lower(val) == "dc")
        "cancelled"
    else if (lower(val) == "deleted")
        "cancelled"
    else if (lower(val) == "noshow")
        "noshow"
    else if (lower(val) == "overbook")
        "waitlist"
    else if (lower(val) == "pending")
        "pending"
    else if (lower(val) == "started")
        "checked-in"
    else if (lower(val) == "waitlist")
        "waitlist"
    else
        "entered-in-error"
)

/**
 * Maps the provided SCH HL7 segment to the participants 
 * list for the Appointment object.
 * @param obj is a SCH segment.
 * @param pid is the PID segment list.
 * @param ais is a AIS segment.
 * @param aig is a list of AIG segments.
 * @param ail is a list of AIL segments.
 * @param aip is a list of AIP segments.
 * @return A FHIR formatted list of participant objects.
 */
fun mapParticipants(obj, pid, ais, aig, aip) = 
[
    (if (!isEmpty(obj."SCH-12"."XCN-01"))
        {
            "type": [{
                coding: [{
                    code: "ATND",
                    system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
                }]
            }],
            actor: {
                reference: "Practitioner/" ++ obj."SCH-12"."XCN-01"
            },
            status: "accepted",
            (
            	if (!isEmpty(ais."AIS-04"))
                period: {
                    start: hl7ConvertDateTime(ais."AIS-04")
                }
            	else null
            )
        }
    else null)
]
++ (
    obj."SCH-16" map (item, index) -> 
    (if (!isEmpty(item)) // Why is this needed? 
        {
            "type": [{
                coding: [{
                    code: "PRF",
                    system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
                }]
            }],
            actor: {
                reference: "Practitioner/" ++ (item."XCN-01" default "")
            },
            status: "accepted",
            (
            	if (!isEmpty(ais."AIS-04"))
                period: {
                    start: hl7ConvertDateTime(ais."AIS-04")
                }
            	else null
            )
        }
    else [])
)
++ (
    obj."SCH-20" map (item, index) -> 
    (if (!isEmpty(item)) // Why is this needed? 
        {
            "type": [{
                coding: [{
                    code: "ADM",
                    system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
                }]
            }],
            actor: {
                reference: "Practitioner/" ++ (item."XCN-01" default "")
            },
            status: "accepted",
            (
            	if (!isEmpty(ais."AIS-04"))
                period: {
                    start: hl7ConvertDateTime(ais."AIS-04")
                }
            	else null
            )
        }
    else [])
)
++ (
    pid map (item, index) -> 
    (if (!isEmpty(item."PID-02"))
    {
        "type": [{
            coding: [{
                code: "ATND",
                system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
            }]
        }],
        actor: {
                reference: "Patient/" ++ (item."PID-02" default "")
            },
            status: "accepted",
            (
            	if (!isEmpty(ais."AIS-04"))
                period: {
                    start: hl7ConvertDateTime(ais."AIS-04")
                }
            	else null
            )
    }
    else null)
) default []
++ (
    pid map (item, index) -> 
    (if (!isEmpty(item."PID-03"))
    {
        "type": [{
            coding: [{
                code: "ATND",
                system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
            }]
        }],
        actor: {
                reference: "Patient/" ++ (item."PID-03"[0]."CX-01" default "")
            },
            status: "accepted",
            (
            	if (!isEmpty(ais."AIS-04"))
                period: {
                    start: hl7ConvertDateTime(ais."AIS-04")
                }
            	else null
            )
    }
    else null)
) default []
++ (
    pid map (item, index) -> 
    (if (!isEmpty(item."PID-04"))
    {
        "type": [{
            coding: [{
                code: "ATND",
                system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
            }]
        }],
        actor: {
                reference: "Patient/" ++ (item."PID-04" default "")
            },
            status: "accepted",
            (
            	if (!isEmpty(ais."AIS-04"))
                period: {
                    start: hl7ConvertDateTime(ais."AIS-04")
                }
            	else null
            )
    }
    else null)
) default []
++ (
    aig map (item, index) -> 
    (if (!isEmpty(item."AIG-03"."CWE-01"))
    {
        "type": [{
            coding: [{
                code: "REF",
                system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
            }]
        }],
        actor: {
                reference: "Location/" ++ (item."AIG-03"."CWE-01" default "")
            },
            status: "accepted",
            (
            	if (!isEmpty(item."AIG-08"))
                period: {
                    start: hl7ConvertDateTime(item."AIG-08")
                }
            	else null
            )
    }
    else null)
) default []
++ (
    aig map (item, index) -> 
    (if (!isEmpty(item."AIP-03"[0]."XCN-01"))
    {
        "type": [{
            coding: [{
                code: "ATND",
                system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
            }]
        }],
        actor: {
                reference: "Practitioner/" ++ (item."AIP-03"[0]."XCN-01" default "")
            },
            status: "accepted",
            (
            	if (!isEmpty(item."AIP-06"))
                period: {
                    start: hl7ConvertDateTime(item."AIP-06")
                }
            	else null
            )
    }
    else null)
) default []