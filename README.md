# Battery-counter
This software allows you to keep track of how many 18650 batteries you have at your workshop, supposing you work with such batteries. It has them sorted by colors, according to the spectrum, you can scroll down to see the other options and you can click to add, subtract or include any of them in your tally.

In order to run it you need to have the folders "sounds" and "images", all of which can be found in the "dependencies.zip" folder here on Github, you also need to have the text file "quantities.txt", which is created automatically. If you want to compile it then remember to download the source code file, the 'dependencies.zip' file, extract it and then use "dmd source.d -m64 -i -J. -O -g".
