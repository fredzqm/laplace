% s/(s^2+1) -> cos(t)
%% initialize
clear;
s = simulator( {@(s)s/(s*s+1) @(s)1/(s*s+1)} , 0, ...
   [ rel(1, 1, 0, 2)   rel(1, -2, 2,[2 2]) ...
     rel(2,-2, 1, [2 2]) ] );

%% compute
s.minOrder = 3;
s.minResetTime = 0.01;
s.compute(10);

%% plot taylor
figure(2)
hold off
answer = @(x) x ./(x.*x + 1);
t = 0 :0.01: 40 ;
s.plot( t , answer );
% s.plotDeriv( t , 1); 
% s.plotDeriv( t , 2);

%% plot error
figure(3)
s.plotError(t,answer);

%% convergence
figure(1)
hold off
t = 10.2;
kk = 1 : 500 : 10000;
answer = cos(t);
vv = s.converge( t , kk);
plot(kk , vv ,'-', kk , ones(1, size(kk,2)) * answer , '.');

%% inverseTransform
figure(4)
hold off
tt = 0 : 0.5 : 20;
k = @(t) t .* t * 10 + 100;
answer = @(t) cos(t);
vv = s.converge( tt, ceil(k(tt)));
plot(tt, vv ,'-', tt, answer(tt), '.');

figure(5)
err(tt, vv, answer);

