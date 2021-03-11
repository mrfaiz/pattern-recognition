function [p_x_c, p_c] = parzen_likelihood(trn_pat, trn_tar, test_pat, var)

% Parzen window based estimate of the likelihood.

% Classify using the Parzen windows algorithm
% Inputs:
% 	trn_pat             - Training patterns
%	trn_tar             - Training targets
%   test_pat            - Compute likelihood for these test values
%	var                 - Variance of Gaussian Parzen window
%
% Outputs
%	p_x_c               - Estimated likelihood p(x|c) (computed for test_pat)
%   p_c                 - Estimated prior probability
%
% Author: H. Schramm, 2014

N       = size(test_pat, 2);       % number of test samples
Uc      = unique(trn_tar);         % existing classes
p_x_c	= zeros(length(Uc), N);    % build Uc x N zero matrix
x_i     = trn_pat;

for j = 1:length(Uc),                          % for each class
    indices   = find(trn_tar == Uc(j));        % Uc(j) is label of current class
    p_c(j)    = length(indices)/size(x_i,2);   % prior probability
    n		  = length(indices);               % number of training samples
    
    for i = 1:n,                               % for each training(!) sample
        % Compute the squared Euclidean distance between test vectors x and
        % train vectors x_i instead of just using simple distance x-x_i (as shown in Equation 27, page 168 of
        % Duda/Hart). This distance metric is defined as sum_{each vector component d}(x_d - x_id)^2
        % x_i(:,indices(i))           -->  one training sample (the one with index n)
        % x_i(:,indices(i))*ones(1,N) -->  repeat the sample N times to get the same size as test_pat
        % (test_pat - x_i(:,indices(i))*ones(1,N)).^2 --> Compute squared distances for each test pattern 
        % and current train pattern.
        % sum((test_pat - x_i(:,indices(i))*ones(1,N)).^2) --> sum over the vector components (definition 
        % of the Euclidean distance)
        % temp --> Euclidean distance (scalar) between each display point (x) and current training observation.
        temp      = sum((test_pat - x_i(:,indices(i))*ones(1,N)).^2);  % Euclidean distance is used instead of x - x_i

        % This sums the different parzen windwows as shown in equation 27.
        % The sum is carried out over each training sample.
        %p_x_c(j,:)    = p_x_c(j,:) + phi(temp./var);
        p_x_c(j,:)    = p_x_c(j,:) + phi(temp, var);
    end
    
    % Normalization
    p_x_c(j,:) = p_x_c(j,:) / sum(p_x_c(j,:));
end

% Gaussian distribution
function p = phi(val, s)

% Gaussian density (mean=0) of the Euclidean distance between each display point and each training sample
p = exp(-0.5*((val)./s).^2)./(sqrt(2*pi)*s);
