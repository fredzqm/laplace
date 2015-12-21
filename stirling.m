clear
tt = 100 : 200 ;                     
d(3,:) = tt;
for i = 1 : size(tt , 2)
    k = tt(i);
    d(1, i) = log( k ^(k+1) / factorial(k) );
    d(2, i) = log( multFactor.stir(k) );
    d(3, i) = exp( d(1, i) - d(2, i) );
%     erro(i) = factorial(n) / exp( n*log(n) - n ) ;
end
% plot( tt , d(3 ,:) , 'b');
plot(tt, d(1, :), '-b', tt, d(2, :) , '.r');