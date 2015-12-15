% x(t) = sin(t)
%% initialize
clear;

s = simulator( [0 1] , 0 , ...
   [rel( 1 , 1 , 0 , 2 ) ...
    rel( 2 , -1, 0 , 1 ) ] );

%% compute
u = 200 ;
for x = 1 : u
    s.compute(100)
    if x ~= u
        s.reset(x/20);     
    end
end

%% display
figure(1)
hold off
answer = @(x) sin(x);
t = 0 :0.01: 20 ;
s.plot( t , answer );

