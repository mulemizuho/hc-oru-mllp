/**
 * Maps the allergy severity.
 */

%dw 2.0

/**
 * Maps the provided code to the allergy severity.
 * @param code is a string with the severity code.
 * @return An AllergySeverity object.
 */
fun mapAllergySeverity(code) = {
	( if (code == 'MI')
    {
        "code" : "mild",
        "display" : "Mild",
        "system" : "",
    } else if (code == 'MO')
    {
        "code" : "moderate",
        "display" : "Moderate",
        "system" : "",
    } else if (code == 'SV')
    {
        "code" : "severe",
        "display" : "Severe",
        "system" : "",
    } else if (code == 'U')
    {
        "code" : "unknown",
        "display" : "Unknown",
        "system" : "",
    } else
        {
        "code" : "warning",
        "display" : "Warning",
        "system" : "",
    }
    )
	
}