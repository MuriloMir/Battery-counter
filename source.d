// import all tools
import arsd.image : loadImageFromFile;
import arsd.simpleaudio : AudioOutputThread;
import arsd.simpledisplay : Color, Image, MouseButton, MouseEvent, MouseEventType, OperatingSystemFont, Point, Rectangle, ScreenPainter, SimpleWindow;
import std.algorithm : sum;
import std.array : replace;
import std.conv : to;
import std.file : exists, readText, write;

// start the software
void main()
{
    // load all images
    Image backgroundImg = Image.fromMemoryImage(loadImageFromFile("images/background.jpeg")),
          grayLgabImg = Image.fromMemoryImage(loadImageFromFile("images/gray lgab.jpeg")),
          grayBarCodeImg = Image.fromMemoryImage(loadImageFromFile("images/gray bar code.jpeg")),
          brownLgabImg = Image.fromMemoryImage(loadImageFromFile("images/brown lgab.jpeg")),
          sanyoRedRingImg = Image.fromMemoryImage(loadImageFromFile("images/sanyo red ring.jpeg")),
          sanyoLimeRingImg = Image.fromMemoryImage(loadImageFromFile("images/sanyo lime ring.jpeg")),
          sanyoDarkGreenRingImg = Image.fromMemoryImage(loadImageFromFile("images/sanyo dark green ring.jpeg")),
          sanyoBlueRingImg = Image.fromMemoryImage(loadImageFromFile("images/sanyo blue ring.jpeg")),
          sanyoLightPurpleRingImg = Image.fromMemoryImage(loadImageFromFile("images/sanyo light purple ring.jpeg")),
          sanyoWhiteRingImg = Image.fromMemoryImage(loadImageFromFile("images/sanyo white ring.jpeg")),
          orangeLgabImg = Image.fromMemoryImage(loadImageFromFile("images/orange lgab.jpeg")),
          sanyoOrangeImg = Image.fromMemoryImage(loadImageFromFile("images/sanyo orange.jpeg")),
          orangeLgdbImg = Image.fromMemoryImage(loadImageFromFile("images/orange lgdb.jpeg")),
          lightOrangeLgabImg = Image.fromMemoryImage(loadImageFromFile("images/light orange lgab.jpeg")),
          limeRooferImg = Image.fromMemoryImage(loadImageFromFile("images/lime roofer.jpeg")),
          limeBarCodeImg = Image.fromMemoryImage(loadImageFromFile("images/lime bar code.jpeg")),
          limePanasonicImg = Image.fromMemoryImage(loadImageFromFile("images/lime panasonic.jpeg")),
          limeBlankCgrImg = Image.fromMemoryImage(loadImageFromFile("images/lime blank cgr.jpeg")),
          limeCgrImg = Image.fromMemoryImage(loadImageFromFile("images/lime cgr.jpeg")),
          greenShinyImg = Image.fromMemoryImage(loadImageFromFile("images/green shiny.jpeg")),
          greenCgrImg = Image.fromMemoryImage(loadImageFromFile("images/green cgr.jpeg")),
          greenSamsungImg = Image.fromMemoryImage(loadImageFromFile("images/green samsung.jpeg")),
          greenNcrImg = Image.fromMemoryImage(loadImageFromFile("images/green ncr.jpeg")),
          darkGreenSamsungImg = Image.fromMemoryImage(loadImageFromFile("images/dark green samsung.jpeg")),
          darkGreenLgdbImg = Image.fromMemoryImage(loadImageFromFile("images/dark green lgdb.jpeg")),
          tealLgdbImg = Image.fromMemoryImage(loadImageFromFile("images/teal lgdb.jpeg")),
          tealBarCodeImg = Image.fromMemoryImage(loadImageFromFile("images/teal bar code.jpeg")),
          tealTsImg = Image.fromMemoryImage(loadImageFromFile("images/teal ts.jpeg")),
          tealRooferImg = Image.fromMemoryImage(loadImageFromFile("images/teal roofer.jpeg")),
          lightBlueLgdaImg = Image.fromMemoryImage(loadImageFromFile("images/light blue lgda.jpeg")),
          blueSamsungImg = Image.fromMemoryImage(loadImageFromFile("images/blue samsung.jpeg")),
          blueLgdaImg = Image.fromMemoryImage(loadImageFromFile("images/blue lgda.jpeg")),
          purpleBlankImg = Image.fromMemoryImage(loadImageFromFile("images/purple blank.jpeg")),
          purpleBarCodeImg = Image.fromMemoryImage(loadImageFromFile("images/purple bar code.jpeg")),
          purpleHlvImg = Image.fromMemoryImage(loadImageFromFile("images/purple hlv.jpeg")),
          purpleLnImg = Image.fromMemoryImage(loadImageFromFile("images/purple ln.jpeg")),
          purpleCfImg = Image.fromMemoryImage(loadImageFromFile("images/purple cf.jpeg")),
          lightPurpleSamsungImg = Image.fromMemoryImage(loadImageFromFile("images/light purple samsung.jpeg")),
          purpleLgdbImg = Image.fromMemoryImage(loadImageFromFile("images/purple lgdb.jpeg")),
          purpleCgrImg = Image.fromMemoryImage(loadImageFromFile("images/purple cgr.jpeg")),
          sanyoPinkImg = Image.fromMemoryImage(loadImageFromFile("images/sanyo pink.jpeg")),
          pinkSamsungImg = Image.fromMemoryImage(loadImageFromFile("images/pink samsung.jpeg"));

    // create an array with all battery images
    Image[41] allBatteryImages = [grayLgabImg, grayBarCodeImg, brownLgabImg, sanyoRedRingImg, sanyoLimeRingImg, sanyoDarkGreenRingImg,
                                  sanyoBlueRingImg, sanyoLightPurpleRingImg, sanyoWhiteRingImg, orangeLgabImg, sanyoOrangeImg, orangeLgdbImg,
                                  lightOrangeLgabImg, limeRooferImg, limeBarCodeImg, limePanasonicImg, limeBlankCgrImg, limeCgrImg, greenShinyImg,
                                  greenCgrImg, greenSamsungImg, greenNcrImg, darkGreenSamsungImg, darkGreenLgdbImg, tealLgdbImg, tealBarCodeImg,
                                  tealTsImg, tealRooferImg, blueSamsungImg, lightBlueLgdaImg, blueLgdaImg, lightPurpleSamsungImg, purpleBlankImg,
                                  purpleBarCodeImg, purpleHlvImg, purpleLnImg, purpleCfImg, purpleLgdbImg, purpleCgrImg, sanyoPinkImg,
                                  pinkSamsungImg];

    // create an array with the groups of 3 rectangles of all "+", "-" and "tally" boxes
    Rectangle[3][4] allBoxesGroups = [[Rectangle(567, 80, 595, 110), Rectangle(597, 80, 625, 110), Rectangle(521, 114, 544, 137)],
                                      [Rectangle(567, 250, 595, 280), Rectangle(597, 250, 625, 280), Rectangle(521, 284, 544, 307)],
                                      [Rectangle(567, 420, 595, 450), Rectangle(597, 420, 625, 450), Rectangle(521, 454, 544, 477)],
                                      [Rectangle(567, 590, 595, 620), Rectangle(597, 590, 625, 620), Rectangle(521, 624, 544, 647)]];

    // create the rectangles for the down and up arrows
    Rectangle downArrow = Rectangle(236, 711, 302, 792), upArrow = Rectangle(340, 711, 406, 792);
    // create an array with the quantities of each battery, corresponding to the 'allBatteryImages' array
    ushort[41] allBatteryQuantities;
    // create an array to tell which batteries have been selected for the tally
    bool[41] selectedBatteries;
    // this counter will be used when you scroll down to see the batteries below
    ubyte listCounter;
    // these variables will keep track of the total number of batteries and the tally of batteries you've selected
    ushort total, tally;
    // 'origin' is where to draw the background, 'imagePlace' is where to draw each battery, 'quantityPlace' is where to write each quantity,
    // 'totalPlace' is where to write the total of batteries, 'tallyPlace' is where to write the tally, 'mousePoint' will be the point where you've clicked
    Point origin = Point(0, 0), imagePlace = Point(0, 20), quantityPlace = Point(515, 80), totalPlace = Point(110, 753),
          tallyPlace = Point(475, 753), mousePoint;
    // create the thread which will be playing the sounds for the button clicks
    AudioOutputThread sounds = AudioOutputThread(true);
    // create the GUI window
    SimpleWindow window = new SimpleWindow(630, 800, "Battery Counter");

    // if you are on Linux
    version (linux)
        // this will be the font used by the painter in order to write the quantities of the batteries
        OperatingSystemFont font = new OperatingSystemFont("Ubuntu", 19);
    // if you are on Windows
    else
        // this will be the font used by the painter in order to write the quantities of the batteries
        OperatingSystemFont font = new OperatingSystemFont("Calibri", 30);

    // if the text file with all the quantities already exists
    if (exists("quantities.txt"))
    {
        // read the content of the file and store it in the array 'allBatteryQuantities', notice we need to remove any possible '\n'
        allBatteryQuantities = to!(ushort[41])(replace(readText("quantities.txt"), '\n', ""));
        // calculate the total number of batteries, it has to be cast into 'ushort'
        total = cast(ushort) sum(allBatteryQuantities[]);
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
        imagePlace.y = 20, quantityPlace.y = 80;

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
        // if you've left-clicked somewhere
        if (event.type == MouseEventType.buttonPressed && event.button == MouseButton.left)
        {
            // define the point where you've clicked
            mousePoint = Point(event.x, event.y);

            // if you've clicked on the down arrow and you are not at the bottom of the list (there is only room for 4 batteries)
            if (downArrow.contains(mousePoint) && listCounter < allBatteryImages.length - 4)
            {
                // increment the list counter
                listCounter++;
                // play the arrow sound
                sounds.playOgg("sounds/arrow.ogg");

                // end the event, we are done
                return;
            }
            // if you've clicked on the up arrow and you are not at the top of the list
            else if (upArrow.contains(mousePoint) && listCounter > 0)
            {
                // decrement the list counter
                listCounter--;
                // play the arrow sound
                sounds.playOgg("sounds/arrow.ogg");

                // end the event, we are done
                return;
            }

            // start a loop to go through all possible "+", "-" and "tally" groups of 3 boxes
            foreach (i, boxGroup; allBoxesGroups)
                // if the "+" box contains the mouse arrow and it hasn't reached the limit of 999
                if (boxGroup[0].contains(mousePoint) && allBatteryQuantities[listCounter + i] < 999)
                {
                    // increment the quantity of that battery, add 'listCounter' in case you've scrolled down the list
                    allBatteryQuantities[listCounter + i]++;
                    // increment the total number of batteries and the tally, if this battery is selected, using the 'bool' array 'selectedBatteries',
                    // add 'listCounter' in case you've scrolled down the list
                    total++, tally += cast(ushort) selectedBatteries[listCounter + i];
                    // write the updated quantities to the text file
                    write("quantities.txt", to!string(allBatteryQuantities));
                    // play the button sound
                    sounds.playOgg("sounds/button.ogg");

                    // end the event, we are done
                    return;
                }
                // if the "-" box contains the mouse arrow and it hasn't reached the limit of 0
                else if (boxGroup[1].contains(mousePoint) && allBatteryQuantities[listCounter + i] > 0)
                {
                    // decrement the quantity of that battery, add 'listCounter' in case you've scrolled down the list
                    allBatteryQuantities[listCounter + i]--;
                    // decrement the total number of batteries and the tally, if this battery is selected, using the 'bool' array 'selectedBatteries',
                    // add 'listCounter' in case you've scrolled down the list
                    total--, tally -= cast(ushort) selectedBatteries[listCounter + i];
                    // write the updated quantities to the text file
                    write("quantities.txt", to!string(allBatteryQuantities));
                    // play the button sound
                    sounds.playOgg("sounds/button.ogg");

                    // end the event, we are done
                    return;
                }
                // if the "tally" box contains the mouse arrow
                else if (boxGroup[2].contains(mousePoint))
                {
                    // if this box was already checked, add 'listCounter' in case you've scrolled down the list
                    if (selectedBatteries[listCounter + i])
                        // remove this battery quantity from the tally, add 'listCounter' in case you've scrolled down the list
                        tally -= allBatteryQuantities[listCounter + i];
                    // if this box wasn't checked
                    else
                        // add this battery quantity to the tally, add 'listCounter' in case you've scrolled down the list
                        tally += allBatteryQuantities[listCounter + i];

                    // update the status of the box, add 'listCounter' in case you've scrolled down the list
                    selectedBatteries[listCounter + i] = !selectedBatteries[listCounter + i];
                    // play the button sound
                    sounds.playOgg("sounds/button.ogg");

                    // end the event, we are done
                    return;
                }
        }
    });
}
