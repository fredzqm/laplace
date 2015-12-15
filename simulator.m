classdef simulator < handle
    
    properties (SetAccess = public)
        relationship;
        f = comp(1);
        t;
        seg;
        minResetTime = 0.05;
        minOrder = 20;
    end
    
    methods        
        function created = simulator(initValue , initTime , relationship)
            created.t = initTime;
            created.relationship = relationship;
            for i = 1 : size(initValue, 2)
                created.f(i) = comp( initValue(i) );
            end
            created.seg = 1;
            created.addRelations();
        end
        
        function addRelations(this)
            for k = this.relationship
                comps = [];
                for j = k.comps
                    comps = [comps this.f(this.seg , j)];
                end
                if k.order ~= 0
                    this.f(this.seg , k.addTo).addR(k.coefficient*this.t(this.seg)^k.order , 0 ,  comps );
                end
                this.f(this.seg , k.addTo).addR( k.coefficient, k.order ,  comps );
            end
        end
        
        function compute(this , time)
            u = time / this.minResetTime ;
            for x = 1 : u
                for k = 1 : this.minOrder
                    for i = this.f(this.seg,:)
                        i.compute();
                    end
                end
                this.reset(this.minResetTime);
            end
            for k = 1 : this.minOrder*3
                for i = this.f(this.seg,:)
                    i.compute();
                end
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
            this.addRelations();          
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
            end
        end
        
        function vv = converge(this, t, kk , answer)
            vv = kk;
            aa = kk;
            aa(:) = answer(t);
            for i = 1 : size(kk,2)
                k = kk(i);
                kt = k / t;
                v = (-1)^k / factorial(k) * kt^(k+1);
                x = this.deriv(kt , k);
                vv(i) = v * x;
            end
            plot(kk , vv ,'-', kk , aa , '.');
        end
        
        function plot(this , tt , compare)
            tts = min(tt): (max(tt)-min(tt))/70 : max(tt);
            plot( tt , this.func(tt) , '-'  , tts , compare(tts) , '.');             
        end
        
        function plotDeriv(this , tt , order)
            hold on
            plot( tt , this.deriv(tt , order) , 'y');             
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
    end
end