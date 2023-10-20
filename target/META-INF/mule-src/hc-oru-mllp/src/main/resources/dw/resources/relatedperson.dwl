/**
 * Produces the FHIR related person object.
 */

%dw 2.0

// Import the extended compositeID library
import mapExtendedCompositeID from dw::resources::datatypes::extendedcompositeid

// Import the relationship library
import mapRelationship from dw::resources::codesystem::relationship

// Import the codeable concept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

// Import the date/ datetime format conversion library
import hl7ConvertDate, hl7ConvertDateTime from dw::resources::util

// Import the address library
import mapAddress from dw::resources::datatypes::address

// Import the extended person name library
import mapExtendedPersonName from dw::resources::datatypes::extendedpersonname

// Import the extended telecommunication library
import mapExtendedTelecommunicationNumber from dw::resources::datatypes::extendedtelecommunicationnumber

// Import the gender library
import mapGender from dw::resources::codesystem::gender

// Import the language library
import mapLanguage from dw::resources::codesystem::language

// Import utility Functions
import mapGuid, removeNull, removeEmpty from dw::resources::util


/**
 * This function produces the FHIR related person object with
 * the provided PID and NK1 objects, and id string.
 * @param pid is the PID object.
 * @param nk1 is the NK1 object.
 * @param id is a string with the ID to use.
 * @return A FHIR RelatedPerson formatted object.
 */ 
fun mapRelatedPerson(pid:Object, nk1,  id) = mapRelatedPerson(pid, nk1, id, null)

/**
 * This function produces the FHIR related person object with
 * the provided PID and NK1 objects, id string and patient reference string.
 * @param pid is the PID object.
 * @param nk1 is the NK1 object.
 * @param id is a string with the ID to use.
 * @param patientRef is an optional patient reference.
 * @return A FHIR RelatedPerson formatted object.
 */ 
fun mapRelatedPerson(pid:Object, nk1,  id, patientRef) = {
	fullUrl: "urn:uuid:" ++ id,
    resource: {
        resourceType: "RelatedPerson",
        id: id,
        
     (if (!isEmpty(pid."PID-21"))
     "identifier": []
        ++  pid."PID-21" map (item, index) -> mapExtendedCompositeID(item)
      else null),




     (if (((!isEmpty(nk1."NK1-03"."CWE-01")) or (!isEmpty(nk1."NK1-03"."CWE-07"))))
     "relationship": removeEmpty ([
     
         (if (!isEmpty(nk1."NK1-03"."CWE-01"))  
      			(if (!isEmpty(mapRelationship(nk1."NK1-03"."CWE-01").code)  )      		
	               mapCodeableConcept(nk1."NK1-03", true, mapRelationship)
	        	else null)    
        	else null) ,
     
        
         (if (!isEmpty(nk1."NK1-07"."CWE-01"))  
      			(if (!isEmpty(mapRelationship(nk1."NK1-07"."CWE-01").code))      		
	                mapCodeableConcept(nk1."NK1-07", true, mapRelationship)
	        	else null)    
        	else null)        
      ] )   
      else null), 
     
      
      (if (((!isEmpty(nk1."NK1-08")) or (!isEmpty(nk1."NK1-09"))))
        "period":
        {
        	(if (!isEmpty(nk1."NK1-08"))
            "start":hl7ConvertDateTime(nk1."NK1-08")
            else []),
            (if (!isEmpty(nk1."NK1-09"))
            "end":hl7ConvertDateTime(nk1."NK1-09")
             else []),
        }
        else null),      
       
       
      (if (((!isEmpty(nk1."NK1-04")) or (!isEmpty(nk1."NK1-32"))))
        "address": []
        ++ (nk1."NK1-04" default [] map (item, index) -> mapAddress(item))
        ++ (nk1."NK1-32" default [] map (item, index) -> mapAddress(item))
        else null),     
            

      (if (((!isEmpty(nk1."NK1-05")) or (!isEmpty(nk1."NK1-06")) or (!isEmpty(nk1."NK1-31"))
      	or (!isEmpty(nk1."NK1-40")) or (!isEmpty(nk1."NK1-41"))
      ))
        "telecom": [

         (nk1."NK1-05" default [] map (item, index) -> mapExtendedTelecommunicationNumber(item)) reduce $,  
            
         (nk1."NK1-06" default [] map (item, index) -> mapExtendedTelecommunicationNumber(item)) reduce $,  
         
         (nk1."NK1-31" default [] map (item, index) -> mapExtendedTelecommunicationNumber(item)) reduce $, 
         
         (nk1."NK1-40" default [] map (item, index) -> mapExtendedTelecommunicationNumber(item)) reduce $, 
         
         (nk1."NK1-41" default [] map (item, index) -> mapExtendedTelecommunicationNumber(item)) reduce $, 
                  
        ]      
        else null),
 
 
      (if (((!isEmpty(nk1."NK1-02")) or (!isEmpty(nk1."NK1-30"))))
        "name": []
        ++ (nk1."NK1-02" default [] map (item, index) -> mapExtendedPersonName(item))
        ++ (nk1."NK1-30" default [] map (item, index) -> mapExtendedPersonName(item))
       //++ [mapExtendedPersonName(nk1."NK1-02")]
       // ++ [mapExtendedPersonName(nk1."NK1-30")]
        else null),

 
		(if (!isEmpty(nk1."NK1-15"."CWE-01"))
        "gender":mapGender(nk1."NK1-15"."CWE-01").code
        else null),

       		(if (!isEmpty(nk1."NK1-16"))  
      			(if (!isEmpty(hl7ConvertDate(nk1."NK1-16")))      		
	                "birthDate":hl7ConvertDate(nk1."NK1-16")
	        	else null)    
        	else null), 


        
        (if (!isEmpty(mapCodeableConcept(pid."NK1-15", true, mapLanguage)))
        "communication":
        [
            {        		
            "language": mapCodeableConcept(pid."NK1-15", true, mapLanguage)
               
            }
        ]        
        else null), 	 

		(
			if (!isEmpty(patientRef))
			patient: {
				reference: patientRef
			}
			else if (!isEmpty(pid."PID-01"))
			patient: {
				"reference": "Patient/" ++ mapGuid(pid."PID-01") 	
			}
			else null
		), 
 
     },
                
 	    "request":{
	        "method":"PUT",
	        "url":"RelatedPerson/" ++ id,
	    }
}
