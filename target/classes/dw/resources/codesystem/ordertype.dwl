/**
 * Maps the order type object.
 */

%dw 2.0

/**
 * Maps the order type with the provided code.
 * @param code is a string with the code to map.
 * @return An OrderType object.
 */
fun mapOrderType(code) = {
    ( if (code == 'I') {
        "code" : "HOSP",
        "display" : "Hospital",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'O') {
        "code" : "OF",
        "display" : "Outpatient facility",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else {
        "code" : "",
        "display" : "",
        "system" : "",
    }
)}