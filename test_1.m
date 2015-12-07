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
u = 200 ;
for x = 1 : u
    s.compute(40)
    if x ~= u
        s.reset(x/20);     
    end
end

%% display
answer = @(x) sin(x);
t = 0 :0.01: 20 ;
s.plot( t , answer );