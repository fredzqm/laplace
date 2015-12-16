<<<<<<< HEAD
% 1/(s + a) -> e^-a*t from time 1
%% initialize
clear;
a = 1;
s = simulator( [1] , 1-a , ...
   [rel(1, -1, 0, [1 1]) ] );

%% compute
s.minOrder = 10;
s.minResetTime = 1/20;
s.compute(100);
=======
% 1/(s+1) -> exp(-t)
%% initialize
clear;
s = simulator( [1] , 0 , ...
   [rel(1, -1, 0, [1 1]) ] );

%% compute
s.minOrder = 100;
s.minResetTime = 1/20;
s.compute(75);
>>>>>>> 0d54de76d0e059573b8e6c182fa280ce93a6efbe

%% plot taylor
figure(1)
hold off
<<<<<<< HEAD
answer = @(x) 1./(x);
t = 0 :0.01: 2;
s.plot( t , answer );
=======
answer = @(x) 1./(x+1);
t = 0 :0.01: 20 ;
s.plot( t , answer );
% s.plotDeriv( t , 1);
% s.plotDeriv( t , 2);
>>>>>>> 0d54de76d0e059573b8e6c182fa280ce93a6efbe

%%
figure(2)
hold off
t = 5;
<<<<<<< HEAD
kk = 3 : 200;
answer = exp(-a*t);
=======
kk = 1 : 80;
answer = @(x) exp(-x);
>>>>>>> 0d54de76d0e059573b8e6c182fa280ce93a6efbe
vv = s.converge(t,kk , answer);