% s/(s^2+1) -> cos(t)
%% initialize
clear;
s = simulator( [0 1] , 0 , ...
   [ rel(1, 1, 0, 2)   rel(1, -2, 2 ,[2 2]) ...
     rel(2,-2, 1, [2 2]) ] );

%% compute
s.minOrder = 20;
s.minResetTime = 0.0001;
s.compute(10);

%% plot taylor
figure(1)
hold off
answer = @(x) x ./(x.*x + 1);
t = 0.8:0.01: 1 ;
s.plot( t , answer );
% s.plotDeriv( t , 1); 
% s.plotDeriv( t , 2);

%%
figure(2)
hold off
t = 5;
kk = 1 : 20;
answer = cos(t);
vv = s.converge( t, kk , answer);
