#!/bin/wish
lappend auto_path "./awthemes"

package require awdark
package require Tk
package require platform

#configure style
ttk::style theme use awdark
. configure -background [::ttk::style lookup TFrame -background]
font configure TkDefaultFont -family Helvetica -size 14
global variable arrayGames
global variable arrayMaps
global variable arrayMods
global variable modId

proc strToList {vStr vDelimiter} {
    append vStr $vDelimiter
    set lResult ""
    set i1 0
    for {set i 0} {$i < [string length $vStr]} {incr i} {
        if {[string index $vStr $i] == $vDelimiter} {
            set i2 $i
            set strTemp [string range $vStr $i1 [expr $i2 -1]]
            if {$strTemp != ""} {lappend lResult $strTemp}
            set i1 [expr $i2 + 1]
        }
    }
    return $lResult
}

proc listToStr {vList vDelimiter} {
    set tmpStr ""
    for {set i 0} {$i < [llength $vList]} {incr i} {
        if {$i < [expr [llength $vList] -1 ]} {
            append tmpStr "[lindex $vList $i],"
        } else {
            append tmpStr [lindex $vList $i]
        }
    }
    return $tmpStr
}

proc readCSV {} {
    upvar arrayGames arrayGames
    upvar arrayMaps arrayMaps
    upvar arrayMods arrayMods

    set idxGames 0
    set idxMaps 0
    set idxMods 0

    set csv [open "games.csv" r]
    while { [gets $csv data] >= 0 } {
        if {[string index $data 0] != {#}} {
            set listTemp [strToList $data ","]
            
            if {[lindex $listTemp 2] == "0"} {
                set arrayGames($idxGames) $listTemp
                incr idxGames
            }

            if {[lindex $listTemp 2] == "1"} {
                set arrayMaps($idxMaps) $listTemp
                incr idxMaps
            }
        }
    }

    for {set i 0} {$i < [array size arrayGames]} {incr i} {
        .lstStart insert $i [lindex $arrayGames($i) 1]
    }

    for {set i 0} {$i < [array size arrayMaps]} {incr i} {
        .lstMap insert $i [lindex $arrayMaps($i) 1]
    }
    close $csv

    set arrayMods(0) "none"
    incr idxMods

    set csv [open "mods.csv" r]
    while { [gets $csv data] >= 0 } {
        if {[string index $data 0] != {#}} {
            set arrayMods($idxMods) [strToList $data ","]
            incr idxMods
        }
    }
    close $csv

    .comboMods set "none"
    .comboMods configure -state readonly
}

proc listMods {csvLine} {
    upvar arrayMods arrayMods
	upvar idMods idMods

    set listTemp ""
    set modSet [lindex $csvLine 3]
	
    lappend listTemp "none"
	set idMods(0) 0
	set idCombo 1
	
    for {set i 0} {$i < [array size arrayMods]} {incr i} {
        if {$modSet == [lindex $arrayMods($i) 2]} {
            lappend listTemp [lindex $arrayMods($i) 1]
			set idMods($idCombo) [lindex $arrayMods($i) 0]
			incr idCombo			
        }
    }

    .comboMods set ""
    .comboMods configure -state readonly
    .comboMods configure -values $listTemp
	for {set i 0} {$i < [array size idMods]} {incr i} {
		if {$idMods($i) == [lindex $csvLine 4]} {
			.comboMods current $i
		}
	}
	
}

proc getSelectedIndex {vListBox} {
    for {set i 0} {$i < [$vListBox size]} {incr i} {
        if {[$vListBox get active] == [$vListBox get $i]} {
            return $i
        }
    }

    return 0
}

proc execGzdoom {csvLine} {
    upvar arrayMods arrayMods
	upvar idMods idMods
	

    set ::env(DOOMWADDIR) wad

    if {[string first "win" [platform::generic]] >= 0} {
		set cmdStr "exec -ignorestderr ./gzdoom/gzdoom.exe"
	} else {
		set cmdStr "exec -ignorestderr ./gzdoom/gzdoom"
	}

    append cmdStr " -iwad [lindex $csvLine 5]"

    if {[.comboMods get] != "none"} {
        set arrayLine $arrayMods($idMods([.comboMods current]))
        append cmdStr " -file"

        for {set i 3} {$i < [llength $arrayLine]} {incr i} {
            append cmdStr " mods/[lindex $arrayLine $i]"
        }
    } else {
        set arrayLine "0"
    }

    if {[lindex $csvLine 6] != ""} {
        if {[string first "-file" $cmdStr] < 0} {
            append cmdStr " -file"
        }

        for {set i 6} {$i < [llength $csvLine]} {incr i} {
          append cmdStr " [lindex $csvLine $i]"
        }
    }


    append $cmdStr " &"

    set csv [open "games.csv" r]
    set i 0
    while { [gets $csv data] >= 0 } {
        set tmpArray($i) $data
        incr i
    }
    close $csv

    set csv [open "games_new.csv" w+]
    for {set i 0} {$i < [array size tmpArray]} {incr i} {
        if {[strToList $tmpArray($i) ","] == $csvLine} {
            set csvLine [lreplace $csvLine 4 4 [lindex $arrayLine 0]]
            set tmpArray($i) [listToStr $csvLine ","]
        }
        puts $csv $tmpArray($i)
    }
    close $csv

    file rename -force "games_new.csv" "games.csv"

    set tmpCommand [open "tmpCommand.tcl" w+]
    puts $tmpCommand $cmdStr
    close $tmpCommand
    source tmpCommand.tcl
    file delete -force tmpCommand.tcl

    exit;
}

proc bindEvents {} {
    bind . <Return> {
        #line for test purposes
        if {$currentList == ".lstStart"} {
            execGzdoom "$arrayGames([getSelectedIndex .lstStart])"
        } else {
            execGzdoom "$arrayMaps([getSelectedIndex .lstMap])"
        }
    }

    bind . <Escape> {
        exit
    }

    bind . <<NotebookTabChanged>> {
        if {[.nbMain select] == ".frmStart"} {set currentList ".lstStart"}
        if {[.nbMain select] == ".frmMap"} {set currentList ".lstMap"}
        $currentList selection set [getSelectedIndex $currentList]
        set sIndex [getSelectedIndex $currentList]
        if {$currentList == ".lstStart"} {
            listMods "$arrayGames($sIndex)"
        } else {
            listMods "$arrayMaps($sIndex)"
        }
        set sIndexAnt $sIndex
        focus $currentList
    }

    bind . <Up> {
        set sIndex [getSelectedIndex $currentList]
        event generate . <<btnRelease>>
        focus $currentList
    }


    bind . <Down> {
        set sIndex [getSelectedIndex $currentList]
        event generate . <<btnRelease>>
        focus $currentList
    }

    bind . <<ListboxSelect>> {
        if {$sIndexAnt != $sIndex} {
            if {$currentList == ".lstStart"} {
                listMods "$arrayGames($sIndex)"
            } else {
                listMods "$arrayMaps($sIndex)"
            }
            set sIndexAnt $sIndex
        }
    }

    bind . <<btnRelease>> {
        $currentList selection clear 0 end
        $currentList selection set $sIndex
        event generate . <<ListboxSelect>>
    }

    bind .lstStart <ButtonRelease-1> {
        set sIndex [$currentList curselection]
        event generate . <<btnRelease>>
    }

    bind .lstMap <ButtonRelease-1> {
        set sIndex [$currentList curselection]
        event generate . <<btnRelease>>
    }

    bind . <Right> {
        .nbMain select 1
    }

    bind . <Left> {
        .nbMain select 0
    }

    bind . <space> {
        set cmbSize [llength [.comboMods cget -values]]
        if {[expr $cmbSize - 1] > [.comboMods current]} {
            .comboMods current [expr [.comboMods current] + 1]
        } else {
            .comboMods current 0
        }
    }
}

proc centerWindow {window} {
	wm withdraw $window
	update idletasks

	set width  [winfo reqwidth  $window]
	set height [winfo reqheight $window]

	toplevel [set testWin ".__test_screen_size__[incr UID]"]
    wm withdraw $testWin
	if {[string first "win" [platform::generic]] >= 0} {
        wm state $testWin zoomed
        set yOffset 0
    } else {
        set testX [winfo screenwidth $testWin]
        set testY [winfo screenheight $testWin]
        set testGeometry "${testX}x${testY}+0+0"
        catch {set testGeometry [exec xrandr | grep primary | cut -f 4-4 -d " "]} ; #some distributions may not come with xrandr installed
        wm deiconify $testWin
        wm geometry $testWin $testGeometry
        set yOffset 38 ; #my computer's window decoration size, may be different for others. I will try to code something later
    }
    update idletasks
    puts [wm geometry $testWin]
    set x [expr { ([winfo width $testWin] - $width) / 2 }]
    set y [expr { ([winfo height $testWin] - $height) / 2 - $yOffset}]
    destroy $testWin

	wm geometry $window ${width}x${height}+${x}+${y}
	wm deiconify $window
}

proc main {args} {
    upvar arrayGames arrayGames
    upvar arrayMaps arrayMaps
    upvar arrayMods arrayMods

    #set main window attributes
    wm title . "Choose your destiny!"
    wm resizable . 0 0

    #create widgets
    ttk::notebook .nbMain
    ttk::frame .frmStart
    ttk::frame .frmMap
    ttk::frame .frmCombo

    set listSize 1
    if {[array size arrayGames] >= [array size arrayMaps]} {
        set listSize [array size arrayGames]
    } else {
        set listSize [array size arrayMaps]
    }

    font create defaultFont -family Helvetica -size 14

    #width was to display "Back to Saturn X E2: Tower in the Fountain of Sparks" map name
    listbox .lstStart -activestyle dotbox -selectmode single -width 42 -heigh $listSize
    listbox .lstMap  -activestyle dotbox -selectmode single -width 42 -heigh $listSize
    ttk::label .lblMods -text "Mod set:"
    ttk::combobox .comboMods -font defaultFont
    ttk::button .btnRun -text "OK" -command "event generate . <Return>"
    ttk::button .btnCancel -text "Cancel" -command "event generate . <Escape>"

    readCSV
    bindEvents

    #put all widigets at the screen
    pack .lstStart -in .frmStart
    pack .lstMap -in .frmMap
    .nbMain add .frmStart -text {Start Game}
    .nbMain add .frmMap -text {Start Map}
    pack .nbMain
    pack .lblMods -in .frmCombo -side left -padx 4
    pack .comboMods -in .frmCombo -padx 4 -pady 4 -side left
    pack .frmCombo -expand 1 -fill x
    pack .btnCancel -padx 4 -pady 4 -side right
    pack .btnRun -padx 4 -pady 4 -side right

    .lstStart activate 0
    .lstStart selection set 0   
    
    #bind events

    #move the window to the center of the screen, not working as intended I need to correct
	centerWindow .	
    focus .lstStart
}

::main
