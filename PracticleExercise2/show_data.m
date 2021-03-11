function show_data(im_num)
  close all;
  pkg load image;
  
  for i = 0:9
     filename = ["../digits/digit" int2str(i) '.mat'];  
     load(filename)
   
      for j = 1:im_num       
          I = D(j,:);           
          I= reshape(I, 28, 28); # Conver I to size to 28 x 28
          I = transpose(I);
          figure(j);
          
          imshow(I, []);
          pause(0.5);  
      end
  end
endfunction  

