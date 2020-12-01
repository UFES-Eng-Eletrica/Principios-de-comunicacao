%% Lendo Imagem jpg
img_matrix  = imread('puppy.jpg');
figure, imshow(img), title('Local image'); % Mostrando meu Puppy
resized_img = imresize(img, 0.2); % resize by a factor here 0.2
%resized_img = imresize(img, [600 500]); % resize to a specific dimensions
figure, imshow(resized_img), title('Resized image')

% change color did you mean from RGB to grayscale 
gray_img = rgb2gray(resized_img);
figure, imshow(gray_img), title ('Grayscale image')
img = gray_img;
clear resized_img;
clear map;
clear gray_img;

%% Transformando em vetor
y_image = reshape(img_matrix,1,[]);