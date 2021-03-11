function show_joint_probs(digit, min , max)
    close all;
    pkg load image;

    #digit = 3;
    #min = 155;
    #max = 255;

    digit_number = digit;
    filename = ["/home/noman/Noman_lenux/academic/4th Semester/pattern/digit/digit" int2str(digit_number) '.mat']; 
    load (filename);
    Prob_y = 1/784;
    Prob_x_y = [];



    conditional_x_y = [];
    c =[];
    for i = 1:784
      A = D(:,i);
      B = A >= min & A  <= max ;
      conditional_x_y = [conditional_x_y (sum(B)/length(B))*100];
      Prob_x_y = [Prob_x_y (sum(B)/length(B))*Prob_y];
      
      
      
      #Prob_x_y = [Prob_x_y (conditional_x_y* Prob_y*100000)];
        
     
    endfor

    X = sum(Prob_x_y);
    Prob_x_y = reshape(Prob_x_y, 28,28);
    Prob_x_y = transpose(Prob_x_y);
    title('Joint probability distribution');

    figure(2);
    imshow(Prob_x_y, []);
    figure(1);
    conditional_x_y = reshape(conditional_x_y, 28, 28);
    conditional_x_y = transpose(conditional_x_y);
    #imshow(Prob_x_y, []);
    imshow(conditional_x_y, []);
    title('Conditional probability distribution');

endfunction
