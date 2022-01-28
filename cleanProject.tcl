#!/bin/tclsh
proc strToList {vStr} {
    append vStr " "
    set lResult ""
    set i1 0
    for {set i 0} {$i < [string length $vStr]} {incr i} {
        if {[string index $vStr $i] == " "} {
            set i2 $i
            lappend lResult [string range $vStr $i1 [expr $i2 -1]]
            set i1 [expr $i2 + 1]
        }
    }
    return $lResult
}

proc main {} {
    set files [glob *]
    set lFiles [strToList $files]
    set deleteList ""
    for {set i 0} {$i < [llength $lFiles]} {incr i} {
      set strTemp [lindex $lFiles $i]
      if {[string first ".tcl" $strTemp] >= 0} {
        set strTemp ""
      }
      if {[string first "awthemes" $strTemp] >= 0} {
        set strTemp ""
      }

      if {[string first ".cfg" $strTemp] >=0} {
        set strTemp ""
      }
      if {[string first "wget" $strTemp] >=0} {
        set strTemp ""
      }
      if {[string first "7z" $strTemp] >=0} {
        set strTemp ""
      }

      if {$strTemp != ""} {
        lappend deleteList $strTemp
      }
    }

    for {set i 0} {$i < [llength $deleteList]} {incr i} {
        file delete -force [lindex $deleteList $i]
    }
}

::main
