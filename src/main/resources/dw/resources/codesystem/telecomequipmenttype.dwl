/**
 * Maps the Telecom Equipment Type object.
 */

%dw 2.0

/**
 * Maps the provided XAD-07 field to the proper Telecom Equipment Type object.
 * @param code is a XTN-03 field to map.
 * @return An telecom equipment type object or null if not found.
 */
fun mapTelecomEquipmentType(code) = 
{
    ( if (code == 'PH')
    {
        "code" : "phone",
        "display" : "Phone",
        "system" : "http://hl7.org/fhir/contact-point-system",
    } else if (code == 'FX')
    {
        "code" : "fax",
        "display" : "Fax",
        "system" : "http://hl7.org/fhir/contact-point-system",
    } else if (code == 'MD')
    {
        "code" : "other",
        "display" : "Other",
        "system" : "http://hl7.org/fhir/contact-point-system",
    } else if (code == 'CP')
    {
        "code" : "mobile",
        "display" : "Mobile",
        "system" : "http://hl7.org/fhir/contact-point-use",
    } else if (code == 'SAT')
    {
        "code" : "other",
        "display" : "Other",
        "system" : "http://hl7.org/fhir/contact-point-system",
    } else if (code == 'BP')
    {
        "code" : "pager",
        "display" : "Page",
        "system" : "http://hl7.org/fhir/contact-point-system",
    } else if (code == 'Internet')
    {
        "code" : "email",
        "display" : "Email",
        "system" : "http://hl7.org/fhir/contact-point-system",
    } else if (code == 'X.400')
    {
        "code" : "email",
        "display" : "Email",
        "system" : "http://hl7.org/fhir/contact-point-system",
    } else if (code == 'TDD')
    {
        "code" : "other",
        "display" : "Other",
        "system" : "http://hl7.org/fhir/contact-point-system",
    } else if (code == 'TTY')
    {
        "code" : "other",
        "display" : "Other",
        "system" : "http://hl7.org/fhir/contact-point-system",
    }  else 
    {
        "code" : code,
        "display" : code,
        "system" : "urn:undefined"
        
        }
    )
}