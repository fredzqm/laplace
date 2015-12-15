classdef simulator < handle
    
    properties (SetAccess = public)
        relation; % calculate relationship between comps
        f = comp(1); % comps used to calcuate taylor series
        t ; % start time of each segment
        seg; % the last segment
        minResetTime = 0.05; % default minResetTime
        minOrder = 20; % default minOrder
    end
    
    methods        
        function created = simulator(initValue , initTime , relation)
            created.t = initTime;
            created.relation = relation;
            for i = 1 : size(initValue, 2)
                created.f(i) = comp( initValue(i) );
            end
            created.seg = 1;
            addRelations(relation , created.f, initTime);
            repeatCompute(created.f, 10);
        end
        
        function compute(this , time)
            u = time / this.minResetTime ;
            repeatCompute(this.f(this.seg, :) , this.minOrder);
            for x = 1 : u
                this.reset(this.minResetTime);
                repeatCompute(this.f(this.seg, :) , this.minOrder);
            end
        end
        
        function vv = func(this , tt)
            vv = tt ;
            segn = 1;
            upper = this.findThresh(1);
            for i = 1 : size(tt , 2)
                while tt(i) > upper
                    segn = segn + 1;
                    upper = this.findThresh(segn);
                end
                vv(i) = this.f(segn , 1).func(tt(i) - this.t(segn));
            end
        end
        
        function vv = deriv(this , tt , k)
            vv = tt ;
            segn = 1;
            upper = this.findThresh(1);
            for i = 1 : size(tt , 2)
                while tt(i) > upper
                    segn = segn + 1;
                    upper = this.findThresh(segn);
                end
                vv(i) = this.f(segn , 1).deriv( tt(i) - this.t(segn) , k );
                continue;
            end
        end
        
        function plot(this , tt , compare)
            tts = min(tt): (max(tt)-min(tt))/70 : max(tt);
            plot( tt , this.func(tt) , '-'  , tts , compare(tts) , '.');             
        end
        
        function plotDeriv(this , tt , order)
            hold on
            plot( tt , this.deriv(tt , order) , 'y');  
        end
        
        function vv = converge(this, t, kk , answer)
            vv = kk;
            aa = kk;
            aa(:) = answer(t);
            for i = 1 : size(kk,2)
                k = kk(i);
                kt = k / t;
%                 v = (-1)^k  * (kt)^(k+1) /  factorial(k);
%                 v = (-1)^k / factorial(k) * (k/exp(1))^(k+1);
                v = (-1)^k / sqrt(2*pi*k) * (k/exp(1));
                v = v * (exp(1)/t)^(k+1) ;
%                 v = (-1)^k * (kt)^(k+1);
                x = this.derivAcc(kt , k);
                vv(i) = v * x;
            end
            plot(kk , vv ,'-', kk , aa , '.');
        end
        
        function v = derivAcc(this , t , k)
            segn = 1;
            upper = this.findThresh(1);
            while t > upper
                segn = segn + 1;
                upper = this.findThresh(segn);
            end
            leftDuration =  t - this.t(segn);
            newSegComp = this.f(1,:);
            for q = 1 : size( this.f , 2 )
                newSegComp(q) = comp( this.f(segn,q).func( leftDuration ) ) ;
            end
            addRelations(this.relation , newSegComp , t );
            repeatCompute(newSegComp, k);
            v = newSegComp(1).taylor2(k+1)
        end
    end
    
    
    
    methods (Access = private)
       function thresh = findThresh(this, seg)
            if size(this.t , 2) < seg + 1
                thresh = inf;
            else
                thresh = this.t(seg + 1);
            end
       end
       
       
       function reset(this , segDuration)
            resetTime = segDuration + this.t(this.seg);
            this.t = [this.t resetTime];
            newSegComp = this.f(1,:);
            for k = 1 : size( this.f , 2 )
                newSegComp(k) = comp( this.f(this.seg,k).func( resetTime - this.t(this.seg) ) ) ;
            end
            this.f = [this.f ; newSegComp];
            this.seg = this.seg + 1;
            addRelations(this.relation , newSegComp, this.t(this.seg) );
       end
        
       
    end
end


function addRelations(relation, segComp , startTime)
    for k = relation
        comps = [];
        for j = k.comps
            comps = [comps segComp(j)];
        end
        if k.order ~= 0
            segComp(k.addTo).addR(k.coefficient* startTime^k.order , 0 ,  comps );
        end
        segComp(k.addTo).addR( k.coefficient, k.order ,  comps );
    end
end

function repeatCompute(comps, order)
    for k = 1 : order
        for i = comps
            i.compute();
        end
    end
end