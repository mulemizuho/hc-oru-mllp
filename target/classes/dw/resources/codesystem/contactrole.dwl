/**
 * Maps the contact role.
 */

%dw 2.0

/**
 * Maps the contact role with the provided code.
 * @param code is a string with the code to map.
 * @return A ContactRole object.
 */
fun mapContactRole(code:String) = 
(if (!isEmpty(code))
{
    ( if (code == 'E')
    {
        "code" : "E",
        "display" : "Employer",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code ==  'C')
    {
        "code" : "C",
        "display" : "Emergency Contact",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code ==  'F')
    {
        "code" : "F",
        "display" : "Federal Agency",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code ==  'I')
    {
        "code" : "I",
        "display" : "Insurance Company",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code ==  'N')
    {
        "code" : "N",
        "display" : "Next-of-Kin",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code ==  'S')
    {
        "code" : "S",
        "display" : "State Agency",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code ==  'O')
    {
        "code" : "O",
        "display" : "Other",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code ==  'U')
    {
        "code" : "U",
        "display" : "Unknown",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else 
    {
        "code" : "",
        "display" : "",
        "system" : "",
    }
    
    )
}else null)
