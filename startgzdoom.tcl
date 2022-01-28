#!/bin/wish
lappend auto_path "./awthemes"

package require awdark
package require Tk
package require platform

ttk::style theme use awdark
. configure -background [::ttk::style lookup TFrame -background]

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

            if {[lindex $listTemp 2] == {game}} {
                set arrayGames($idxGames) $listTemp
                incr idxGames
            }

            if {[lindex $listTemp 2] == {mod}} {
                set arrayMods($idxMods) $listTemp
                incr idxMods
            }

            if {[lindex $listTemp 2] == {map}} {
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

font configure TkDefaultFont -size 14

proc main {args} {

    #set main window attributes
    wm title . "Choose your destiny!"
    wm resizable . 0 0

    #create widgets
    ttk::notebook .nbMain
    ttk::frame .frmStart
    ttk::frame .frmMap
    ttk::frame .frmButtons
    listbox .lstStart -activestyle dotbox -selectmode single -width 38 -heigh [array size arrayGames]
    listbox .lstMap  -activestyle dotbox -selectmode single -width 38 -heigh [array size arrayMaps]
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

    #move the window to the center of the screen
    update
    set wHeight [expr 1920 / 2 - [winfo height .] / 2]
    set wWidth [expr 1080 / 2 - [winfo width .] / 2]
    set wGeometry +$wHeight+$wWidth
    wm geometry . $wGeometry
    focus .lstStart
}

::main
