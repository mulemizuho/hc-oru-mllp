/**
 * Maps the gender object.
 */

%dw 2.0

/**
 * Maps the gender with the provided code.
 * @param code is a string with the code to map.
 * @return A Gender object.
 */
fun mapGender(code) = 
{
    ( if (code ==  'F')
    {
        "code" : "female",
        "display" : "Female",
        "system" : "http://hl7.org/fhir/administrative-gender",
    } else if (code ==  'M')
    {
        "code" : "male",
        "display" : "Male",
        "system" : "http://hl7.org/fhir/administrative-gender",
    } else if (code ==  'O')
    {
        "code" : "other",
        "display" : "Other",
        "system" : "http://hl7.org/fhir/administrative-gender",
    } else if (code ==  'U')
    {
        "code" : "unknown",
        "display" : "Unknown",
        "system" : "http://hl7.org/fhir/administrative-gender",
    } else if (code ==  'A')
    {
        "code" : "other",
        "display" : "Other",
        "system" : "http://hl7.org/fhir/administrative-gender",
    } else if (code ==  'N')
    {
        "code" : "other",
        "display" : "Other",
        "system" : "http://hl7.org/fhir/administrative-gender",
    } else
    {
        "code" : "",
        "display" : "",
        "system" : "",
     }
    )
}
