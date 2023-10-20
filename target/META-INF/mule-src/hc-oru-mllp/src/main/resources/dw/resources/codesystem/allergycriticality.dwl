/**
 * Maps the allergy criticality.
 */

%dw 2.0

/**
 * Maps the provided code to the allergy criticality.
 * @param code is a string with the criticality code.
 * @return An AllergyCriticality object.
 */
fun mapAllergyCriticality(code) = {
	( if (code == 'MI')
    {
        "code" : "low",
        "display" : "Low",
        "system" : "",
    } else if (code == 'MO')
    {
        "code" : "low",
        "display" : "Low",
        "system" : "",
    } else if (code == 'SV')
    {
        "code" : "high",
        "display" : "High",
        "system" : "",
    } else if (code == 'U')
    {
        "code" : "",
        "display" : "",
        "system" : "",
    } else
        {
        "code" : "",
        "display" : "",
        "system" : "",
    }
    )
	
}