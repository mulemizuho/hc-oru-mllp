/**
 * This module is responsible for converting an OML-O21 HL7 
 * message into it's equivalent FHIR format.
 */

%dw 2.0

// Import GUID Function
import mapGuid, removeNull, toString from dw::resources::util

// Import the patient library
import mapPatient from dw::resources::patient

// Import the location library
import mapLocation from dw::resources::location

// Import the encounter library
import mapEncounter, mapEncounterSubject from dw::resources::encounter

// Import the procedure library
import mapProcedure, mapProcedureSubject from dw::resources::procedure

// Import the related person library
import mapRelatedPerson from dw::resources::relatedperson

// Import the servicerequest library
import mapServiceRequest, mapServiceRequestSupportingInfo, mapServiceRequestReasonReference, mapServiceRequestSpecimen from dw::resources::servicerequest

// Import the allergy intolerance library
import mapAllergyIntolerance from dw::resources::allergyintolerance

// Import the observation library
import mapObservation from dw::resources::observation

// Import the condition library
import mapCondition, mapConditionSubject from dw::resources::condition

// Import the specimen library
import mapSpecimen from dw::resources::specimen

// Import the device library
import mapDevice from dw::resources::device

/**
 * This function maps the entire O21 message into 
 * it's FHIR equivalent.
 * @param data is an object with the parsed OML_O21 message.
 * @return An object with the FHIR representation.
 */
fun mapO21Message(data:Object) = []

// If PID segment then map patient.
++ (if(!isEmpty(data.PATIENT.PID))
[
	mapPatient(
		data.PATIENT.PID, 
		data.PATIENT.PD1 default {}, 
		data.PATIENT.NK1 default {}, 
		mapGuid(data.PATIENT.PID."PID-03"[0]."CX-01")
	)
]
else [])


// If PV1 segment
++ (if (!isEmpty(data.PATIENT.PATIENT_VISIT.PV1))[
	// map encounter
	(if (!isEmpty(data.PATIENT.PID."PID-03"[0]."CX-01"))
	    mapEncounter(
	        data.PATIENT.PATIENT_VISIT.PV1, 
	        data.PATIENT.PATIENT_VISIT.PV2 default {}, 
	        data.PATIENT.PID default {}, 
	        mapGuid(toString(data.PATIENT.PATIENT_VISIT.PV1)),
	        "Patient/" ++ mapGuid(data.PATIENT.PID."PID-03"[0]."CX-01")
	    )
	else
		mapEncounter(
	        data.PATIENT.PATIENT_VISIT.PV1, 
	        data.PATIENT.PATIENT_VISIT.PV2 default {}, 
	        data.PATIENT.PID default {}, 
	        mapGuid(toString(data.PATIENT.PATIENT_VISIT.PV1))
	    )
	),
    
    // map location
    (if (!isEmpty(data.PATIENT.PATIENT_VISIT.PV1."PV1-03"))
        mapLocation(
        	data.PATIENT.PATIENT_VISIT.PV1."PV1-03", 
        	mapGuid(toString(data.PATIENT.PATIENT_VISIT.PV1."PV1-03"))
        )
    else null),
    
    // map location
    (if (!isEmpty(data.PATIENT.PATIENT_VISIT.PV1."PV1-06"))
        mapLocation(
        	data.PATIENT.PATIENT_VISIT.PV1."PV1-06",
        	mapGuid(toString(data.PATIENT.PATIENT_VISIT.PV1."PV1-06"))
        )
    else null)
]
else [])


// If AL1 segment then map AllergyIntolerance.
++ 
(
	if(!isEmpty(data.PATIENT.AL1)) 
		(data.PATIENT.AL1 map (al1Item, al1Index) ->
			(
				// If patient reference is there use it.
				if (!isEmpty(data.PATIENT.PID."PID-03"[0]."CX-01"))
					mapAllergyIntolerance(
						data.PATIENT.PID default {},
						al1Item,
						mapGuid(toString(al1Item)),
						"Patient/" ++ mapGuid(data.PATIENT.PID."PID-03"[0]."CX-01")
					)
				// Otherwise map without it
				else
					mapAllergyIntolerance(
					data.PATIENT.PID default {},
					al1Item,
					mapGuid(toString(al1Item))
				)
			)	
		)
	else []
)

// If NK1 segment then map RelatedPerson.
++ (
	if(!isEmpty(data.PATIENT.NK1)) 
		(data.PATIENT.NK1 map (nk1Item, nk1Index) ->
			(
				if (!isEmpty(data.PATIENT.PID."PID-03"[0]."CX-01"))
					mapRelatedPerson(
						data.PATIENT.PID, 
						nk1Item, 
						mapGuid(toString(nk1Item)), 
						"Patient/" ++ mapGuid(data.PATIENT.PID."PID-03"[0]."CX-01")
					)
				else 
					mapRelatedPerson(
						data.PATIENT.PID, 
						nk1Item, 
						mapGuid(toString(nk1Item))
					)
			)
		)
	else []
)

// Foreach order
++ (
	if (!isEmpty(data.ORDER))
	data.ORDER map (orderItem, orderIndex) -> 
	(
		// Map the order (ORC) to a service request.
		if (!isEmpty(data.PATIENT.PID."PID-03"[0]."CX-01"))
			mapServiceRequest(
				orderItem.ORC,
				orderItem.OBSERVATION_REQUEST.OBR default {},
				orderItem.TIMING[0].TQ1 default {},
				orderItem.OBSERVATION.OBX,
				orderItem.OBSERVATION_REQUEST.DG1,
				mapGuid("ServiceRequest" ++ toString(orderItem.ORC)),
				"Patient/" ++ mapGuid(data.PATIENT.PID."PID-03"[0]."CX-01")
			)
		else
			mapServiceRequest(
				orderItem.ORC,
				orderItem.OBSERVATION_REQUEST.OBR default {},
				orderItem.TIMING[0].TQ1 default {},
				orderItem.OBSERVATION.OBX,
				orderItem.OBSERVATION_REQUEST.DG1,
				mapGuid("ServiceRequest" ++ toString(orderItem.ORC)),
				""	
			)
	)
	else []
)

// Foreach PRIOR_RESULT order
++ (
	if (!isEmpty(data.ORDER))
     flatten(
         data.ORDER map (orderItem, orderIndex) -> 
        (
            flatten(
                orderItem.OBSERVATION_REQUEST.PRIOR_RESULT map (priorItem, priorIndex) ->
                    priorItem.ORDER_PRIOR map (ordPriItem, ordPriIndex) -> 
                    	if (!isEmpty(data.PATIENT.PID."PID-03"[0]."CX-01"))
	                        mapServiceRequest(
								ordPriItem.ORC,
								ordPriItem.OBR default {},
								ordPriItem.TIMING[0].TQ1 default {},
								ordPriItem.OBSERVATION_PRIOR.OBX,
								[],
								mapGuid("ServiceRequest" ++ toString(ordPriItem.ORC)),
								"Patient/" ++ mapGuid(data.PATIENT.PID."PID-03"[0]."CX-01")
							)
						else
							mapServiceRequest(
								ordPriItem.ORC,
								ordPriItem.OBR default {},
								ordPriItem.TIMING[0].TQ1 default {},
								ordPriItem.OBSERVATION_PRIOR.OBX,
								[],
								mapGuid("ServiceRequest" ++ toString(ordPriItem.ORC)),
								""
							)
            )
        )
     )
	else []
)


// Foreach order observation segment.
++ (
	if (!isEmpty(data.ORDER))
	flatten(
		data.ORDER map (orderItem, orderIndex) -> 
		(
			orderItem.OBSERVATION_REQUEST.OBSERVATION map (obsItem, obsIndex) ->
				if (!isEmpty(data.PATIENT.PID."PID-03"[0]."CX-01"))
					mapObservation(
						obsItem.OBX, 
						mapGuid("Observation" ++ toString(obsItem.OBX)),
						(if (!isEmpty(obsItem.PRT[0]."PRT-10"[0]."EI-01")) "Device/" ++ mapGuid(obsItem.PRT[0]."PRT-10"[0]."EI-01") else null),
						"Patient/" ++ mapGuid(data.PATIENT.PID."PID-03"[0]."CX-01")
						)
				else
					mapObservation(
						obsItem.OBX, 
						mapGuid("Observation" ++ toString(obsItem.OBX)),
						(if (!isEmpty(obsItem.PRT[0]."PRT-10"[0]."EI-01")) "Device/" ++ mapGuid(obsItem.PRT[0]."PRT-10"[0]."EI-01") else null),
						null
						)
		)
	)
	else []
)


// Foreach diagnosis (DG1) segment
++ (
	if (!isEmpty(data.ORDER))
     flatten(
        data.ORDER map (orderItem, orderIndex) -> 
        (
        	orderItem.OBSERVATION_REQUEST.DG1 map (dgItem, dgIndex) -> 
        		if (!isEmpty(data.PATIENT.PID."PID-03"[0]."CX-01"))
        			mapCondition(
	        			dgItem, 
	        			data.PATIENT.PID default {},
	        			mapGuid(toString(dgItem)),
	        			"Patient/" ++ mapGuid(data.PATIENT.PID."PID-03"[0]."CX-01")
	        		)
        		else
	        		mapCondition(
	        			dgItem, 
	        			data.PATIENT.PID default {},
	        			mapGuid(toString(dgItem))
	        		)
        )
	)
	else []
)

// Foreach specimen segment.
++ (
	if (!isEmpty(data.ORDER))
	flatten(
		data.ORDER map (orderItem, orderIndex) -> 
            orderItem.OBSERVATION_REQUEST.SPECIMEN map (specimenItem, specimenIndex) -> 
 				mapSpecimen(specimenItem."SPM", mapGuid(specimenItem."SPM"."SPM-02"."EIP-01"."EI-01"))
    )
	else []
)

// Foreach order observation segment.
++ (
	if (!isEmpty(data.ORDER))
	flatten(
		data.ORDER map (orderItem, orderIndex) -> 
		(
			flatten(
				orderItem.OBSERVATION_REQUEST.OBSERVATION map (obsItem, obsIndex) ->
					obsItem.PRT map (prtItem, prtIndex) ->
						mapDevice(
							prtItem,
							mapGuid(prtItem."PRT-10"[0]."EI-01")
						)
			)
		)
	)
	else []
)








