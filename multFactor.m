classdef multFactor
    
    methods (Static)
        function m = first(a,b)
           m = factorial(a+b) / factorial(a) / factorial(b);
%             persistent data;
%             if a > b
%                 m = multFactor.first(b,a);
%                 return
%             end
%             if a == 0
%                 m = 1;
%                 return;
%             end
%             s = size( data );
%             if( a > s(1) || b > s(2) ) 
%                 data(a,b) = factorial(a+b) / factorial(a) / factorial(b);
%             end
%             m = data(a,b);
        end
        
        function m = second(a,b)
%              persistent data;
%              s = size( data );
%              if b < a
%                  m = 1;
%                  return
%              end
%              if ( a > s(1) || b > s(2))
                m = 1;
                for x = a : b
                    m = m * x;
                end
%                 data(a,b) = m;
%              end
%              m = data(a,b);
        end
        
    end
    
end