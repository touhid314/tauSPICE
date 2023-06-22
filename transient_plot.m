% implementation is not complete
% might give unexpected error

for i = 1:length(sol)
    x(i) = sol{i,1};
    y(i) = sol{i,2}(3);
    
    plot(x,y)
    xlabel('time'); 
    ylabel('output');
end