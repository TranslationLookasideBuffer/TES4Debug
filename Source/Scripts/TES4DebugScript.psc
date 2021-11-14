ScriptName TES4DebugScript Extends Quest  

Actor Property PlayerRef Auto

UILIB_1 UILib
String[] HexDigits

Int LocationDebugKey = 55 ; Num*

Event OnInit()
	RegisterKeys()
	; get the attached UILIB_1 instance
	UILib = (((Self as Quest) as Form) as UILIB_1)

    HexDigits = New String[16]
    ; Doing this here prevents a series of function calls later.
    HexDigits[0] = "0"
    HexDigits[1] = "1"
    HexDigits[2] = "2"
    HexDigits[3] = "3"
    HexDigits[4] = "4"
    HexDigits[5] = "5"
    HexDigits[6] = "6"
    HexDigits[7] = "7"
    HexDigits[8] = "8"
    HexDigits[9] = "9"
    HexDigits[10] = "A"
    HexDigits[11] = "B"
    HexDigits[12] = "C"
    HexDigits[13] = "D"
    HexDigits[14] = "E"
    HexDigits[15] = "F"
EndEvent

Event OnKeyDown(Int KeyCode)
    If !UI.IsMenuOpen("Dialogue Menu") && !utility.IsInMenuMode() && !UI.IsTextInputEnabled()
        If keyCode == LocationDebugKey
			RetrievePlayerLocation()
        EndIf
    EndIf
EndEvent

Function RegisterKeys()
	RegisterForKey(LocationDebugKey)
EndFunction

Function RetrievePlayerLocation()
    ; Disable menu controls and the ability to activate objects.
	Game.DisablePlayerControls(False, False, False, False, False, True, True, False, 0)
    Int xPos = Math.Floor(PlayerRef.GetPositionX())
    Int yPos = Math.Floor(PlayerRef.GetPositionY())
    Int zPos = Math.Floor(PlayerRef.GetPositionZ())
	Int xCell = xPos / 4096
	Int yCell = yPos / 4096
    String cellName = PlayerRef.GetParentCell().GetName()
    String locationName = PlayerRef.GetCurrentLocation().GetName()
	String weatherId = DecToHex(Weather.GetCurrentWeather().GetFormID())
	Debug.MessageBox("Postion: (" + xPos + ", " + yPos + ", " + zPos + ")\n" \
        + "Cell: (" + xCell + ", " + yCell + ") " + cellName + "\n" \
        + "Weather ID: " + weatherId + "\n" \
        + "Location: " + locationName)
	Game.EnablePlayerControls(False, False, False, False, False, True, True, False, 0)
EndFunction

String Function DecToHex(Int Decimal)
    String[] result = New String[8]
    Int i = 8
    While i > 0
        i -= 1
        result[i] = HexDigits[Math.LogicalAnd(0xF, Decimal)]
        Decimal /= 16
    EndWhile
    ; While we could assemble the string in the previous loop,
    ; doing so sometimes results in odd changes in case. For
    ; example, a hex string that ends with "EE" would be changed
    ; to end in "ee" which is just annoying. However if the
    ; string is assembled in order as done here, this issue does
    ; no occur.
    String hex
    While i < 8
        hex += result[i]
        i += 1
    EndWhile
    Return hex
EndFunction
