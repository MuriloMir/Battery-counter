// This software is designed to keep a record of the tally of all the different types of 18650 batteries you have.

// import all the tools we need
import multimedia.audio : AudioOutputThread;
import multimedia.display : Color, Image, MouseButton, MouseEvent, MouseEventType, OperatingSystemFont, Point, Rectangle, ScreenPainter, SimpleWindow;
import multimedia.image : loadImageFromMemory, memory;
import std.algorithm : sum;
import std.array : replace;
import std.conv : to;
import std.file : exists, readText, write;

// in case you are on Windows
version (Windows)
{
    // these 2 lines will simply stop the terminal from popping-up
    pragma(linkerDirective, "/subsystem:windows");
    pragma(linkerDirective, "/entry:mainCRTStartup");
}

// start the software
void main()
{
    // import all the audio files
    memory arrow = cast(memory) import("sounds/arrow.ogg"),
           button = cast(memory) import("sounds/button.ogg");

    // import all the image files
    memory backgroundFile = cast(memory) import("images/background.jpeg"),
           grayLgdaFile = cast(memory) import("images/gray lgda.jpeg"),
           grayLgabFile = cast(memory) import("images/gray lgab.jpeg"),
           grayBarCodeFile = cast(memory) import("images/gray bar code.jpeg"),
           brownLgabFile = cast(memory) import("images/brown lgab.jpeg"),
           sanyoRedRingFile = cast(memory) import("images/sanyo red ring.jpeg"),
           sanyoLimeRingFile = cast(memory) import("images/sanyo lime ring.jpeg"),
           sanyoDarkGreenRingFile = cast(memory) import("images/sanyo dark green ring.jpeg"),
           sanyoBlueRingFile = cast(memory) import("images/sanyo blue ring.jpeg"),
           sanyoDarkPurpleRingFile = cast(memory) import("images/sanyo dark purple ring.jpeg"),
           sanyoPurpleRingFile = cast(memory) import("images/sanyo purple ring.jpeg"),
           sanyoLightPurpleRingFile = cast(memory) import("images/sanyo light purple ring.jpeg"),
           sanyoWhiteRingFile = cast(memory) import("images/sanyo white ring.jpeg"),
           orangeLgabFile = cast(memory) import("images/orange lgab.jpeg"),
           sanyoOrangePurpleRingFile = cast(memory) import("images/sanyo orange purple ring.jpeg"),
           sanyoOrangePinkRingFile = cast(memory) import("images/sanyo orange pink ring.jpeg"),
           sanyoLightOrangeFile = cast(memory) import("images/sanyo light orange.jpeg"),
           orangeLgdbFile = cast(memory) import("images/orange lgdb.jpeg"),
           lightOrangeLgabFile = cast(memory) import("images/light orange lgab.jpeg"),
           lightBrownLgabFile = cast(memory) import("images/light brown lgab.jpeg"),
           limeRooferFile = cast(memory) import("images/lime roofer.jpeg"),
           limeBarCodeFile = cast(memory) import("images/lime bar code.jpeg"),
           limePanasonicFile = cast(memory) import("images/lime panasonic.jpeg"),
           limeBlankCgrFile = cast(memory) import("images/lime blank cgr.jpeg"),
           limeCgrFile = cast(memory) import("images/lime cgr.jpeg"),
           limeSamsungFile = cast(memory) import("images/lime samsung.jpeg"),
           greenShinySeFile = cast(memory) import("images/green shiny se.jpeg"),
           greenShinySfFile = cast(memory) import("images/green shiny sf.jpeg"),
           greenCfInrFile = cast(memory) import("images/green cf inr.jpeg"),
           greenCgrFile = cast(memory) import("images/green cgr.jpeg"),
           greenSamsungFile = cast(memory) import("images/green samsung.jpeg"),
           greenNcrFile = cast(memory) import("images/green ncr.jpeg"),
           darkGreenSamsungFile = cast(memory) import("images/dark green samsung.jpeg"),
           darkGreenLgdbFile = cast(memory) import("images/dark green lgdb.jpeg"),
           tealLgdbFile = cast(memory) import("images/teal lgdb.jpeg"),
           tealBarCodeFile = cast(memory) import("images/teal bar code.jpeg"),
           tealTsFile = cast(memory) import("images/teal ts.jpeg"),
           tealCgrFile = cast(memory) import("images/teal cgr.jpeg"),
           tealRooferFile = cast(memory) import("images/teal roofer.jpeg"),
           blueishTealBarCodeFile = cast(memory) import("images/blueish teal bar code.jpeg"),
           paleBlueSamsungFile = cast(memory) import("images/pale blue samsung.jpeg"),
           paleBlueLgdaFile = cast(memory) import("images/pale blue lgda.jpeg"),
           lightBlueBarCodeFile = cast(memory) import("images/light blue bar code.jpeg"),
           blueLgdsFile = cast(memory) import("images/blue lgds.jpeg"),
           blueBarCodeFile = cast(memory) import("images/blue bar code.jpeg"),
           blueLgdaFile = cast(memory) import("images/blue lgda.jpeg"),
           lightPurpleSamsungFile = cast(memory) import("images/light purple samsung.jpeg"),
           purpleBlankFile = cast(memory) import("images/purple blank.jpeg"),
           purpleBarCodeFile = cast(memory) import("images/purple bar code.jpeg"),
           purpleHlvFile = cast(memory) import("images/purple hlv.jpeg"),
           purpleLnFile = cast(memory) import("images/purple ln.jpeg"),
           purpleCfFile = cast(memory) import("images/purple cf.jpeg"),
           purpleLgdbFile = cast(memory) import("images/purple lgdb.jpeg"),
           purpleCgrFile = cast(memory) import("images/purple cgr.jpeg"),
           sanyoPinkFile = cast(memory) import("images/sanyo pink.jpeg"),
           pinkBarCodeFile = cast(memory) import("images/pink bar code.jpeg"),
           pinkSamsungFile = cast(memory) import("images/pink samsung.jpeg");

    // create all images
    Image backgroundImg = Image.fromMemoryImage(loadImageFromMemory(backgroundFile)),
          grayLgdaImg = Image.fromMemoryImage(loadImageFromMemory(grayLgdaFile)),
          grayLgabImg = Image.fromMemoryImage(loadImageFromMemory(grayLgabFile)),
          grayBarCodeImg = Image.fromMemoryImage(loadImageFromMemory(grayBarCodeFile)),
          brownLgabImg = Image.fromMemoryImage(loadImageFromMemory(brownLgabFile)),
          sanyoRedRingImg = Image.fromMemoryImage(loadImageFromMemory(sanyoRedRingFile)),
          sanyoLimeRingImg = Image.fromMemoryImage(loadImageFromMemory(sanyoLimeRingFile)),
          sanyoDarkGreenRingImg = Image.fromMemoryImage(loadImageFromMemory(sanyoDarkGreenRingFile)),
          sanyoBlueRingImg = Image.fromMemoryImage(loadImageFromMemory(sanyoBlueRingFile)),
          sanyoDarkPurpleRingImg = Image.fromMemoryImage(loadImageFromMemory(sanyoDarkPurpleRingFile)),
          sanyoPurpleRingImg = Image.fromMemoryImage(loadImageFromMemory(sanyoPurpleRingFile)),
          sanyoLightPurpleRingImg = Image.fromMemoryImage(loadImageFromMemory(sanyoLightPurpleRingFile)),
          sanyoWhiteRingImg = Image.fromMemoryImage(loadImageFromMemory(sanyoWhiteRingFile)),
          orangeLgabImg = Image.fromMemoryImage(loadImageFromMemory(orangeLgabFile)),
          sanyoOrangePurpleRingImg = Image.fromMemoryImage(loadImageFromMemory(sanyoOrangePurpleRingFile)),
          sanyoOrangePinkRingImg = Image.fromMemoryImage(loadImageFromMemory(sanyoOrangePinkRingFile)),
          sanyoLightOrangeImg = Image.fromMemoryImage(loadImageFromMemory(sanyoLightOrangeFile)),
          orangeLgdbImg = Image.fromMemoryImage(loadImageFromMemory(orangeLgdbFile)),
          lightOrangeLgabImg = Image.fromMemoryImage(loadImageFromMemory(lightOrangeLgabFile)),
          lightBrownLgabImg = Image.fromMemoryImage(loadImageFromMemory(lightBrownLgabFile)),
          limeRooferImg = Image.fromMemoryImage(loadImageFromMemory(limeRooferFile)),
          limeBarCodeImg = Image.fromMemoryImage(loadImageFromMemory(limeBarCodeFile)),
          limePanasonicImg = Image.fromMemoryImage(loadImageFromMemory(limePanasonicFile)),
          limeBlankCgrImg = Image.fromMemoryImage(loadImageFromMemory(limeBlankCgrFile)),
          limeCgrImg = Image.fromMemoryImage(loadImageFromMemory(limeCgrFile)),
          limeSamsungImg = Image.fromMemoryImage(loadImageFromMemory(limeSamsungFile)),
          greenShinySeImg = Image.fromMemoryImage(loadImageFromMemory(greenShinySeFile)),
          greenShinySfImg = Image.fromMemoryImage(loadImageFromMemory(greenShinySfFile)),
          greenCfInrImg = Image.fromMemoryImage(loadImageFromMemory(greenCfInrFile)),
          greenCgrImg = Image.fromMemoryImage(loadImageFromMemory(greenCgrFile)),
          greenSamsungImg = Image.fromMemoryImage(loadImageFromMemory(greenSamsungFile)),
          greenNcrImg = Image.fromMemoryImage(loadImageFromMemory(greenNcrFile)),
          darkGreenSamsungImg = Image.fromMemoryImage(loadImageFromMemory(darkGreenSamsungFile)),
          darkGreenLgdbImg = Image.fromMemoryImage(loadImageFromMemory(darkGreenLgdbFile)),
          tealLgdbImg = Image.fromMemoryImage(loadImageFromMemory(tealLgdbFile)),
          tealBarCodeImg = Image.fromMemoryImage(loadImageFromMemory(tealBarCodeFile)),
          tealTsImg = Image.fromMemoryImage(loadImageFromMemory(tealTsFile)),
          tealCgrImg = Image.fromMemoryImage(loadImageFromMemory(tealCgrFile)),
          tealRooferImg = Image.fromMemoryImage(loadImageFromMemory(tealRooferFile)),
          blueishTealBarCodeImg = Image.fromMemoryImage(loadImageFromMemory(blueishTealBarCodeFile)),
          paleBlueSamsungImg = Image.fromMemoryImage(loadImageFromMemory(paleBlueSamsungFile)),
          paleBlueLgdaImg = Image.fromMemoryImage(loadImageFromMemory(paleBlueLgdaFile)),
          lightBlueBarCodeImg = Image.fromMemoryImage(loadImageFromMemory(lightBlueBarCodeFile)),
          blueLgdsImg = Image.fromMemoryImage(loadImageFromMemory(blueLgdsFile)),
          blueBarCodeImg = Image.fromMemoryImage(loadImageFromMemory(blueBarCodeFile)),
          blueLgdaImg = Image.fromMemoryImage(loadImageFromMemory(blueLgdaFile)),
          lightPurpleSamsungImg = Image.fromMemoryImage(loadImageFromMemory(lightPurpleSamsungFile)),
          purpleBlankImg = Image.fromMemoryImage(loadImageFromMemory(purpleBlankFile)),
          purpleBarCodeImg = Image.fromMemoryImage(loadImageFromMemory(purpleBarCodeFile)),
          purpleHlvImg = Image.fromMemoryImage(loadImageFromMemory(purpleHlvFile)),
          purpleLnImg = Image.fromMemoryImage(loadImageFromMemory(purpleLnFile)),
          purpleCfImg = Image.fromMemoryImage(loadImageFromMemory(purpleCfFile)),
          purpleLgdbImg = Image.fromMemoryImage(loadImageFromMemory(purpleLgdbFile)),
          purpleCgrImg = Image.fromMemoryImage(loadImageFromMemory(purpleCgrFile)),
          sanyoPinkImg = Image.fromMemoryImage(loadImageFromMemory(sanyoPinkFile)),
          pinkBarCodeImg = Image.fromMemoryImage(loadImageFromMemory(pinkBarCodeFile)),
          pinkSamsungImg = Image.fromMemoryImage(loadImageFromMemory(pinkSamsungFile));

    // create an array with all battery images
    Image[56] allBatteryImages = [grayLgdaImg, grayLgabImg, grayBarCodeImg, brownLgabImg, sanyoRedRingImg, sanyoLimeRingImg, sanyoDarkGreenRingImg, sanyoBlueRingImg,
                                  sanyoDarkPurpleRingImg, sanyoPurpleRingImg, sanyoLightPurpleRingImg, sanyoWhiteRingImg, orangeLgabImg, sanyoOrangePurpleRingImg,
                                  sanyoOrangePinkRingImg, sanyoLightOrangeImg, orangeLgdbImg, lightOrangeLgabImg, lightBrownLgabImg, limeRooferImg, limeBarCodeImg,
                                  limePanasonicImg, limeBlankCgrImg, limeCgrImg, limeSamsungImg, greenShinySeImg, greenShinySfImg, greenCfInrImg, greenCgrImg,
                                  greenSamsungImg, greenNcrImg, darkGreenSamsungImg, darkGreenLgdbImg, tealLgdbImg, tealBarCodeImg, tealTsImg, tealCgrImg, tealRooferImg,
                                  blueishTealBarCodeImg, paleBlueSamsungImg, paleBlueLgdaImg, lightBlueBarCodeImg, blueLgdsImg, blueBarCodeImg, blueLgdaImg,
                                  lightPurpleSamsungImg, purpleBlankImg, purpleBarCodeImg, purpleHlvImg, purpleLnImg, purpleCfImg, purpleLgdbImg, purpleCgrImg,
                                  sanyoPinkImg, pinkBarCodeImg, pinkSamsungImg];

    // create an array with the groups of 3 rectangles of all "+", "-" and "tally" boxes
    Rectangle[3][4] allBoxesGroups = [[Rectangle(563, 75, 588, 100), Rectangle(592, 75, 617, 100), Rectangle(517, 108, 541, 132)],
                                      [Rectangle(563, 244, 588, 269), Rectangle(592, 244, 617, 269), Rectangle(517, 278, 541, 302)],
                                      [Rectangle(563, 414, 588, 439), Rectangle(592, 414, 617, 439), Rectangle(517, 447, 541, 472)],
                                      [Rectangle(563, 585, 588, 610), Rectangle(592, 585, 617, 610), Rectangle(517, 618, 541, 642)]];

    // create the rectangles for the down and up arrows
    Rectangle downArrow = Rectangle(236, 697, 291, 778), upArrow = Rectangle(340, 697, 395, 778);
    // create an array with the quantities of each battery, corresponding to the 'allBatteryImages' array
    int[56] allBatteryQuantities;
    // create an array to tell which batteries have been selected for the tally
    bool[56] selectedBatteries;
    // this counter will be used when you scroll down to see the batteries below
    ubyte listCounter;
    // these variables will keep track of the total number of batteries and the tally of batteries you've selected
    int total, tally;
    // 'origin' is where to draw the background, 'imagePlace' is where to draw each battery, 'quantityPlace' is where to write each quantity,
    // 'totalPlace' is where to write the total of batteries, 'tallyPlace' is where to write the tally, 'mousePoint' will be the point where you've clicked
    Point origin = Point(0, 0), imagePlace = Point(4, 20), quantityPlace = Point(511, 72), totalPlace = Point(110, 735),
          tallyPlace = Point(463, 735), mousePoint;
    // create the thread which will be playing the sounds for the button clicks
    AudioOutputThread sounds = AudioOutputThread(true);
    // create the GUI window
    SimpleWindow window = new SimpleWindow(630, 800, "Battery Counter");

    // if you are on Linux
    version (linux)
        // this will be the font used by the painter in order to write the quantities of the batteries
        OperatingSystemFont font = new OperatingSystemFont("Ubuntu", 19);
    // else, meaning you are on Windows
    else
        // this will be the font used by the painter in order to write the quantities of the batteries
        OperatingSystemFont font = new OperatingSystemFont("Calibri", 30);

    // if the text file with all the quantities already exists
    if (exists("quantities.txt"))
    {
        // read the content of the file and store it in the array 'allBatteryQuantities', notice we need to remove any possible '\n'
        allBatteryQuantities = to!(int[56])(replace(readText("quantities.txt"), '\n', ""));
        // calculate the total number of batteries
        total = sum(allBatteryQuantities[]);
    }

    // start the event loop, refreshing at each 150 msecs
    window.eventLoop(150,
    {
        // create the painter
        ScreenPainter painter = window.draw();
        // choose the outline color and the font of the painter
        painter.outlineColor = Color.white(), painter.setFont(font);
        // draw the background image
        painter.drawImage(origin, backgroundImg);
        // reset the y coordinates of 'imagePlace' and 'quantityPlace' back to the top
        imagePlace.y = 20, quantityPlace.y = 72;

        // start a loop to go through all battery images, according to how far down the list you've scrolled (there is only room for 4 batteries),
        // add 'listCounter' in case you've scrolled down the list
        foreach (i, img; allBatteryImages[listCounter .. listCounter + 4])
        {
            // draw the battery image
            painter.drawImage(imagePlace, img);
            // write the battery quantity, add 'listCounter' in case you've scrolled down the list
            painter.drawText(quantityPlace, to!string(allBatteryQuantities[listCounter + i]));
            // update the y coordinates of 'imagePlace' and 'quantityPlace' so they move down
            imagePlace.y += 170, quantityPlace.y += 170;

            // if you've selected this battery to be in the tally, add 'listCounter' in case you've scrolled down the list
            if (selectedBatteries[listCounter + i])
            {
                // draw the first line to mark the box with an X
                painter.drawLine(allBoxesGroups[i][2].upperLeft(), allBoxesGroups[i][2].lowerRight());
                // draw the second line to mark the box with an X
                painter.drawLine(Point(allBoxesGroups[i][2].right, allBoxesGroups[i][2].top),
                                 Point(allBoxesGroups[i][2].left, allBoxesGroups[i][2].bottom));
            }
        }

        // draw the total and the tally in their places, at the bottom
        painter.drawText(totalPlace, to!string(total)), painter.drawText(tallyPlace, to!string(tally));
    },
    // register mouse events
    (MouseEvent event)
    {
        // if you've pressed any mouse button
        if (event.type == MouseEventType.buttonPressed)
        {
            // if you've scrolled down the list and you are not at the bottom of the list (there is only room for 4 batteries)
            if (event.button == MouseButton.wheelDown && listCounter < allBatteryImages.length - 4)
            {
                // increment the list counter
                listCounter++;
                // play the arrow sound
                sounds.playOgg(arrow);

                // end the event, we are done
                return;
            }
            // else if you've scrolled up the list and you are not at the top of the list
            else if (event.button == MouseButton.wheelUp && listCounter > 0)
            {
                // decrement the list counter
                listCounter--;
                // play the arrow sound
                sounds.playOgg(arrow);

                // end the event, we are done
                return;
            }
            // else if you've left-clicked somewhere
            else if (event.button == MouseButton.left)
            {
                // define the point where you've clicked
                mousePoint = Point(event.x, event.y);

                // if you've clicked on the down arrow and you are not at the bottom of the list (there is only room for 4 batteries)
                if (downArrow.contains(mousePoint) && listCounter < allBatteryImages.length - 4)
                {
                    // increment the list counter
                    listCounter++;
                    // play the arrow sound
                    sounds.playOgg(arrow);

                    // end the event, we are done
                    return;
                }
                // else if you've clicked on the up arrow and you are not at the top of the list
                else if (upArrow.contains(mousePoint) && listCounter > 0)
                {
                    // decrement the list counter
                    listCounter--;
                    // play the arrow sound
                    sounds.playOgg(arrow);

                    // end the event, we are done
                    return;
                }

                // start a loop to go through all possible "+", "-" and "tally" groups of 3 boxes
                foreach (i, boxGroup; allBoxesGroups)
                {
                    // if the "+" box contains the mouse arrow and it hasn't reached the limit of 999
                    if (boxGroup[0].contains(mousePoint) && allBatteryQuantities[listCounter + i] < 999)
                    {
                        // increment the quantity of that battery, add 'listCounter' in case you've scrolled down the list
                        allBatteryQuantities[listCounter + i]++;
                        // increment the total number of batteries and the tally, if this battery is selected, using the 'bool' array 'selectedBatteries',
                        // add 'listCounter' in case you've scrolled down the list
                        total++, tally += selectedBatteries[listCounter + i];
                        // write the updated quantities to the text file
                        write("quantities.txt", to!string(allBatteryQuantities));
                        // play the button sound
                        sounds.playOgg(button);

                        // end the event, we are done
                        return;
                    }
                    // else if the "-" box contains the mouse arrow and it hasn't reached the limit of 0
                    else if (boxGroup[1].contains(mousePoint) && allBatteryQuantities[listCounter + i] > 0)
                    {
                        // decrement the quantity of that battery, add 'listCounter' in case you've scrolled down the list
                        allBatteryQuantities[listCounter + i]--;
                        // decrement the total number of batteries and the tally, if this battery is selected, using the 'bool' array 'selectedBatteries',
                        // add 'listCounter' in case you've scrolled down the list
                        total--, tally -= selectedBatteries[listCounter + i];
                        // write the updated quantities to the text file
                        write("quantities.txt", to!string(allBatteryQuantities));
                        // play the button sound
                        sounds.playOgg(button);

                        // end the event, we are done
                        return;
                    }
                    // else if the "tally" box contains the mouse arrow
                    else if (boxGroup[2].contains(mousePoint))
                    {
                        // if this box was already checked, add 'listCounter' in case you've scrolled down the list
                        if (selectedBatteries[listCounter + i])
                            // remove this battery quantity from the tally, add 'listCounter' in case you've scrolled down the list
                            tally -= allBatteryQuantities[listCounter + i];
                        // else, meaning this box wasn't checked
                        else
                            // add this battery quantity to the tally, add 'listCounter' in case you've scrolled down the list
                            tally += allBatteryQuantities[listCounter + i];

                        // update the status of the box, add 'listCounter' in case you've scrolled down the list
                        selectedBatteries[listCounter + i] = !selectedBatteries[listCounter + i];
                        // play the button sound
                        sounds.playOgg(button);

                        // end the event, we are done
                        return;
                    }
                }
            }
        }
    });
}
