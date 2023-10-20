/**
 * Produces the FHIR Specimen object.
 */

%dw 2.0

// Import the date/ datetime format conversion library
import hl7ConvertDate, hl7ConvertDateTime from dw::resources::util

// Import the EI identifier library
import mapEIIdentifier from dw::resources::datatypes::eiidentifier

// Import the extended compositeID library
import mapCX from dw::resources::datatypes::cx

// Import the codeable concept library
import mapCodeableConcept from dw::resources::datatypes::codeableconcept

// Import the specimen available library
import mapSpecimenAvailability from dw::resources::codesystem::specimenavailability

/**
 * This function produces the FHIR Specimen object with
 * the provided order objects.
 * @param spm is the specimen object.
 * @param id is a string with the ID to use.
 * @return A object with the mapped specimen.
 */
fun mapSpecimen(spm,  id) = 
	mapSpecimen(spm, {}, id)

/**
 * This function produces the FHIR Specimen object with
 * the provided order objects.
 * @param spm is the specimen object.
 * @param obr is the OBR object.
 * @param id is a string with the ID to use.
 * @return A object with the mapped specimen.
 */
 
fun mapSpecimen(spm, obr, id) = 
{
    fullUrl: "urn:uuid:" ++ id,
    resource: {
        resourceType: "Specimen",
        id: id,

        "receivedTime":hl7ConvertDateTime (obr."OBR-14"),
        "receivedTime":hl7ConvertDateTime (spm."SPM-18"),
        "receivedTime":hl7ConvertDateTime (obr."OBR-13"),
          
		
		"identifier":[]
		
		++ [(mapEIIdentifier(spm."SPM-02"."EIP-01"))]
  
 		++ (if (!isEmpty(spm."SPM-03"))
 			spm."SPM-03" default[]  map (spmItem, spmIndex) ->
			(if (!isEmpty(mapEIIdentifier(spmItem."EIP-01"))) 
            	 mapEIIdentifier(spmItem."EIP-01")
            else [])    
        else [])

 		++ (if (!isEmpty(spm."SPM-31"))
 			spm."SPM-31" default[]  map (spmItem, spmIndex) ->
			(if (!isEmpty(mapCX(spmItem))) 
            	 mapCX(spmItem)
            else [])    
        else [])		

 		++ (if (!isEmpty(spm."SPM-32")) [{
                
                (mapEIIdentifier(spm."SPM-32")),
                "type":
                {
                    "coding":
                    [
                        {
                        		
                                "system":"http://terminology.hl7.org/CodeSystem/v2-0203",
                        }
                    ]
                }
            }]
            else []),
            
    (if (!isEmpty(spm."SPM-04"))
	      "type": (mapCodeableConcept(spm."SPM-04"))
    else null),     
	
	(if (!isEmpty(spm."SPM-17"))
	"collection":
	{
	    "method":(mapCodeableConcept(spm."SPM-07")),
		(if (!isEmpty(spm."SPM-17"."DR-02"))
		"collectedPeriod":			
			{
				"start":hl7ConvertDateTime (spm."SPM-17"."DR-01"),
				"end":hl7ConvertDateTime (spm."SPM-17"."DR-02")
			}

         else null),
           (if (isEmpty(spm."SPM-17"."DR-02"))
                "collectedDateTime": hl7ConvertDateTime (spm."SPM-17"."DR-01")
            else null)
	}else null),	
	
	"status": mapSpecimenAvailability (spm."SPM-20").code,

	
	
            
    (if (!isEmpty(spm."SPM-24"))
		"condition": spm."SPM-24" default[]  map (spmItem, spmIndex) ->
		(if (!isEmpty(mapCodeableConcept(spmItem))) 
			mapCodeableConcept(spmItem)
		else [])    
    else []),
	
	(if (!isEmpty(spm."SPM-30"))
 			spm."SPM-30" default[]  map (spmItem, spmIndex) ->
			(if (!isEmpty(mapCX(spmItem))) 
            	"accessionIdentifier": mapCX(spmItem)
            else [])    
      else [])	
	},
	"request":{
	     "method":"PUT",
	     "url":"Specimen/" ++ id,
	 },	
}