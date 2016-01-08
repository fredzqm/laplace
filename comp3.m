classdef comp3 < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        rel ; % relationship to other component
        taylor3 ; % taylor series, log(|coe|), coe*k^n/n!,
        % taylor3(:,1) store log(|coe|), while taylor3(:,2) store sign(coe)
    end
    
    properties (Dependent)
        len ; % quick way to find the length of current taylor's series
    end
    
    methods
        % init is the initial value of comp unit
        function newComp = comp3( init )
            newComp.rel = [];
            newComp.taylor3(1,1) = log(abs(init));
            newComp.taylor3(1,2) = sign(init);
        end
        
        function v = get.len(this)
            v = size(this.taylor3 , 1) ;
        end
        
        function coe = taylor2(this, order)
            coe = exp(this.taylor3(order , 1)) * this.taylor3(order , 2);
        end
        
        % append another term of taylor's series
        function [this] = add( this, v , s )
            l = this.len + 1;
            this.taylor3(l , 1) = v;
            this.taylor3(l , 2) = s;
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
            if size(this.rel, 2) > 1
                next = zeros( size(this.rel, 2), 2);
                for i = 1 : size(this.rel, 2)
                    [v, s] = this.computeItem( this.rel(i) );
                    next(i, 1) = v;
                    next(i, 2) = s;
                end
                ave = max(next(:,1));
                next(:,1) = next(:,1) - ave;
                next(:,1) = exp(next(:,1)) .* next(:,2);
                value = sum(next(:,1));
                this.add(log(abs(value)) + ave , sign(value) );
            else
                [v, s] = this.computeItem( this.rel(1) );
                this.add( v , s );
            end
        end
        
        % compute the result of one relation
        function [v, s] = computeItem( this ,  k )
            o = this.len - k.order;
            if o < 1
                v = 0;
                s = 0;
                return;
            end
            if size( k.comps , 2 ) == 1
                v = k.comps(1).taylor3(o , 1);
                s = k.comps(1).taylor3(o , 2);
            else
                a = k.comps(1).taylor3(1:o , :);
                b = flipud( k.comps(2).taylor3(1:o , :) );
                mf = multFactor.firstList(o);
                ss = a(:,2) .* b(:,2);
                vv = a(:,1) + b(:,1) + mf;
                ave = max(vv) - 50;
                vv = vv - ave;
                vv = exp(vv) .* ss;
                v = sum(vv);
                s = sign(v);
                v = log(abs(v)) + ave;
            end
            v = v + log(abs(k.coefficient)) + log(multFactor.second( o, this.len-1 ));
            if k.coefficient < 0
                s = -s;
            end
        end
        
        % calculate the value of taylor series at certain point
        % using taylor2
        function v = calc(this, t , derivOrder)
            v = this.taylor2(this.len) ;
            for  i = this.len - 1 : -1 : derivOrder + 1
                v = v * t / (i - derivOrder) + this.taylor2( i ) ;
            end
        end
    end       
end
