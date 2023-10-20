/**
 * Maps the FHIR Location object.
 */

%dw 2.0

// Import the physicaltype library
import mapPhysicalType from dw::resources::datatypes::physicaltype

// Import the address library
import mapAddress from dw::resources::datatypes::address

// Import the contactpoint library.
import mapContactPoint from dw::resources::datatypes::contactpoint

/**
 * Maps the FHIR Location object with the provided PV1-03 object.
 * @param data is a PV1-03 object.
 * @param id is a string with the ID.
 * @return A FHIR Location object or null if no object provided.
 */
fun mapLocation(data, id:String) = mapLocation(data, id, null, null)

/**
 * Maps the FHIR Location object with the provided PV1-03 object.
 * @param data is a PV1-03 object.
 * @param id is a string with the ID.
 * @param orc is an optional argument with the ORC segment object.
 * @param rxa is an optional argument with the RXA segment object.
 * @return A FHIR Location object or null if no object provided.
 */
fun mapLocation(data, id:String, orc, rxa) = 
(if (!isEmpty(data))
    {
        fullUrl: "urn:uuid:" ++ id,
        resource: {
            // Resource type
            resourceType: "Location",

            // ID
            id: id,

            // Mode
            (if (!isEmpty(data."PL-01"))
                mode: "instance"
            else null),

            // Physical Type
            physicalType: mapPhysicalType(data."PL-01"),

            // ORC Name
            (if (!isEmpty(orc."ORC-21"."XON-01"))
                name: orc."ORC-21"."XON-01"
            else null),

            // ORC Identifier
            (if (!isEmpty(orc."ORC-21"."XON-01"))
                identifier: mapLocationIdentifier(orc."ORC-21")
            else null),

            // Address ORC
            (if (!isEmpty(orc."ORC-22"))
                address: mapAddress(orc."ORC-22")
            else null),

            // Address RXA
            (if (!isEmpty(rxa."RXA-28"))
                address: mapAddress(rxa."RXA-28")
            else null),

            // Telecom
            (if (!isEmpty(orc."ORC-23"))
                telecom: [
                    mapContactPoint(orc."ORC-23")
                ]
            else null),

            // Mode
            (if (!isEmpty(rxa."RXA-27"."PL-01"))
                mode: "instance"
            else null),

            // Physical Type RXA
            physicalType: mapPhysicalType(rxa."RXA-27"."PL-01")
        },
        request: {
            method: "PUT",
            url: "Location/" ++ id
        }
    }
else null)

/**
 * Maps the location identifier and returns an array if object 
 * is provided and null if not.
 * @param data is an ORC-21 object.
 * @return An array with the identifier result or null if no object is provided.
 */
fun mapLocationIdentifier(data) = 
(if (!isEmpty(data))
[
    {
        value: data."XON-03",
        value: data."XON-10",
        (if (!isEmpty(data."XON-07"))
        "type": {
            coding: [
                {
                    code: data."XON-07",
                    system: "http://terminology.hl7.org/CodeSystem/v2-0203"
                }
            ]
        }
        else null)
    }
]
else null)