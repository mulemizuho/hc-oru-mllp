/**
 * Produces the FHIR diagnostic report object.
 */

%dw 2.0
// Import toString Function
import mapGuid, toString, hl7ConvertDateTime from dw::resources::util

// Import the codeableconcept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

// Import the eiidentifier library
import mapEIIdentifier from dw::resources::datatypes::eiidentifier

// Import the result status library
import mapResultStatus from dw::resources::codesystem::resultstatus

/**
 * This function produces the FHIR diagnostic report object with
 * the provided ORC segment.
 * @param orc is the ORC segment.
 * @param obr is the OBR segment.
 * @param obsItem is the list of OBS segment.
 * @param specimenList is the list of specimen segment.
 * @param id is a string with the ID to use. 
 * @param subjectRef is a string with the subjectRef to use. 
 * @return A FHIR DiagnosticReport formatted object.
 */

fun mapDiagnosticReport (orc , obr, obsItem, specimenList, id:String, subjectRef:String) = {
    fullUrl: "urn:uuid:" ++ id,
    resource: 
    {
        resourceType: "DiagnosticReport",
        id: id,
        "identifier": ([]
 
        ++[(if ((!isEmpty(obr."ORC-02")) or (!isEmpty(obr."OBR-02")) or (!isEmpty(obr."OBR-03")) )
        		{
        			(mapEIIdentifier(obr."OBR-02")),
        			"type":
				    {
				        "coding":
				        [
				        	( if (!isEmpty(obr."OBR-03"))
				            {
				                code: "FILL",
				                system: "http://terminology.hl7.org/CodeSystem/v2-0203"	
				            } else if (!isEmpty(obr."OBR-02"))
				            { 
				                "code": "PLAC",
				                "system":"http://terminology.hl7.org/CodeSystem/v2-0203"
				                    
				            }
				            else if (!isEmpty(obr."ORC-02"))
				            {
				                code: "PLAC",
				                system: "http://terminology.hl7.org/CodeSystem/v2-0203"
				            } else null)			            	
				                          	
				        ]
				    }
        		}

    		else null)]

		++ [(if (!isEmpty(orc."ORC-03"))
		
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
    		
		++ [(if (!isEmpty(orc."ORC-04"))
		
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
    		

		++ [(if (!isEmpty(obr."OBR-02"))
			    (mapEIIdentifier(obr."OBR-02"))
		   else null)]

		++ [(if (!isEmpty(obr."OBR-03"))
			    (mapEIIdentifier(obr."OBR-03"))
		   else null)]
		   ),

        // Effective date time
        (if (!isEmpty(orc."ORC-09"))
        	effectiveDateTime: hl7ConvertDateTime(orc."ORC-09")
		else null),
		
		// Effective date time
        (if (isEmpty(orc."ORC-08"))
        	effectiveDateTime: hl7ConvertDateTime(orc."ORC-07")
		else null),
 		
		// Code
		(if (!isEmpty(obr."OBR-04"))
	        (if (!isEmpty(mapCodeableConcept(obr."OBR-04")))
	            "code": 
	                mapCodeableConcept(obr."OBR-04")
	            
	        else null)
        else null),
        
        "effectivePeriod":
        {
            (if (!isEmpty(obr."OBR-08"))
                "start": hl7ConvertDateTime(obr."OBR-07")  
            else null),
            	"end": hl7ConvertDateTime(obr."OBR-08")
        },
        
        "issued": hl7ConvertDateTime(obr."OBR-22"),
    	
		// category
		(if (!isEmpty(obr."OBR-24"))
	        (if (!isEmpty(mapCodeableConcept(obr."OBR-24")))
	            "category": 
	                mapCodeableConcept(obr."OBR-24")	            
	        else null)
        else null),    	
        
		(if (!isEmpty(obr."OBR-25"))
	        (if (!isEmpty(mapResultStatus(obr."OBR-25")))
	            "status": mapResultStatus (obr."OBR-25").code	            
	        else null)
        else null),    	
        // Subject ref
        subject:
         (if (!isEmpty(subjectRef))
        {
        	reference: subjectRef
        }
        else null),  
         
        // result
        (if (!isEmpty(obsItem) and sizeOf(obsItem) > 0)
        result: obsItem map (obxItem, obxIndex) -> 
        	{
        		reference: "Observation/" ++ mapGuid("Observation" ++ toString(obxItem))
        	}
        else null),
        
        
        // specimen
        (if (!isEmpty(specimenList))
        "specimen":	
        (
          specimenList map (specimenItem, specimenIndex) -> 
              {      
              "reference": "Specimen/" ++ mapGuid(specimenItem."SPM"."SPM-02"."EIP-01"."EI-01")
 	              
	          }
          )
        else [])          
         		
	}, //resource
        
	"request":{
			        "method":"PUT",
			        "url":"DiagnosticReport/" ++ id,
	    	},        
        
        	
	
}


/**
 * This function produces the FHIR diagnostic report reason reference object with
 * the provided ref and ID strings.
 * @param ref is a string with the reference.
 * @param id is a string with the ID to use.
 * @return A FHIR service request reason request formatted object.
 */
fun mapDiagnosticReportResultReference (obs, id:String) = {
	resource: {
		resourceType: "DiagnosticReport",
		id: id,
		result: 
			(obs map (obsItem, obsIdex) -> 
			
				{
					reference: mapGuid("Observation" ++ toString(obs))
				}
			)
		 
	}
}

/**
 * This function produces the FHIR diagnostic report reason reference object with
 * the provided ref and ID strings.
 * @param ref is a string with the reference.
 * @param id is a string with the ID to use.
 * @return A FHIR service request reason request formatted object.
 */
fun mapDiagnosticReportspecimenReference (ref, id:String) = {
	resource: {
		resourceType: "DiagnosticReport",
		id: id,
		specimen: 
			
				{
					reference: ref
				}
			
		 
	}
}