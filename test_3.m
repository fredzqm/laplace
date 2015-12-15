%% initialize
clear;
s = simulator();
s.f(1) = comp(1);
s.f(2) = comp(0);
s.f(3) = comp(1);
% s.addR( addTo, coefficient , order , comps )
s.addR( 1 , 1/2 , 0 , [1 3] );
s.addR( 1 , -2  , 1 , 2 );
s.addR( 2 , 1/2 , 0 , [2 3] );
s.addR( 2 , 2 , 1 , 1 );
s.addR( 3 , -1, 0 , [3 3]);
s.start();

%% compute
u = 1500;
for x = 1 : u
    s.compute(10)
    if x ~= u
        s.reset(x/20);
    end
end

%% plot taylor
answer = @(x) sqrt(x+1).*cos(x.^2);
t = 0 :0.01: 2 ;
s.plot( t , answer );

