% 1/(s + a) -> e^-a*t from time 1
%% initialize
clear;
a = 2;
s = simulator( {@(s)1/(s+a)} , 1-a , ...
   [rel(1, -1, 0, [1 1]) ] );
% s = simulator( [1/a] , 1-a , ...
%    [rel(1, -1, 0, [1 1]) ] );


%% compute
s.minOrder = 10;
s.minResetTime = 1/20;
s.compute(100);

%% plot taylor
figure(1)
hold off
answer = @(s) 1./(s+a);
t = 1 :0.01: 20;
s.plot( t , answer );

%% convergence
figure(2)
hold off
t = 2;
kk = 1 : 200;
answer = exp(-a*t);
vv = s.converge( t , kk);
plot(kk , vv ,'-', kk , ones(1, size(kk,2)) * answer , '.');