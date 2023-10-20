/**
 * Maps the driver license number object.
 */

%dw 2.0
import hl7ConvertDateTime from dw::resources::util

/**
 * Maps the driver license number object with the provided 
 * PID PID-20 object.
 * @param obj is a PID-20 object.
 * @return A DriverLicenseNumber object.
 */
fun mapDriverLicenseNumber(obj) = 
(if (!isEmpty(obj."PID-20"))
{
	(if (!isEmpty(obj."PID-20")) 
	{
	"value": obj."PID-20",
	"type":

	    "coding":
	    [
	        {	           
	            "code":"DL",
	            "system":"http://terminology.hl7.org/CodeSystem/v2-0203"     
	        }
	    ]
	} else null),
/*	
	(if (!isEmpty(obj."DLN-02")) 
	{
		"system": obj."DLN-02",
	} else null),
	
	
	(if (!isEmpty(obj."DLN-03")) 
	
	{
		"period":
		    "end": obj."DLN-03"
	} else null) 
 */

}
else null)