v_max = 26.8224;
rho_max = 0.2;
dx = 1;
dt = 1;
rho_initial = 0.15;
rho_final = 0.15;
X_total = 5;
T_total = 5;
num_T = T_total/dt;
num_X = X_total/dx;

index = @(x,t) x + num_X*t;
revIndex = @(i) [(mod(i,num_X)),(floor(mod(i, num_T*num_X)/num_X))];
rho_0 = @(x) 0;
indexMax = index(X_total,T_total);
S = sparse(indexMax);
B = zeros(indexMax,1);
revIndex(0)
for i=0:indexMax-1
    currCoord = revIndex(i);
    currX = currCoord(1);
    currT = currCoord(2);
    if currX == 0 || currX == X_total
        S(i+1,i+1) = 1;
        B(i+1,1) = rho_initial;
    elseif currT == 0
        S(i+1,i+1) = 1;
        B(i+1,1) = rho_0(currX);
    else
        X_next = index(currX+dx,currT);
        T_next = index(currX,currT+dt);
        S(i+1,X_next+1) = -v_max/(2*rho_max*dx);
        S(i+1,T_next+1) = 1/dt;
        S(i+1,i+1) = -(1/dt) + v_max/(2*rho_max*dx);
        B(i+1,1) = 0;
    end
end
Rho = S^-1 * B;
Rho