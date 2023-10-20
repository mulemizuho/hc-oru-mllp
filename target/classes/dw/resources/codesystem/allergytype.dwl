/**
 * Maps the allergy type.
 */

%dw 2.0

/**
 * Maps the allergy type with the provided code.
 * @param code is a string with the allergy type code.
 * @return An AllergyType object.
 */
fun mapAllergyType(code) = {
    ( if (code == 'DA') {
        "code" : "allergy",
        "display" : "Allergy",
        "system" : "http://hl7.org/fhir/allergy-intolerance-type",
    } else if (code == 'FA') {
        "code" : "allergy",
        "display" : "Allergy",
        "system" : "http://hl7.org/fhir/allergy-intolerance-type",
    } else if (code == 'MA') {
        "code" : "allergy",
        "display" : "Allergy",
        "system" : "http://hl7.org/fhir/allergy-intolerance-type",
    } else if (code == 'MC') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'EA') {
        "code" : "allergy",
        "display" : "Allergy",
        "system" : "http://hl7.org/fhir/allergy-intolerance-type",
    } else if (code == 'AA') {
        "code" : "allergy",
        "display" : "Allergy",
        "system" : "http://hl7.org/fhir/allergy-intolerance-type",
    } else if (code == 'PA') {
        "code" : "allergy",
        "display" : "Allergy",
        "system" : "http://hl7.org/fhir/allergy-intolerance-type",
    } else if (code == 'LA') {
        "code" : "allergy",
        "display" : "Allergy",
        "system" : "http://hl7.org/fhir/allergy-intolerance-type",
    } else {
        "code" : "",
        "display" : "",
        "system" : "",
    }
)}