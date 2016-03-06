% s/(s^2-b^2) -> cosh(bt)
%% initialize
clear;
b = 1;
s = simulator( {@(s)s/(s^2-b^2) ...
    @(s)1/(s*s-1)} , 0, ...
   [ rel(1, 1, 1, 2)  rel(1, -2, 2, [2 2]) ...
     rel(2,-2, 1, [2 2]) ] );

%% convergence
figure(1)
hold off
t = 50;
kk = 1000 : 300 : 20000;
answer = cosh(b*t);
vv = s.converge( t , kk);
plot(kk , vv ,'-', kk , ones(1, size(kk,2)) * answer , '.');

%% inverseTransform
figure(4)
hold off
tt = 0 : 0.01 : 1;
k = @(t) t .* t * 10 + 100;
answer = @(t) cosh(b*t);
vv = s.converge( tt, ceil(k(tt)));
plot(tt, vv ,'-', tt, answer(tt), '.');

figure(5)
err(tt, vv, answer);
