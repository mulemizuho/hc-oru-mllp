/**
 * Maps the FHIR ratio object.
 */

%dw 2.0

/**
 * Maps the provided HL7 object to part of the 
 * FHIR ratio object.
 * @param is an object to map.
 * @return an object with part of the ratio object 
 * or null if the provided obj is null.
 */
fun mapSnRatio(obj) = 
(if (!isEmpty(obj))
{
    numerator: {
        value: obj."OBX-02"
    },
    denominator: {
        value: obj."OBX-04"
    }
}
else null)