
s = simulator();
s.f(1) = comp(0);
s.f(2) = comp(1);

s.addR( 1 , 1 , 0 , 2 );
s.addR( 2 , -1, 0 , 1 );
% s.f(1).addR( 1, 0 , s.f(2) );
% s.f(2).addR( -1, 0 , s.f(1) );
s.start();

for k = 1 : 20
    s.compute();
end


answer = @(x) sin(x);

t = 0 :0.001: 10 ;
plot( t , s.func(t) , t , answer(t) ); 
