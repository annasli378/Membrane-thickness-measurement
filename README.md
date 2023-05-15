# Membrane-thickness-measurement
Automatic method of measuring the thickness of the podocyte foot membrane based on expert masks 

# Data
The data are expert contours for images recorded at 3000x magnification. The pixel size for each image is 0.15 nm. The data was divided into 4 overlapping quadrants to facilitate the work of experts and was rejoined before processing.

# About
The goal of the project was to automatically determine the thickness of the membrane and compare the results with data read manually by an expert. For this purpose, membrane masks were extracted from the images and corrected to flood small holes and smooth the edges. 

Then, based on the skeletons of the corrected masks, the measurement locations were determined and the intersections of the incisal skeletons at the points and edges of the masks were measured. These distances determined the mask widths measured at the given points.

 ## GetMask
 
 ## GetBlobs
 
 ## GetWidths
 
 ## demo
