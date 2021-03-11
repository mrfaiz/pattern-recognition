
close all;


for i = 0:9
    filename = ["../digits/digit" int2str(i) '.mat']; 
    load (filename);
    
    figure(1);
    
    m = mean(D);
    m = reshape(m, 28, 28);
    m = transpose(m);
    subplot(211);
    imshow(m, []);
    title('Mean of each pixel');

    v = var(D);
    v = reshape(v, 28, 28);
    v = transpose(v);
    subplot(212);
    imshow(v, []);
    title('Variance of each pixel');

    pause(1);
end


