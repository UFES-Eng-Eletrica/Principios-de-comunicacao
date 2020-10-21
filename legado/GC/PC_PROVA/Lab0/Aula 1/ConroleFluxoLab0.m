% PC I - Laboraório 0 - 29/03/2018
% Wagner Trarbach Frank

% Código da página 49 do slide do Lab 0 do AVA
% Interpretar o código


n = input('Enter the number of linhas');
m = input ('Enter the number of columns');
A = [];  % define an empty matrix A

for k = 1:n              % start of the first for-end loop
    for h = 1:m          % start of the second for-end loop
        if k == 1        % starto the conditional statement
            A(k,h) = h;  % assign values of the elements of the first row
        elseif h == 1
            A(k,h) = k;  % assign values to the elements of the first column
        else
            A(k,h) = A(k,h-1)+A(k-1,h);  % assign values to the other elements;
        end  % end of the if statement
    end      % end of the nested for-end loop
end          % end of the first for-end loop
A