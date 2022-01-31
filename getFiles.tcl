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

        set csvMods [open "mods.csv" w]
        puts $csvMods "#mods"
        close $csvMods

        set csvGames [open "games.csv" a]
        puts $csvGames "#id,name,tab index,mod group,last run mod,iwad,file1,file2,file3,file4,file5,file6,file7,file8,file9"
        puts $csvGames "0,Blasphemer,0,heretic,0,blasphem-0.1.7.wad,wad/BLSMPTXT.WAD"
        puts $csvGames "1,Freedoom Phase 1,0,doom,0,freedoom1.wad"
        puts $csvGames "2,Freedoom Phase 2,0,doom,0,freedoom2.wad"
        puts $csvGames "3,Eviternity,1,doom,0,freedoom2.wad,maps/Eviternity.wad"
        puts $csvGames "4,Memento Mori,1,doom,0,freedoom2.wad,maps/MM.wad,MMMUS.WAD"
        close $csvGames
        
        set csvMods [open "mods.csv" a]
        puts $csvMods "#id,name,mod group,file1,file2,file3,file4,file5,file6,file7,file8,file9"
        puts $csvMods "1,Beaultiful Doom,doom,Beautiful_Doom_716.pk3"
        puts $csvMods "2,Brutal Doom,doom,brutalv21.11.2.pk3"
        close $csvMods
        
    }
}

proc downloadFiles {} {
        set wget "./wget"
        file mkdir downloads

        #gzdoom
        exec -ignorestderr $wget -c https://github.com/coelckers/gzdoom/releases/download/g4.7.1/gzdoom_4.7.1_amd64.deb -P downloads
    #     file rename -force gzdoom_4.7.1_amd64.deb downloads/gzdoom_4.7.1_amd64.deb

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
	set unzip "./unzip"
        
        #downloadFiles

        file delete -force temp
        file mkdir temp

        puts "extractiong files..."
        exec -ignorestderr $sevenzip x -slp downloads/gzdoom_4.7.1_amd64.deb -otemp
        exec -ignorestderr $sevenzip x -slp temp/data.tar -otemp

	#7zip freezes at the final file so I use unzip
        exec -ignorestderr $unzip -o downloads/blasphem-0.1.7.zip -d temp
        exec -ignorestderr $unzip -o downloads/blasphemer-texture-pack.zip -d temp
        exec -ignorestderr $unzip -o downloads/freedoom-0.12.1.zip -d temp
        exec -ignorestderr $unzip -o downloads/eviternity.zip -d temp
        exec -ignorestderr $unzip -o downloads/mm_allup.zip -d temp
        exec -ignorestderr $unzip -o downloads/mm2.zip -d temp

        set files [glob ./temp/opt/gzdoom/*]
        set lFiles [strToList $files]
        file delete -force fm_banks
        file delete -force soundfonts
        for {set i 0} {$i < [llength $lFiles]} {incr i} {
            file rename -force [lindex $lFiles $i] ./
        }

        puts "extractiong wads..."
        file mkdir wad
        file rename -force ./temp/blasphem-0.1.7.wad ./wad
        file rename -force ./temp/BLSMPTXT.WAD ./wad
        file rename -force ./temp/freedoom-0.12.1/freedoom1.wad ./wad
        file rename -force ./temp/freedoom-0.12.1/freedoom2.wad ./wad

        puts "extractiong maps..."
        file mkdir maps
#         exec -ignorestderr $sevenzip x -slp downloads/mm2.zip -otemp
        file rename -force ./temp/Eviternity.wad ./maps
        file rename -force ./temp/MM.WAD ./maps
        file rename -force ./temp/MMMUS.WAD ./maps
        file rename -force ./temp/MM2.WAD ./maps
        file rename -force ./temp/MM2MUS.WAD ./maps

        puts "extractiong mods..."
        file mkdir mods
        exec cp downloads/Beautiful_Doom_716.pk3 ./mods
        exec cp downloads/brutalv21.11.2.pk3 ./mods
        file delete -force temp

        puts "generationg games csv..."
        genCSV

        exit
    }
}

::main
