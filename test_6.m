% s/(s^2+1) -> cos(t)
%% initialize
clear;
s = simulator( {@(s)s/(s*s+1) @(s)1/(s+1)} , 0, ...
   [ rel(1, 1, 0, 2)   rel(1, -2, 2 ,[2 2]) ...
     rel(2,-2, 1, [2 2]) ] );

% %% compute
% s.minOrder = 3;
% s.minResetTime = 0.001;
% s.compute(10);
% 
% %% plot taylor
% figure(1),LLLLLLLLLLLLLLLLLLL
% hold off
% answer = @(x) x ./(x.*x + 1);
% t = 0.5 :0.01: 10 ;
% s.plot( t , answer );
% % s.plotDeriv( t , 1); 
% % s.plotDeriv( t , 2);
% 
% %% plot error
% figure(3)
% s.plotError(t,answer);

%% convergence
figure(2)
hold off
t = 10;
kk = 1 : 200;
answer = cos(t);
vv = s.converge( t, kk , answer);
