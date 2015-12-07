classdef simulator < handle
    
    properties (SetAccess = public)
        rel = [];
        f = comp(0);
        t = 0 ;
        seg = 1;
    end
    
    methods
        function addR(this , addTo, coefficient , order , comps )
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
                this.f(this.seg , k.addTo).addR( k.coefficient, k.order , comps );
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
                
        function compute(this)
           for i = this.f(this.seg,:)
               i.compute();
           end 
        end
        
        function reset(this , resetTime)
            this.t = [this.t resetTime];
            newSegComp = [];
            for k = 1 : size( this.f , 2 )
                newSegComp = [newSegComp  comp( this.f(this.seg,k).func( resetTime - this.t(this.seg) ) ) ];
            end
            this.seg = this.seg + 1;
            this.f = [this.f ; newSegComp];
            this.start();
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