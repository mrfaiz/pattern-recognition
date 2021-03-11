
close all;
digit_number = 3;
image_dimension = 28;
filename = ["../digits/digit" int2str(digit_number) '.mat']; 
load (filename);

# Start of Task c #
pixel_number = 297;
figure(1);

subplot(211);
m = mean(D);
m(pixel_number) = 255; # assignin White color
# Make square (image_dimension x image_dimension) matrix
m = reshape(m, image_dimension, image_dimension);
m = transpose(m);
imshow(m, []);
title(['Illustration of pixel ', int2str(pixel_number)]);

subplot(212);
pixel_dis = D(:,297);
hist(pixel_dis, 255);
title([num2str(pixel_number),'th pixel distribution']);

# Task D

A = zeros(28);
figure(2);


for i = 100:50:600
  
    A(i-50) = 0;
    
    # Make a Vector
    A = reshape(A, 1, image_dimension * image_dimension);
    A(i) = 255; # assignin White color
    # Make square (image_dimension x image_dimension) matrix
    A = reshape(A, image_dimension, image_dimension);
    subplot(211);
    imshow(A);
    title(['Illustration of pixel ', int2str(i),' of digit ', int2str(digit_number)]);
       
    subplot(212);
    pixel_dis = D(:, i);
    hist(pixel_dis, 255);
    title([num2str(i),'th pixel distribution']);
    
    pause(1);
    
end


