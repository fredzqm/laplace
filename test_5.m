% 1/(s^2+1) -> sin(t)
%% initialize
clear;
s = simulator( 1 , 0 , ...
   [ rel(1,-2, 1, [1 1]) ] );

%% compute
s.minOrder = 10;
s.minResetTime = 0.01;
s.compute(10);

%% plot taylor
figure(1)
hold off
answer = @(x) 1 ./(x.*x + 1);
<<<<<<< HEAD
t = 1 :0.01: 10 ;
s.plot( t , answer );
% s.plotDeriv( t , 1);
=======
t = 0 :0.01: 10 ;
s.plot( t , answer );
s.plotDeriv( t , 1);
>>>>>>> 0d54de76d0e059573b8e6c182fa280ce93a6efbe
% s.plotDeriv( t , 2);

%%
figure(2)
hold off
t = 25;
kk = 1 : 180;
<<<<<<< HEAD
answer = sin(t);
=======
answer = @(x) sin(x);
>>>>>>> 0d54de76d0e059573b8e6c182fa280ce93a6efbe
vv = s.converge(t,kk , answer);
