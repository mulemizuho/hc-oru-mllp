/**
 * This module defines a number of common 
 * utility functions.
 */

%dw 2.0

// Used for SHA function to generate ID.
import dw::Crypto

/**
 * Generates a GUID with the provided string. This is 
 * helpful because the GUID generated is predictable.
 * @param InStr is the input string to the hash function.
 * @return A string with the predictable hashed value.
 */ 
fun mapGuid(InStr:String) = Crypto::SHA1(InStr as Binary)

/**
 * Converts anything to a JSON string representation. Note that 
 * if you are serializing an object datetime fields may have local 
 * timezone information so this can cause issues with repeatability 
 * for munit tests.
 * @param data is the data type to convert to JSON.
 * @return A JSON formatted string of the provided variable.
 */
fun toString(data) = write(data,'application/json')

/**
 * Converts a HL7 datetime string to 
 * the expected datetime string.
 * @param timeStr is a HL7 datetime string formatted YYYYMMDDHHMMSS.
 * @return A timestamp string formatted YYYY-MM-DDTHH:MM:SS.000Z.
 */
fun hl7ConvertDateTime(timeStr) = 
(if (!isEmpty(timeStr) and sizeOf(timeStr) > 4)
    (if (timeStr contains("-"))
        timeStr
    else
        timeStr[0 to 3] 
        ++ (
            if (sizeOf(timeStr) > 5) 
                "-" ++ timeStr[4 to 5] 
            else "-01"
        )
        ++ (
            if (sizeOf(timeStr) > 7) 
                "-" ++ timeStr[6 to 7]
            else "-01"
        ) 
        ++ "T"
        ++ (
            if (sizeOf(timeStr) > 9) 
                timeStr[8 to 9]
            else "00"
            
        )
        ++ (
            if (sizeOf(timeStr) > 11) 
                ":" ++ timeStr[10 to 11]
            else ":00"
        )
        ++ (
            if (sizeOf(timeStr) > 13) 
                ":" ++ timeStr[12 to 13]
            else ":00"
        )
        ++ ".000Z"
    )
else null)

/**
 * Converst a HL7 date to date string.
 * @param dateStr is a HL7 date string formatted YYYYMMDD.
 * @return A date string formatted YYYY-MM-DD.
 */
fun hl7ConvertDate(dateStr) =
(if (dateStr contains("-"))
	dateStr[0 to 9]
else
	dateStr[0 to 3] 
    ++ "-" ++ dateStr[4 to 5] 
    ++ "-" ++ dateStr[6 to 7]     
)

/**
 * Removes all null items from an array.
 * @param arr is an array.
 * @return An array with null items removed.
 */
fun removeNull(arr:Array) = (
    if (!isEmpty(arr))
        arr filter ($ != null and !isEmpty($))
    else []
)

/**
 * Removes all null values from an object.
 * @param obj is an object.
 * @return An object with null values removed.
 */
fun removeNull(obj:Object) = (
    if (!isEmpty(obj))
        obj mapObject (value, key, index) -> 
        (
            (key): value
        ) if (!isEmpty(value))
    else {}
)

/**
 * Cleans the provided object of blank strings, null values,
 * empty objects, and empty arrays.
 * @param obj is an Object to clean.
 * @return A cleaned object.
 */
fun clean(obj:Object) = (
    removeNull(
        obj mapObject (value, key, index) -> (
            if (typeOf(value) as String == "Array")
                (key): clean(value)
            else if (typeOf(value) as String == "Object")
                (key): clean(value)
            else if (!isEmpty(value) and value != "")
                (key): value
            else (key): null
        )
    )
)

/**
 * Cleans the provided array of blank strings, null values,
 * empty objects, and empty arrays.
 * @param arr is an Array to clean.
 * @return A cleaned Array.
 */
fun clean(arr:Array) = (
    removeNull(
        arr map (value, index) -> (
            if (typeOf(value) as String == "Array")
                clean(value)
            else if (typeOf(value) as String == "Object")
                clean(value)
            else if (!isEmpty(value) and value != "")
                value
            else null
        )
    )
)

/**
 * Recursively strips the provided key name from 
 * any objects in the provided item.
 * @param item is an value.
 * @param key is a String with the object key name to strip.
 * @return The provided value with any instances of the key removed.
 */
fun strip(item, key:String) = 
(
    if (typeOf(item) as String == "Array")
        item map (arrItem) -> 
            strip(arrItem, key)
    else if (typeOf(item) as String == "Object")
        item mapObject (objVal, objKey) -> 
        (
            (objKey): strip(objVal, key)
        ) if (objKey as String != key)
    else item
)

/**
 * Converts the provided HL7 datetime string and 
 * converts it to a number with the number of seconds 
 * since epoch.
 * @param str is a HL7 datetime string.
 * @return A number with number of seconds since epoch.
 */
fun toEpochSeconds(str) = 
    ((hl7ConvertDateTime(str) as LocalDateTime) ++ "+00:00") as Number

/**
 * Converts the provided datetime as a number with seconds 
 * since epoch into the FHIR formatted datetime string.
 * @param seconds is a number with the seconds since epoch.
 * @return A string with the FHIR formatted datetime string.
 */
fun fromEpochSeconds(seconds) = 
    seconds as DateTime as String {format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"}

/**
 * Replaces a key value pair in an object with 
 * the provided object and key value set.
 * @param obj is an object to replace in.
 * @param key is a string to match on.
 * @param val is the value to replace with.
 * @return An object with the replaced pair or 
 * null if no object is provided.
 */
fun replacePair(obj:Object, key:String, val) = 
(if (!isEmpty(obj))
    obj mapObject (tvalue, tkey, tindex) -> 
        (
            if (tkey as String == (key))
                (key): val
            else 
                (tkey): tvalue
        )
else null)



fun removeEmpty(a: Array) = a reduce (e, acc=[]) -> if (isEmpty(e)) acc else (acc + removeEmpty(e))
fun removeEmpty(o: Object) = o mapObject if (isEmpty($)) {} else {($$): removeEmpty($)}
fun removeEmpty(s: String) = s
fun removeEmpty(b: Boolean) = b
fun removeEmpty(n: Number) = n

/**
 * Removed any generated IDs such as GUIDS from the 
 * payload for testing purposes.
 * @param data is FHIR bundle with the data to remove 
 * IDs from.
 * @return The FHIR bundle with generated IDs removed.
 */
fun removeGeneratedIds(data) = 
(data - "entry" - "identifier" - "id") ++ 
{
    entry: data.entry map (item, index) -> 
    removeAllInstances(
        (
            if (!isEmpty(item.request))
                (item - "fullUrl" - "resource" - "request")
                ++ { resource: (item.resource - "id") }
                ++ { request: (item.request - "url") }
            else
                (item - "fullUrl" - "resource")
                ++ { resource: (item.resource - "id") }
        ), ["reference", "identifier", "period", "authoredOn", "occurrenceDateTime", "effectiveDateTime", "onsetDateTime", "collectedDateTime"]
    )
}

/**
 * Recursivly removes all instances of the provided 
 * fieldName within the provided data structure.
 * @param data is an array or object to remove the 
 * field from.
 * @param fieldNames is a array of strings with the field  
 * names to remove.
 * @return The data with the field removed.
 */
fun removeAllInstances(data, fieldNames:Array) = 
(
    if (typeOf(data) as String == "Array")
        data map (item, index) -> removeAllInstances(item, fieldNames)
    else if (typeOf(data) as String == "Object")
        data mapObject ((value, key, index) -> 
            (
                (key): removeAllInstances(value, fieldNames)
            ) if !(fieldNames contains(key as String))
        )
    else 
        data
)