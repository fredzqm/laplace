% x(t) = sin(t^2)
%% initialize
clear;
s = simulator( [0 1] , 0 , ...
   [rel( 1 , 2 , 1 , 2 ) ...
    rel( 2 , -2 , 1 , 1 ) ] );

%% compute
u = 20;
for x = 1 : u
    s.compute(100)
    if x ~= u
        s.reset(x/2);
    end
end

%% display
figure(1)
hold off
answer = @(t) sin(t.^2);
t = 9 :0.001: 10 ;
s.plot( t , answer );
