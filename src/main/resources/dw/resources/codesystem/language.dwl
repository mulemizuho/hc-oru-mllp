/**
 * Maps the Language object.
 */

%dw 2.0

/**
 * Maps the provided code to a Language object.
 * @param code is a string with the code to map.
 * @return A Language object.
 */
fun mapLanguage(code) = 
{
    (if (code ==  'ar')
    {
        "code" : "ar",
        "display" : "Arabic",
        "system" : "urn:ietf:bcp:47"
    } else if (code ==  'bn')
    {
        "code" : "bn",
        "display" : "Bengali",
        "system" : ""
    } else if (code ==  'cs')
    {
        "code" : "cs",
        "display" : "Czech",
        "system" : ""
    } else if (code ==  'da')
    {
        "code" : "da",
        "display" : "Danish",
        "system" : ""
    } else if (code ==  'de')
    {
        "code" : "de",
        "display" : "German",
        "system" : ""
    } else if (code ==  'de-AT')
    {
        "code" : "de-AT",
        "display" : "German (Austria)",
        "system" : ""
    } else if (code ==  'de-CH')
    {
        "code" : "de-CH",
        "display" : "German (Switzerland)",
        "system" : ""
    } else if (code ==  'de-DE')
    {
        "code" : "de-DE",
        "display" : "German (Germany)",
        "system" : ""
    } else if (code ==  'el')
    {
        "code" : "el",
        "display" : "Greek",
        "system" : ""
    } else if (code ==  'en')
    {
        "code" : "en",
        "display" : "English",
        "system" : ""
    } else if (code ==  'en-AU')
    {
        "code" : "en-AU",
        "display" : "English (Australia)",
        "system" : ""
    } else if (code ==  'en-CA')
    {
        "code" : "en-CA",
        "display" : "English (Canada)",
        "system" : ""
    } else if (code ==  'en-GB')
    {
        "code" : "en-GB",
        "display" : "English (Great Britain)",
        "system" : ""
    } else if (code ==  'en-IN')
    {
        "code" : "en-IN",
        "display" : "English (India)",
        "system" : ""
    } else if (code ==  'en-NZ')
    {
        "code" : "en-NZ",
        "display" : "English (New Zeland)",
        "system" : ""
    } else if (code ==  'en-SG')
    {
        "code" : "en-SG",
        "display" : "English (Singapore)",
        "system" : ""
    } else if (code ==  'en-US')
    {
        "code" : "en-US",
        "display" : "English (United States)",
        "system" : ""
    } else if (code ==  'es')
    {
        "code" : "es",
        "display" : "Spanish",
        "system" : ""
    } else if (code ==  'es-AR')
    {
        "code" : "es-AR",
        "display" : "Spanish (Argentina)",
        "system" : ""
    } else if (code ==  'es-ES')
    {
        "code" : "es-ES",
        "display" : "Spanish (Spain)",
        "system" : ""
    } else if (code ==  'es-UY')
    {
        "code" : "es-UY",
        "display" : "Spanish (Uruguay)",
        "system" : ""
    } else if (code ==  'fi')
    {
        "code" : "fi",
        "display" : "Finnish",
        "system" : ""
    } else if (code ==  'fr')
    {
        "code" : "fr",
        "display" : "French",
        "system" : ""
    } else if (code ==  'fr-BE')
    {
        "code" : "fr-BE",
        "display" : "French (Belgium)",
        "system" : ""
    } else if (code ==  'fr-CH')
    {
        "code" : "fr-CH",
        "display" : "French (Switzerland)",
        "system" : ""
    } else if (code ==  'fr-FR')
    {
        "code" : "fr-FR",
        "display" : "French (France)",
        "system" : ""
    } else if (code ==  'fy')
    {
        "code" : "fy",
        "display" : "Frysian",
        "system" : ""
    } else if (code ==  'fy-NL')
    {
        "code" : "fy-NL",
        "display" : "Frysian (Netherlands)",
        "system" : ""
    } else if (code ==  '')
    {
        "code" : "hi",
        "display" : "Hindi",
        "system" : ""
    } else if (code ==  'hr')
    {
        "code" : "hr",
        "display" : "Croatian",
        "system" : ""
    } else if (code ==  'it')
    {
        "code" : "it",
        "display" : "Italian",
        "system" : ""
    } else if (code ==  'it-CH')
    {
        "code" : "it-CH",
        "display" : "Italian (Switzerland)",
        "system" : ""
    } else if (code ==  'it-IT')
    {
        "code" : "it-IT",
        "display" : "Italian (Italy)",
        "system" : ""
    } else if (code ==  'ja')
    {
        "code" : "ja",
        "display" : "Japanese",
        "system" : ""
    } else if (code ==  'ko')
    {
        "code" : "ko",
        "display" : "Korean",
        "system" : ""
    } else if (code ==  'nl')
    {
        "code" : "nl",
        "display" : "Dutch",
        "system" : ""
    } else if (code ==  'nl-BE')
    {
        "code" : "nl-BE",
        "display" : "Dutch (Belgium)",
        "system" : ""
    } else if (code ==  'nl-NL')
    {
        "code" : "nl-NL",
        "display" : "Dutch (Netherlands)",
        "system" : ""
    } else if (code ==  'no')
    {
        "code" : "no",
        "display" : "Norwegian",
        "system" : ""
    } else if (code ==  'no-NO')
    {
        "code" : "no-NO",
        "display" : "Norwegian (Norway)",
        "system" : ""
    } else if (code ==  'pa')
    {
        "code" : "pa",
        "display" : "Punjabi",
        "system" : ""
    } else if (code ==  'pl')
    {
        "code" : "pl",
        "display" : "Polish",
        "system" : ""
    } else if (code ==  'pt')
    {
        "code" : "pt",
        "display" : "Portuguese",
        "system" : ""
    } else if (code ==  'pt-BR')
    {
        "code" : "pt-BR",
        "display" : "Portuguese (Brazil)",
        "system" : ""
    } else if (code ==  'ru')
    {
        "code" : "ru",
        "display" : "Russian",
        "system" : ""
    } else if (code ==  'ru-RU')
    {
        "code" : "ru-RU",
        "display" : "Russian (Russia)",
        "system" : ""
    } else if (code ==  'sr')
    {
        "code" : "sr",
        "display" : "Serbian",
        "system" : ""
    } else if (code ==  'sr-RS')
    {
        "code" : "sr-RS",
        "display" : "Serbian (Serbia)",
        "system" : ""
    } else if (code ==  'sv')
    {
        "code" : "sv",
        "display" : "Swedish",
        "system" : ""
    } else if (code ==  'sv-SE')
    {
        "code" : "sv-SE",
        "display" : "Swedish (Sweden)",
        "system" : ""
    } else if (code ==  'te')
    {
        "code" : "te",
        "display" : "Telegu",
        "system" : ""
    } else if (code ==  'zh')
    {
        "code" : "zh",
        "display" : "Chinese",
        "system" : ""
    } else if (code ==  'zh-CN')
    {
        "code" : "zh-CN",
        "display" : "Chinese (China)",
        "system" : ""
    } else if (code ==  'zh-HK')
    {
        "code" : "zh-HK",
        "display" : "Chinese (Hong Kong)",
        "system" : ""
    } else if (code ==  'zh-SG')
    {
        "code" : "zh-SG",
        "display" : "Chinese (Singapore)",
        "system" : ""
    } else if (code ==  'zh-TW')
    {
        "code" : "zh-TW",
        "display" : "Chinese (Taiwan)",
        "system" : ""
    } else
    {
        "code" : "",
        "display" : "",
        "system" : ""
     }
    )
}
	
