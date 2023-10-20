/**
 * Maps the specimen available object.
 */

%dw 2.0

/**
 * Maps the role with the provided code.
 * @param code is a string with the code to map.
 * @return A specimen available object.
 */
fun mapSpecimenAvailability (code) = 
{
    ( if (code == 'Y') {
        "code" : "available",
        "display" : "Available",
        "system" : "http://hl7.org/fhir/specimen-status",
    } else if (code == 'N') {
        "code" : "unavailable",
        "display" : "Unavailable",
        "system" : "http://hl7.org/fhir/specimen-status",
    } else if (code == '') {
        "code" : "unsatisfactory",
        "display" : "Unsatisfactory",
        "system" : "http://hl7.org/fhir/specimen-status",
    } else if (code == '') {
        "code" : "entered-in-error",
        "display" : "Entered in Error",
        "system" : "http://hl7.org/fhir/specimen-status",
    } else {
        "code" : "",
        "display" : "",
        "system" : "",
    }
)}
