# tclgz_loader
Tcl/tk gzdoom loader

A very basic tcl/tk gzdoom loader that read profiles from a csv to load games and custom maps. For now it works on linux, but I'm tweeking it to work on windows too.

Usage:
- Install tcl and tk packages 
- clone the reopsitory
- change to the project folder
- run getFiles.tcl
- run startgzdoom.tcl

Ubunto / Debian: <br />
<code> sudo apt install tcl tk git libsdl2-2.0-0 </code> <br />
<code> git clone https://github.com/alic3woodstock/tclgz_loader.git </code> <br />
<code> cd tclgz_loader </code> <br />
<code> tclsh getFiles.tcl </code> <br />
<code> wish startgzdoom </code> <br /> 
<br />
To play again you only need to cd to the project folder and run startgzdoom.tcl (wish startgzdoom.tcl). 

To add a game, map or mod you need to edit the csv file. You can use LibreOffice calc for that, you just need to remember to save as CSV. Id and name must be unique.

if you get this error:
"./wget: error while loading shared libraries: libnettle.so.8: cannot open shared object file: No such file or directory" or similar run the fallowing commands: <br />
<code> sudo apt install wget </code> <br />
<code> cp /usr/bin/wget ./ </code>
<br />
the wget may not be compatible with all linux system that's why you can get this error. I will try replacing wget with a tcl library in the future

This project is not finished but, for now, it's usable. I do not intend to continue for a while since I have a lot of things to do and I want some time to play doom instead of work in this launcher. 

Some considerations:<br />
- I used the Skyrim mod downloader Wabbajack as an inspiration for getting wads, mods, and maps for my application it's easier to deal with licenses than distributing the files with a release or something like that.<br />
- I plan to make a compiled release for Windows in the future. I compiled with Freewrap for windows but fonts became blurry.<br /> 
- A I plan a Linux release with all downloaded files included for near future, since Linux doesn't receive much attention as windows. For Windows, we have Brutalizer but nothing like that for Linux <br />
- Editing config files is not as easy as creating profiles, but is faster once everything is configured it's just a matter of launching the application and start playing <br />
- The program can be used entirely via keyboard. <br />
-- Tab -> change tab <br />
-- Space -> change mod <br />
-- Arrow up/down -> choose map/game to play <br />
-- Enter -> run game.
