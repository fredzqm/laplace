
s = simulator();
s.f(1) = comp(0);
s.f(2) = comp(1);

s.f(1).addR( 1, 0 , s.f(2) );
s.f(2).addR( -1, 0 , s.f(1) );

for k = 1 : 20
    for i = 1 : size(s.f,2)
        s.f(i).compute();
    end
end


t = 0 :0.001: 6 ;
plot( t , s.func(t) ) 
