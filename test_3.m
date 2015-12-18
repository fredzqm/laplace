%% initialize sqrt(x+1)*cos(x^2)
clear;
s = simulator({@(t)sqrt(t+1)*cos(t^2)  @(t)sqrt(t+1)*sin(t^2) @(t)1/(t+1)} , 0 , ...
   [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
    rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
    rel(3, -1, 0, [3 3]) ] );

%% compute
s.minOrder = 20;
s.minResetTime = 0.1;
s.compute(150);

%% plot taylor
figure(1)
hold off
answer = @(x) sqrt(x+1).*cos(x.^2);
t = 0 :0.01: 10 ;
s.plot( t , answer );

