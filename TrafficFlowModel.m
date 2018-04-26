v_max = 26.8224;
rho_max = 0.2;
dx = 1;
dt = 1;
rho_initial = 0.15;
rho_final = 0.15;
xn = 5;
tn = 5;

index = @(x,t) x + xn*t;
revIndex = @(i) [mod(i,xn),floor(mod(i, tn*xn)/xn)];
rho_0 = @(x) 0;
indexMax = index(xn-1,tn-1);
S = sparse(indexMax+1);
B = zeros(indexMax+1,1);
indexMax
num = 0;
for i=0:indexMax
    currCoord = revIndex(i);
    currX = currCoord(1);
    currT = currCoord(2);
    if (currX == 0)
        S(i+1,i+1) = 1;
        B(i+1,1) = rho_initial;
    elseif(currX == xn-1)
        S(i+1,i+1) = 1;
        B(i+1,1) = rho_final;
    elseif currT == 0
        S(i+1,i+1) = 1;
        B(i+1,1) = rho_0(currX);
    elseif currT ~= tn-1
        X_next = index(currX+dx,currT);
        T_next = index(currX,currT+dt);
        if(T_next+1>=25)
            currX
            currT
        end
        S(i+1,X_next+1) = -v_max/(2*rho_max*dx);
        S(i+1,T_next+1) = 1/dt;
        S(i+1,i+1) = -(1/dt) + v_max/(2*rho_max*dx);
        B(i+1,1) = 0;
    end
    
end
Rho = S^-1 * B