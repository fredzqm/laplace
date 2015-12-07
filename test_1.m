% x(t) = sin(t)
%% initialize
clear;
s = simulator();
s.f(1) = comp(0);
s.f(2) = comp(1);

s.addR( 1 , 1 , 0 , 2 );
s.addR( 2 , -1, 0 , 1 );
s.start();

%% compute
for x = 1 : 100
    s.compute(20)
    if x ~= 3
        s.reset(x);
    end
end

%% display
answer = @(x) sin(x);
t = 0 :0.1: 20 ;
s.plot( t , answer );