/**
 * Maps the EIIdentifier part of a CodeableConcept object.
 */

%dw 2.0

/**
 * Maps the provided object into a CodeableConcept object.
 * @param obj is the object to map from.
 * @return A CodeableConcept object.
 */
fun mapEIIdentifier(obj) = {
	(if (!isEmpty(obj))
		"value": obj."EI-01"
	else null)
}