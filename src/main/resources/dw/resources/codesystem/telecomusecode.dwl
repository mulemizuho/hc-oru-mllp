/**
 * Maps the telecom use code object.
 */

%dw 2.0

/**
 * Maps the telecom use code with the provided code.
 * @param code is a string with the code to map.
 * @return A TelecomUseCode object.
 */
fun mapTelecomUseCode(code:String) =
(if (!isEmpty(code))
{
    ( if (code == 'PRN')
    {
        "code" : "home",
        "display" : "Home",
        "system" : "http://hl7.org/fhir/contact-point-use"
    } else if (code == 'WPN')
    {
        "code" : "work",
        "display" : "Work",
        "system" : "http://hl7.org/fhir/contact-point-use"
    } else if (code == 'PRS')
    {
        "code" : "mobile",
        "display" : "Mobile",
        "system" : "http://hl7.org/fhir/contact-point-use"
    } else
    {
        "code" : "temp",
        "display" : "temp",
        "system" : "http://hl7.org/fhir/contact-point-use",
    }
    )
}else null)

