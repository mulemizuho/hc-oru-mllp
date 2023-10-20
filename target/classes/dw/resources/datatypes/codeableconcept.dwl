/**
 * Maps the CodeableConcept object.
 */

%dw 2.0

// Import removeNull Function
import removeNull from dw::resources::util

/**
 * Maps the provided object into a CodeableConcept object.
 * @param obj is the object to map from.
 * @return A CodeableConcept object.
 */
fun mapCodeableConcept(obj) = mapCodeableConcept(obj, false, (obj) -> {})

/**
 * Maps the provided object with the provided mapping function into 
 * a CodeableConcept object.
 * @param obj is the object to map from.
 * @param hasMappingFunct is a boolean with true for has a provided 
 * mapping function and false for not. If set to true mappingFunct 
 * must be a vaild mapping function reference.
 * @param mappingFunct is a function reference with the function to 
 * call to provide the mapping. This function definition must take 
 * a single argument.
 * @return A CodeableConcept object.
 */
fun mapCodeableConcept(obj, hasMappingFunct, mappingFunct) = 
(if (!isEmpty(obj))
    (if (sizeOf(removeNull(mapCodeableConceptDoMapping(obj, hasMappingFunct, mappingFunct))) > 0)
    {
        coding: mapCodeableConceptDoMapping(obj, hasMappingFunct, mappingFunct),
        text: obj    
    }
    else null)
else null)

/**
 * This function produces the codeable concept mappings. It's 
 * broken out into it's own function so it can be called multiple times 
 * from mapCodeableConcept.
 * @param obj is the object to map from.
 * @param hasMappingFunct is a boolean with true for has a provided 
 * mapping function and false for not. If set to true mappingFunct 
 * must be a vaild mapping function reference.
 * @param mappingFunct is a function reference with the function to 
 * call to provide the mapping. This function definition must take 
 * a single argument.
 * @return A CodeableConcept object.
 */
fun mapCodeableConceptDoMapping(obj, hasMappingFunct, mappingFunct) = [
            ((if (hasMappingFunct)
                mappingFunct(obj)
            else
                {
                    code: obj,
                    display: obj,
                    system: obj,
                    version: obj
                }
            )) if (!isEmpty(obj))
]