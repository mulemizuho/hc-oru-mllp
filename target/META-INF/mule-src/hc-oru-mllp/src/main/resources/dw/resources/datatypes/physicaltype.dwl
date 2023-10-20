/**
 * Maps the PhysicalType object.
 */

%dw 2.0

/**
 * Maps the PL-01 field to the FHIR PhysicalType object.
 * @param data is the PL-01 field.
 * @return a PhysicalType object or null if no field provided.
 */
fun mapPhysicalType(data) = 
(if (!isEmpty(data))
	{
		coding: [ 
			{
            	system: "http://terminology.hl7.org/CodeSystem/location-physical-type"
            }
        ]
	}
else null)