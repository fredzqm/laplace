classdef simulator < handle
    
    properties (SetAccess = public)
        f = comp(0);
        t = [];
    end
    
    methods
        
        function v = func(this , tt)
            v = tt ;
            seg = 1;
            lower = 0 ;
            upper = this.findThresh(1);
            for i = 1 : size(tt , 2)
                while tt(i) > upper
                    seg = seg + 1;
                    lower = upper;
                    upper = this.findThresh(seg);
                end
                v(i) = this.f(seg , 1).func( tt(i) - lower );
            end
        end
        
        
        function thresh = findThresh(this, seg)
            if size(this.t , 2) < seg
                thresh = inf;
            else
                thresh = this.t(seg);
            end
        end
        
        
        function reset(this , thresh)
            
            
        end
        
    end
end