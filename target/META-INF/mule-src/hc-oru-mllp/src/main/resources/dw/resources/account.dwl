/**
 * Maps the account object.
 */

%dw 2.0

// Import the identifier library
import mapIdentifier from dw::resources::datatypes::identifier

/**
 * This function maps the account object with 
 * the provided PID object and ID string.
 * @param data is the PID object.
 * @param id is a string with the ID to use.
 * @return A FHIR Account formatted object or null if no object provided.
 */
fun mapAccount(data, id:String) = 
(if (!isEmpty(data))
    {
        fullUrl: "urn:uuid:" ++ id,
        resource: {
            // Resource type
            resourceType: "Account",

            // ID
            id: id,

            // Identifier
            identifier:
            (if (!isEmpty(data."PID-18"))
                [
                    mapIdentifier(data."PID-18")
                ]
            else null),

            // Status
            status: "unknown",

            // Subject - TODO: Implement this?
        },
        request: {
            method: "PUT",
            url: "Account/" ++ id
        }
    }
else null)