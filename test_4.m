% 1/(s+1) -> exp(-t)
%% initialize
clear;
s = simulator();
s.f(1) = comp(1);
% s.addR( addTo, coefficient , order , comps )
s.addR( 1 , -1 , 0 , [1 1] );
s.start();

%% compute
u = 1500;
for x = 1 : u
    s.compute(100)
    if x ~= u
        s.reset(x/20);
    end
end

%% plot taylor
figure(1)
hold off
answer = @(x) 1./(x+1);
t = 0 :0.01: 20 ;
s.plot( t , answer );
% s.plotDeriv( t , 1);
% s.plotDeriv( t , 2);

%%
figure(2)
hold off
t = 5;
kk = 1 : 80;
answer = @(x) exp(-x);
vv = s.converge(t,kk , answer);