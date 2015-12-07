% x(t) = sin(t^2)
%% initialize
clear;
s = simulator();
s.f(1) = comp(0);
s.f(2) = comp(1);
% s.addR( addTo, coefficient , comps )
s.addR( 1 , 2 , 1 , 2 );
s.addR( 2 , -2 , 1 , 1 );
s.start();

%% compute
u = 20;
for x = 1 : u
    s.compute(30)
    if x ~= u
        s.reset(x/2);
    end
end

%% display
answer = @(t) sin(t.^2);
t = 0 :0.01: 10 ;
s.plot( t , answer );