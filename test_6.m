% 1/(s) -> 1 from time 1
%% initialize
clear;
s = simulator( [1] , 1 , ...
   [rel(1, -1, 0, [1 1]) ] );

%% compute
s.minOrder = 10;
s.minResetTime = 1/20;
s.compute(100);

%% plot taylor
figure(1)
hold off
answer = @(x) 1./(x);
t = 0 :0.01: 2;
s.plot( t , answer );

%%
figure(2)
hold off
t = 5;
kk = 1 : 200;
answer = @(x) 1;
vv = s.converge(t,kk , answer);