/**
 * Maps the name type object.
 */

%dw 2.0

/**
 * Maps the name type with the provided code.
 * @param code is a string with the status.
 * @return A NameType object.
 */
fun mapNameType(code:String) = 
{

    ( if (code == 'A') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'B') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'BAD') {
        "code" : "old",
        "display" : "Old",
        "system" : "http://hl7.org/fhir/name-use",
    } else if (code == 'C') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'D') {
        "code" : "usual",
        "display" : "Usual",
        "system" : "http://hl7.org/fhir/name-use",
    } else if (code == 'F') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'I') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'K') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'L') {
        "code" : "official",
        "display" : "Official",
        "system" : "http://hl7.org/fhir/name-use",
    } else if (code == 'M') {
        "code" : "maiden",
        "display" : "Maiden",
        "system" : "http://hl7.org/fhir/name-use",
    } else if (code == 'MSK') {
        "code" : "anonymous",
        "display" : "Anonymous",
        "system" : "http://hl7.org/fhir/name-use",
    } else if (code == 'N') {
        "code" : "nickname",
        "display" : "Nickname",
        "system" : "http://hl7.org/fhir/name-use",
    } else if (code == 'NAV') {
        "code" : "temp",
        "display" : "temp",
        "system" : "http://hl7.org/fhir/name-use",
    } else if (code == 'NB') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'NOUSE') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'P') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'R') {
        "code" : "official",
        "display" : "Official",
        "system" : "http://hl7.org/fhir/name-use",
    } else if (code == 'REL') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'S') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'T') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'TEMP') {
        "code" : "temp",
        "display" : "Temp",
        "system" : "http://hl7.org/fhir/name-use",
    } else if (code == 'U') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else {
        "code" : "",
        "display" : "",
        "system" : "",
    }
)}

