myImage = imread('foto_gcmf.jpg');

figure
subplot(1,2,1);
imshow(myImage);
title('Original Image');

subplot(1,2,2);
grayScaleImage = toGrayscale(myImage);
imshow(grayScaleImage);
imsave
title('Grayscale Image');