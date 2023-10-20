/**
 * Maps the relationship object.
 */

%dw 2.0

/**
 * Maps the relationship with the provided code.
 * @param code is a string with the code to map.
 * @return A Relationship object.
 */
fun mapRelationship(code) =
{
    ( if (code == 'SEL') {
        "code" : "ONESELF",
        "display" : "self",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'SPO') {
        "code" : "SPS",
        "display" : "spouse",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'DOM') {
        "code" : "SIGOTHR",
        "display" : "significant other",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'CHD') {
        "code" : "CHILD",
        "display" : "child",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'GCH') {
        "code" : "GRNDCHILD",
        "display" : "grandchild",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'NCH') {
        "code" : "NCHILD",
        "display" : "natural child",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'SCH') {
        "code" : "STPCHLD",
        "display" : "step child",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'FCH') {
        "code" : "CHLDFOST",
        "display" : "foster child",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'DEP') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'WRD') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'PAR') {
        "code" : "PRN",
        "display" : "parent",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'MTH') {
        "code" : "MTH",
        "display" : "mother",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'FTH') {
        "code" : "FTH",
        "display" : "father",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'CGV') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'GRD') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'GRP') {
        "code" : "GRPRN",
        "display" : "grandparent",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'EXF') {
        "code" : "EXT",
        "display" : "extended family member",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'SIB') {
        "code" : "SIB",
        "display" : "sibling",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'BRO') {
        "code" : "BRO",
        "display" : "brother",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'SIS') {
        "code" : "SIS",
        "display" : "sister",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'FND') {
        "code" : "FRND",
        "display" : "unrelated friend",
        "system" : "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
    } else if (code == 'OAD') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'EME') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'EMR') {
        "code" : "E",
        "display" : "Employer",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code == 'ASC') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'EMC') {
        "code" : "C",
        "display" : "Emergency Contact",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code == 'OWN') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'TRA') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'MGR') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'NON') {
        "code" : "",
        "display" : "",
        "system" : "",
    } else if (code == 'UNK') {
        "code" : "U",
        "display" : "Unknown",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code == 'OTH') {
        "code" : "O",
        "display" : "Other",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code == 'E') {
        "code" : "E",
        "display" : "Employer",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code == 'C') {
        "code" : "C",
        "display" : "Emergency Contact",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code == 'F') {
        "code" : "F",
        "display" : "Federal Agency",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code == 'I') {
        "code" : "I",
        "display" : "Insurance Company",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code == 'N') {
        "code" : "N",
        "display" : "Next-of-Kin",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code == 'S') {
        "code" : "S",
        "display" : "State Agency",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code == 'O') {
        "code" : "O",
        "display" : "Other",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else if (code == 'U') {
        "code" : "U",
        "display" : "Unknown",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0131",
    } else {
        "code" : "",
        "display" : "",
        "system" : "",
    }
)}
