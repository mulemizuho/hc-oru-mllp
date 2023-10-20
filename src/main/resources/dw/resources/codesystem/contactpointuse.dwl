/**
 * Maps the FHIR ContactPointUse object.
 */

%dw 2.0

/**
 * Maps the provided code value to the proper FHIR ContactPointUse object.
 * @param code is a string with the code to map.
 * @return A ContactPointUse obect or null if no field is supplied.
 */
fun mapContactPointUse(code) = 
(if (!isEmpty(code))
(
    if (code == "PRN")
    {
        code: "home",
        display: "Home",
        system: "http://hl7.org/fhir/contact-point-use"
    } else if (code == "ORN")
    {
        code: "",
        display: "",
        system: ""
    } else if (code == "WPN")
    {
        code: "work",
        display: "Work",
        system: "http://hl7.org/fhir/contact-point-use"
    } else if (code == "VHN")
    {
        code: "",
        display: "",
        system: ""
    } else if (code == "ASN")
    {
        code: "",
        display: "",
        system: ""
    } else if (code == "EMR")
    {
        code: "",
        display: "",
        system: ""
    } else if (code == "NET")
    {
        code: "",
        display: "",
        system: ""
    } else if (code == "BPN")
    {
        code: "",
        display: "",
        system: ""
    } else if (code == "PRS")
    {
        code: "mobile",
        display: "Mobile",
        system: "http://hl7.org/fhir/contact-point-use"
    }
    else null
)
else null)