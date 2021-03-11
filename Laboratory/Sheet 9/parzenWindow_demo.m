% Parzen Window density estimation technique.
%
% Author: H. Schramm, 2015

close all;
clear;

% load data set
load 'D:/Users/hschramm/Dropbox/Vorlesungen/PAT/datasets/clouds.mat'

% USER SETTINGS
% display spacing, used for linspace
steps = 200;

% smoothing parameter for parzen windows
sm = 0.01;

% training data
train_pat = patterns(:,1:1000);
train_tar = targets(1:1000);

% test data
test_pat = patterns(:,1001:2000);
test_tar = targets(1001:2000);

[X1,X2] = meshgrid(linspace(min(train_pat(1,:)), max(train_pat(1,:)), steps), linspace(min(train_pat(2,:)), max(train_pat(2,:)), steps));

% display patterns (x1, x2): likelihoods are estimated for this area
X = [X1(:) X2(:)]';

[p_x_c, p_c] = parzen_likelihood(train_pat, train_tar, X, sm);

p_x1_x2_class1 = reshape(p_x_c(1,:),size(X1,2),size(X2,2));
p_x1_x2_class2 = reshape(p_x_c(2,:),size(X1,2),size(X2,2));

% get the indices of class 1 (0) and class 2(1)
ind_1 = find(~train_tar);
ind_2 = find(train_tar);

figure(1);
hold on;
gscatter(train_pat(1,:),train_pat(2,:), train_tar(:), 'br', 'xo');
xlabel('x1');
ylabel('x2');
axis([-1 1 -1 1]);

figure(2);
hold on;
plot(train_pat(1,ind_1),train_pat(2,ind_1),'black.');
xlabel('x1');
ylabel('x2');
%title('Class 1');
axis([-1 1 -1 1]);
contour(X1,X2,p_x1_x2_class1);

figure(3);
hold on;
plot(train_pat(1,ind_2),train_pat(2,ind_2),'black.');
xlabel('x1');
ylabel('x2');
%title('Class 2');
contour(X1,X2,p_x1_x2_class2);
axis([-1 1 -1 1]);
%surf(X1,X2,p_x1_x2_class1);

figure(4);
hold on;
xlabel('x1');
ylabel('x2');
C1 = 0.2*double(p_x1_x2_class1 >= p_x1_x2_class2);
C2 = 0.6*double(p_x1_x2_class2 > p_x1_x2_class1);
C = C1+C2;
surf(X1, X2, p_x1_x2_class1, C);
surf(X1, X2, p_x1_x2_class2, C);
view(-53,27);
grid;

figure(5);
hold on;
colormap([228 98 40; 240 255 240]/255);
colormap pink;
contourf(X1, X2, p_x1_x2_class1 >= p_x1_x2_class2, [0.5 0.5], 'k-.');
plot(train_pat(1,ind_1),train_pat(2,ind_1),'black.');
plot(train_pat(1,ind_2),train_pat(2,ind_2),'redo');
axis([-1 1 -1 1]);

% visualization of test data coverage
figure(6);
testind_1 = find(~test_tar);
testind_2 = find(test_tar);
title('Test data coverage');
hold on;
colormap pink;
contourf(X1, X2, p_x1_x2_class1 >= p_x1_x2_class2, [0.5 0.5], 'k-.');
plot(test_pat(1,testind_1),test_pat(2,testind_1),'black.');
plot(test_pat(1,testind_2),test_pat(2,testind_2),'redo');
xlabel('x1');
ylabel('x2');
%contour(X1,X2,p_x1_x2_class2);
%contour(X1,X2,p_x1_x2_class1);
axis([-1 1 -1 1]);

% Perform classification
Uc = unique(train_tar);  % get number of classes
N  = size(test_pat, 2);  % number of test samples
test_tar_hyp = zeros(1, N);

% stepsize is required to map from values to indices
dx1 = (max(train_pat(1,:))-min(train_pat(1,:)))/(steps-1);
dx2 = (max(train_pat(2,:))-min(train_pat(2,:)))/(steps-1);
for i = 1:N,
    % map values (x1, x2) to corresponding indices (ind1, ind2) of p_x_c(ind1, ind2)
    % we only computed probabilities for this area
    if (test_pat(1,i) >= min(train_pat(1,:))) && (test_pat(2,i) >= min(train_pat(2,:))) && (test_pat(1,i) <= max(train_pat(1,:))) && (test_pat(2,i) <= max(train_pat(2,:)))
       % test pattern lies inside the area for which we have computed
       % the likelihood --> go on
       ind1 = ceil((test_pat(1,i)-min(train_pat(1,:)))/dx1);
       ind2 = ceil((test_pat(2,i)-min(train_pat(2,:)))/dx2);
       
       % Why (ind2, ind1,...) instead of (ind1, ind2,...)?
       % p_x1_x2_class1 is a matrix. Therefore the x1-direction is
       % addressed by the column-index and x2-direction by the row index.
       p_x_1_p_1 = p_x1_x2_class1(ind2,ind1)*p_c(1);
       p_x_2_p_2 = p_x1_x2_class2(ind2,ind1)*p_c(2);
           
       [m, best]       = max([p_x_1_p_1, p_x_2_p_2]);
       test_tar_hyp(i) = Uc(best);
       %fprintf('index: %d, p_x_1_p_1 = %f, p_x_2_p_2 = %f, correct: %d, decision: %d\n', i, p_x_1_p_1, p_x_2_p_2, test_tar(i), Uc(best));
    end
end

% error counting
num_obs_class1 = sum(test_tar == 0);
num_obs_class2 = sum(test_tar == 1);

corr_recog_class1 = (test_tar == 0) & (test_tar == test_tar_hyp);
corr_recog_class2 = (test_tar == 1) & (test_tar == test_tar_hyp);

err_class1 = 1 - sum(corr_recog_class1)/num_obs_class1;
err_class2 = 1 - sum(corr_recog_class2)/num_obs_class2;

err_total = 1 - (sum(corr_recog_class1)+sum(corr_recog_class2))/(num_obs_class1+num_obs_class2);

fprintf('Total error rate: %.2f%%\n Class 1 error: %.2f%%\n Class 2 error: %.2f%%\n', 100*err_total, 100*err_class1, 100*err_class2);

