classdef compUnit
     properties (SetAccess = public)
        t;
        adder;
        multer;
     end
    
    methods
        % create a computational unit with initial value provided with 
        % this.simulatorValue(), which return the accurate function value
        % if known, otherwise estimate with PSM.
        function unit = compUnit(simulator, initTime)
            unit.t = initTime;
            for i = 1 : size(simulator.funct, 2)
                if i == 1
                    unit.adder = Adder( simulator.simulatorValue(i, initTime) );
                else
                    unit.adder(i) = Adder( simulator.simulatorValue(i, initTime) );
                end
            end
            for i = 1 : size(simulator.multRel, 2)
                mult = simulator.multRel(i);
                if mult.a.t
                    a = unit.multer(mult.a.i);
                else
                    a = unit.adder(mult.a.i);
                end
                if mult.b.t
                    b = unit.multer(mult.b.i);
                else
                    b = unit.adder(mult.b.i);
                end
                if i == 1
                    unit.multer = Multipler(a, b);
                else
                    unit.multer(i) = Multipler(a, b);
                end
            end
            
            for i = 1 : size(simulator.adderRel, 2)
                for k = simulator.adderRel(i).list
                    if k.multer.t
                        comps = unit.multer(k.multer.i);
                    else
                        comps = unit.adder(k.multer.i);
                    end
                    for order = 0 : k.order
                        unit.adder(i).addR(k.coefficient*nchoosek(k.order,order)...
                            *initTime^order , k.order - order ,  comps );
                    end
                end
            end
        end
        
    end
        
end