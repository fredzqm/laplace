tt = 0 : 300 ;                     
real = tt;
appr = tt;
erro = tt;
for i = 1 : size(tt , 2)
    n = tt(i);
    real(i) = log( factorial(n) );
    appr(i) = n*log(n) - n;
    erro(i) = factorial(n) / exp( n*log(n) - n ) ;
%     erro(i) = factorial(n) / exp( n*log(n) - n ) ;
end
plot( tt , erro , 'b' , tt , log(tt) , 'y', tt , appr/100 , 'r' ,tt, real/100 , 'g');
% plot(tt, real, tt, appr);