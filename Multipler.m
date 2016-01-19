classdef Multipler < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        a ;
        b ; % two computational unit to be multiplied
        taylor3 ; % taylor series, log(|coe|), coe*k^n/n!,
        len ; % taylor3(:,1) store log(|coe|), while taylor3(:,2) store sign(coe)
    end
    
    methods
        % init is the initial value of comp unit
        function newComp = Multipler(a, b)
            newComp.a = a;
            newComp.b = b;
            newComp.taylor3 = [];
            newComp.len = 0;
        end
        
        % append another term of taylor's series
        function [this] = add( this, v , s )
            this.len = this.len + 1;
            if s == 0
                this.taylor3(this.len , 1) = 0;
            else
                this.taylor3(this.len , 1) = v;
            end
            this.taylor3(this.len , 2) = s;
        end
                
        % compute all relatioins for this term and sum them up
        function [this] = compute(this)
            o = this.len + 1;
            a = this.a.taylor3(1:o , :);
            b = flipud( this.b.taylor3(1:o , :) );
            ss = a(:,2) .* b(:,2);
            vv = a(:,1) + b(:,1);
            ave = max(vv) - 50;
            vv = vv - ave;
            vv = exp(vv) .* ss;
            v = sum(vv);
            s = sign(v);
            v = log(abs(v)) + ave;
            this.add( v , s );
        end
        
        function [v , s] = lastTermLog(this)
            v = this.taylor3(this.len , 1) + multFactor.logfactorial(this.len-1);
            s = this.taylor3(this.len , 2);
        end
    end       
end
