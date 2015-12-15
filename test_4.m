% 1/(s+1) -> exp(-t)
%% initialize
clear;
s = simulator( [1] , 0 , ...
   [rel(1, -1, 0, [1 1]) ] );

%% compute
s.minOrder = 100;
s.minResetTime = 1/20;
s.compute(75);

%% plot taylor
figure(1)
hold off
answer = @(x) 1./(x+1);
t = 0 :0.01: 20 ;
s.plot( t , answer );
% s.plotDeriv( t , 1);
% s.plotDeriv( t , 2);

%%
figure(2)
hold off
t = 5;
kk = 1 : 80;
answer = @(x) exp(-x);
vv = s.converge(t,kk , answer);