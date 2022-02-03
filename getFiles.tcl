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
        puts $csvGames "3,Eviternity,1,doom,1,freedoom2.wad,maps/eviternity.zip"
        puts $csvGames "4,Memento Mori,1,doom,1,freedoom2.wad,maps/mm_allup.zip"
        puts $csvGames "5,Memento Mori 2,1,doom,1,freedoom2.wad,maps/mm2.zip"
        close $csvGames
        
        set csvMods [open "mods.csv" a]
        puts $csvMods "#id,name,mod group,file1,file2,file3,file4,file5,file6,file7,file8,file9"
        puts $csvMods "1,Beaultiful Doom,doom,Beautiful_Doom_716.pk3"
        puts $csvMods "2,Brutal Doom,doom,brutalv21.11.2.pk3"
        close $csvMods
        
    }
}

proc downloadFiles {} {
		if {[string first "win" [platform::generic]] >= 0} {
			set wget "./wget.exe"

			#gzdoom
			exec -ignorestderr $wget -c https://github.com/coelckers/gzdoom/releases/download/g4.7.1/gzdoom-4-7-1-Windows-64bit.zip -P downloads
		} else {
			set wget "./wget"
			
			#gzdoom
			exec -ignorestderr $wget -c https://github.com/coelckers/gzdoom/releases/download/g4.7.1/gzdoom_4.7.1_amd64.deb -P downloads
		}
        file mkdir downloads

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
        set sevenzip "./7za.exe"
        set unzip "./unzip.exe"
		set windows true
    } else {
        set sevenzip "./7zzs"
        set unzip "./unzip"
		set windows false
    }
        
    downloadFiles

    file delete -force temp
    file mkdir temp

    puts "extractiong files..."
	
	if {$windows} {
		file mkdir gzdoom
		exec -ignorestderr $unzip -o downloads/gzdoom-4-7-1-Windows-64bit.zip -d gzdoom
	} else {
		exec -ignorestderr $sevenzip x -slp downloads/gzdoom_4.7.1_amd64.deb -otemp
		exec -ignorestderr $sevenzip x -slp temp/data.tar -otemp
		file delete -force gzdoom
		file copy -force temp/opt/gzdoom ./
	}


	#7zip freezes at the final file so I use unzip
    exec -ignorestderr $unzip -o downloads/blasphem-0.1.7.zip -d temp
    exec -ignorestderr $unzip -o downloads/blasphemer-texture-pack.zip -d temp
    exec -ignorestderr $unzip -o downloads/freedoom-0.12.1.zip -d temp

    puts "extractiong wads..."
    file mkdir wad
    file rename -force ./temp/blasphem-0.1.7.wad ./wad
    file rename -force ./temp/BLSMPTXT.WAD ./wad
    file rename -force ./temp/freedoom-0.12.1/freedoom1.wad ./wad
    file rename -force ./temp/freedoom-0.12.1/freedoom2.wad ./wad

    puts "copying maps..."
    file mkdir maps
    file copy -force ./downloads/eviternity.zip ./maps
    file copy -force ./downloads/mm_allup.zip ./maps
    file copy -force ./downloads/mm2.zip ./maps

    puts "copying mods..."
    file mkdir mods
    file copy -force downloads/Beautiful_Doom_716.pk3 ./mods
    file copy -force downloads/brutalv21.11.2.pk3 ./mods
    file delete -force temp

    puts "generationg games csv..."
    genCSV

    exit
}

::main
