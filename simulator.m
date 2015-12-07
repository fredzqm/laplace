classdef simulator < handle
    
    properties (SetAccess = public)
        rel = [];
        f = comp(0);
        t = 0 ;
        seg = 1;
    end
    
    methods
        function addR(this , addTo, coefficient , order, comps )
            newAdd.addTo = addTo ;
            newAdd.coefficient = coefficient ;
            newAdd.order = order ;
            newAdd.comps = comps ;
            this.rel = [this.rel newAdd]; 
        end
        
        function start(this)
            for k = this.rel
                comps = [];
                for j = k.comps
                    comps = [ comps this.f(this.seg , j)];
                end
                if k.order ~= 0
                    this.f(this.seg , k.addTo).addR(k.coefficient*this.t(this.seg)^k.order , 0 ,  comps );
                end
                this.f(this.seg , k.addTo).addR( k.coefficient, k.order ,  comps );
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
                vv(i) = this.f(segn , 1).func( tt(i) - this.t(segn));
            end
        end
                
        function compute(this , times)
            for k = 1 : times
                for i = this.f(this.seg,:)
                    i.compute();
                end
            end 
        end
        
        function reset(this , resetTime)
            this.t = [this.t resetTime];
            newSegComp = [];
            for k = 1 : size( this.f , 2 )
                newSegComp = [newSegComp  comp( this.f(this.seg,k).func( resetTime - this.t(this.seg) ) ) ];
            end
            this.f = [this.f ; newSegComp];
            this.seg = this.seg + 1;
            this.start();
        end
        
        function plot(this , tt , compare)
            plot( tt , this.func(tt) , '-' , tt , compare(tt) , '.' ); 
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