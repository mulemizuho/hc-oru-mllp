/**
 * This module is responsible for converting an ADT-A01 HL7 
 * message into it's equivalent FHIR format.
 */

%dw 2.0

// Import GUID Function
import mapGuid, removeNull, toString from dw::resources::util

// Import the patient library
import mapPatient from dw::resources::patient

// Import the related person library
import mapRelatedPerson from dw::resources::relatedperson

// Import the encounter library
import mapEncounter, mapEncounterDiagnosis from dw::resources::encounter

// Import the location library
import mapLocation from dw::resources::location

// Import the procedure library
import mapProcedure from dw::resources::procedure

// Import the observation library
import mapObservation from dw::resources::observation

// Import the allergy intolerance library
import mapAllergyIntolerance from dw::resources::allergyintolerance

// Import the condition library
import mapCondition from dw::resources::condition

// Import the account library
import mapAccount from dw::resources::account

// Import the removeEmpty function library
import removeEmpty from dw::resources::util 


/**
 * This function maps the entire A01 message into 
 * it's FHIR equivalent.
 * @param data is an object with the parsed ADT_A01 message.
 * @return An object with the FHIR representation.
 */
fun mapA01Message(data:Object) = []

// If PID segment then map patient.
++ (if(!isEmpty(data.PID."PID-03"[0]."CX-01")) [
	removeEmpty(mapPatient(
		data.PID, 
		data.PD1, 
		data.NK1, 
		mapGuid(data.PID."PID-03"[0]."CX-01")
	))
]
else [])


// If PV1 segment
++ (if(!isEmpty(data.PV1)) [
    // map encounter
    (
    	if (!isEmpty(data.PID."PID-03"[0]."CX-01"))
		    mapEncounter(
		        data.PV1 default {}, 
		        data.PV2 default {}, 
		        data.PID default {}, 
		        mapGuid(toString(data.PV1)),
		        "Patient/" ++ mapGuid(data.PID."PID-03"[0]."CX-01")
		    )
		 else
		 	mapEncounter(
		        data.PV1 default {}, 
		        data.PV2 default {}, 
		        data.PID default {}, 
		        mapGuid(toString(data.PV1))
		    )
	),
    
    // map location
    (if (!isEmpty(data.PV1."PV1-03"))
        mapLocation(data.PV1."PV1-03",  mapGuid(toString(data.PV1."PV1-03")))
    else null),
    
    // map location
    (if (!isEmpty(data.PV1."PV1-06"))
        mapLocation(data.PV1."PV1-06",  mapGuid(data.PV1."PV1-06"))
    else null)
]
else [])


// If PR1 segment
++ (if(!isEmpty(data.PROCEDURE[0].PR1)) [
	// map procedure
	(
		if (!isEmpty(data.PID."PID-03"[0]."CX-01"))
			mapProcedure(
		    	data.PROCEDURE[0].PR1, 
		    	mapGuid(toString(data.PROCEDURE[0].PR1)),
		    	"Patient/" ++ mapGuid(data.PID."PID-03"[0]."CX-01")
		    )
		else
			mapProcedure(
		    	data.PROCEDURE[0].PR1, 
		    	mapGuid(toString(data.PROCEDURE[0].PR1))
		    )
	),
    

    // map location
    (if (!isEmpty(data.PROCEDURE[0].PR1."PR1-23"))
        mapLocation(
            data.PROCEDURE[0].PR1."PR1-23", 
            mapGuid(toString(data.PROCEDURE[0].PR1."PR1-23"))
        )
    else null)
]
else [])

// If NK1 segment then map RelatedPerson.
++ (if(!isEmpty(data.NK1)) 
	(data.NK1 map (nk1Item, nk1Index) ->
		removeEmpty (mapRelatedPerson(
			data.PID, 
			nk1Item, 
			mapGuid(toString(nk1Item))
		))
	)
else [])


// OBX Observation objects
++ (
    data.OBX map (item, index) -> 
    	(if (!isEmpty(data.PID."PID-03"[0]."CX-01"))
	        mapObservation(
	        	item, 
	        	mapGuid(toString(item)),
	        	null,
	        	"Patient/" ++ mapGuid(data.PID."PID-03"[0]."CX-01")
	        )
	     else
	     	mapObservation(
	        	item, 
	        	mapGuid(toString(item))
	        )
	     )
)


// If AL1 segment then map AllergyIntolerance.
++ (if(!isEmpty(data.AL1)) 
	(data.AL1 map (al1Item, al1Index) ->
		removeEmpty(mapAllergyIntolerance(
			data.PID, 
			al1Item, 
			mapGuid(toString(al1Item))
		))
	)
else [])


// DG1 Condition objects
++ (
    data.DG1 map (item, index) -> 
    (
	    if (!isEmpty(data.PID."PID-03"[0]."CX-01"))
	    	mapCondition(
	        	item, 
	        	data.PID, 
	        	mapGuid(toString(item)),
	        	"Patient/" ++ mapGuid(data.PID."PID-03"[0]."CX-01")
	        )
	    else
	        mapCondition(
	        	item, 
	        	data.PID, 
	        	mapGuid(toString(item))
	        )
     )
) default []


// DG1/PV1 Encounter diagnosis objects
++ removeNull((
    data.DG1 map (item, index) -> (
        if (!isEmpty(data.PV1."PV1-19"."CX-01"))
        mapEncounterDiagnosis(
            mapGuid(data.PV1."PV1-19"."CX-01" as String), 
            "Condition/" ++ mapGuid(item."DG1-01" as String)
        )
    else null)
) default [])

// Account object
++ (
	if (!isEmpty(data.PID) and !isEmpty(data.PID."PID-18"."CX-01"))
	[
		mapAccount(
			data.PID,
			mapGuid(data.PID."PID-18"."CX-01")
		)
	]
	else []
)