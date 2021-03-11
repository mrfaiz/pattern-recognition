## Team member 
#1. Faiz Ahmed id: 1152231,
#2. Md Abu Noman Majumdar id: 1144101, 
#3. Mohammad Abir Reza id: 1151705


close all;
clear;


load("twoClasses.mat");

## Part a

# cell structue will be
#  number of class = 2
#=========================
#  class0 Sensor1 Sensor2
#-------------------------
#   Obs_1   -       - 
#   Obs_2   -       -
#     .
#     .
#     .
#   Obs_2000  -       -   

#  class1 Sensor1 Sensor2
#   Obs_1   -       - 
#   Obs_2   -       -
#     .
#     .
#     .
#   Obs_2000   -       -
  
cloud1 = cell(2001,3,2); 
observations = strcat({'Obs_'},num2str((1:2000)','%d'));

cloud1(2:end, 1, :) = repmat(observations, [1 1 2]);

cloud1(1, 1, 1) = "Class0";
cloud1(1, 1, 2) = "Class1";
attribute = {"Sensor1", "Sensor2"};
cloud1(1, 2:end, :) = repmat(attribute,[1 1 2]);

cloud1(2:end, 2:end, 1) = num2cell(transpose(patterns(:, 1:2000)));
cloud1(2:end, 2:end, 2) = num2cell(transpose(patterns(:, 2001:4000)));


## Part b

class0_sensor1 = cell2mat(cloud1(2:end, 2, 1));
class0_sensor2 = cell2mat(cloud1(2:end, 3, 1));

class1_sensor1 = cell2mat(cloud1(2:end, 2, 2));
class1_sensor2 = cell2mat(cloud1(2:end, 3, 2));

### Covariance matrixes of the sensor vectors

#>> cov([class0_sensor1, class0_sensor2])
# ans =
#
#    1.5452206   0.0053226
#    0.0053226   3.1228906

# >> cov([class1_sensor1, class1_sensor2])
# ans =

#   1.037294   0.015407
#   0.015407   1.596455

# Here the minor  diagonal elements are ignorable with respect to main digonal values, so variables are not related.
# Hence, We can use  Gaussian model with independent components


pts_x = min(patterns(1,:)):0.1:max(patterns(1,:)); 
pts_y = min(patterns(2,:)):0.1:max(patterns(2,:)); 

# mean and standard deviation of class 0

mean11 = mean(class0_sensor1);  
std11 = sqrt(var(class0_sensor1));
mean12 = mean(class0_sensor2);  
std12 = sqrt(var(class0_sensor2));

px1 = exp(-0.5*((pts_x-mean11)./std11).^2)./(sqrt(2*pi)*std11);
px2 = exp(-0.5*((pts_y-mean12)./std12).^2)./(sqrt(2*pi)*std12);
p_x_1 = px2'*px1;

# mean and standard deviation of class 1
mean21 = mean(class1_sensor1);
std21 = sqrt(var(class1_sensor1));
mean22 = mean(class1_sensor2);  
std22 = sqrt(var(class1_sensor2));

px1 = exp(-0.5*((pts_x-mean21)./std21).^2)./(sqrt(2*pi)*std21);
px2 = exp(-0.5*((pts_y-mean22)./std22).^2)./(sqrt(2*pi)*std22);
p_x_2 = px2'*px1;

# priors
p_1 = 2000 / 4000;
p_2 = 2000 / 4000;

# evidence
p_x_1_p_1 = p_x_1 * p_1;
p_x_2_p_2 = p_x_2 * p_2;

p_x = p_x_1_p_1 + p_x_2_p_2;

# posteriors
p_1_x = p_x_1_p_1 ./ p_x;
p_2_x = p_x_2_p_2 ./ p_x;

# two point distributions
figure(1);
# To join multiple figures
hold on;

plot(class0_sensor1, class0_sensor2, "*b");
plot(class1_sensor1, class1_sensor2, "or");
legend("class 0", "class 1" );
xlabel("Sensor 1");
ylabel("Sensor 2");

contourf(pts_x, pts_y, p_1_x, [0.5 0.5], 'k-.');
contour(pts_x, pts_y, p_x_1);
contour(pts_x, pts_y, p_x_2);

plot(class0_sensor1, class0_sensor2, "*b");
plot(class1_sensor1, class1_sensor2, "or");



## Part c

## two likelihoods distribution
figure(2);
hold on;
xlabel("Sensor 1");
ylabel("Sensor 2");
zlabel("p(x|class)");
title("Likelihoods distribution")

# show decision boundary
C1 = 0.2*double(p_x_1 > p_x_2);
C2 = 0.5*double(p_x_2 > p_x_1);
C = C1 + C2;
surf(pts_x, pts_y, p_x_1, C);
surf(pts_x, pts_y, p_x_2, C);
view(-23,27);
grid;


## posterior probability P( ω 0 | x )

figure(3);
xlabel("Sensor 1");
ylabel("Sensor 2");
zlabel("p(class|x)");
title("posterior probability P( ω 0 | x )")
hold on;

surf(pts_x, pts_y, p_1_x);
view(-23,27);
grid;
