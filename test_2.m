% x(t) = sin(t^2)
%% initialize
clear;
s = simulator( [0 1] , 0 , ...
   [rel( 1 , 2 , 1 , 2 ) ...
    rel( 2 , -2 , 1 , 1 ) ] );

%% compute
s.minOrder = 100;
s.minResetTime = 1/2;
s.compute(9);

%% display
figure(1)
hold off
answer = @(t) sin(t.^2);
t = 0 :0.01: 10 ;
s.plot( t , answer );
