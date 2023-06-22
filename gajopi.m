function sol = gajopi(a,b)
format long;
%this function solves a linear equation by gauss jordan elimination method
%with pivoting
%   input is a and b, where the equation is ax = b;

%input validation
sa = size(a);
sb = size(b);
if sa(2) ~= sb(1)
    sol = NaN;
    return;
end

%main code starts

A=[a b];

n = length(a);

for i = 1:n
    
    %code for pivotal condensation
    max = abs(A(i,i));
    p = i; %p holds the row number of the row where amk > akk
    
    for l = i+1:n
        if abs(A(l,i)) > max
            max = A(l,i);
            p = l;
        end
    end
    
    %exchanging row
    if (p ~= i)
        %exchanging p-th and i-th row
        for q = 1:(n+1)
            temp = A(i,q);
            A(i,q) = A(p,q);
            A(p,q) = temp;
        end
    end
    
    %
    for j = 1:(n-i)
        A(j+ i,:) = A(j+i,:) - ( (A(i,:)./A(i,i)) * A(j+i,i)) ;
    end
end

x = zeros(n,1);

%back substitution
for i = 0:n-1
    sum = 0;
    
    for j = 1:n
            sum = sum + A(n-i,j)*x(j, 1);    
    end
    
    x(n-i) = (A(n-i, n+1) - sum)/A(n-i, n-i);
end

sol = x;

end

% %sample data
% a=[2 3 5;3 4 1;6 7 2];
% b=[23 14 26]';
