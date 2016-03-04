% 2*(3*s^2-1)/(3*s^2+1)^3 -> t^2*sin(t)
%% initialize
clear;
s = simulator( {@(s)2*(3*s^2-1)/(3*s^2+1)^3 ...
    @(s)1/(s*s+1)} , 0, ...
   [ rel(1, 12, 1, [2 2 2])  rel(1, -36, 3,[2 2 2 2])  rel(1, 12, 1,[2 2 2 2]) ...
     rel(2,-2, 1, [2 2]) ] );
%% compute
s.minOrder = 3;
s.minResetTime = 0.01;
s.compute(10);

%% plot taylor
figure(2)
hold off
answer = @(s) 2*(3*s.*s-1)/(3*s.*s+1).^3;
t = 25 :0.01: 40 ;
s.plot( t , answer );
% s.plotDeriv( t , 1); 
% s.plotDeriv( t , 2);

%% plot error
figure(3)
s.plotError(t,answer);

%% convergence
figure(1)
hold off
t = 10;
kk = 1 : 40 : 1000;
answer = t^2 * sin(t);
vv = s.converge( t , kk);
plot(kk , vv ,'-', kk , ones(1, size(kk,2)) * answer , '.');