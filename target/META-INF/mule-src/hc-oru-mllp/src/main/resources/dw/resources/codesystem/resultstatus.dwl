/**
 * Maps the relationship object.
 */

%dw 2.0

/**
 * Maps the result status with the provided code.
 * @param code is a string with the code to map.
 * @return A ResultStatus object.
 */
fun mapResultStatus(code) =
{
    ( if (code == 'O') {
        "code" : "registered",
        "display" : "Registered",
        "system" : "http://hl7.org/fhir/diagnostic-report-status",
    } else if (code == 'I') {
        "code" : "registered",
        "display" : "Registered",
        "system" : "http://hl7.org/fhir/diagnostic-report-status",
    } else if (code == 'S') {
        "code" : "registered",
        "display" : "Registered",
        "system" : "http://hl7.org/fhir/diagnostic-report-status",
    } else if (code == 'A') {
        "code" : "partial",
        "display" : "Partial",
        "system" : "http://hl7.org/fhir/diagnostic-report-status",
    } else if (code == 'P') {
        "code" : "preliminary",
        "display" : "Preliminary",
        "system" : "http://hl7.org/fhir/diagnostic-report-status",
    } else if (code == 'C') {
        "code" : "corrected",
        "display" : "Corrected",
        "system" : "http://hl7.org/fhir/diagnostic-report-status",
    } else if (code == 'R') {
        "code" : "partial",
        "display" : "Partial",
        "system" : "http://hl7.org/fhir/diagnostic-report-status",
    } else if (code == 'F') {
        "code" : "final",
        "display" : "Final",
        "system" : "http://hl7.org/fhir/diagnostic-report-status",
    } else if (code == 'X') {
        "code" : "cancelled",
        "display" : "Cancelled",
        "system" : "http://hl7.org/fhir/diagnostic-report-status",
    } else if (code == 'Y') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'Z') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else {
        "code" : "",
        "display" : "",
        "system" : "",
    }
)}
