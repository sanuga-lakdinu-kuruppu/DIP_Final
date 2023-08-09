-------------------------- Instructions to run the each code -----------------------------------

Open the matlab environment and open the suitable folder in that tool according to the needness.

ex : For bilevel thresholding in MEC open  - > "MEC(Bilevel)"  named folder.

Reading any image but lena.png is comming with this folder.

(01). Bilevel Thresholding using (MEC).
	
	1 -> Read the image using this command -> img = imread('image_path');
	2 -> Call the required function -> mecBilevel(img);

(02). Bilevel Thresholding using (MCC).
	
	1 -> Read the image using this command -> img = imread('image_path');
	2 -> Call the required function -> mccBilevel(img);

(03). Multilevel Thresholding using (MEC).
	
	1 -> Read the image using this command -> img = imread('image_path');
	2 -> Call the required function -> mecMultilevel(img,3);
	
	## above second parameter is the classification number provided by a supervision.

(04). Multilevel Thresholding using (MCC).
	
	1 -> Read the image using this command -> img = imread('image_path');
	2 -> Call the required function -> mccMultilevel(img);