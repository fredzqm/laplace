classdef comp < handle
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
        function newComp = comp( init )
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
            v = 0 ;
            if numComp == 1
                v = k.comps(1).taylor(o);
            else
                for i = 1 : o
                    v = v + k.comps(2).taylor(i) * k.comps(1).taylor(o-i+1);
                end
            end
            v = v * k.coefficient ;
        end
                
        % calculate the value of taylor series at certain point
        % using taylor2
        function v = calc(this, t , k )
            v = this.taylor2(this.len) ;
            for  i = this.len - 1 : -1 : k + 1
                v = v * t / (i - k) + this.taylor2( i ) ;
            end
        end
    end       
end
