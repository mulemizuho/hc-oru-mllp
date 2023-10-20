/**
 * This module is responsible for converting an ORU_R01 HL7 
 * message into it's equivalent FHIR format.
 */

%dw 2.0

// Import GUID Function
import mapGuid, removeNull, toString from dw::resources::util

// Import the patient library
import mapPatient from dw::resources::patient

// Import the encounter library
import mapEncounter, mapEncounterSubject from dw::resources::encounter

// Import the related person library
import mapRelatedPerson from dw::resources::relatedperson

// Import the servicerequest library
import mapServiceRequest, mapServiceRequestSupportingInfo, mapServiceRequestReasonReference, mapServiceRequestSpecimen from dw::resources::servicerequest

// Import the observation library
import mapObservation, mapObservationSubject from dw::resources::observation

// Import the specimen library
import mapSpecimen from dw::resources::specimen

// Import the device library
import mapDevice from dw::resources::device


// Import the location library
import mapLocation from dw::resources::location

// Import the diagnostic report library
import mapDiagnosticReport, mapDiagnosticReportResultReference, mapDiagnosticReportspecimenReference from dw::resources::diagnosticreport

// Import the diagnostic practitionerrole library
import mapPractitionerRole from dw::resources::practitionerrole


// Import the provenance library
import mapProvenance from dw::resources::provenance

/**
 * This function maps the entireR01 message into 
 * it's FHIR equivalent.
 * @param data is an object with the parsed ORU_R01 message.
 * @return An object with the FHIR representation.
 */
 
fun mapR01Message(data:Object) = 

flatten (data."PATIENT_RESULT" map (pResult, pResultIndex)  -> using (patient = pResult."PATIENT", order = pResult."ORDER_OBSERVATION")
 
[] 


  	// If MSH segment then provenance patient.
++ [(if(!isEmpty(data."MSH")) 
 
 	
		( 
			mapProvenance(
		      {}, 
		      data."MSH" default {}, 
		      "Patient/" ++ mapGuid(patient."PID"."PID-03"[0]."CX-01"),
		      "",
		      "",
		      "Patient/" ++ mapGuid(patient."PID"."PID-03"[0]."CX-01"),
		      mapGuid(toString(data."MSH"))
    		)	                    
		)
		
 
  else [])]

  // If PID segment then map patient.
++  [(if(!isEmpty(patient."PID"))
    mapPatient(
      patient."PID", 
      patient."PD1" default {}, 
      patient."NK1" default {}, 
      mapGuid(patient."PID"."PID-03"[0]."CX-01")
    ) 
  else [])]

  
  // If PV1 segment then 
++  [(if (!isEmpty(patient."VISIT"."PV1"))
    // If patient segment then 
    (if (!isEmpty(patient."PID"."PID-03"[0]."CX-01"))
      //map encounter
        mapEncounter(
            patient."VISIT"."PV1", 
            patient."VISIT"."PV2" default {}, 
            {}, 
            mapGuid(toString(patient."VISIT"."PV1")),
            "Patient/" ++ mapGuid(patient."PID"."PID-03"[0]."CX-01")
        )
     else mapEncounter(
            patient."VISIT".PV1, 
            patient."VISIT".PV2 default {}, 
            {}, 
            mapGuid(toString(patient."VISIT".PV1))
        )
     )
   else null)]


     // map location
++   [(if (!isEmpty(patient."VISIT".PV1."PV1-03"))
        mapLocation(
          patient."VISIT".PV1."PV1-03", 
          mapGuid(toString(patient."VISIT".PV1."PV1-03"))
        )
    else null)]

    // map location
++  [(if (!isEmpty(patient."VISIT".PV1."PV1-06"))
        mapLocation(
          patient."VISIT".PV1."PV1-06",
          mapGuid(toString(patient."VISIT".PV1."PV1-06"))
        )
    else null)]  
/*
 // map encounter subject
++ [(if (!isEmpty(patient."PID"."PID-03"[0]."CX-01"))
      mapEncounterSubject ("Patient/" ++ mapGuid(patient."PID"."PID-03"[0]."CX-01"), mapGuid(toString(patient."VISIT"."PV1")))    
    else null)]
 */
 
 
// If NK1 segment then map RelatedPerson.
++ (
  if(!isEmpty(patient."NK1")) 
    (patient."NK1" map (nk1Item, nk1Index) ->
      (
        if (!isEmpty(patient."PID"."PID-03"[0]."CX-01"))
          mapRelatedPerson(
            patient."PID", 
            nk1Item, 
            mapGuid(toString(nk1Item)), 
            "Patient/" ++ mapGuid(patient."PID"."PID-03"[0]."CX-01")
          )
        else 
          mapRelatedPerson(
            patient."PID", 
            nk1Item, 
            mapGuid(toString(nk1Item))
          )
      )
    )
  else [])
 

// Foreach order - PractitionerRole
++ (
  if (!isEmpty(order))
  flatten(order map (orderItem, orderIndex) -> 
  (
    orderItem.PRT map (prtItem, prtIndex) ->
      mapPractitionerRole(
        prtItem,
        mapGuid(toString(prtItem))
      )
  ))
  else []
)

// Foreach order - PractitionerRole location
++ (
  if (!isEmpty(order))
  flatten(order map (orderItem, orderIndex) -> 
  (
    orderItem.PRT map (prtItem, prtIndex) ->
      (if (!isEmpty(prtItem."PRT-09"))
        mapLocation(
          prtItem."PRT-09",
          mapGuid(toString(prtItem."PRT-09"))
        )
      else null)
  ))
  else []
)


// Foreach mapDiagnosticReport
++ (if (!isEmpty(order))
    flatten (order map (orderItem, orderIndex) -> 
          
     ( if (!isEmpty(orderItem.OBSERVATION))
        // Observation mapping
        //orderItem.OBSERVATION map (obsItem, obsIndex) -> 
          
            // map DiagnosticReport
             (if (!isEmpty(patient."PID"."PID-03"[0]."CX-01"))
              mapDiagnosticReport(
                orderItem.COMMON_ORDER."ORC", 
                orderItem."OBR",
                orderItem."OBSERVATION",
                //obsItem,
                orderItem."SPECIMEN", 
                mapGuid(toString(orderItem."OBR"."OBR-01")),
                "Patient/" ++ mapGuid(patient."PID"."PID-03"[0]."CX-01")
              ) 
            else
              mapDiagnosticReport(
                orderItem.COMMON_ORDER."ORC", 
                orderItem."OBR", 
                orderItem."OBSERVATION",
                //obsItem,
                orderItem."SPECIMEN",
                mapGuid(toString(orderItem."OBR"."OBR-01")),
                ""
              )
            )  // map DiagnosticReport

 	 else []) )  
 else [])
 
 
// Foreach mapObservation 
++ flatten (if (!isEmpty(order))
     (order map (orderItem, orderIndex) -> 
          
     ( if (!isEmpty(orderItem.OBSERVATION))
        // Observation mapping
        orderItem.OBSERVATION map (obsItem, obsIndex) -> 
      //  "aaa": obsItem
          // (obsItem."OBX" map (obxItem, obxIdex) ->
            {
            (
              (if (!isEmpty(patient."PID"."PID-03"[0]."CX-01"))
                  mapObservation(
                    obsItem."OBX", 
                    mapGuid("Observation" ++ toString(obsItem)),
                    null,
                    "Patient/" ++ mapGuid(patient."PID"."PID-03"[0]."CX-01")
                  )
                else
                  mapObservation(
                    obsItem."OBX", 
                    mapGuid("Observation" ++ toString(obsItem."OBX")),
                    null,
                    null
                  )
              )         
             )}
           
           // ) // map Observation (obx)
  
 	 else []) )   
 else []) 
 
// Foreach mapObservation 
++ (if (!isEmpty(order))
    flatten (order map (orderItem, orderIndex) -> 
          
   //  ( if (!isEmpty(order.OBSERVATION))
        (if (!isEmpty(orderItem.SPECIMEN))
        (
          orderItem.SPECIMEN map (specimenItem, specimenIndex) -> 
              {      
              (mapSpecimen(specimenItem."SPM", {}, mapGuid(specimenItem."SPM"."SPM-02"."EIP-01"."EI-01")))//,
             // (mapDiagnosticReportspecimenReference (mapGuid(toString(orderItem."OBR"."OBR-01")), mapGuid(specimenItem."SPM"."SPM-02"."EIP-01"."EI-01")))
              
          }
          )
        else []) ) 
 
 //	 else []) reduce $)   
 else [])  
 
 )
  // End map patient result


