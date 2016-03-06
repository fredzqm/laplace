% s/(s^2-b^2) -> cosh(bt)
%% initialize
clear;
b = 1;
s = simulator( {@(s)s/(s^2-b^2) ...
    @(s)1/(s*s-1)} , 0, ...
   [ rel(1, 1, 1, 2)  rel(1, -2, 2, [2 2]) ...
     rel(2,-2, 1, [2 2]) ] );

 %% compute
s.minOrder = 10;
s.minResetTime = 0.01;
s.compute(10);

%% plot taylor
figure(2)
hold off
answer = @(s) s ./(s.^2-b.^2);
t = 0 :0.01: 0.99 ;
s.plot( t , answer );
% s.plotDeriv( t , 1); 
% s.plotDeriv( t , 2);

%% plot error
figure(3)
s.plotError(t,answer);

%% convergence
figure(1)
hold off
t = 5;
kk = 10000 : 50000 : 100000;
answer = cosh(b*t);
vv = s.converge( t , kk);
plot(kk , vv ,'-', kk , ones(1, size(kk,2)) * answer , '.');

%% inverseTransform
figure(4)
hold off
tt = 0 : 0.01 : 1;
k = @(t) 2000;
answer = @(t) cosh(t);
vv = s.converge( tt, ceil(k(tt)));
plot(tt, vv ,'-', tt, answer(tt), '.');

figure(5)
err(tt, vv, answer);
