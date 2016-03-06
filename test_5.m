% 1/(s^2+1) -> sin(t)
%% initialize
clear;
s = simulator( {@(s)1/(s^2+1)} , 0 , ...
   [rel(1,-2, 1, [1 1]) ] );

%% compute
s.minOrder = 10;
s.minResetTime = 0.01;
s.compute(10);

%% plot taylor
figure(2)
hold off
answer = @(x) 1 ./(x.*x + 1);
t = 1 :0.01: 10 ;
s.plot( t , answer );
s.plotDeriv( t , 1);
% s.plotDeriv( t , 2);
%
%% plot error
figure(3)
s.plotError(t,answer);

%% convergence
figure(1)
hold off
t = 5;
kk = 1 : 500 : 10000;
answer = sin(t);
vv = s.converge( t , kk);
plot(kk , vv ,'-', kk , ones(1, size(kk,2)) * answer , '.');

%% inverseTransform
figure(4)
hold off
tt = 0 : 1 : 20;
k = @(t) t .* t + 10;
answer = @(t) sin(t);
vv = s.converge( tt, ceil(k(tt)));
plot(tt, vv ,'-', tt, answer(tt), '.');

figure(5)
plot(tt, vv - answer(tt) ,'-');

