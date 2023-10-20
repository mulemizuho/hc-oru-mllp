/**
 * Maps the FHIR quantity object.
 */

%dw 2.0

/**
 * Maps the provided HL7 object to part of the 
 * FHIR quantity object.
 * @param is an object to map.
 * @return an object with part of the quantity object.
 */
fun mapCweQuantity(obj) = {
    (if (!isEmpty(obj."CWE-01"))
        code: obj."CWE-01"
    else null),
    (if (!isEmpty(obj."CWE-02"))
        unit: obj."CWE-01"
    else null),
    unit: obj."CWE-02",
    (if (!isEmpty(obj."CWE-01"))
        system: obj."CWE-03"
    else null)
}