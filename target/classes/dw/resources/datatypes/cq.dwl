/**
 * Maps the CQ quantity object.
 */

%dw 2.0

/**
 * Maps the CQ quantity object with the provided TQ1 TQ1-02
 * object.
 * @param cq is a TQ1-02 object to map.
 * @return A mapped CQ object.
 */
fun mapCQ(cq) = 
	(if (!isEmpty(cq))
	{	
	"value":cq."CQ-01",
	(if (!isEmpty(cq."CQ-02"."CWE-09"))
		"unit": cq."CQ-02"."CWE-09"
	else if (!isEmpty(cq."CQ-02"."CWE-02"))
		"unit":"CQ-02"."CWE-02"
	else null)
	}
	else null)
