 classdef Adder < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        rel ; % relationship to other component
        taylor3 ; % taylor series, log(|coe|), coe*k^n/n!,
        taylor2 ; % use for derivative
        len ; % taylor3(:,1) store log(|coe|), while taylor3(:,2) store sign(coe)
    end
    
    methods
        % init is the initial value of comp unit
        function newComp = Adder( init )
            newComp.rel = [];
            newComp.taylor3(1,2) = sign(init);
            if sign(init) ~= 0
                newComp.taylor3(1,1) = log(abs(init));
            end
            newComp.len = 1;
        end
        
        % append another term of taylor's series
        function [this] = add( this, v , s )
            this.len = this.len + 1;
            if s == 0
                this.taylor3(this.len , 1) = 0;
            else
                this.taylor3(this.len , 1) = v - log(this.len - 1);
            end
            this.taylor3(this.len , 2) = s;
        end
        
        function [this] = updateDerv(this)
            if size(this.taylor3, 1) > size(this.taylor2, 1)
                for i = size(this.taylor2, 1) + 1 : size(this.taylor3, 1)
                    this.taylor2(i , 1) = this.taylor3(i , 1) + multFactor.logfactorial(i-1);
                end
            end
        end
        
        function [v , s] = derivLog(this, order)
            this.updateDerv();
            v = this.taylor2(order , 1);
            s = this.taylor3(order , 2);
        end
        
        % call comp.addR( coefficient , order , list of comps multiplied ] );
        % add a relationship term
        function [this] = addR(this , coefficient , order , comps )
            if coefficient ~= 0
                if coefficient < 0
                    newAdd.coeNeg = 1;
                else
                    newAdd.coeNeg = 0;
                end
                newAdd.coeVal = log(abs(coefficient)) ;
                newAdd.order = order ;
                newAdd.comps = comps ;
                this.rel = [this.rel newAdd];
            end
        end
        
        % compute all relatioins for this term and sum them up
        function [this] = compute(this)
            if size(this.rel, 2) ~= 1
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
            v = k.comps.taylor3(o , 1);
            s = k.comps.taylor3(o , 2);
            v = v + k.coeVal;
            if k.coeNeg
                s = -s;
            end
        end
        
        function v = calc(this, t, order)
            s = sign(t);
            t = abs(t);
            if order == 0
                if s == 0
                    v =  exp(this.taylor3(1, 1)) * this.taylor3(1 , 2);
                    return;
                end
                x = log(t) .* (0:this.len-1)' + this.taylor3(: , 1);
                x = exp(x) .* this.taylor3(: , 2);
            else
                this.updateDerv();
                if s == 0
                    v =  exp(this.taylor2(1+order, 1)) * this.taylor3(1+order , 2);
                    return;
                end
                x = log(t) .* (0:this.len-order-1)' + this.taylor2(1+order:end , 1);
                for i = 1 : this.len-order
                    x(i) = x(i) - multFactor.logfactorial(i-1);
                end
                x = exp(x) .* this.taylor3(1+order:end , 2);
            end
            if s == -1
                x = x .* (-1).^(0:size(x,2)-1);
            end
            v = sum(x);
        end
       
        
    end       
end
