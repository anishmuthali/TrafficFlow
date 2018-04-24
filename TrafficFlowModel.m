v = 26.8224;
rho_max = 0.2;
dx = 1;
dt = 1;
rho_initial = 5;
rho_final = 10;
X_total = 5;
T_total = 5;
num_T = T_total/dt;
num_X = X_total/dx;

index = @(x,t) x + num_X*t;
revIndex = @(i) [mod(i,num_X),floor(mod(i, num_T*num_X)/num_X)];
rho_0 = @(x) 2;
indexMax = index(X_total,T_total);
S = sparse(indexMax);
B = zeros(indexMax,1);
for i=0:indexMax
    [currX,currT] = revIndex(i);
    if currX == 0 || currX == X_total
        S(i,i) = 1;
        B(i,1) = rho_initial;
    elseif currT == 0
        S(i,i) = 1;
        B(i,1) = rho_0(currX);
    else
        
    end
end