/**
 * Maps the FHIR range object.
 */

%dw 2.0

/**
 * Maps the provided HL7 object to part of the 
 * FHIR range object.
 * @param is an object to map.
 * @return an object with part of the range object 
 * or null if provided obj is null.
 */
fun mapSnRange(obj) = 
(if (!isEmpty(obj))
{
    low: {
        value: obj."SN-02"
    },
    high: {
        value: obj."SN-04"
    }
}
else null)