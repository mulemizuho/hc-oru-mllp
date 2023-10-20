/**
 * Maps the role object.
 */

%dw 2.0

/**
 * Maps the role with the provided code.
 * @param code is a string with the code to map.
 * @return A Role object.
 */
fun mapRole(code) = 
{
    ( if (code == 'AD') {
        "code" : "ADM",
        "display" : "admitter",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
    } else if (code == 'AP') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'AT') {
        "code" : "ATND",
        "display" : "attender",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
    } else if (code == 'CLP') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'CP') {
        "code" : "CON",
        "display" : "consultant",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
    } else if (code == 'DP') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'EP') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'FHCP') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'IP') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'MDIR') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'OP') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'PH') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'PP') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'RO') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'RP') {
        "code" : "REF",
        "display" : "referrer",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
    } else if (code == 'RT') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'TR') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'PI') {
        "code" : "translator",
        "display" : "Translator",
        "system" : "http://terminology.hl7.org/CodeSystem/participant-type",
    } else if (code == 'AI') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'TN') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'VP') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'VPS') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'VTS') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else {
        "code" : "",
        "display" : "",
        "system" : "",
    }
)}
