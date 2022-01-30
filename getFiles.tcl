#!/bin/tclsh
package require platform

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

proc genCSV {} {
    if {![file exists "game.csv"]} {
        set csvGames [open "games.csv" w]
        puts $csvGames "#games"
        close $csvGames

        set csvGames [open "games.csv" a]
        puts $csvGames "#id,name,type,mod suport,config,iwad,file1,file2,file3,file4,file5,file6,file7,file8,file9"
        puts $csvGames "0,Blasphemer,game,fasle,gzdoom.cfg,blasphem-0.1.7.wad,wad/BLSMPTXT.WAD"
        puts $csvGames "1,Freedoom Phase 1,game,true,gzdoom.cfg,freedoom1.wad"
        puts $csvGames "2,Freedoom Phase 2,game,true,gzdoom.cfg,freedoom2.wad"
        puts $csvGames "#Mods"
        puts $csvGames "#id,name,type,file1,file1,file2,file3,file4,file5,file6,file7,file8,file9"
        puts $csvGames "3,Beaultiful Doom,mod,mods/Beautiful_Doom_716.pk3"
        puts $csvGames "4,Brutal Doom,mod,mods/brutalv21.11.2.pk3"
        puts $csvGames "#maps"
        puts $csvGames "#id,name,type,mod suport,config,iwad,file1,file2,file3,file4,file5,file6,file7,file8,file9"
        puts $csvGames "1,Eviternity,map,true,gzdoom.cfg,freedoom2.wad,maps/Eviternity.wad"
        puts $csvGames "1,Memento Mori,map,true,gzdoom.cfg,freedoom2.wad,maps/MM.wad,MMMUS.WAD"
        close $csvGames
    }
}

proc downloadFiles {} {
        set wget "./wget"
        file delete -force temp
        file mkdir downloads

        #gzdoom
        exec -ignorestderr $wget -c https://github.com/coelckers/gzdoom/releases/download/g4.7.1/gzdoom_4.7.1_amd64.deb -P downloads
    #     exec mv gzdoom_4.7.1_amd64.deb downloads/gzdoom_4.7.1_amd64.deb

        #blasphemer
        exec -ignorestderr $wget -c https://github.com/Blasphemer/blasphemer/releases/download/v0.1.7/blasphem-0.1.7.zip -P downloads
        exec -ignorestderr $wget -c https://github.com/Blasphemer/blasphemer/releases/download/v0.1.7/blasphemer-texture-pack.zip -P downloads

        #freedoom
        exec -ignorestderr $wget -c https://github.com/freedoom/freedoom/releases/download/v0.12.1/freedoom-0.12.1.zip -P downloads

        #beaultiful doom
        exec -ignorestderr $wget -c https://github.com/jekyllgrim/Beautiful-Doom/releases/download/7.1.6/Beautiful_Doom_716.pk3 -P downloads

        #brutal doom
        exec -ignorestderr $wget -c https://github.com/BLOODWOLF333/Brutal-Doom-Community-Expansion/releases/download/V21.11.2/brutalv21.11.2.pk3 -P downloads

        #maps
        exec -ignorestderr $wget -c https://www.quaddicted.com/files/idgames/levels/doom2/Ports/megawads/eviternity.zip -P downloads
        exec -ignorestderr $wget -c https://www.quaddicted.com/files/idgames/themes/mm/mm_allup.zip -P downloads
        exec -ignorestderr $wget -c https://www.quaddicted.com/files/idgames/themes/mm/mm2.zip -P downloads        
}

proc main {} {
    if {[string first "win" [platform::generic]] >= 0} {
    } else {
        set sevenzip "./7zzs"
        set wget "./wget"
        
        downloadFiles

        file mkdir temp

        puts "extractiong gzdoom..."
        exec -ignorestderr $sevenzip x -slp downloads/gzdoom_4.7.1_amd64.deb -otemp
        exec -ignorestderr $sevenzip x -slp temp/data.tar -otemp
        exec sync
        set files [glob ./temp/opt/gzdoom/*]
        set lFiles [strToList $files]
        exec rm -Rf fm_banks
        exec rm -Rf soundfonts
        for {set i 0} {$i < [llength $lFiles]} {incr i} {
            exec mv [lindex $lFiles $i] ./
        }

        puts "extractiong wads..."
        file mkdir wad
        exec -ignorestderr $sevenzip x -slp downloads/blasphem-0.1.7.zip -otemp
        exec -ignorestderr $sevenzip x -slp downloads/blasphemer-texture-pack.zip -otemp
        exec -ignorestderr $sevenzip x -slp downloads/freedoom-0.12.1.zip -otemp
        exec sync
        exec mv ./temp/blasphem-0.1.7.wad ./wad
        exec mv ./temp/BLSMPTXT.WAD ./wad
        exec mv ./temp/freedoom-0.12.1/freedoom1.wad ./wad
        exec mv ./temp/freedoom-0.12.1/freedoom2.wad ./wad

        puts "extractiong maps..."
        file mkdir maps
        exec -ignorestderr $sevenzip x -slp downloads/eviternity.zip -otemp
        exec -ignorestderr $sevenzip x -slp downloads/mm_allup.zip -otemp
#         exec -ignorestderr $sevenzip x -slp downloads/mm2.zip -otemp
        exec sync
        exec mv ./temp/Eviternity.wad ./maps
        exec mv ./temp/MM.WAD ./maps
        exec mv ./temp/MMMUS.WAD ./maps

        puts "extractiong mods..."
        file mkdir mods
        exec cp downloads/Beautiful_Doom_716.pk3 ./mods
        exec cp downloads/brutalv21.11.2.pk3 ./mods
        exec sync
        file delete force temp

        puts "generationg games csv..."
        genCSV

        exit
    }
}

::main
