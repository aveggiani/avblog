﻿/*
 * FCKeditor - The text editor for internet
 * Copyright (C) 2003-2006 Frederico Caldeira Knabben
 * 
 * Licensed under the terms of the GNU Lesser General Public License:
 * 		http://www.opensource.org/licenses/lgpl-license.php
 * 
 * For further information visit:
 * 		http://www.fckeditor.net/
 * 
 * "Support Open Source software. What about a donation today?"
 * 
 * File Name: no.js
 * 	Norwegian language file.
 * 
 * File Authors:
 * 		Martin Kronstad (www.siteman.no) (martin.kronstad@gmail.com)
 */

var FCKLang =
{
// Language direction : "ltr" (left to right) or "rtl" (right to left).
Dir					: "ltr",

ToolbarCollapse		: "Skjul verktøylinje",
ToolbarExpand		: "Vis verktøylinje",

// Toolbar Items and Context Menu
Save				: "Lagre",
NewPage				: "Ny Side",
Preview				: "Forhåndsvis",
Cut					: "Klipp ut",
Copy				: "Kopier",
Paste				: "Lim inn",
PasteText			: "Lim inn som ren tekst",
PasteWord			: "Lim inn fra Word",
Print				: "Skriv ut",
SelectAll			: "Velg alle",
RemoveFormat		: "Fjern format",
InsertLinkLbl		: "Lenke",
InsertLink			: "Sett inn/Rediger lenke",
RemoveLink			: "Fjern lenke",
Anchor				: "Sett inn/Rediger anker",
InsertImageLbl		: "Bilde",
InsertImage			: "Sett inn/Rediger bilde",
InsertFlashLbl		: "Flash",
InsertFlash			: "Sett inn/Rediger Flash",
InsertTableLbl		: "Tabell",
InsertTable			: "Sett inn/Rediger tabell",
InsertLineLbl		: "Linje",
InsertLine			: "Sett inn horisontal linje",
InsertSpecialCharLbl: "Spesielt tegn",
InsertSpecialChar	: "Sett inn spesielt tegn",
InsertSmileyLbl		: "Smil",
InsertSmiley		: "Sett inn smil",
About				: "Om FCKeditor",
Bold				: "Fet",
Italic				: "Kursiv",
Underline			: "Understrek",
StrikeThrough		: "Gjennomstrek",
Subscript			: "Senket skrift",
Superscript			: "Hevet skrift",
LeftJustify			: "Venstrejuster",
CenterJustify		: "Midtjuster",
RightJustify		: "Høyrejuster",
BlockJustify		: "Blokkjuster",
DecreaseIndent		: "Senk nivå",
IncreaseIndent		: "Øk nivå",
Undo				: "Angre",
Redo				: "Gjør om",
NumberedListLbl		: "Numrert liste",
NumberedList		: "Sett inn/Fjern numrert liste",
BulletedListLbl		: "Uordnet liste",
BulletedList		: "Sett inn/Fjern uordnet liste",
ShowTableBorders	: "Vis tabellrammer",
ShowDetails			: "Vis detaljer",
Style				: "Stil",
FontFormat			: "Format",
Font				: "Skrift",
FontSize			: "Størrelse",
TextColor			: "Tekstfarge",
BGColor				: "Bakgrunnsfarge",
Source				: "Kilde",
Find				: "Finn",
Replace				: "Erstatt",
SpellCheck			: "Stavekontroll",
UniversalKeyboard	: "Universelt tastatur",
PageBreakLbl		: "Sideskift",
PageBreak			: "Sett inn sideskift",

Form			: "Skjema",
Checkbox		: "Sjekkboks",
RadioButton		: "Radioknapp",
TextField		: "Tekstfelt",
textarea		: "Tekstområde",
HiddenField		: "Skjult felt",
Button			: "Knapp",
SelectionField	: "Dropdown meny",
ImageButton		: "Bildeknapp",

FitWindow		: "Maksimer størrelsen på redigeringsverktøyet",

// Context Menu
EditLink			: "Rediger lenke",
CellCM				: "Celle",
RowCM				: "Rader",
ColumnCM			: "Kolonne",
InsertRow			: "Sett inn rad",
DeleteRows			: "Slett rader",
InsertColumn		: "Sett inn kolonne",
DeleteColumns		: "Slett kolonner",
InsertCell			: "Sett inn celle",
DeleteCells			: "Slett celler",
MergeCells			: "Slå sammen celler",
SplitCell			: "Splitt celler",
TableDelete			: "Slett tabell",
CellProperties		: "Celleegenskaper",
TableProperties		: "Tabellegenskaper",
ImageProperties		: "Bildeegenskaper",
FlashProperties		: "Flash Egenskaper",

AnchorProp			: "Ankeregenskaper",
ButtonProp			: "Knappegenskaper",
CheckboxProp		: "Sjekkboksegenskaper",
HiddenFieldProp		: "Skjult felt egenskaper",
RadioButtonProp		: "Radioknappegenskaper",
ImageButtonProp		: "Bildeknappegenskaper",
TextFieldProp		: "Tekstfeltegenskaper",
SelectionFieldProp	: "Dropdown menyegenskaper",
textareaProp		: "Tekstfeltegenskaper",
FormProp			: "Skjemaegenskaper",

FontFormats			: "Normal;Formatert;Adresse;Tittel 1;Tittel 2;Tittel 3;Tittel 4;Tittel 5;Tittel 6",

// Alerts and Messages
ProcessingXHTML		: "Lager XHTML. Vennligst vent...",
Done				: "Ferdig",
PasteWordConfirm	: "Teksten du prøver å lime inn ser ut som om den kommer fra word , du bør rense den før du limer inn , vil du gjøre dette?",
NotCompatiblePaste	: "Denne kommandoen er tilgjenglig kun for Internet Explorer version 5.5 eller bedre. Vil du fortsette uten å rense?(Du kan lime inn som ren tekst)",
UnknownToolbarItem	: "Ukjent menyvalg \"%1\"",
UnknownCommand		: "Ukjent kommando \"%1\"",
NotImplemented		: "Kommando ikke ennå implimentert",
UnknownToolbarSet	: "Verktøylinjesett \"%1\" finnes ikke",
NoActiveX			: "Din nettleser's sikkerhetsinstillinger kan begrense noen av funksjonene i redigeringsverktøyet. Du må aktivere \"Kjør ActiveXkontroller og plugins\". Du kan oppleve feil og advarsler om manglende funksjoner",
BrowseServerBlocked : "Kunne ikke åpne dialogboksen for filarkiv. Pass på at du har slått av popupstoppere.",
DialogBlocked		: "Kunne ikke åpne dialogboksen. Pass på at du har slått av popupstoppere.",

// Dialogs
DlgBtnOK			: "OK",
DlgBtnCancel		: "Avbryt",
DlgBtnClose			: "Lukk",
DlgBtnBrowseServer	: "Bla igjennom server",
DlgAdvancedTag		: "Avansert",
DlgOpOther			: "<Annet>",
DlgInfoTab			: "Info",
DlgAlertUrl			: "Vennligst skriv inn URL'en",

// General Dialogs Labels
DlgGenNotSet		: "<ikke satt>",
DlgGenId			: "Id",
DlgGenLangDir		: "Språkretning",
DlgGenLangDirLtr	: "Venstre til høyre (VTH)",
DlgGenLangDirRtl	: "Høyre til venstre (HTV)",
DlgGenLangCode		: "Språk kode",
DlgGenAccessKey		: "Aksessknapp",
DlgGenName			: "Navn",
DlgGenTabIndex		: "Tab Indeks",
DlgGenLongDescr		: "Utvidet beskrivelse",
DlgGenClass			: "Stilarkklasser",
DlgGenTitle			: "Tittel",
DlgGenContType		: "Type",
DlgGenLinkCharset	: "Lenket språkkart",
DlgGenStyle			: "Stil",

// Image Dialog
DlgImgTitle			: "Bildeegenskaper",
DlgImgInfoTab		: "Bildeinformasjon",
DlgImgBtnUpload		: "Send det til serveren",
DlgImgURL			: "URL",
DlgImgUpload		: "Last opp",
DlgImgAlt			: "Alternativ tekst",
DlgImgWidth			: "Bredde",
DlgImgHeight		: "Høyde",
DlgImgLockRatio		: "Lås forhold",
DlgBtnResetSize		: "Tilbakestill størrelse",
DlgImgBorder		: "Ramme",
DlgImgHSpace		: "HMarg",
DlgImgVSpace		: "VMarg",
DlgImgAlign			: "Juster",
DlgImgAlignLeft		: "Venstre",
DlgImgAlignAbsBottom: "Abs bunn",
DlgImgAlignAbsMiddle: "Abs midten",
DlgImgAlignBaseline	: "Bunnlinje",
DlgImgAlignBottom	: "Bunn",
DlgImgAlignMiddle	: "Midten",
DlgImgAlignRight	: "Høyre",
DlgImgAlignTextTop	: "Tekst topp",
DlgImgAlignTop		: "Topp",
DlgImgPreview		: "Forhåndsvis",
DlgImgAlertUrl		: "Vennligst skriv bildeurlen",
DlgImgLinkTab		: "Lenke",

// Flash Dialog
DlgFlashTitle		: "Flash Egenskaper",
DlgFlashChkPlay		: "Auto Spill",
DlgFlashChkLoop		: "Loop",
DlgFlashChkMenu		: "Slå på Flash meny",
DlgFlashScale		: "Skaler",
DlgFlashScaleAll	: "Vis alt",
DlgFlashScaleNoBorder	: "Ingen ramme",
DlgFlashScaleFit	: "Skaler til å passeExact Fit",

// Link Dialog
DlgLnkWindowTitle	: "Lenke",
DlgLnkInfoTab		: "Lenkeinfo",
DlgLnkTargetTab		: "Mål",

DlgLnkType			: "Lenketype",
DlgLnkTypeURL		: "URL",
DlgLnkTypeAnchor	: "Lenke til bokmerke i teksten",
DlgLnkTypeEMail		: "E-Post",
DlgLnkProto			: "Protokoll",
DlgLnkProtoOther	: "<annet>",
DlgLnkURL			: "URL",
DlgLnkAnchorSel		: "Velg ett anker",
DlgLnkAnchorByName	: "Anker etter navn",
DlgLnkAnchorById	: "Element etter ID",
DlgLnkNoAnchors		: "<Ingen anker i dokumentet>",
DlgLnkEMail			: "E-Post Addresse",
DlgLnkEMailSubject	: "Meldingsemne",
DlgLnkEMailBody		: "Melding",
DlgLnkUpload		: "Last opp",
DlgLnkBtnUpload		: "Send til server",

DlgLnkTarget		: "Mål",
DlgLnkTargetFrame	: "<ramme>",
DlgLnkTargetPopup	: "<popup vindu>",
DlgLnkTargetBlank	: "Nytt vindu (_blank)",
DlgLnkTargetParent	: "Foreldre vindu (_parent)",
DlgLnkTargetSelf	: "Samme vindu (_self)",
DlgLnkTargetTop		: "Hele vindu (_top)",
DlgLnkTargetFrameName	: "Målramme",
DlgLnkPopWinName	: "Popup vindus navn",
DlgLnkPopWinFeat	: "Popup vindus egenskaper",
DlgLnkPopResize		: "Endre størrelse",
DlgLnkPopLocation	: "Adresselinje",
DlgLnkPopMenu		: "Menylinje",
DlgLnkPopScroll		: "Scrollbar",
DlgLnkPopStatus		: "Statuslinje",
DlgLnkPopToolbar	: "Verktøylinje",
DlgLnkPopFullScrn	: "Full skjerm (IE)",
DlgLnkPopDependent	: "Avhenging (Netscape)",
DlgLnkPopWidth		: "Bredde",
DlgLnkPopHeight		: "Høyde",
DlgLnkPopLeft		: "Venstre posisjon",
DlgLnkPopTop		: "Topp posisjon",

DlnLnkMsgNoUrl		: "Vennligst skriv inn lenkens url",
DlnLnkMsgNoEMail	: "Vennligst skriv inn e-postadressen",
DlnLnkMsgNoAnchor	: "Vennligst velg ett anker",
DlnLnkMsgInvPopName	: "The popup name must begin with an alphabetic character and must not contain spaces",	//MISSING

// Color Dialog
DlgColorTitle		: "Velg farge",
DlgColorBtnClear	: "Tøm",
DlgColorHighlight	: "Marker",
DlgColorSelected	: "Velg",

// Smiley Dialog
DlgSmileyTitle		: "Sett inn smil",

// Special Character Dialog
DlgSpecialCharTitle	: "Velg spesielt tegn",

// Table Dialog
DlgTableTitle		: "Tabellegenskaper",
DlgTableRows		: "Rader",
DlgTableColumns		: "Kolonner",
DlgTableBorder		: "Rammestørrelse",
DlgTableAlign		: "Justering",
DlgTableAlignNotSet	: "<Ikke satt>",
DlgTableAlignLeft	: "Venstre",
DlgTableAlignCenter	: "Midtjuster",
DlgTableAlignRight	: "Høyre",
DlgTableWidth		: "Bredde",
DlgTableWidthPx		: "pixler",
DlgTableWidthPc		: "prosent",
DlgTableHeight		: "Høyde",
DlgTableCellSpace	: "Celle marg",
DlgTableCellPad		: "Celle polstring",
DlgTableCaption		: "Tittel",
DlgTableSummary		: "Sammendrag",

// Table Cell Dialog
DlgCellTitle		: "Celle egenskaper",
DlgCellWidth		: "Bredde",
DlgCellWidthPx		: "pixeler",
DlgCellWidthPc		: "prosent",
DlgCellHeight		: "Høyde",
DlgCellWordWrap		: "Tekstbrytning",
DlgCellWordWrapNotSet	: "<Ikke satt>",
DlgCellWordWrapYes	: "Ja",
DlgCellWordWrapNo	: "Nei",
DlgCellHorAlign		: "Horisontal justering",
DlgCellHorAlignNotSet	: "<Ikke satt>",
DlgCellHorAlignLeft	: "Venstre",
DlgCellHorAlignCenter	: "Midtjuster",
DlgCellHorAlignRight: "Høyre",
DlgCellVerAlign		: "Vertikal justering",
DlgCellVerAlignNotSet	: "<Ikke satt>",
DlgCellVerAlignTop	: "Topp",
DlgCellVerAlignMiddle	: "Midten",
DlgCellVerAlignBottom	: "Bunn",
DlgCellVerAlignBaseline	: "Bunnlinje",
DlgCellRowSpan		: "Radspenn",
DlgCellCollSpan		: "Kolonnespenn",
DlgCellBackColor	: "Bakgrunnsfarge",
DlgCellBorderColor	: "Rammefarge",
DlgCellBtnSelect	: "Velg...",

// Find Dialog
DlgFindTitle		: "Finn",
DlgFindFindBtn		: "Finn",
DlgFindNotFoundMsg	: "Den spesifiserte teksten ble ikke funnet.",

// Replace Dialog
DlgReplaceTitle			: "Erstatt",
DlgReplaceFindLbl		: "Finn hva:",
DlgReplaceReplaceLbl	: "Erstatt med:",
DlgReplaceCaseChk		: "Riktig case",
DlgReplaceReplaceBtn	: "Erstatt",
DlgReplaceReplAllBtn	: "Erstatt alle",
DlgReplaceWordChk		: "Finn hele ordet",

// Paste Operations / Dialog
PasteErrorPaste	: "Din nettlesers sikkerhetsinstillinger tillater ikke automatisk innliming av tekst. Vennligst brukt snareveien (Ctrl+V).",
PasteErrorCut	: "Din nettlesers sikkerhetsinstillinger tillater ikke automatisk klipping av tekst. Vennligst brukt snareveien (Ctrl+X).",
PasteErrorCopy	: "Din nettlesers sikkerhetsinstillinger tillater ikke automatisk kopiering av tekst. Vennligst brukt snareveien (Ctrl+C).",

PasteAsText		: "Lim inn som ren tekst",
PasteFromWord	: "Lim inn fra word",

DlgPasteMsg2	: "Vennligst lim inn i den følgende boksen med tastaturet (<STRONG>Ctrl+V</STRONG>) og trykk <STRONG>OK</STRONG>.",
DlgPasteIgnoreFont		: "Fjern skrifttyper",
DlgPasteRemoveStyles	: "Fjern stildefinisjoner",
DlgPasteCleanBox		: "Tøm boksen",

// Color Picker
ColorAutomatic	: "Automatisk",
ColorMoreColors	: "Flere farger...",

// Document Properties
DocProps		: "Dokumentegenskaper",

// Anchor Dialog
DlgAnchorTitle		: "Ankeregenskaper",
DlgAnchorName		: "Ankernavn",
DlgAnchorErrorName	: "Vennligst skriv inn ankernavnet",

// Speller Pages Dialog
DlgSpellNotInDic		: "Ikke i ordboken",
DlgSpellChangeTo		: "Endre til",
DlgSpellBtnIgnore		: "Ignorer",
DlgSpellBtnIgnoreAll	: "Ignorer alle",
DlgSpellBtnReplace		: "Erstatt",
DlgSpellBtnReplaceAll	: "Erstatt alle",
DlgSpellBtnUndo			: "Angre",
DlgSpellNoSuggestions	: "- ingen forslag -",
DlgSpellProgress		: "Stavekontroll pågår...",
DlgSpellNoMispell		: "Stavekontroll fullført: ingen feilstavinger funnet",
DlgSpellNoChanges		: "Stavekontroll fullført: ingen ord endret",
DlgSpellOneChange		: "Stavekontroll fullført: Ett ord endret",
DlgSpellManyChanges		: "Stavekontroll fullført: %1 ord endret",

IeSpellDownload			: "Stavekontroll ikke installert, vil du laste den ned nå?",

// Button Dialog
DlgButtonText		: "Tekst",
DlgButtonType		: "Type",
DlgButtonTypeBtn	: "Button",	//MISSING
DlgButtonTypeSbm	: "Submit",	//MISSING
DlgButtonTypeRst	: "Reset",	//MISSING

// Checkbox and Radio Button Dialogs
DlgCheckboxName		: "Navn",
DlgCheckboxValue	: "Verdi",
DlgCheckboxSelected	: "Valgt",

// Form Dialog
DlgFormName		: "Navn",
DlgFormAction	: "Handling",
DlgFormMethod	: "Metode",

// Select Field Dialog
DlgSelectName		: "Navn",
DlgSelectValue		: "Verdi",
DlgSelectSize		: "Størrelse",
DlgSelectLines		: "Linjer",
DlgSelectChkMulti	: "Tillat flervalg",
DlgSelectOpAvail	: "Tilgjenglige alternativer",
DlgSelectOpText		: "Tekst",
DlgSelectOpValue	: "Verdi",
DlgSelectBtnAdd		: "Legg til",
DlgSelectBtnModify	: "Endre",
DlgSelectBtnUp		: "Opp",
DlgSelectBtnDown	: "Ned",
DlgSelectBtnSetValue : "Sett som valgt",
DlgSelectBtnDelete	: "Slett",

// textarea Dialog
DlgtextareaName	: "Navn",
DlgtextareaCols	: "Kolonner",
DlgtextareaRows	: "Rader",

// Text Field Dialog
DlgTextName			: "Navn",
DlgTextValue		: "verdi",
DlgTextCharWidth	: "Tegnbredde",
DlgTextMaxChars		: "Maks antall tegn",
DlgTextType			: "Type",
DlgTextTypeText		: "Tekst",
DlgTextTypePass		: "Passord",

// Hidden Field Dialog
DlgHiddenName	: "Navn",
DlgHiddenValue	: "Verdi",

// Bulleted List Dialog
BulletedListProp	: "Uordnet listeegenskaper",
NumberedListProp	: "Ordnet listeegenskaper",
DlgLstStart			: "Start",	//MISSING
DlgLstType			: "Type",
DlgLstTypeCircle	: "Sirkel",
DlgLstTypeDisc		: "Hel sirkel",
DlgLstTypeSquare	: "Firkant",
DlgLstTypeNumbers	: "Numre(1, 2, 3)",
DlgLstTypeLCase		: "Små bokstaver (a, b, c)",
DlgLstTypeUCase		: "Store bokstaver(A, B, C)",
DlgLstTypeSRoman	: "Små romerske tall(i, ii, iii)",
DlgLstTypeLRoman	: "Store romerske tall(I, II, III)",

// Document Properties Dialog
DlgDocGeneralTab	: "Generalt",
DlgDocBackTab		: "Bakgrunn",
DlgDocColorsTab		: "Farger og marginer",
DlgDocMetaTab		: "Meta Data",

DlgDocPageTitle		: "Sidetittel",
DlgDocLangDir		: "Språkretning",
DlgDocLangDirLTR	: "Venstre til høyre (LTR)",
DlgDocLangDirRTL	: "Høyre til venstre (RTL)",
DlgDocLangCode		: "Språkkode",
DlgDocCharSet		: "Tegnsett",
DlgDocCharSetCE		: "Central European",	//MISSING
DlgDocCharSetCT		: "Chinese Traditional (Big5)",	//MISSING
DlgDocCharSetCR		: "Cyrillic",	//MISSING
DlgDocCharSetGR		: "Greek",	//MISSING
DlgDocCharSetJP		: "Japanese",	//MISSING
DlgDocCharSetKR		: "Korean",	//MISSING
DlgDocCharSetTR		: "Turkish",	//MISSING
DlgDocCharSetUN		: "Unicode (UTF-8)",	//MISSING
DlgDocCharSetWE		: "Western European",	//MISSING
DlgDocCharSetOther	: "Annet tegnsett",

DlgDocDocType		: "Dokumenttype header",
DlgDocDocTypeOther	: "Annet dokumenttype header",
DlgDocIncXHTML		: "Inkulder XHTML deklarasjon",
DlgDocBgColor		: "Bakgrunnsfarge",
DlgDocBgImage		: "Bakgrunnsbilde url",
DlgDocBgNoScroll	: "Ikke scroll bakgrunnsbilde",
DlgDocCText			: "Tekst",
DlgDocCLink			: "Link",
DlgDocCVisited		: "Besøkt lenke",
DlgDocCActive		: "Aktiv lenke",
DlgDocMargins		: "Sidemargin",
DlgDocMaTop			: "Topp",
DlgDocMaLeft		: "Venstre",
DlgDocMaRight		: "Høyre",
DlgDocMaBottom		: "Bunn",
DlgDocMeIndex		: "Dokument nøkkelord (kommaseparert)",
DlgDocMeDescr		: "Dokumentbeskrivelse",
DlgDocMeAuthor		: "Forfatter",
DlgDocMeCopy		: "Kopirett",
DlgDocPreview		: "Forhåndsvising",

// Templates Dialog
Templates			: "Maler",
DlgTemplatesTitle	: "Innholdsmaler",
DlgTemplatesSelMsg	: "Velg malen du vil åpne<br>(innholdet du har skrevet blir tapt!):",
DlgTemplatesLoading	: "Laster malliste. Vennligst vent...",
DlgTemplatesNoTpl	: "(Ingen maler definert)",
DlgTemplatesReplace	: "Replace actual contents",	//MISSING

// About Dialog
DlgAboutAboutTab	: "Om",
DlgAboutBrowserInfoTab	: "Nettleserinfo",
DlgAboutLicenseTab	: "Lisens",
DlgAboutVersion		: "versjon",
DlgAboutLicense		: "Lisensiert under GNU Lesser General Public License",
DlgAboutInfo		: "Oversatt av Siteman AS<br /><a target=\"_blank\" href=\"http://www.siteman.no\">www.siteman.no</a><br /><br />For mer informasjon gå til"
}