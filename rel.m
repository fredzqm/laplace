classdef rel
    properties (SetAccess = public)
        addTo;
        coefficient;
        order;
        comps;
    end
    
    methods
        function newAdd =  rel(addTo, coefficient , order, comps )
            newAdd.addTo = addTo ;
            newAdd.coefficient = coefficient ;
            newAdd.order = order ;
            newAdd.comps = comps ;
        end
                
        function r = normalize(r)
            if size(r.comps, 1) > 1
                return;
            end
            oldComps = sort(r.comps);
            newComps = [oldComps(1) ; 0];
            for e = oldComps
                if newComps(1, size(newComps, 2)) == e
                    newComps(2, size(newComps, 2)) = newComps(2, size(newComps, 2)) + 1;
                else
                    newComps(1, size(newComps, 2) + 1) = e;
                    newComps(2, size(newComps, 2)) = 1;
                end
            end
            r.comps = newComps;
        end
    end
    
end