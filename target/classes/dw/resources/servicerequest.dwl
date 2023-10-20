/**
 * Produces the FHIR service request object.
 */

%dw 2.0

// Import the EI identifier library
import mapEIIdentifier from dw::resources::datatypes::eiidentifier

// Import the order status library
import mapOrderStatus from dw::resources::codesystem::orderstatus

// Import the order type library
import mapOrderType from dw::resources::codesystem::ordertype

// Import the priority library
import mapPriority from dw::resources::codesystem::priority


// Import the date/ datetime format conversion library
import hl7ConvertDate, hl7ConvertDateTime, mapGuid, toString from dw::resources::util

// Import the codeable concept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

// Import the CQ library
import mapCQ from dw::resources::datatypes::cq

/**
 * This function produces the FHIR service request object with
 * the provided ORC segment.
 * @param orc is the ORC segment.
 * @param id is a string with the ID to use.
 * @return A FHIR ServiceRequest formatted object.
 */
fun mapServiceRequest(orc, id:String) =
	mapServiceRequest(orc, {}, {}, [], [], id, "")

/**
 * This function produces the FHIR service request object with
 * the provided ORC segment, id string and subject string.
 * @param orc is the ORC segment.
 * @param id is a string with the ID to use.
 * @param subject is a reference string with the subject.
 * @return A FHIR ServiceRequest formatted object.
 */
fun mapServiceRequest(orc, id:String, subject:String) = 
	mapServiceRequest(orc, {}, {}, [], [], id, subject)

/**
 * This function produces the FHIR service request object with
 * the provided ORC segment and optional TQ1 segment.
 * @param orc is the ORC segment.
 * @param obr is an optional OBR segment.
 * @param tq1 is an optional TQ1 segment.
 * @param obxList is an optional OBX object Array.
 * @param dg1List is an optional DG1 object Array.
 * @param id is a string with the ID to use.
 * @param subject is a reference string with the subject.
 * @return A FHIR ServiceRequest formatted object.
 */
fun mapServiceRequest(orc, obr, tq1, obxList, dg1List, id:String, subject:String) = {
    fullUrl: "urn:uuid:" ++ id,
    resource: {
        resourceType: "ServiceRequest",
        id: id,

		// Intent
        (
	        if (obr."OBR-11" == "G")
	        	intent: "reflex-order"
	        else
	        	intent: "order"        	
        ),

		// Identifier
        identifier: mapServiceRequestIdentifier(orc, obr),
		
        
        // Status  
        (if (!isEmpty(orc."ORC-05"))  
      		(if (!isEmpty(mapOrderStatus(orc."ORC-05").code))      		
	    		status: mapOrderStatus(orc."ORC-05").code
	    	else status: "unknown")    
        else status: "unknown"), 

		// Authored on
        (if (!isEmpty(orc."ORC-01"))
         	authoredOn: hl7ConvertDateTime(orc."ORC-09")
        else null),
 
        occurrenceDateTime: hl7ConvertDateTime(orc."ORC-15"),
        occurrenceDateTime: hl7ConvertDateTime(orc."ORC-06"), 

        (if (!isEmpty(mapCodeableConcept(orc."ORC-29", true, mapOrderType)))       
        locationCode:
        [        	
        	mapCodeableConcept(orc."ORC-29", true, mapOrderType)
        ]else null),
		
		 (if (!isEmpty(mapCQ(tq1."TQ1-02")))
       		quantityQuantity: mapCQ(tq1."TQ1-02")
         else null),
         
        (if ((!isEmpty(tq1."TQ1-02")) or (!isEmpty(tq1."TQ1-06")) or (!isEmpty(tq1."TQ1-07")) or (!isEmpty(tq1."TQ1-08"))
        	or (!isEmpty(tq1."TQ1-13")) or (!isEmpty(tq1."TQ1-14")))
        occurrenceTiming:
        {
            repeat:
            {
                (if (!isEmpty(mapCQ(tq1."TQ1-02")))
       				boundsDuration: mapCQ(tq1."TQ1-06")
         		else null),

 				(if (!isEmpty(tq1."TQ1-07") or (!isEmpty(tq1."TQ1-08")))
                boundsPeriod:
                {
                    start: hl7ConvertDateTime(tq1."TQ1-07"),
                    end: hl7ConvertDateTime(tq1."TQ1-08"),
                } else null),
				
				(if (!isEmpty(mapCQ(tq1."TQ1-14")))
                	count:tq1."TQ1-14"
                 else null),
            } ++ 
            	// Validation rule, if duration is specified then unit must also be specified.
                (if (!isEmpty(tq1."TQ1-13"."CQ-01") and !isEmpty(tq1."TQ1-13"."CQ-02"."CWE-02"))
                {
				    duration: tq1."TQ1-13"."CQ-01",
				    durationUnit: tq1."TQ1-13"."CQ-02"."CWE-02"
				}
				 else {})
            ,
        } 
 		else null),
        
        (if (!isEmpty(tq1."TQ1-09"))
              priority: tq1."TQ1-09"
         else if (!isEmpty(obr."OBR-05"))
              priority: mapPriority (obr."OBR-05")    
         else null),
       
        // Code
        (if (!isEmpty(mapCodeableConcept(obr."OBR-04")))  
        "code":
        {
            (mapCodeableConcept(obr."OBR-04")),
        }      
		else null),
		
		// Reason code
        (if (!isEmpty(mapCodeableConcept(obr."OBR-31")))
        "reasonCode":
        [
            (mapCodeableConcept(obr."OBR-31"[0]))
        ]
        else null),
        
        // Subject
        (if (!isEmpty(subject))
        subject: {
			reference: subject
		}
        else null),
        
        // Supporting info
        (if (!isEmpty(obxList) and sizeOf(obxList) > 0)
        supportingInfo: obxList map (obxItem, obxIndex) -> 
        	{
        		reference: "Observation/" ++ mapGuid("Observation" ++ toString(obxItem))
        	}
        else null),
        
        (if (!isEmpty(dg1List))
        	reasonReference:
        	dg1List map (dgItem, dgIndex) ->
			{
				reference: "Condition/" ++ mapGuid(toString(dgItem))
			}
        else null)
           
        }, //resource
    request:{
        method: "PUT",
        url: "ServiceRequest/" ++ id,
    },
}

/**
 * This function produces the FHIR service request supporting info object with
 * the provided ref and ID strings.
 * @param ref is a string with the reference.
 * @param id is a string with the ID to use.
 * @return A FHIR service request supporting info formatted patient object.
 */
fun mapServiceRequestSupportingInfo (ref:String, id:String) = {
	resource: {
		resourceType: "ServiceRequest",
		id: id,
		supportingInfo: [ 
			{
				reference: ref
			}
		]
	}
}

/**
 * This function produces the FHIR service request reason reference object with
 * the provided ref and ID strings.
 * @param ref is a string with the reference.
 * @param id is a string with the ID to use.
 * @return A FHIR service request reason request formatted object.
 */
fun mapServiceRequestReasonReference (ref:String, id:String) = {
	resource: {
		resourceType: "ServiceRequest",
		id: id,
		reasonReference: [ 
			{
				reference: ref
			}
		]
	}
}

/**
 * This function produces the FHIR service request specimen object with
 * the provided ref and ID strings.
 * @param ref is a string with the reference.
 * @param id is a string with the ID to use.
 * @return A FHIR service request specimen formatted object.
 */
fun mapServiceRequestSpecimen (ref:String, id:String) = {
	resource: {
		resourceType: "ServiceRequest",
		id: id,
		specimen: [ 
			{
				reference: ref
			}
		]
	}
}

/**
 * Maps the service request identifier with the 
 * provided orc and obr segments.
 * @param orc is the ORC segment.
 * @param obr is an optional OBR segment.
 * @return An Array with the service request identifier.
 */
fun mapServiceRequestIdentifier(orc, obr) = 
[] 
++ (if (!isEmpty(obr))
[{
    (if (!isEmpty(obr."OBR-02"))
    "value": obr."OBR-02"."EI-01"
    else null),
    "type":
    {
        "coding":
        [
            {
                code: "PLAC",
                system: "http://terminology.hl7.org/CodeSystem/v2-0203"
            }                	
        ]
    }
}]
else []) // if obr not empty

++ [(if (!isEmpty(obr."OBR-03"))

    {
    (mapEIIdentifier(orc."ORC-03")),
        
    "type":
    {
        "coding":
        [
            { 
                "code": "FILL",
                "system":"http://terminology.hl7.org/CodeSystem/v2-0203"
                    
            }  
        ]
    }
    
    }
    else null)]

++ [(if (!isEmpty(obr."ORC-04"))

    {
    (mapEIIdentifier(orc."ORC-04")),                 
    "type":
    {
        "coding":
        [
            { 
                "code": "PGN",
                "system":"http://terminology.hl7.org/CodeSystem/v2-0203"      
            }  
        ]
    }
    }
    else null)]
++ [
    (if (!isEmpty(obr."OBR-02"))
        mapEIIdentifier(orc."OBR-02")
    else null)
]
++ [
    mapEIIdentifier(orc."OBR-03"),
    mapEIIdentifier(orc."OBR-53")
]