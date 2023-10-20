/**
 * Maps order status object.
 */

%dw 2.0

/**
 * Maps order status with the provided code.
 * @param code is a string with the code to map.
 * @return An OrderStatus object.
 */
fun mapOrderStatus(code) = {
    ( if (code == 'CA') {
        "code" : "revoked",
        "display" : "Revoked",
        "system" : "http://hl7.org/fhir/request-status",
    } else if (code == 'CM') {
        "code" : "completed",
        "display" : "Completed",
        "system" : "http://hl7.org/fhir/request-status",
    } else if (code == 'DC') {
        "code" : "revoked",
        "display" : "Revoked",
        "system" : "http://hl7.org/fhir/request-status",
    } else if (code == 'ER') {
        "code" : "entered-in-error",
        "display" : "Entered in Error",
        "system" : "http://hl7.org/fhir/request-status",
    } else if (code == 'HD') {
        "code" : "on-hold",
        "display" : "On Hold",
        "system" : "http://hl7.org/fhir/request-status",
    } else if (code == 'IP') {
        "code" : "active",
        "display" : "Active",
        "system" : "http://hl7.org/fhir/request-status",
    } else if (code == 'RP') {
        "code" : "revoked",
        "display" : "Revoked",
        "system" : "http://hl7.org/fhir/request-status",
    } else if (code == 'SC') {
        "code" : "active",
        "display" : "Active",
        "system" : "http://hl7.org/fhir/request-status",
    } else {
        "code" : "",
        "display" : "",
        "system" : "",
    }
)}