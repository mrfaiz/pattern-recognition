clear all;
close all;
load "iris_data.mat"
load "iris_species.mat"

# Task 1
setosa_vector = strcmp("setosa",species);
setosa_matrix = meas(setosa_vector, :);
 
versicolor_vector = strcmp('versicolor', species);
versicolour_matrix = meas(versicolor_vector, :);
 
virginica_vector = strcmp('virginica', species);
virginica_matrix = meas(virginica_vector, :);
 
iris = cat(3, setosa_matrix, versicolour_matrix, virginica_matrix);
fprintf("Setosa\n");
disp(iris(:, :, 1));

fprintf("versicolor\n");
disp(iris(:, :, 2));

fprintf("virginica\n");
disp(iris(:, :, 3));

# Task 2
iris1 = cell(51,5,3); 

obs = strcat({'Obs'}, num2str((1:50)', '%d'));
iris1(2:end, 1, :) = repmat(obs, [1 1 3]);

iris1(1, 1, 1) = "Setosa";
iris1(1, 1, 2) = "Versicolor";
iris1(1, 1, 3) = "Virginica";

attribute = {"SepalLength", "SepalWidth", "PetalLength", "PetalWidth"};
iris1(1, 2:end, :) = repmat(attribute, [1 1 3]);

iris1(2:end, 2:end, 1) = num2cell(setosa_matrix);
iris1(2:end, 2:end, 2) = num2cell(versicolour_matrix);
iris1(2:end, 2:end, 3) = num2cell(virginica_matrix);

# Task 3
function printcell (data)

for i = 1:size(data, 3)
    fprintf("\n%20s %15s %15s %15s %15s\n", data{1, 1:size(data,2), i})
    for j = 2:size(data, 1)
        fprintf ("%20s %10.2f    %13.2f    %12.2f    %12.2f\n", data{j, 1:size(data,2), i})
    end
    fprintf("\n");
end
endfunction

# Task 4
setosa = reshape([iris1{2:51, 2:5, 1}], 50, 4);
versicolor = reshape([iris1{2:51, 2:5, 2}], 50, 4);
virginica = reshape([iris1{2:51, 2:5, 3}], 50, 4);

# Task 5
mv_array = cell(3, 5);
mv_array(2:3, 1) = {"mean", "variance"}';
mv_array(2, 2:5) = num2cell(mean(double(versicolor(:, 1:4))));
mv_array(3, 2:5) = num2cell(var(double(versicolor(:, 1:4))));
mv_array(1, 2:5) = {"SepalLength", "SepalWidth", "PetalLength", "PetalWidth"};
printcell(mv_array);

# Task 6

data_name_setosa = "Setosa";
data_name_versicolor = "Versicolor";
data_name_virginica = "Virginica";

function color = pickColor(dataString)
  switch (dataString)
    case "Setosa"
      color = "bo";
    case "Versicolor"
      color = "r*";
    case "Virginica"
      color = "gx";
    otherwise
      color = "rx";
  endswitch
endfunction

function visualize(figNumber, data1, data2, data1_name, data2_name)
  figure(figNumber);
  hold on; # to hold previously plotted data
  plot(data1(:, 1), data1(:, 2), pickColor(data1_name));
  plot(data2(:, 1), data2(:, 2), pickColor(data2_name));  
  xlabel("Sepal Length");
  ylabel("Sepal Width");
  title_str = strcat(data1_name, ' vs ', data2_name);
  title(title_str);
  legend(data1_name, data2_name);
endfunction

figureno = 1;
visualize(figureno++, setosa, versicolor, data_name_setosa, data_name_versicolor);
visualize(figureno++, setosa, virginica, data_name_setosa, data_name_virginica);
visualize(figureno++, versicolor, virginica, data_name_versicolor, data_name_virginica);

## meged figure 
figure(figureno);
hold on;
plot(setosa(:,1), setosa(:,2), pickColor(data_name_setosa));
plot(versicolor(:,1), versicolor(:,2), pickColor(data_name_versicolor));
plot(virginica(:,1), virginica(:,2), pickColor(data_name_virginica));
xlabel("Sepal Length");
ylabel("Sepal Width");
title(strcat(data_name_setosa,' vs ', data_name_versicolor, ' vs ', data_name_virginica));
legend(data_name_setosa, data_name_versicolor, data_name_virginica);
