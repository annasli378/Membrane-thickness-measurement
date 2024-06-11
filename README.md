# Membrane-thickness-measurement
Automatic method of measuring the thickness of the podocyte foot membrane based on expert masks.

# Data
The data are expert contours for images recorded at 3000x magnification. The pixel size for each image is 0.15 nm. The data was divided into 4 overlapping quadrants to facilitate the work of experts and was rejoined before processing.

# About
The goal of the project was to automatically determine the thickness of the membrane and compare the results with data read manually by an expert. For this purpose, membrane masks were extracted from the images and corrected to flood small holes and smooth the edges. 

Then, based on the skeletons of the corrected masks, the measurement locations were determined and the intersections of the incisal skeletons at the points and edges of the masks were measured. These distances determined the mask widths measured at the given points.

# Methods
 ## GetMask
 A function responsible for extracting an interesting mask from an image, then smoothing the jagged edges and flooding the small holes.
 
 ## GetBlobs
 The function responsible for extracting each separate membrane fragment from the image, arranging them by size, removing elements that are too small and checking that the element does not adhere too much to the edges of the image.
 
 ## GetWidthsInc
A function that measures width at selected points in the skeleton using incisors. It iteratively searches for the points of intersection of the secant determined at a given point and the edge of the diaphragm, additionally checking the correctness of each result.

 ## GetWidthsBwd
  A function that determines the width of the membrane at selected points using the bwdist() function available in the Matlab environment.
  
# demo
 Example file - how to use to calcualte results
