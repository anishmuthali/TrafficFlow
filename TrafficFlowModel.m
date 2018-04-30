v_max = 26.8224;
rho_max = 0.2;
dx = 1;
dt = 1;
rho_initial = 0.15;
rho_final = 0.05;
xn = 5;
tn = 5;

index = @(x,t) x + xn*t;
revIndex = @(i) [mod(i,xn),floor(mod(i, tn*xn)/xn)];
rho_0 = @(x) 0;
indexMax = index(xn-1,tn-1);
S = sparse(indexMax+1);
B = zeros(indexMax+1,1);
num = 0;
for i=0:indexMax
    currCoord = revIndex(i);
    currX = currCoord(1);
    currT = currCoord(2);
    if (currX == 0)
        S(i+1,i+1) = 1;
        B(i+1,1) = rho_initial;
    else if currT == 0
        S(i+1,i+1) = 1;
        B(i+1,1) = rho_0(currX);
    else
        X_prev = index(currX-dx,currT);
        T_prev = index(currX,currT-dt);
        S(i+1,X_prev+1) = v_max/(2*rho_max*dx);
        S(i+1,T_prev+1) = -1/dt;
        S(i+1,i+1) = (1/dt) - v_max/(2*rho_max*dx);
        B(i+1,1) = 0;
        end
    end
    
end
Rho = S^-1 * B