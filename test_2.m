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
for x = 1 : 4
    s.compute(1000)
    if x ~= 4
        s.reset(x/2);
    end
end

%% display
answer = @(t) sin(t.^2);
t = 0 :0.01: 4 ;
s.plot( t , answer );