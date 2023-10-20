/**
 * This module is responsible for converting a SIU-S12 HL7 
 * message into it's equivalent FHIR format.
 */

%dw 2.0

// Import needed libraries
import mapGuid, clean, toString from dw::resources::util
import mapAppointment from dw::resources::appointment
import mapPatient from dw::resources::patient
import mapEncounter from dw::resources::encounter
import mapObservation from dw::resources::observation
import mapCondition from dw::resources::condition
import mapProvenance from dw::resources::provenance
import mapServiceRequest from dw::resources::servicerequest

fun mapSiuS12Message(data:Object) = []

// Appointment
++ (if(!isEmpty(data.SCH)) [
	clean(
		mapAppointment(
			mapGuid(data.SCH."SCH-01"."EI-01"),
			data.SCH,
            data.PATIENT..PID,
            data.NTE,
            data.RESOURCES..AIS[0] default null,
            data.RESOURCES..NTE default [],
            data.RESOURCES.GENERAL_RESOURCE..AIG,
            data.RESOURCES.PERSONNEL_RESOURCE..AIP
		)
	)
]
else [])

// Patient
++ (if(!isEmpty(data.PATIENT))
	data.PATIENT map (patient, pindex) -> 
	(if (!isEmpty(patient.PID."PID-03"[0]."CX-01"))
		clean(
			mapPatient(
				patient.PID, 
				patient.PD1, 
				null, 
				mapGuid(patient.PID."PID-03"[0]."CX-01")
			)
		)
	else null)
else [])

// Encounter
++ (if(!isEmpty(data.PATIENT))
	data.PATIENT map (patient, pindex) -> 
	(if (!isEmpty(patient.PID."PID-03"[0]."CX-01") and !isEmpty(patient.PV1))
		clean(
			mapEncounter(
				patient.PV1 default {}, 
				patient.PV2 default {}, 
				patient.PID, 
				mapGuid(toString(patient.PV1)),
				"Patient/" ++ mapGuid(patient.PID."PID-03"[0]."CX-01")
			)
		)
	else null)
else [])

// Observation
++ clean(flatten(if(!isEmpty(data.PATIENT))
	data.PATIENT map (patient, pindex) -> 
		patient.OBX map (item, index) -> 
		(if (!isEmpty(patient.PID."PID-03"[0]."CX-01"))
			mapObservation(
		        item, 
		        mapGuid(toString(item)),
		        null,
		        "Patient/" ++ mapGuid(patient.PID."PID-03"[0]."CX-01")
			)
		else 
			mapObservation(
		        item, 
		        mapGuid(toString(item))
			)
		)
else []))

// Condition
++ clean(flatten(flatten(if(!isEmpty(data.PATIENT))
    data.PATIENT map (patient, pindex) -> 
    	patient.DG1 map (item, index) ->
	    (
		    if (!isEmpty(patient.PID."PID-03"[0]."CX-01"))
		    	mapCondition(
		        	item, 
		        	patient.PID, 
		        	mapGuid(toString(item)),
		        	"Patient/" ++ mapGuid(patient.PID."PID-03"[0]."CX-01")
		        )
		    else
		        mapCondition(
		        	item, 
		        	patient.PID, 
		        	mapGuid(toString(item))
		        )
     	)
	else [])
))

// Provenance
++ clean(
	if(!isEmpty(data.MSH) and !isEmpty(data.PATIENT[0]."PID"."PID-03"[0]."CX-01")) 
		[
			mapProvenance(
				{}, 
				data.MSH default {}, 
				"Patient/" ++ mapGuid(data.PATIENT[0]."PID"."PID-03"[0]."CX-01"),
				"",
				"",
				"Patient/" ++ mapGuid(data.PATIENT[0]."PID"."PID-03"[0]."CX-01"),
				mapGuid(toString(data.MSH))
			)
		]
	else []
)

// ServiceRequest
++ clean(
	if (!isEmpty(data.PATIENT[0]."PID"."PID-03"[0]."CX-01"))
	[
		mapServiceRequest(
				{},
				{},
				data.TQ1[0] default {},
				data.PATIENT.OBX default [],
				data.PATIENT.DG1 default [],
				mapGuid("ServiceRequest" ++ data.PATIENT[0]."PID"."PID-03"[0]."CX-01"),
				"Patient/" ++ mapGuid(data.PATIENT[0]."PID"."PID-03"[0]."CX-01")
		)
	]
	else []
)