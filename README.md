# Expansion of the National Drug File to include non-US drugs
This paper is funded by Electronic Health Solutions LLC from the Hashemite
Kingdom of Jordan.

Released under CC-BY 3.0. Code accompanying this paper is all in the public domain.

## Purpose of this Paper
This paper is intended to describe a possible path to the addition of
non-US medicines to the National Drug Files in VistA. Addition to the National
Drug Files is a pre-requisite to being able to have allergy, drug-interaction,
and duplicate therapy order checks for medicines that are found in Jordan but
are not found in the United States. It will also help when having to resolve
data from one VistA system to another VistA system.

The reason this is necessary is that medicines are non-standarzied across all
of the world; and thus medicines marketed in one country may not be marketed in
another; and even if marketed, there is no guarantee that the medicines will be
in the same dosage form or the same strength as the US medicines.

## What is the NDF?
The NDF is an acronym for "National Drug File". This is misleading: it really
consists of 19 files, as follows in this table:

| File Number | File Name | Global Location |
| ----------- | --------- | --------------- |
| 50.416      | DRUG INGREDIENTS | ^PS(50.416) |
| 50.6        | VA GENERIC | ^PSNDF(50.6)   |
| 50.605      | VA DRUG CLASS | ^PS(50.605) |
| 50.606      | DOSAGE FORM | ^PS(50.606)   |
| 50.607      | DRUG UNITS | ^PS(50.607)    |
| 50.608      | PACKAGE TYPE | ^PS(50.608)  |
| 50.609      | PACKAGE SIZE | ^PS(50.609)  |
| \*50.621      | PMI-ENGLISH      | ^PS(50.621) |
| \*50.622      | PMI-SPANISH      | ^PS(50.622) |
| \*50.623      | PMI MAP-ENGLISH  | ^PS(50.623)
| \*50.625      | WARNING LABEL-ENGLISH | ^PS(50.625)
| \*50.626      | WARNING LABEL-SPANISH | ^PS(50.626)
| \*50.627      | WARNING LABEL MAP | ^PS(50.627)
| 50.64       | VA DISPENSE UNIT | ^PSNDF(50.64) |
| 50.67       | NDC/UPN    | ^PSNDF(50.67)  |
| 50.68       | VA PRODUCT | ^PSNDF(50.68)  |
| 51.2        | MEDICATION ROUTES | ^PS(51.2) |
| 55.95       | DRUG MANUFACTURER | ^PS(55.95) |
| \#56          | DRUG INTERACTION | ^PS(56)  |

Files with a asterisk next to their number are not maintained by the VA. They
are loaded directly from FDB data. Files with a hash next to their number are
not used in the VA anymore; but are still maintained for Indian Health Service.

Looking at the list of the above files does not help with knowing what's
important and what isn't. So I will state it here: VA PRODUCT is the center of
NDF. Drugs are tied to a VA PRODUCT and by virtue of that may be able to
participate in Drug Interaction, Duplicate Therapy, and Allergy/ADR checks.
The VA PRODUCT in turn points to all other files. Here's a map produced by
Fileman's 'MAP POINTER RELATIONS' option. Note the all of the pointers are
forward pointers (one VA PRODUCT to one), with the exception of NDC/UPN
(50.67), which has a backwards pointer (many to one VA PRODUCT). 

```
   File/Package: VA PRODUCT POINTERS                                                        Date: NOV 9,2016

  FILE (#)                                                                    POINTER           (#) FILE
   POINTER FIELD                                                               TYPE           POINTER FIELD              FILE POINTED TO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          L=Laygo      S=File not in set      N=Normal Ref.      C=Xref.
          *=Truncated      m=Multiple           v=Variable Pointer

                                                                                          -------------------------------
  DRUG (#50)                                                                              |                             |
    PSNDF VA PRODUCT NAME ENTRY ............................................  (N S C L)-> |  50.68 VA PRODUCT           |
  NATIONAL DRUG TRANSL (#50.612)                                                          |                             |
    VA PRODUCT NAME DA .....................................................  (N S L)->   |   VA GENERIC NAME           |-> VA GENERIC
  NDC/UPN (#50.67)                                                                        |                             |
    VA PRODUCT NAME ........................................................  (N S )->    |   DOSAGE FORM               |-> DOSAGE FORM
  BCMA EXTRACT (#727.833)                                                                 |                             |
    DRUG IEN ...............................................................  (N S )->    |   UNITS                     |-> DRUG UNITS
                                                                                          |                             |
                                                                                          |   VA DISPENSE UNIT          |-> VA DISPENSE UNIT
                                                                                          |   PRIMARY VA DRUG CLASS     |-> VA DRUG CLASS
                                                                                          |   ACTIVE INGR:ACTIVE INGR*  |-> DRUG INGREDIENTS
                                                                                          |   ACTIVE INGREDIENTS:UNITS  |-> DRUG UNITS
                                                                                          | m SECONDARY V:SECONDARY V*  |-> VA DRUG CLASS
                                                                                          -------------------------------
```
## How is the NDF maintained?
The NDF was maintained using the National Drug File Management System (NDFMS),
a VistA application running on a standalone system. The NDF was maintained by
four pharmacists [1] who monitored FDB, the FDA, and user input; and made
changes to the NDF as a result. After each month was over, a "cut" of the
changes was created by looking at the Audit Fileman Global since the last time
an update was sent. This cut is installed at the destination VistA systems in
order to update the NDF at each site using VistA. Of note, none of the internal
entry numbers (IENs) of the files are resolved at the destination system; they are all
sent as is. In other words, there is no pointer resolution: all files are
assumed to be in an identical static state across all VistA sites.

Since 2013, the VA has transitioned to a Web Application called Pharmacy
Product System - National (PPS-N). This application provides similar capabilites
to NDFMS, but includes extra functionality, especially with regards to querying
external data sources. The application interfaces with the NDFMS via remote
procedures; NDFMS is still responsible today for making the "cut" to send to
destination VistA systems. As of today (Nov 9th 2016), the KIDS builds that
are applied to the NDFMS in order be able to communicate to PPS-N are not
available. A FOIA request has been placed in order to obtain them.

There is no documentation besides what I will supply here in this paper for
NDFMS. KIDS build will be supplied along with this paper.

Documentation for PPS-N can be found at [2].

Source code for the two future versions (unreleased) of PPS-N can be found at
[3] and [4]. I can't find the source code for v1.0.

## Systems Involved

 a. Client VistA systems; which are the systems that have patient data
 and which pharmacists and physicians use.
 b. NDFMS, a VistA system which makes the NDF patches. You distribute
 these patches to VistA systems in a.
 c. PPS-N, which is a WebLogic system, which uses Remote Procedures to
 apply data to the NDFMS. The remote procedures run using VistALink.

## Proposed Process for adding non-US drugs to the NDF
### Activation of previously inactive entries
An easy fix for many products is that they may exist already in the NDF, but
are inactive. If that is so, it's easy to activate them by reversing the action
of the menu option [NDF INACTIVATE PRODUCT] found in the NDFMS system.
### Adding new entries
Due to the fact that IENs are static at the client sites--i.e., they are what
the source NDFMS supplies, it is a feasible proposition to have non-US drugs
at higher numbers. I do not know if NDF patches from the VA will continue
working as is or will they need some modifications. As far as I am able to tell,
everything in the VA NDF patch is entered into the VistA system using static
IENs.
### Making the patch
I think this may be the hardest: making a Jordan specific NDF patch. The
reason is that the NDFMS system needs initial configuration and data entry in
files in the 5000 range which it distrubutes. However, there is no documentation
on how to do that. The 5000 file range does not contain any files with data;
instead, they contain data control structures that keep track of which entries
were previously exported and by whom. In order to set-up the NDF-MS, it is
necessary set-up the 5000 range files. This should be done using experimentation.

## Drug Interactions
The NDF-MS also allows you to update drug interactions. It will let you assign
CRITICAL/SIGNIFICANT severity to a pair of ingredients. They will be transported
with all the rest of the data that you added.

It's important to note that if new drug ingredients are added to the National
Drug File, if there are interactions, they ought to be added to the DRUG
INTERACTION file in NDF-MS.

## Timeline if I were to develop this
 * 100 hours to get NDFMS running
 * 100 hours to get Jordan specific numbering running
 * I can't estimate porting effort for PPS-N as I have no expertise in porting
   Java applications that run on IBM WebLogic. I don't think it's necessary
   for this project. PPS-N may provide a convenient way to enter data--but as
   usual, there is a lot of data sources it taps into which are unapplicable in
   Jordan.

## Technical Details for reverse engineering the NDF process
This section is intended for the programmers who will do the work. It describes
some of my findings that are pertinent to this project.

### Post Install for NDF Data Update Patches
In this package, under the folder PSN_4.0_466, you will eventually find a file
called PSN466D.m. I annotated this file for interested readers.

It reads the KIDS transport global referenced in XPDGREF, and looks first at
subscript DATANT, which contain the .01 entries for all new and changed entries.
Of note, FILE^DICN is called with the exact number of the IEN to enter using the
variable DINUM.

Next, subscript DATAN is examined. It contains the .01's for the multiples.
Again, the IENs are maintained; this time by sending the "IEN" subscripted
variable with the desired IENs to UPDATE^DIE. Any changes to active ingredients
are cached into a ^TMP global.

Next, subscript DATAO contains the rest of the data. It's filed using FILE^DIE.

Next, Cached changes to active ingredients are sent over to the Drug Ingredients
file.

Next, two email messages are sent. The email messages are NOT generated on the
fly; rather they are inside of the transport global. These email messages are
the ones received by the installer and all holders of the PSNMGR key on the
destination VistA system into which the NDF patches are installed.

Next, find VA PRODUCTs that just got inactivated by this or any other patch;
for each found one, delete the NDF node ("ND") and the doses (possible and
local possible). For any drugs that have the "ND" node left, update the
National Formulary Indicator and the VA Class.

Next, the unmatched drugs email message is sent.

### NDF Management System Details
The NDF Management system's main menu is called "NDF MANAGER". It contains:

 * NDF ENTER EDIT
 * NDF REPORTS
 * NDF MISCELLANEOUS
 * NDF INQUIRY
 * NDFPBM (calls a ZZ routine)
 * NDFRTE (calls a ZZ routine)

We only care right now about NDF ENTER EDIT and NDF MISCELLENOUS. Here's NDF
ENTER EDIT:

 * NDF VA PRODUCT
 * NDF VA GENERIC
 * NDF MANUFACTURERS
 * NDF DOSAGE FORM
 * NDF DRUG UNITS
 * NDF VA CLASS
 * NDF PACKAGE TYPE
 * NDF PACKAGE SIZE
 * NDF DISPENSE UNIT
 * NDF ROUTE
 * NDF INGREDIENT
 * NDF INTERACTIONS

All of these reference simple code in routine NDFENTER; with the exception of
NDF VA PRODUCT, which goes through a long list of questions and checks starting
from NDFRR2.

Here's NDF MISCELLANEOUS:

 * NDF INACTIVATE NDC
 * NDF INACTIVATE PRODUCT
 * NDF MESSAGE
 * NDF PURGE
 * NDF INACTIVATE INTERACTION
 * NDF ENTER RESTRICTIONS
 * NDF PATCH EDIT REPORT
 * NDF EXLCUSIONS

The first two reference NDFDEACT.

NDFPRE generates the NDF data patch. You will find a reference to it in any
data build as the pre-transport routine.

Last but not least, every entry needs to have a VUID assigned. I haven't dug
into this process, but it's certain that you will need to establish your own
unique numbering system for that field too. The reason you need to do that is
that VUID is a key on all the files; and the VA will continue to generate
their own VUIDs. Therefore, you need to generate VUIDs that have no possiblity
of colliding with VA VUIDs. In theory, any number range above 10,000,000 is
fine; the VA currently uses 4,000,000-5,000,000.

# Attachments
Along with this report, I am sending patch PSN\*4.0\*466 as an example NDF
Data patch, as well the FOIA copy of the NDF Management System. All routines
referenced anywhere in the document can be found in either of these two folders.

# Next Steps

 1. Install the NDF-MS System on a Standalone VistA System for development and testing.
 2. Test the system by adding entries, and try to make an initial export (you
 	need to figure out how to set up the files in the 5000 range).
 3. Modify NDF-MS in order that it a. adds new entries in IENs in the EHS
 	numberspace, and b. assigns VUIDs that are in the EHS numberspace.
 4. Add entries, and make an export.
 5. Install the export in a test VistA system, to see if it works. Verify that
    a. IENs are in the EHS numberspace and b. VUIDs are unique across all the system
	and are in the EHS numberspace and c. New Drug Interactions are seen in the
	VistA system.
 6. Create a production NDF-MS system with the modified code (up to you how to copy the code and files), and initialize it.
 7. Add entries, and create a patch.
 8. Install patch on test system. Do checks in no. 5 again.
 9. If everything is okay, install patch on production systems.
 10. Monitor for issues.
 
 Repeat 7-10 with an objective of releasing updated drugs monthly.

# Footnotes
[1] Personal conversation with Don Lees, manager of the NDF at PBM, VA.
[2] http://www.va.gov/vdl/application.asp?appid=202
[3] http://hdl.handle.net/10909/11003
[4] http://hdl.handle.net/10909/11163
