/**
 * Maps the priority object.
 */

%dw 2.0

/**
 * Map the priority with the provided code.
 * @param code is a string with the code to map.
 * @return A Priority object.
 */
fun mapPriority(code) = 
{
    ( if (code == 'S') {
        "code" : "stat",
        "display" : "STAT",
        "system" : "http://hl7.org/fhir/request-priority",
    } else if (code == 'A') {
        "code" : "asap",
        "display" : "ASAP",
        "system" : "http://hl7.org/fhir/request-priority",
    } else if (code == 'R') {
        "code" : "routine",
        "display" : "Routine",
        "system" : "http://hl7.org/fhir/request-priority",
    } else if (code == 'P') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'C') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'T') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'TS<integer>') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'TM<integer>') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'TH<integer>') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'TD<integer>') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'TW<integer>') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'TL<integer>') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'PRN') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else {
        "code" : "",
        "display" : "",
        "system" : "",
    }
)}

