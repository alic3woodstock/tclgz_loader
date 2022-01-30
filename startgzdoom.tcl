#!/bin/wish
lappend auto_path "./awthemes"

package require awdark
package require Tk
package require platform

#configure style
ttk::style theme use awdark
. configure -background [::ttk::style lookup TFrame -background]
font configure TkDefaultFont -size 14

global variable arrayGames
global variable arrayMaps
global variable arrayMods

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

#    puts $listGames
}

proc getSelectedIndex {vListBox} {
    for {set i 0} {$i < [$vListBox size]} {incr i} {
        if {[$vListBox get active] == [$vListBox get $i]} {
            return $i
        }
    }

    return 0
}

proc main {args} {

    #set main window attributes
    wm title . "Choose your destiny!"
    wm resizable . 0 0

    #create widgets
    ttk::notebook .nbMain
    ttk::frame .frmStart
    ttk::frame .frmMap
    ttk::frame .frmButtons

    set listSize 1
    if {[array size arrayGames] >= [array size arrayMaps]} {
        set listSize [array size arrayGames]
    } else {
        set listSize [array size arrayMaps]
    }

    listbox .lstStart -activestyle dotbox -selectmode single -width 38 -heigh $listSize
    listbox .lstMap  -activestyle dotbox -selectmode single -width 38 -heigh $listSize
    ttk::button .btnRun -text "OK" -command "event generate . <Return>"
    ttk::button .btnCancel -text "Cancel" -command "event generate . <Escape>"

    #put all widigets at the screen
    pack .lstStart -in .frmStart
    pack .lstMap -in .frmMap
    .nbMain add .frmStart -text {Start Game}
    .nbMain add .frmMap -text {Start Map}
    pack .nbMain
    pack .btnCancel -padx 4 -pady 4 -side right
    pack .btnRun -padx 4 -pady 4 -side right

    readCSV

    .lstStart activate 0
    .lstStart selection set 0   
    
    bind . <<startApp>> {
        set currentList ".lstStart"
    }       
    event generate . <<startApp>>
    
    bind . <Return> {
        #line for test purposes
        puts [getSelectedIndex $currentList]
    }

    #move the window to the center of the screen, not working as intended I need to correct
    update
    set wHeight [expr 1920 / 2 - [winfo height .] / 2]
    set wWidth [expr 1080 / 2 - [winfo width .] / 2]
    set wGeometry +$wHeight+$wWidth
    wm geometry . $wGeometry
    focus .lstStart
}

::main
