<<<<<<< HEAD
% s/(s^2+1) -> cos(t)
%% initialize
clear;
s = simulator( [0 1] , 0 , ...
   [ rel(1, 1, 0, 2)   rel(1, -2, 2 ,[2 2]) ...
     rel(2,-2, 1, [2 2]) ] );

%% compute
s.minOrder = 20;
s.minResetTime = 0.0001;
s.compute(10);
=======
% 1/(s) -> 1 from time 1
%% initialize
clear;
s = simulator( [1] , 1 , ...
   [rel(1, -1, 0, [1 1]) ] );

%% compute
s.minOrder = 10;
s.minResetTime = 1/20;
s.compute(100);
>>>>>>> 0d54de76d0e059573b8e6c182fa280ce93a6efbe

%% plot taylor
figure(1)
hold off
<<<<<<< HEAD
answer = @(x) x ./(x.*x + 1);
t = 0.8:0.01: 1 ;
s.plot( t , answer );
% s.plotDeriv( t , 1); 
% s.plotDeriv( t , 2);
=======
answer = @(x) 1./(x);
t = 0 :0.01: 2;
s.plot( t , answer );
>>>>>>> 0d54de76d0e059573b8e6c182fa280ce93a6efbe

%%
figure(2)
hold off
t = 5;
<<<<<<< HEAD
kk = 1 : 20;
answer = cos(t);
vv = s.converge( t, kk , answer);
=======
kk = 1 : 200;
answer = @(x) 1;
vv = s.converge(t,kk , answer);
>>>>>>> 0d54de76d0e059573b8e6c182fa280ce93a6efbe
