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
    end
    
end