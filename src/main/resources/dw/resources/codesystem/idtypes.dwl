/**
 * Maps the ID type object.
 */

%dw 2.0

/**
 * Maps the ID type with the provided code.
 * @param code is a string with the ID type.
 * @return An IdType object.
 */
fun mapIdTypes(code) = 
{
    ( if (code == 'ACSN')
    {
        "code" : "ACSN",
        "display" : "Accession ID",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'AM')
    {
        "code" : "AM",
        "display" : "American Express",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'AMA')
    {
        "code" : "AMA",
        "display" : "American Medical Association Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'AN')
    {
        "code" : "AN",
        "display" : "Account number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'ANON')
    {
        "code" : "ANON",
        "display" : "Anonymous identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'ANC')
    {
        "code" : "ANC",
        "display" : "Account number Creditor",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'AND')
    {
        "code" : "AND",
        "display" : "Account number debitor",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'ANT')
    {
        "code" : "ANT",
        "display" : "Temporary Account Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'APRN')
    {
        "code" : "APRN",
        "display" : "Advanced Practice Registered Nurse number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'ASID')
    {
        "code" : "ASID",
        "display" : "Ancestor Specimen ID",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'BA')
    {
        "code" : "BA",
        "display" : "Bank Account Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'BC')
    {
        "code" : "BC",
        "display" : "Bank Card Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'BCT')
    {
        "code" : "BCT",
        "display" : "Birth Certificate",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'BR')
    {
        "code" : "BR",
        "display" : "Birth registry number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'BRN')
    {
        "code" : "BRN",
        "display" : "Breed Registry Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'BSNR')
    {
        "code" : "BSNR",
        "display" : "Primary physician office number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'CC')
    {
        "code" : "CC",
        "display" : "Cost Center number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'CONM')
    {
        "code" : "CONM",
        "display" : "Change of Name Document",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'CZ')
    {
        "code" : "CZ",
        "display" : "Citizenship Card",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'CY')
    {
        "code" : "CY",
        "display" : "County number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'DDS')
    {
        "code" : "DDS",
        "display" : "Dentist license number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'DEA')
    {
        "code" : "DEA",
        "display" : "Drug Enforcement Administration registration number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'DI')
    {
        "code" : "DI",
        "display" : "Diner’s Club card",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'DFN')
    {
        "code" : "DFN",
        "display" : "Drug Furnishing or prescriptive authority Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'DL')
    {
        "code" : "DL",
        "display" : "Driver’s license number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'DN')
    {
        "code" : "DN",
        "display" : "Doctor number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'DO')
    {
        "code" : "DO",
        "display" : "Osteopathic License number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'DP')
    {
        "code" : "DP",
        "display" : "Diplomatic Passport",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'DPM')
    {
        "code" : "DPM",
        "display" : "Podiatrist license number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'DR')
    {
        "code" : "DR",
        "display" : "Donor Registration Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'DS')
    {
        "code" : "DS",
        "display" : "Discover Card",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'EI')
    {
        "code" : "EI",
        "display" : "Employee number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'EN')
    {
        "code" : "EN",
        "display" : "Employer number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'ESN')
    {
        "code" : "ESN",
        "display" : "Staff Enterprise Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'FI')
    {
        "code" : "FI",
        "display" : "Facility ID",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'GI')
    {
        "code" : "GI",
        "display" : "Guarantor internal identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'GL')
    {
        "code" : "GL",
        "display" : "General ledger number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'GN')
    {
        "code" : "GN",
        "display" : "Guarantor external identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'HC')
    {
        "code" : "HC",
        "display" : "Health Card Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'JHN')
    {
        "code" : "JHN",
        "display" : "Jurisdictional health number (Canada)",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'IND')
    {
        "code" : "IND",
        "display" : "Indigenous/Aboriginal",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'LACSN')
    {
        "code" : "LACSN",
        "display" : "Laboratory Accession ID",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'LANR')
    {
        "code" : "LANR",
        "display" : "Lifelong physician number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'LI')
    {
        "code" : "LI",
        "display" : "Labor and industries number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'LN')
    {
        "code" : "LN",
        "display" : "License number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'LR')
    {
        "code" : "LR",
        "display" : "Local Registry ID",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MA')
    {
        "code" : "MA",
        "display" : "Patient Medicaid number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MB')
    {
        "code" : "MB",
        "display" : "Member Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MC')
    {
        "code" : "MC",
        "display" : "Patient’s Medicare number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MCD')
    {
        "code" : "MCD",
        "display" : "Practitioner Medicaid number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MCN')
    {
        "code" : "MCN",
        "display" : "Microchip Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MCR')
    {
        "code" : "MCR",
        "display" : "Practitioner Medicare number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MCT')
    {
        "code" : "MCT",
        "display" : "Marriage Certificate",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MD')
    {
        "code" : "MD",
        "display" : "Medical License number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MI')
    {
        "code" : "MI",
        "display" : "Military ID number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MR')
    {
        "code" : "MR",
        "display" : "Medical record number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MRT')
    {
        "code" : "MRT",
        "display" : "Temporary Medical Record Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'MS')
    {
        "code" : "MS",
        "display" : "MasterCard",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'NBSNR')
    {
        "code" : "NBSNR",
        "display" : "Secondary physician office number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'NCT')
    {
        "code" : "NCT",
        "display" : "Naturalization Certificate",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'NE')
    {
        "code" : "NE",
        "display" : "National employer identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'NH')
    {
        "code" : "NH",
        "display" : "National Health Plan Identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'NI')
    {
        "code" : "NI",
        "display" : "National unique individual identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'NII')
    {
        "code" : "NII",
        "display" : "National Insurance Organization Identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'NIIP')
    {
        "code" : "NIIP",
        "display" : "National Insurance Payor Identifier (Payor)",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'NNxxx')
    {
        "code" : "NNxxx",
        "display" : "National Person Identifier where the xxx is the ISO table 3166 3-character (alphabetic) country code",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'NP')
    {
        "code" : "NP",
        "display" : "Nurse practitioner number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'NPI')
    {
        "code" : "NPI",
        "display" : "National provider identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'OD')
    {
        "code" : "OD",
        "display" : "Optometrist license number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PA')
    {
        "code" : "PA",
        "display" : "Physician Assistant number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PC')
    {
        "code" : "PC",
        "display" : "Parole Card",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PCN')
    {
        "code" : "PCN",
        "display" : "Penitentiary/correctional institution Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PE')
    {
        "code" : "PE",
        "display" : "Living Subject Enterprise Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PEN')
    {
        "code" : "PEN",
        "display" : "Pension Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PI')
    {
        "code" : "PI",
        "display" : "Patient internal identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PN')
    {
        "code" : "PN",
        "display" : "Person number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PNT')
    {
        "code" : "PNT",
        "display" : "Temporary Living Subject Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PPIN')
    {
        "code" : "PPIN",
        "display" : "Medicare/CMS Performing Provider Identification Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PPN')
    {
        "code" : "PPN",
        "display" : "Passport number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PRC')
    {
        "code" : "PRC",
        "display" : "Permanent Resident Card Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PRN')
    {
        "code" : "PRN",
        "display" : "Provider number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'PT')
    {
        "code" : "PT",
        "display" : "Patient external identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'QA')
    {
        "code" : "QA",
        "display" : "QA number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'RI')
    {
        "code" : "RI",
        "display" : "Resource identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'RPH')
    {
        "code" : "RPH",
        "display" : "Pharmacist license number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'RN')
    {
        "code" : "RN",
        "display" : "Registered Nurse Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'RR')
    {
        "code" : "RR",
        "display" : "Railroad Retirement number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'RRI')
    {
        "code" : "RRI",
        "display" : "Regional registry ID",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'RRP')
    {
        "code" : "RRP",
        "display" : "Railroad Retirement Provider",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'SID')
    {
        "code" : "SID",
        "display" : "Specimen ID",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'SL')
    {
        "code" : "SL",
        "display" : "State license",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'SN')
    {
        "code" : "SN",
        "display" : "Subscriber Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'SP')
    {
        "code" : "SP",
        "display" : "Study Permit",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'SR')
    {
        "code" : "SR",
        "display" : "State registry ID",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'SS')
    {
        "code" : "SS",
        "display" : "Social Security number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'TAX')
    {
        "code" : "TAX",
        "display" : "Tax ID number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'TN')
    {
        "code" : "TN",
        "display" : "Treaty Number/ (Canada)",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'TPR')
    {
        "code" : "TPR",
        "display" : "Temporary Permanent Resident (Canada)",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'U')
    {
        "code" : "U",
        "display" : "Unspecified identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'UPIN')
    {
        "code" : "UPIN",
        "display" : "Medicare/CMS (formerly HCFA)’s Universal Physician Identification numbers",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'USID')
    {
        "code" : "USID",
        "display" : "Unique Specimen ID",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'VN')
    {
        "code" : "VN",
        "display" : "Visit number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'VP')
    {
        "code" : "VP",
        "display" : "Visitor Permit",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'VS')
    {
        "code" : "VS",
        "display" : "VISA",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'WC')
    {
        "code" : "WC",
        "display" : "WIC identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'WCN')
    {
        "code" : "WCN",
        "display" : "Workers’ Comp Number",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'WP')
    {
        "code" : "WP",
        "display" : "Work Permit",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else if (code == 'XX')
    {
        "code" : "XX",
        "display" : "Organization identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    } else {
        "code" : "XX",
        "display" : "Organization identifier",
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
    }
)}