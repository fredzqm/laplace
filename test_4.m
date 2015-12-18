% 1/(s + a) -> e^-a*t from time 1
%% initialize
clear;
a = 2;
s = simulator( {@(s)1/(s+a)} , 1-a , ...
   [rel(1, -1, 0, [1 1]) ] );

%% compute
s.minOrder = 10;
s.minResetTime = 1/20;
s.compute(100);

%% plot taylor
figure(1)
hold off
answer = @(s) 1./(s+a);
t = -0 :0.01: 2;
s.plot( t , answer );

%% convergence
figure(2)
hold off
t = 5;
kk = 3 : 220;
answer = exp(-a*t);
vv = s.converge(t,kk , answer);