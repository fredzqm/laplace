 classdef Adder < handle
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
        function newComp = Adder( init )
            newComp.rel = [];
            newComp.taylor3(1,1) = log(abs(init));
            newComp.taylor3(1,2) = sign(init);
        end
        
        function v = get.len(this)
            v = size(this.taylor3 , 1) ;
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
                this.add(log(abs(value)) + ave - log(this.len) , sign(value) );
            else
                [v, s] = this.computeItem( this.rel(1) );
                this.add( v - log(this.len) , s );
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
                v = k.comps.taylor3(o , 1);
                s = k.comps.taylor3(o , 2);
            end
            v = v + log(abs(k.coefficient));
            if k.coefficient < 0
                s = -s;
            end
        end
        
        function [v , s] = lastTermLog(this)
            v = this.taylor3(this.len , 1) + multFactor.logfactorial(this.len-1);
            s = this.taylor3(this.len , 2);
        end
    end       
end
