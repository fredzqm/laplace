%% initialize
clear;
s = simulator( [1 0 1] , 0 , ...
   [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
    rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
    rel(3, -1, 0, [3 3]) ] );

%% compute
u = 1500;
for x = 1 : u
    s.compute(10)
    if x ~= u
        s.reset(x/20);
    end
end

%% plot taylor
figure(1)
hold off
answer = @(x) sqrt(x+1).*cos(x.^2);
t = 0 :0.01: 2 ;
s.plot( t , answer );

