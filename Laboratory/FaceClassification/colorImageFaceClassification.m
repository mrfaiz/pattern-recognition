% Color image classification demonstration
%
% One training image is used for parameter estimation. Classification is
% applied to a second image.
%
% Author: Hauke Schramm

close all;
clear;
iptsetpref('ImshowInitialMagnification', 1000);

% read image
I = imread('D:\Uebungen\PAT\Exercise3\color_face_classification\portrait1.jpg');

% resize image for faster processing
J = imresize(I,[size(I,1)/10 size(I,2)/10]);

% plot image
figure(1), imshow(J);

% Get training data: Localize face pixels in the image

% We will use the image processing toolbox function regiongrow (see lecture 
% image analysis for details) for face pixel localization. This tool does
% only work on gray value images.
grayJ = rgb2gray(J);

% Region growing requires a starting point which is determined here. It is
% just the center of the image.
S = zeros(size(grayJ,1), size(grayJ,2));
S(floor(size(S,1)/2), floor(size(S,2)/2)) = 1;

% Apply the function. All labeled (face) pixels are 1 in the result matrix 
% G. Everything else is labeled as 0.
G = regiongrow(grayJ, S, 20);
figure(2), imshow(G, []);

% Build a 3D matrix from G which is required for selecting the face pixels
% from J.
G3D = repmat(G, [1 1 3]);

% Get and show the face pixels
K = J .* uint8(G3D);
figure(3), imshow(K);

% Grep the face pixels from the color image to form feature vectors.
faceFeats = J(logical(G3D));
nonFaceFeats = J(~logical(G3D));

% Reshape the feature vectors
faceFeats = reshape(faceFeats, [size(faceFeats,1)/3 3]);  
nonFaceFeats = reshape(nonFaceFeats, [size(nonFaceFeats,1)/3 3]);  

% Estimate the mean vectors and covariance matrices
% class 1 (faces)
MF = mean(faceFeats);
CF = cov(double(faceFeats));

% class 2 (non-faces)
MN = mean(nonFaceFeats);
CN = cov(double(nonFaceFeats));

%% Distance classification

% Load a new image
I = imread('D:\Uebungen\PAT\Exercise3\color_face_classification\portrait6.jpg');
J = imresize(I,[size(I,1)/5 size(I,2)/5]);

% Convert image into feature vectors using im2col
Jfeat = im2col(J, [1 1 3]);

% Convert to other format (1 feature vector per row)
Jfeat = reshape(Jfeat, [size(Jfeat,2)/3 3])';

% For each feature vector: Compute its distance to both classes
dist_1 = sum((double(Jfeat) - repmat(MF',[1 size(Jfeat,2)])).^2);
dist_2 = sum((double(Jfeat) - repmat(MN',[1 size(Jfeat,2)])).^2);

% adjust class priors
dist_1 = dist_1 * 0.9;

% Assign each feature vector to the class to which it has the smallest
% distance. Face pixels will be set to 1 in result.
result = dist_1 < dist_2;

% Reshape result into a 2D image
classified = reshape(result, size(J, 1), size(J, 2));

figure(4), imshow(classified);


%% Bayes classification

fprintf('Before: size: %d %d\n', size(faceFeats,1), size(faceFeats,2));

% Features are required in transposed format
faceFeats = faceFeats';
nonFaceFeats = nonFaceFeats';

fprintf('size: %d %d\n', size(faceFeats,1), size(faceFeats,2));

% Compute priors
%p1 = size(faceFeats,2)/(size(faceFeats,2)+size(nonFaceFeats,2));
%p2 = size(nonFaceFeats,2)/(size(faceFeats,2)+size(nonFaceFeats,2));

% Or: use same priors for both classes (we do not know, which image 
% fraction the face covers)
% Same chance for both classes (we do not know, how large the face is in
% the image).
p1 = 0.9999999;
p2 = 0.0000001;

% Compute the likelihoods (class-conditional probabilities) for both
% classes
p_x_1 = mvnpdf(double(Jfeat'), MF, CF);
p_x_2 = mvnpdf(double(Jfeat'), MN, CN);
    
% Compute p_x_1_p_1 = p(x|class 1)*P(class 1) 
%     and p_x_2_p_2 = p(x|class 2)*P(class 2)
p_x_1_p_1 = p_x_1 * p1;
p_x_2_p_2 = p_x_2 * p2;
    
% Compare according to Bayes decision rule
% Decision for class with largest probability -> face pixels will be set to 1
result = p_x_1_p_1 > p_x_2_p_2;

% Reshape classification result to image size
classified = reshape(result, size(J, 1), size(J, 2));

% Plot original image and classification result
figure(5), imshow(J);
figure(6), imshow(classified);



