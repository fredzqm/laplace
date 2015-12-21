classdef multFactor
    properties (Constant)
        factorialThreshold = 150 ;
        factorialErrorThreshold = 0.000000000000001 ;
        stirlingUpper = 1e100;
        stirlingUpper2 = 1e150;
        stirlingLower = 1e-100;
    end
    methods (Static)
        function m = first(a,b)
            persistent data;
            if a > b
                m = multFactor.first(b,a);
                return
            end
            % at this point a <= b
            s = size( data );
            if( a > s(1) || b > s(2) || data(a,b) == 0 )
                if a == 1
                    data(a,b) = 1;
                elseif a + b < multFactor.factorialThreshold
                    data(a,b) = vpa( factorial(a+b-2)/factorial(a-1)/factorial(b-1) );
                else
                    x = multFactor.first(a,b-1)/(b-1)*(a+b-2);
                    y = multFactor.first(a-1,b)/(a-1)*(a+b-2);
                    % error calculation to ensure accuracy
                    data(a,b) = (x + y) /2;
                    error = abs(x-y)/data(a,b);
                    if ( error > multFactor.factorialErrorThreshold )
                        fprintf('error is large: %f%%\n' , double(error*100) );
                    end
                end
            end
            m = data(a,b);
        end
        
        function m = second(a,b)
%              persistent data;
%              if a > b
%                  m = 1;
%                  return
%              end
%              s = size( data );
%              if ( a > s(1)  || b > s(2) || data(a,b) == 0)
%                 if b - a < 2
                    m = 1;
                    for x = a : b
                        m = m * x;
                    end
%                     data(a,b) = m;
%                 else
%                     data(a,b) = multFactor.second(a,b-1) * b;
%                 end
%              end
%              m = data(a,b);
        end
        
        function m = stir(k)
            persistent data;
            s = size( data );
            if s(2) < k || data(k) == 0
                if k < 120
                    data(k) = k ^(k+1) / factorial(k) ;
                else
                    m = 1;
                    n = k + 1;
                    b = k;
                    f = k;
                    while(b <= multFactor.stirlingUpper2)
                        if mod(n,2) == 1
                            m = m * b;
                            n = (n-1) / 2;
                        else
                            n = n / 2;
                        end
                        b = b * b;
                    end
%                   fprintf( 'is %f n:%d f:%d m:%5f\n', log( m * b^n / factorial(f) ) , n , f , log(m) / log(10) );
                    while( n > 0 || f > 1)
                        while( f > 1 && m >= multFactor.stirlingLower )
                            m = m / f;
                            f = f - 1;
                        end
%                         fprintf( 'b %f n:%d f:%d m:%5f\n', log( m * b^n / factorial(f) ) , n , f , log(m) / log(10) );
                        while( n > 0 && m <= multFactor.stirlingUpper)
                            m = b * m ;
                            n = n - 1;
                        end
%                         fprintf( 'a %f n:%d f:%d m:%5f\n', log( m * b^n / factorial(f) ) , n , f , log(m) / log(10) );
                     end
                    data(k) = m;
                end
            end
            m = data(k);
        end
    end
    
end