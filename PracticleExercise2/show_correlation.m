function show_correlation (digit, x_co_pix, y_co_pix)
    close all;
    pkg load image;
    digit_number = digit;
    filename = ["../digits/digit" int2str(digit_number) '.mat']; 
    load (filename);


    pixel = (y_co_pix - 1) *  28 + x_co_pix;


    A = zeros(28, 28);
    A(y_co_pix, x_co_pix) = 255;


    if var(D(:, pixel)) == 0
        disp('No Correlation as there is no variance.');
        return;
    else
        correlation = [];
        for i=1:784
            if var(D(:, i)) == 0
                correlation = [correlation 0];
            else
                correlation = [correlation corr(D(:, pixel), D(:, i))];
            end
        end
    end
    correlation = reshape(correlation, 28, 28);
    correlation = transpose(correlation);


    figure(1);
    subplot(211);
    imshow(A);
    title(['Illustration of pixel  ', int2str(pixel),' of digit ', int2str(digit_number)]);

    subplot(212);
    correlation = correlation * 128 + 128;  # scaling to [0,255]
    imshow(correlation, []);
    title(['Correlation image of pixel  ', int2str(pixel), ' of digit ', int2str(digit_number)]);

endfunction



