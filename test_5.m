% 1/(s^2+1) -> sin(t)
%% initialize
clear;
s = simulator( 1 , 0 , ...
   [ rel(1,-2, 1, [1 1]) ] );

%% compute
s.minOrder = 150;
s.minResetTime = 1/20;
s.compute(75);

%% plot taylor
figure(1)
hold off
answer = @(x) 1 ./(x.*x + 1);
t = 0 :0.01: 10 ;
s.plot( t , answer );
s.plotDeriv( t , 1);
s.plotDeriv( t , 2);

%%
figure(2)
hold off
t = 5;
kk = 1 : 150;
answer = @(x) sin(x);
vv = s.converge(t,kk , answer);
