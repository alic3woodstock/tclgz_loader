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
<code> sudo apt install tcl tk git wget libsdl2-2.0-0 </code> <br />
<code> git clone https://github.com/alic3woodstock/tclgz_loader.git </code> <br />
<code> cd tclgz_loader </code> <br />
<code> cp /usr/bin/wget ./ </code>
<code> tclsh getFiles.tcl </code> <br />
<code> wish startgzdoom </code> <br /> 
<br />
To play again you only need to cd to the project folder and run startgzdoom.tcl (wish startgzdoom.tcl). 

To add a game, map or mod you need to edit the csv file. You can use LibreOffice calc for that, you just need to remember to save as CSV. Id and name must be unique.

if you get this error:
"./wget: error while loading shared libraries: libnettle.so.8: cannot open shared object file: No such file or directory"
run the fallowing commands: <br />
<code> sudo apt install wget </code>
<code> cp /usr/bin/wget ./ </code>
<br />
the wget may not be compatible with all linux system that's why you can get this error. I will try replacing wget with a tcl library in the future
