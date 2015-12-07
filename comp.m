classdef comp < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        rel ; % relationship to other component
        taylor ; % taylor series fixed now
        taylor2 ;
    end
    
    properties (Dependent)
        len ;
    end
    
    methods
        function newComp = comp( init )
            newComp.rel = [];
            newComp.taylor = init;
            newComp.taylor2 = init;
        end
        
        function v = get.len(this)
            v = size(this.taylor , 2) ;
        end
        
        function [this] = add( this, value )
            this.taylor(this.len + 1 ) = value;
        end
        
        function [this] = add2( this, value )
            this.taylor2(this.len + 1 ) = value;
        end
        % call comp.addR( coefficient , order , list of comps multiplied ] );
        % add a relationship term
        function [this] = addR(this , coefficient , order , comps )
            newAdd.coefficient = coefficient ;
            newAdd.order = order ;
            newAdd.comps = comps ;
            this.rel = [this.rel newAdd]; 
        end
        
        function [this] = compute(this)
            next = 0;
            for  k = this.rel
                next = next + this.computeItem( k );
            end
            this.add(next / this.len );
        end
        
        function v = computeItem( this ,  k )
            o = this.len - k.order;
            if o < 1
                v = 0;
                return;
            end
            numComp = size( k.comps , 2 );
            if numComp == 0
                v = 0 ;
            elseif numComp == 1
                v = k.comps(1).taylor(o);
            else
                a = k.comps(numComp).taylor(1 : o);
                while( numComp > 2 )
                    numComp = numComp - 1;
                    b = k.comps(numComp).taylor(1 : o); 
                    a = convEqualLen(a , b);
                end
                b = k.comps(1).taylor(1 : o);
                v = convEnd( a , b);
            end
            v = v * k.coefficient ;
        end
        
        function v = func(this, t )
            v = this.taylor(this.len) ;
            for  i = this.len - 1  : -1 : 1
                v = v * t + this.taylor(i) ;
            end
        end
        
    end       
end


function v = convEnd( a , b)
    v = 0;
    len = size( a , 2 );
    for i = 1 : len
        v = v + a(i) * b(len-i+1);
    end
end

function v = convEqualLen( a , b )
    len = size(a,2);
    v = zeros(1 , len);
    for i = b
        v = v + i * a;
        a = [0 a(1:len-1)];
    end
end





