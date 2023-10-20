/**
 * Produces the FHIR patient object.
 */

%dw 2.0

// Import the identifier library
import mapIdentifier from dw::resources::datatypes::identifier

// Import the Driver License Number library
import mapDriverLicenseNumber from dw::resources::datatypes::driverlicensenumber

// Import the Driver License Number library
import mapExtendedPersonName from dw::resources::datatypes::extendedpersonname

// Import the date/ datetime format conversion library
import hl7ConvertDate, hl7ConvertDateTime from dw::resources::util

// Import the address library
import mapAddress from dw::resources::datatypes::address

// Import the extended telecommunication library
import mapExtendedTelecommunicationNumber from dw::resources::datatypes::extendedtelecommunicationnumber

// Import the gender library
import mapGender from dw::resources::codesystem::gender

// Import the language library
import mapLanguage from dw::resources::codesystem::language

// Import the registry status library
import mapRegistryStatus from dw::resources::codesystem::registrystatus

// Import the yesno library
import mapYesNo from dw::resources::codesystem::yes_no

// Import the contact role library
import mapContactRole from dw::resources::codesystem::contactrole

// Import the marital status library
import mapMaritalStatus from dw::resources::codesystem::maritalstatus

// Import the codeable concept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

// Import the removeEmpty function library
import removeEmpty from dw::resources::util 

/**
 * This function produces the FHIR patient object with
 * the provided PID and NK1 objects.
 * @param pid is the PID object.
 * @param pd1 is the PD1 object.
 * @param nk1 is the NK1 object.
 * @param id is a string with the ID to use.
 * @return A FHIR Patient formatted object.
 */
fun mapPatient(pid, pd1, nk1, id:String) = {

    fullUrl: "urn:uuid:" ++ id,
    resource: {
        resourceType: "Patient",
        id: id,
        identifier: []
        ++ (if (!isEmpty(pid."PID-02"))
        		(if (!isEmpty(mapIdentifier(pid."PID-02")))
            		[ mapIdentifier(pid."PID-02") ]
            	else [])
        	else [])
       	
        ++ (if (!isEmpty(pid."PID-03"))
            pid."PID-03" map (item, index) -> mapIdentifier(item)
        else [])
		++ (if (!isEmpty(pid."PID-04"))
			(if (!isEmpty(mapIdentifier(pid."PID-04")))
            	[ mapIdentifier(pid."PID-04") ]
            else [])
        else [])
        ++
            (if (!isEmpty(pid."PID-19"))
               [{
                    "type": {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                                "code": "SS"
                            }
                        ]
                    },
                    "system": "http://hl7.org/fhir/sid/us-ssn",
                    "value": pid."PID-19"
                }]
                else [])
                 

        ++
       		(if (!isEmpty(pid."PID-20"))  
      			(if (!isEmpty(mapDriverLicenseNumber(pid."PID-20")))      		
	                [mapDriverLicenseNumber(pid."PID-20")]
	        	else [])    
        	else []), 

 		name: [] 
 		++ (if (!isEmpty(pid."PID-05"))
 			pid."PID-05"  map (item, index) -> mapExtendedPersonName(item)	
 		else []) 
       ++ (if (!isEmpty(pid."PID-9"))
 			pid."PID-09"  map (item, index) -> mapExtendedPersonName(item)	
 		else []),
 		
 		
 		(if (!isEmpty(pid."PID-07"))
 		"birthDate": hl7ConvertDate (pid."PID-07"."TS-01")
 		else null),
 		
 		(if (!isEmpty(mapGender(pid."PID-08").code))
 			"gender": mapGender(pid."PID-08").code
 		 else null),
 		 
 		 
 		"address": [] 
           
          ++   (if (!isEmpty(pid."PID-11"))
					(pid."PID-11"  map (item, index) -> mapAddress (item))
			   else [])
           
		   ++  (if (!isEmpty(pid."PID-12")) 
            		["district": pid."PID-12"]
 			   else []),

	  (if ((!isEmpty(pid."PID-13")) or (!isEmpty(pid."PID-14")) or (!isEmpty(pid."PID-40"))) 		   
        "telecom": ([]
       
        ++ (if (!isEmpty(pid."PID-13"))
            [pid."PID-13" map (item, index) -> mapExtendedTelecommunicationNumber(item)]
        else [])
        ++ (if (!isEmpty(pid."PID-14"))
            [pid."PID-14" map (item, index) -> mapExtendedTelecommunicationNumber(item)]
        else [])
        ++ (if (!isEmpty(pid."PID-40"))
            [pid."PID-40" map (item, index) -> mapExtendedTelecommunicationNumber(item)]
        else []) ) reduce $
        
        else null),
        

		(if (!isEmpty(pid."PID-15"."CWE-01"))  
      			(if (!isEmpty(mapLanguage(pid."PID-15"."CWE-01").code))  
        "communication":
        [
            { 
                       		
            "language": 
                mapCodeableConcept(pid."PID-15", true, mapLanguage),               
                                
                (if (!isEmpty(pid."PID-15"))
                    "preferred": true as Boolean 
                else null)
            }
        ] else null)
        else null),
         

 		"maritalStatus": 
       		(if (!isEmpty(pid."PID-16"."CWE-01"))  
      			(if (!isEmpty(mapMaritalStatus(pid."PID-16"."CWE-01").code))      		
	               mapCodeableConcept(pid."PID-16", true, mapMaritalStatus)
	        	else null)    
        	else null), 

         (if (isEmpty(pid."PID-25"))
		"multipleBirthBoolean": mapYesNo (pid."PID-24").code 
		else null),
   
         "multipleBirthInteger":pid."PID-25",
         
         (if (!isEmpty(pid."PID-29"))
		"deceasedDateTime": hl7ConvertDateTime(pid."PID-29")
		else null),
		
        (if (isEmpty(pid."PID-29"))   
       {"deceasedBoolean": mapYesNo(pid."PID-30").code}
       else null),
       
       (if (!isEmpty(pid."PID-33")) 
       "meta":
        { 
             "lastUpdated": hl7ConvertDateTime(pid."PID-33")                    
        }else null) ,
        
        (if (!isEmpty(mapRegistryStatus(pd1."PD1-16"."CWE-01").code)) 
        	"active": (mapRegistryStatus(pd1."PD1-16"."CWE-01").code ) as Boolean
        else null) ,
        
       (if (!isEmpty(nk1)) 
        "contact": nk1 map (nk1Item, nk1Index) ->
        {
        	(if (!isEmpty(nk1Item."NK1-02"))
        	 "name": (nk1Item."NK1-02" map (item, idex) -> (mapExtendedPersonName(item))) reduce $	
            else null),
                   	
        	(if (!isEmpty(nk1Item."NK1-04"))
        	 	"address": (nk1Item."NK1-04" map (item, idex) -> (mapAddress(item))	) reduce $	
            else null),        
            

			(if ((!isEmpty(nk1Item."NK1-05")) or (!isEmpty(nk1Item."NK1-06"))
				or (!isEmpty(nk1Item."NK1-40")) or (!isEmpty(nk1Item."NK1-05")))
			
	            "telecom": []
	       
	        	++ (if (!isEmpty(nk1Item."NK1-05"))
	            	nk1Item."NK1-05" map (item, index) -> mapExtendedTelecommunicationNumber(item)
		        else [])
				++ (if (!isEmpty(nk1Item."NK1-06"))
	            	nk1Item."NK1-06" map (item, index) -> mapExtendedTelecommunicationNumber(item)
		        else [])
		        ++ (if (!isEmpty(nk1Item."NK1-40"))
	            	nk1Item."NK1-40" map (item, index) -> mapExtendedTelecommunicationNumber(item)
		        else [])
		        ++ (if (!isEmpty(nk1Item."NK1-41"))
	            	nk1Item."NK1-41" map (item, index) -> mapExtendedTelecommunicationNumber(item)
		        else [])
	        
	        else null),
	        
            

      		(if (!isEmpty(nk1Item."NK1-07"."CWE-01"))  
      			(if (!isEmpty(mapContactRole(nk1Item."NK1-07"."CWE-01").code))	
	                	relationship: [
	                		mapCodeableConcept(
	                			nk1Item."NK1-07", 
	                			true, 
	                			mapContactRole
	                		)
	                	]
	        	else null)    
        	else null),            
            
            
			(if ((!isEmpty(nk1Item."NK1-08")) or (!isEmpty(nk1Item."NK1-09")))		
				"period":
	                {
	                	(if (!isEmpty(nk1Item."NK1-08"))
	                    	"start": hl7ConvertDateTime(nk1Item."NK1-08")
	                    else null),
	                    (if (!isEmpty(nk1Item."NK1-09"))	                    
	                    	"end": hl7ConvertDateTime(nk1Item."NK1-09")
	                     else null),
	                }                      
             else null),
             (if ((!isEmpty(mapGender(nk1Item."NK1-15"."CWE-01").code)) )
                "gender": mapGender(nk1Item."NK1-15"."CWE-01").code
             else null),
        }else null),

    },
	"request":{
	     "method":"PUT",
	     "url":"Patient/" ++ id,
	 },        
} 