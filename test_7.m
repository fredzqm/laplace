% 2*(3*s^2-1)/(3*s^2+1)^3 -> t^2*sin(t)
%% initialize
clear;
s = simulator( {@(s)2*(3*s^2-1)/(3*s^2+1)^3 ...
    @(s)1/(s*s+1)} , 0, ...
   [ rel(1, 12, 1, [2 2 2])  rel(1, -36, 3,[2 2 2 2])  rel(1, 12, 1,[2 2 2 2]) ...
     rel(2,-2, 1, [2 2]) ] );

%% convergence
figure(1)
hold off
t = 10;
kk = 1 : 100 : 1000;
answer = t^2 * sin(t);
vv = s.converge( t, kk , answer);
