function sol = solvemat(G,rhs)
%SOLVEMAT this function returns the solution matrix provided the 
% conductance matrix and rhs as input

%deleting first row and first column of G and first row of rhs.
% this is because v0 = 0;
G(1,:) = [];
G(:,1) = [];

rhs(1) = [];

%solving

sol = gajopi(G,rhs); %using gauss jordan elimination method with pivoting

end

