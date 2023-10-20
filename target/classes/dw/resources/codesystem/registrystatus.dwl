/**
 * Maps the registry status object.
 */

%dw 2.0

/**
 * Maps the registry status with the provided code.
 * @param code is a string with the code to map.
 * @return A RegistryStatus object.
 */
fun mapRegistryStatus(code)= {
( if (code == 'A')
    {
        "code" : "true",
        "display" : "",
        "system" : ""
    } else if (code ==  'I')
    {
        "code" : "false",
        "display" : "",
        "system" : ""
    } else if (code ==  'L')
    {
        "code" : "false",
        "display" : "",
        "system" : ""
    } else if (code ==  'M')
    {
        "code" : "false",
        "display" : "",
        "system" : ""
    } else if (code ==  'P')
    {
        "code" : "false",
        "display" : "",
        "system" : ""
    } else if (code ==  'O')
    {
        "code" : "",
        "display" : "",
        "system" : ""
    } else if (code ==  'U')
    {
        "code" : "",
        "display" : "",
        "system" : ""
    } else
    {
        "code" : "",
        "display" : "",
        "system" : ""
    }
)
}
