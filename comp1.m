classdef comp1 < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        rel ; % relationship to other component
        taylor ; % taylor series fixed now
        taylor2 ;
    end
    
    properties (Dependent)
        len ; % quick way to find the length of current taylor's series
    end
    
    methods
        % init is the initial value of comp unit
        function newComp = comp1( init )
            newComp.rel = [];
            newComp.taylor = init;
            newComp.taylor2 = init;
        end
        
        function v = get.len(this)
            v = size(this.taylor , 2) ;
        end
        
        % append another term of taylor's series
        function [this] = add( this, value )
            this.taylor2(this.len + 1 ) = value * factorial(this.len);
            this.taylor(this.len + 1 ) = value;
        end
        
        % call comp.addR( coefficient , order , list of comps multiplied ] );
        % add a relationship term
        function [this] = addR(this , coefficient , order , comps )
            newAdd.coefficient = coefficient ;
            newAdd.order = order ;
            newAdd.comps = comps ;
            this.rel = [this.rel newAdd]; 
        end
        
        % compute all relatioins for this term and sum them up
        function [this] = compute(this)
            next = 0;
            for  k = this.rel
                next = next + this.computeItem( k );
            end
            this.add(next / this.len );
        end
        
        % compute the result of one relation
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
            elseif numComp == 2
                v = convEnd(k.comps(2).taylor(1 : o) , k.comps(1).taylor(1 : o));
            else
                a = k.comps(numComp).taylor(1 : o);
                while( numComp > 2 )
                    numComp = numComp - 1;
                    a = convEqualLen(a , k.comps(numComp).taylor(1 : o));
                end
                v = convEnd(a , k.comps(1).taylor(1 : o));
            end
            v = v * k.coefficient ;
        end
        
        % calculate the value of taylor series at certain point
        % taylor1 (potential source of underflow)
        function v = func(this, t )
            v = this.taylor(this.len) ;
            for  i = this.len - 1  : -1 : 1
                v = v * t + this.taylor(i) ;
            end
        end
        
        % calculate the value of taylor series at certain point
        % using taylor2
        function v = deriv(this, t , k )
            v = this.taylor2(this.len) ;
            for  i = this.len - 1 : -1 : k + 1
                v = v * t / (i - k) + this.taylor2( i ) ;
            end
        end
        
        function v = calc(this, t , k )
            if k == 0
                v = this.func(t);
            else
                v = this.deriv(t, k);
            end
        end
        
        function [v , s] = lastTermLog(this)
            v = this.taylor2(this.len);
            s = sign(v);
            v = log(abs(v));
        end
    end       
end

% convolution two array of the same size, return the last term
function v = convEnd( a , b)
    v = 0;
    len = size( a , 2 );
    for i = 1 : len
        v = v + a(i) * b(len-i+1);
    end
end

% convolution two array of the same size, return the whole array
function v = convEqualLen( a , b )
    len = size(a,2);
    v = zeros(1 , len);
    for i = b
        v = v + i * a;
        a = [0 a(1:len-1)];
    end
end