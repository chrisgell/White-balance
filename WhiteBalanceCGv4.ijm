
macro "Batch White balance CGv4" {  //Macro to batch WB a set of histology images.
// Some code taken from 'White balance by Vytas Bindokas, Measurements by by Christine Labno, UChicago, April 2013'



waitForUser("Click Ok to select the directory of Tif images you wish to white balance....");
	
dir = getDirectory("Choose a Directory ");	//Get the directory of the images to be batch processed.
    list = getFileList(dir);
print(list.length, ' files in this folder');
 setFont("SansSerif", 24);
 start = getTime();

waitForUser("Click OK to open an image to use to set the white balance by....");

open()  //Open an image that will be the WB image.
sourceID = getImageID();

 ////////// Get the ROI from the WB image
run("Colors...", "foreground=white background=black selection=yellow");
setTool("rectangle");
waitForUser("Draw a rectangle in the white balance image, in an area away from tissue, cells, dust or scratches, then hit OK");

// beginning of inserted white balance macro code
Bness=getNumber("Enter the brightness scaling: (1-255). The default is 200. >200 with result in a brighter images, ", 200)
ti=getTitle;
run("Set Measurements...", "  mean redirect=None decimal=3");
roiManager("add");
                if (roiManager("count")==0)
               exit("you must draw region first");
run("8-bit Color", "number=256");
run("RGB Color");
roiManager("deselect");
run("RGB Stack");
roiManager("select",0);
setSlice(1);
run("Measure");
R=getResult("Mean");
//print(R);
Re=Bness/R;
//print(Re);   
setSlice(2);
run("Measure");
G=getResult("Mean");
//print(G);
Ge=Bness/G;
//print(Ge);
setSlice(3);
run("Measure");
B=getResult("Mean");
//print(B);
Be=Bness/B;
//print(Be);
roiManager("reset");
run("Select None");


selectImage(sourceID); // close the Wb image
close();

//using that ROI data we now process all of the files in a folder.
//setBatchMode(true); // runs up to 6 times faster

for (f=0; f<list.length; f++) {	//main files loop
        path = dir+list[f];
       // showProgress(f, list.length);
 if (!endsWith(path,"/") && endsWith(path,"f")) open(path);   //do only TIF files
 print(path);
  if (nImages>=1) {


run("RGB Stack");
run("Select None");

run("8-bit");

setSlice(1);


run("Multiply...", "slice value="+Re);

setSlice(2);

run("Multiply...", "slice value="+Ge);

setSlice(3);

run("Multiply...", "slice value="+Be);

run("Convert Stack to RGB");

s=lastIndexOf(path, '.');
r=substring(path, 0,s);
n=r+" balanced.tif";
//print(n);
save(n);
close();



//selectImage(1);
//run("Convert Stack to RGB");
//rename("original");
//selectWindow(ti);
close();




          } 
      }

//Clean up some of the open windows.
      
selectWindow("ROI Manager");
run("Close");
selectWindow("Results");
run("Close");
selectWindow("Log");
run("Close");

//  end white balance macro code

  }
