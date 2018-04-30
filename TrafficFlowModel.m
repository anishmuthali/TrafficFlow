v_max = 26.8224; %typical speed on highway (60 mph) in m/s
rho_max = 0.28; %max car density assuming we have only small Fiat 500s on the freeway
dx = 1; %distance steps
dt = 1; %time steps
rho_initial = 0.2083; %density based on average car length of 4.8 m
xn = 5; %space of 5 meters
tn = 5; %time interval of 5 seconds

index = @(x,t) x + xn*t;
revIndex = @(i) [mod(i,xn),floor(mod(i, tn*xn)/xn)];
rho_0 = @(x) (sin(x) + 1)/8; %arbitrary function to determine the initial distribution of cars along the stretch of road
indexMax = index(xn-1,tn-1);
S = sparse(indexMax+1); %sparse matrix of coefficients
B = zeros(indexMax+1,1); %matrix for inversing
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
Rho = S^-1 * B;
Rho = reshape(Rho,[5,5]) %reshapes the matrix such that rows signify x-values and columns signify t-values

%Interpretation of results: 
%--------------------------
%If there is more space at the end of the freeway, cars will try to go as 
%fast as they can to fill up that space. Once there is a backup in that 
%area, cars will move more slowly and they will flow slowly out of the 
%stretch of freeway, stabilizing the density to a constant value. There is 
%a fixed density at the start of the freeway, and after a certain amount 
%of time, the densities throughout the stretch of highway will stabilize 
%to this value because the amount of cars entering the freeway is held 
%constant by this initial condition value.