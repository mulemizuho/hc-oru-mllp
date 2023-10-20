/**
 * Produces the FHIR provenance object.
 */

%dw 2.0
// Import toString Function
import mapGuid, toString, hl7ConvertDateTime from dw::resources::util

// Import the codeableconcept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

// Import the EI identifier library
import mapEIIdentifier from dw::resources::datatypes::eiidentifier



/**
 * This function produces the FHIR provenance object with
 * the provided ORC segment.
 * @param orc is the ORC segment.
 * @param id is a string with the ID to use.
 * @return A FHIR Provenance formatted object.
 */

fun mapProvenance (orc , msh, targetRef:String, whoPatientRef:String, whoDeviceRef:String, whoOrganizationRef:String, id:String) = {
    fullUrl: "urn:uuid:" ++ id,
    resource: 
    {
    	// Resource type
        resourceType: "Provenance",
        
        // ID
        id: id,
        
         "target": [
		  {
		      "reference": targetRef
		  }
		],
		  
        // agent
        "agent":
        [
            {
                "type":
                {
                    "coding":
                    [
                    	{
				        	( if (isEmpty(msh."MSH-22")) // IF MSH-22 NOT Valued, Organization
				            { 
				                "code": "author",
				                "system":"http://terminology.hl7.org/CodeSystem/provenance-participant-type"
				                    
				            }
				            else if ((!isEmpty(msh."MSH-03")) and (!isEmpty(msh."MSH-24")))
				            {
				                code: "sender-application",
				                system: "http://terminology.hl7.org/CodeSystem/provenance-participant-type"
				            } else null)			            	
                    
                    	}	

                    ]
                },
                "who": 
                	(if (isEmpty(msh."MSH-22")) // IF MSH-22 NOT Valued, Organization
				     { 
				           "reference": whoOrganizationRef
				                    
				      }
				      else if ((!isEmpty(msh."MSH-03")) and (!isEmpty(msh."MSH-24")))
				      {
				           	"reference": whoDeviceRef
				      } else 
								
					  {
						  	"reference": whoPatientRef
					  }
					)
				            
				            
                
            } ,
            {
                "type":
                {
                    "coding":
                    [
                        {
                            ( if (!isEmpty(orc."ORC-10"))
                                {	
                                	code: "enterer",
				                    system: "http://terminology.hl7.org/CodeSystem/provenance-participant-type"	
                                }
                            else null)
                        }
                    ]
                }
            },            
            {
                "type":
                {
                    "coding":
                    [
                        {
                            ( if (!isEmpty(orc."ORC-11"))
                                {	
                                	"code":"verifier",
                                	"system":"http://terminology.hl7.org/CodeSystem/provenance-participant-type"	
                                }
                            else null)
                        }
                    ]
                }
            },            
            
            {
                "type":
                {
                    "coding":
                    [
                        {
                            ( if (!isEmpty(orc."ORC-12"))
                                {	
                                	"code":"author",
                                	"system":"http://terminology.hl7.org/CodeSystem/provenance-participant-type"	
                                }
                            else null)
                        }
                    ]
                }
            }            
         ], // agent
         
        //recorded
        (if (!isEmpty(msh."MSH-07"))    
			"recorded":hl7ConvertDateTime(msh."MSH-07") 
		else null),
		
		//recorded
        (if (!isEmpty(orc."ORC-09"))    
			"recorded":hl7ConvertDateTime(orc."ORC-09") 
		else null),
		
		//activity
        "activity":
        {
            "coding":
            [
            	{
				  ( if ((orc."ORC-01" == "OC") or (orc."ORC-01" == "CA"))
				  {
				       "code": "DELETE",
				       "system": "http://terminology.hl7.org/CodeSystem/v3-DataOperation"	
				  } else if (orc."ORC-01" == "SC")
				  { 
				       "code": "UPDATE",
				       "system": "http://terminology.hl7.org/CodeSystem/v3-DataOperation" 
				  }
				  else if (orc."ORC-01" == "NW")
				  {
				       "code": "CREATE",
				       "system": "http://terminology.hl7.org/CodeSystem/v3-DataOperation"
				  } else null)			            	
            	
            	
                 }
            ]
        },
        
        //occurredDateTime
        (if (!isEmpty(orc."ORC-09"))    
			"occurredDateTime":hl7ConvertDateTime(orc."ORC-09") 
		else null),
 
	},//resource
	
	//request
	"request":
	{
		"method":"PUT",
		"url":"Provenance/" ++ id,
	},   
	
	
	
}