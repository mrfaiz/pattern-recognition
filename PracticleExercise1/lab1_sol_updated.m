# Solution for lab 1 updated
# Group member 
# 1.Faiz Ahmed id: 1152231,
# 2.Md Abu Noman Majumdar id: 1144101, 
# 3.Mohammad Abir Reza id: 1151705

## a
close all;
N = 100;
# Matrix A generation
A = fix(10*rand(N,N)) # fix must be used to keep the values integer 
                      # and in the [0,10) interval because it truncate decimal values
                      # rand for uniform distribution in range (0,1)
                  
# Matrix B generation
B = round(10*randn(N)) # randn function for normal distribution with 0 means and one varience
                       # rund function used for round up to nearest integer number 
                       
## b
amax = max(A(:));
amin = min(A(:));
bmax = max(B(:));
bmin = min(B(:));


## c
a = [];
for i=amin:amax
  x = length(find (A==i));
  a = [a x];
end

b = [];
for i=bmin:bmax
  y = length(find (B==i));
  b = [b y];
end

## d ,e
figure(1);
bar(amin:amax, a);
title ("Uniform distribution over 100*100 metrix in [0,10) range");
xlabel("matrix entry ")
ylabel("frequency")
hold on;
line([amin-1 amax+1],[mean(a(:)) mean(a(:))], 'Color','g'); # plot the mean frequency line

figure(2);
bar(bmin:bmax, b);
title ("Normal distribution  over 100*100 metrix with 0 means and 10 veriance");
xlabel("matrix entry ")
ylabel("frequency")

## f
# Generate  probability distribution from histogram 
a_norm = a./N^2;
b_norm = b./N^2;
figure(3);
bar(amin:amax, a_norm);

figure(4);
bar(bmin:bmax, b_norm);

#probabilities sum 
sum_a= sum(a_norm);
sum_b= sum(b_norm);

fprintf("Probability  of all elements in A: %.2f\n", sum_a);#output:   Probability  of all elements in A: 1.00
fprintf("Probability of all elements in B: %.2f\n", sum_b); #output:   Probability of all elements in B: 1.00

## g

# Normal distribution function to Figure 4
data = bmin:0.1:bmax;

# compute mean and variance
m = mean(B(:));
s = std(B(:));

ndf = exp(-0.5*((data-m)./s).^2)./(sqrt(2*pi)*s);

hold on;
plot(data, ndf, 'r');

## h

# We need to find the index position of mean = 0 
mean_position = -bmin+1


Data_freq_1st_std = sum(b_norm(mean_position-10:mean_position+10))# Sum up all elements in between [-std , +std]
Data_freq_2nd_std = sum(b_norm(mean_position-20:mean_position+20))# Sum up all elements in between [-2std , +2std]
Data_freq_3rd_std = sum(b_norm(mean_position-30:mean_position+30))# Sum up all elements in between [-3std , +3std]

fprintf("[-std,   +std]: %.5f\n", Data_freq_1st_std);
fprintf("[-2std, +2std]: %.5f\n", Data_freq_2nd_std);
fprintf("[-3std, +3std]: %.5f\n", Data_freq_3rd_std);

