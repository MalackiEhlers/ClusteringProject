function D = L2_distance(a, b)
    % Computes the Euclidean distance matrix between columns of a and b
    % Input: a (d x n), b (d x m)
    % Output: D (n x m), where D(i,j) = ||a(:,i) - b(:,j)||_2
    
    if nargin < 2
        b = a;
    end
    
    aa = sum(a.^2, 1);           % 1 x n
    bb = sum(b.^2, 1);           % 1 x m
    ab = a' * b;                 % n x m
    
    D = sqrt(bsxfun(@plus, aa', bb) - 2 * ab);
    D = real(D);                 % Clean up numerical noise
end