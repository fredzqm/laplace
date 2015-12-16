<<<<<<< HEAD
%% initialize sin( sqrt(t^2+1))
=======
%% initialize
>>>>>>> 0d54de76d0e059573b8e6c182fa280ce93a6efbe
clear;
s = simulator( [1 0 1] , 0 , ...
   [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
    rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
    rel(3, -1, 0, [3 3]) ] );

%% compute
s.minOrder = 20;
s.minResetTime = 0.1;
s.compute(150);

%% plot taylor
figure(1)
hold off
answer = @(x) sqrt(x+1).*cos(x.^2);
t = 0 :0.01: 5 ;
s.plot( t , answer );

