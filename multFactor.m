classdef multFactor
    properties (Constant)
        factorialThreshold = 150 ;
        factorialErrorThreshold = 0.000000000000001 ;
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
             persistent data;
             s = size( data );
             if a > b
                 m = 1;
                 return
             end
             if ( a > s(1)  || b > s(2) || data(a,b) == 0)
                m = 1;
                for x = a : b
                    m = m * x;
                end
                data(a,b) = m;
             end
             m = data(a,b);
        end
        
    end
    
end