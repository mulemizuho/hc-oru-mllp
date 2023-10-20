/**
 * Maps the marital status object.
 */

%dw 2.0

/**
 * Maps the marital status with the provided code.
 * @param code is a string with the status.
 * @return A MaritalStatus object.
 */
fun mapMaritalStatus(code:String) = 
{
    ( if (code ==  'A')
    {
        "code" : "L",
        "display" : "Legally Separated",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'D')
    {
        "code" : "D",
        "display" : "Divorced",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'M')
    {
        "code" : "M",
        "display" : "Married",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'S')
    {
        "code" : "S",
        "display" : "Never Married",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'W')
    {
        "code" : "W",
        "display" : "Widowed",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'C')
    {
        "code" : "C",
        "display" : "Common Law",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'G')
    {
        "code" : "T",
        "display" : "Domestic partner",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'P')
    {
        "code" : "T",
        "display" : "Domestic partner",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'R')
    {
        "code" : "T",
        "display" : "Domestic partner",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'E')
    {
        "code" : "L",
        "display" : "Legally Separated",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'N')
    {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code ==  'I')
    {
        "code" : "I",
        "display" : "Interlocutory",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'B')
    {
        "code" : "U",
        "display" : "unmarried",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else if (code ==  'U')
    {
        "code" : "UNK",
        "display" : "unknown",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-NullFlavor",
    } else if (code ==  'O')
    {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code ==  'T')
    {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code ==  '')
    {
        "code" : "P",
        "display" : "Polygamous",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
    } else
    {
        "code" : "",
        "display" : "",
        "system" : "",
    }
    
    )
}
