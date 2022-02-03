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
        puts $csvGames "3,Alien Vendetta,1,doom,1,freedoom2.wad,maps/av.zip"
        puts $csvGames "4,Ancient Aliens,1,doom,1,freedoom2.wad,maps/aaliens.zip"
        puts $csvGames "5,Back to Saturn X E1: Get Out of My Stations,1,doom,1,freedoom2.wad,maps/btsx_e1.zip"
        puts $csvGames "6,Back to Saturn X E2: Tower in the Fountain of Sparks,1,doom,1,freedoom2.wad,maps/btsx_e2.zip"
        puts $csvGames "7,Eviternity,1,doom,1,freedoom2.wad,maps/eviternity.zip"
        puts $csvGames "8,Hell Revealed,1,doom,1,freedoom2.wad,maps/hr.zip,,"
        puts $csvGames "9,Hell Revealed II,1,doom,1,freedoom2.wad,maps/hr2final.zip,,"
        puts $csvGames "10,Heretic Treasure Chest,1,heretic,0,blasphem-0.1.7.wad,maps/htchest.zip"
        puts $csvGames "11,Memento Mori,1,doom,1,freedoom2.wad,maps/mm_allup.zip"
        puts $csvGames "12,Memento Mori 2,1,doom,1,freedoom2.wad,maps/mm2.zip"
        puts $csvGames "13,Plutonia 2,1,doom,1,freedoom2.wad,maps/pl2.zip"
        puts $csvGames "14,Scythe,1,doom,6,freedoom2.wad,maps/scythe.zip"
        puts $csvGames "15,Scythe 2,1,doom,6,freedoom2.wad,maps/scythe2.zip"
        puts $csvGames "16,Scythe X,1,doom,6,freedoom2.wad,maps/scythex.zip"
        puts $csvGames "17,Sunder,1,doom,1,freedoom2.wad,maps/sunder.zip"
        puts $csvGames "18,Sunlust,1,doom,1,freedoom2.wad,maps/sunlust.zip"
        puts $csvGames "19,UnBeliever,1,heretic,0,blasphem-0.1.7.wad,maps/unbeliev.zip"
        puts $csvGames "20,Valiant,1,doom,1,freedoom2.wad,maps/valiant.zip"
        puts $csvGames "21,Zones of Fear,1,doom,1,freedoom2.wad,maps/zof.zip"
        close $csvGames

        
        set csvMods [open "mods.csv" a]
        puts $csvMods "#id,name,mod group,file1,file2,file3,file4,file5,file6,file7,file8,file9"
        puts $csvMods "1,Beaultiful Doom,doom,150skins.zip,Beautiful_Doom_716.pk3"
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

    #150skins
    exec -ignorestderr $wget -c https://doomshack.org/wads/150skins.zip -P downloads

    #beaultiful doom
    exec -ignorestderr $wget -c https://github.com/jekyllgrim/Beautiful-Doom/releases/download/7.1.6/Beautiful_Doom_716.pk3 -P downloads

    #brutal doom
    exec -ignorestderr $wget -c https://github.com/BLOODWOLF333/Brutal-Doom-Community-Expansion/releases/download/V21.11.2/brutalv21.11.2.pk3 -P downloads

    #maps
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/megawads/av.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/Ports/megawads/aaliens.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/megawads/btsx_e1.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/megawads/btsx_e2.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/Ports/megawads/eviternity.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/themes/hr/hr.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/themes/hr/hr2final.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/heretic/Ports/htchest.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/themes/mm/mm_allup.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/themes/mm/mm2.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/megawads/pl2.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/megawads/scythe.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/Ports/megawads/scythe2.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/Ports/s-u/scythex.zip -P downloads
    exec -ignorestderr $wget -c https://www.dropbox.com/s/vi47z1a4e4c4980/Sunder%202407.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/Ports/megawads/sunlust.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/heretic/s-u/unbeliev.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/Ports/megawads/valiant.zip -P downloads
    exec -ignorestderr $wget -c https://youfailit.net/pub/idgames/levels/doom2/Ports/megawads/zof.zip -P downloads
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

    file copy -force ./downloads/av.zip ./maps
    file copy -force ./downloads/aaliens.zip ./maps
    file copy -force ./downloads/btsx_e1.zip ./maps
    file copy -force ./downloads/btsx_e2.zip ./maps
    file copy -force ./downloads/eviternity.zip ./maps
    file copy -force ./downloads/hr.zip ./maps
    file copy -force ./downloads/hr2final.zip ./maps
    file copy -force ./downloads/htchest.zip ./maps
    file copy -force ./downloads/mm_allup.zip ./maps
    file copy -force ./downloads/mm2.zip ./maps
    file copy -force ./downloads/pl2.zip ./maps
    file copy -force ./downloads/scythe.zip ./maps
    file copy -force ./downloads/scythe2.zip ./maps
    file copy -force ./downloads/scythex.zip ./maps
    file copy -force "./downloads/Sunder 2407.zip" ./maps/sunder.zip
    file copy -force ./downloads/sunlust.zip ./maps
    file copy -force ./downloads/unbeliev.zip ./maps
    file copy -force ./downloads/valiant.zip ./maps
    file copy -force ./downloads/zof.zip ./maps

    puts "copying mods..."
    file mkdir mods
    file copy -force downloads/150skins.zip ./mods
    file copy -force downloads/Beautiful_Doom_716.pk3 ./mods
    file copy -force downloads/brutalv21.11.2.pk3 ./mods
    file delete -force temp

    puts "generationg games csv..."
    genCSV

    exit
}

::main
