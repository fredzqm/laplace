classdef comp3 < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        rel ; % relationship to other component
        taylor3 ; % taylor series, log(|coe|), coe*k^n/n!, 
        taylor3sign;
    end
    
    properties (Dependent)
        len ; % quick way to find the length of current taylor's series
    end
    
    methods
        % init is the initial value of comp unit
        function newComp = comp3( init )
            newComp.rel = [];
            newComp.taylor3 = log(abs(init));
            newComp.taylor3sign = sign(init);
        end
        
        function v = get.len(this)
            v = size(this.taylor3 , 2) ;
        end
        
        function coe = taylor2(this, order)
            coe = exp(this.taylor3(order)) * this.taylor3sign(order);
        end
        
        % append another term of taylor's series
        function [this] = add( this, value , sign )
%             this.taylor2(this.len + 1 ) = value * factorial(this.len);
            this.taylor3(this.len + 1 ) = value;
            this.taylor3sign(this.len + 1 ) = sign;
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
                % TODO:
                next = next + this.computeItem( k );
            end
            this.add(next , sign);
        end
        
        % compute the result of one relation
        function v = computeItem( this ,  k )
            o = this.len - k.order;
            if o < 1
                v = 0;
                return;
            end
            v = 0 ;
            
            if size( k.comps , 2 ) == 1
                v = k.comps(1).taylor2(o);
            else
                a = k.comps(1).taylor2(1:o);
                as = k.comps(1).taylor3(1:o);
                b = fliplr( k.comps(2).taylor2(1:o) );
                bs = fliplr( k.comps(2).taylor3(1:o) );
                mf = multFactor.firstList(o);
                s = as .* bs;
                vv = a + b + mf;
                vfactor = (min(vv) + max(vv)) / 2;
                vv = vv - vfactor;
                vv = exp(vv);
                sum(vv) ;
%                 for i = 1 : o
%                     v = v + k.comps(2).taylor2(i) * k.comps(1).taylor2(o-i+1) * multFactor.first(i,o-i+1);
%                 end
            end
            
            v = v * k.coefficient * multFactor.second( o, this.len-1 );
        end
        
        % calculate the value of taylor series at certain point
        % using taylor2
        function v = calc(this, t , derivOrder )
            v = this.taylor2(this.len) ;
            for  i = this.len - 1 : -1 : derivOrder + 1
                v = v * t / (i - derivOrder) + this.taylor2( i ) ;
            end
        end
    end       
end
