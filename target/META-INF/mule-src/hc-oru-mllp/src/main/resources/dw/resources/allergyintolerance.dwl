/**
 * Produces the FHIR Allergy Intolerance object.
 */

%dw 2.0

// Import the marital status library
import mapAllergyType from dw::resources::codesystem::allergytype

// Import the codeable concept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

// Import the date/ datetime format conversion library
import hl7ConvertDate, hl7ConvertDateTime from dw::resources::util

// Import GUID Function
import mapGuid from dw::resources::util

// Import the Allergy Severity library
import mapAllergySeverity from dw::resources::codesystem::allergyseverity

// Import the Allergy Criticality library
import mapAllergyCriticality from dw::resources::codesystem::allergycriticality


/**
 * This function produces the FHIR Allergy Intolerance object with
 * the provided PID and AL1 objects and ID string.
 * @param pid is a PID object.
 * @param al1 is an AL1 object.
 * @param id is a string with the ID to use.
 * @return A FHIR Allergy formatted object.
 */
fun mapAllergyIntolerance (pid:Object, al1, id:String) = mapAllergyIntolerance(pid, al1, id, null)

/**
 * This function produces the FHIR Allergy Intolerance object with
 * the provided PID and AL1 objects, ID string, and patient reference string.
 * @param pid is a PID object.
 * @param al1 is an AL1 object.
 * @param id is a string with the ID to use.
 * @param patientReference is an optional patient reference to set.
 * @return A FHIR Allergy formatted object.
 */
fun mapAllergyIntolerance (pid:Object, al1, id:String, patientReference) = {
	    "fullUrl": "urn:uuid:" ++ id,
        "resource": {
	        "resourceType": "AllergyIntolerance",
			"clinicalStatus": {
			    "coding": [
			      {
			        "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
			        "code": "active",
			        "display": "Active"
			      }
			    ]
			 },
	        "id": id,
	        (if (!isEmpty(al1."AL1-03"))	        	
	       		(if (!isEmpty(al1."AL1-02"."CWE-01"))  
	      			(if (!isEmpty(mapAllergyType(al1."AL1-02"."CWE-01").code ))  
	      				"type":mapAllergyType(al1."AL1-02"."CWE-01").code    				                 
		        	else null)    
	        	else null)	        	
 			else null),
            
	        (if (!isEmpty(al1."AL1-03"))
	            "code": (mapCodeableConcept(al1."AL1-03"))
	        else null),
	         
       		(if (!isEmpty(al1."AL1-04"."CWE-01"))  
      			(if (!isEmpty(mapAllergyCriticality(al1."AL1-04"."CWE-01").code))      		
	            	"criticality": mapAllergyCriticality(al1."AL1-04"."CWE-01").code
	        	else null)    
        	else null), 
	        	        
	        
	        (if ((!isEmpty(al1."AL1-05")) or (!isEmpty(al1."AL1-04")) or (!isEmpty(al1."AL1-06")))
	        "reaction":
	        [
	            {
	                "manifestation": al1."AL1-05" map (al1Item, al1Index) -> "text": al1Item,
	
	       		(if (!isEmpty(al1."AL1-04"."CWE-01"))  
	      			(if (!isEmpty(mapAllergySeverity(al1."AL1-04"."CWE-01").code))      		
		       			 "severity": mapAllergySeverity(al1."AL1-04"."CWE-01").code
		        	else null)    
	        	else null), 


		        
		        (if ((al1."AL1-04"."CWE-01") == 'U')
		        	"note": [
				    {
				      "text": al1."AL1-04"."CWE-02"
				    }
				  ]
		        else null),
		        
		        "onset": hl7ConvertDateTime(al1."AL1-06"."AL1-06"), 	            

	            }
	        ]
	        else null), 	 

		(
			if (!isEmpty(patientReference))
			patient: {
				reference: patientReference
			}
			else if (!isEmpty(pid."PID-01"))
			"patient": {
				"reference": "Patient/" ++ mapGuid(pid."PID-01") 	
			}
			else null
		), 
	        
   
	},
	"request":{
        "method":"PUT",
        "url":"AllergyIntolerance/" ++ id
    	}
}