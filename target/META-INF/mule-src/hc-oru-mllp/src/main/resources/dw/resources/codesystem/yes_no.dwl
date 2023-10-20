/**
 * Maps yes/no object.
 */

%dw 2.0

/**
 * Maps yesno with the provided code.
 * @param code is a string with the code to map.
 * @return A YesNo object.
 */
fun mapYesNo(code) = {
    ( if (code == 'Y')
    {
        "code" : true,
        "display" : "",
        "system" : ""
    } else if (code ==  'N')
    {
        "code" : false,
        "display" : "",
        "system" : ""
    } else if (code ==  'Y')
    {
        "code" : true,
        "display" : "",
        "system" : ""
    } else if (code ==  'N')
    {
        "code" : false,
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