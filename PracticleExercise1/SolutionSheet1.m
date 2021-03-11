% Solution for Exercise Sheet 1
% Author: H. Schramm

close all;
hold off;

N = 100;

% Generation of matrices A and B
% fix must be used for A to assure the interval [0, 10) since 
% this function truncates the decimal values. round realizes a 
% commercial rounding and is therefore appropriate for determining B.

A=fix(10*rand(N,N)); 

% randn returns a matrix with normally distributed random elements having zero mean and variance one.
B=round(10*randn(N));

amax = max(A(:));
amin = min(A(:));
bmax = max(B(:));
bmin = min(B(:));

a = [];
for i=amin:amax
  a = [a length(find (A==i))];
end

b = [];
for i=bmin:bmax
  b = [b length(find (B==i))];
end


figure(1);
bar(amin:amax, a);

% draw the mean frequency line
hold on;
line([min(A(:))-0.5 max(A(:))+0.5],[mean(a(:)) mean(a(:))], 'Color','r');

% axis scaling
axis([min(A(:))-1 max(A(:))+1]);

figure(2);
bar(bmin:bmax, b);

% axis scaling
axis([min(B(:))-1 max(B(:))+1]);

% convert histogram into probability distribution
a_norm = a./N^2;
b_norm = b./N^2;

figure(3);
bar(amin:amax, a_norm);

% axis scaling
axis([min(A(:))-1 max(A(:))+1]);

figure(4);
bar(bmin:bmax, b_norm);

% axis scaling
axis([min(B(:))-1 max(B(:))+1]);

% check if probabilities sum up to 1
a_sum = sum(a_norm);
b_sum = sum(b_norm);

fprintf("Probability mass of frequency of elements in A: %.2f\n", a_sum);
fprintf("Probability mass of frequency of elements in B: %.2f\n", b_sum);

% add normal distribution function to Figure 4
t = bmin:0.1:bmax;

% determine mean and variance
m = mean(B(:));
s = std(B(:));

f = exp(-0.5*((t-m)./s).^2)./(sqrt(2*pi)*s);

hold on;
plot(t, f, 'r');

% determine percentage of probability mass lying in the range mean +/- standard deviation

% get the index of the element positioned at mean = 0 (note: indexing starts at 1)
zero_index = -bmin+1

% sum up elements around mean (+/- sigma)
sum_plusminus_s = sum(b_norm(zero_index-10:zero_index+10))


% sum up elements around mean (+/- 2*sigma)
sum_plusminus_2s = sum(b_norm(zero_index-20:zero_index+20))

% sum up elements around mean (+/- 3*sigma)
sum_plusminus_3s = sum(b_norm(zero_index-30:zero_index+30))


