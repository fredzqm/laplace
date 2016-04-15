classdef simulator < handle
    
    properties (SetAccess = public)
        known;
        % represent the differential equation system
        funct; % ideal function of each term
        adderRel; % calculate multipler relationship
        multRel; % calculate multipler relationship
        
        % represent the computational units in this simulator
        f ;
%         t ; % start time of each segment
        
        computeTill; % the last segment
        
        % configuration for computing
        minResetTime = 0.05; % default minResetTime
        minOrder = 5    ; % default minOrder
    end

    methods
        % take three terms -- funct (the function of comps)
        %                  -- initTime (the time to start compute)
        %                  -- relation (the relation of comps)
        function created = simulator(funct , initTime , relation)
%             created.t = initTime;
            if isa(funct, 'cell')
                for i = 1 : size(funct, 2)
                    if ~isa(funct{i}, 'function_handle')
                        error('Exact functions should be given in the cell arrays');
                    end
                end
                created.known = 1;
            else
                if ~isa(funct, 'double')
                    error('initial values of elements should be given in the array');
                end
                created.known = 0;
            end
            created.funct = funct;
            [created.adderRel, created.multRel] = rephraseRel(relation);
            created.computeTill = initTime;
            created.f = compUnit(created, initTime);
            repeatCompute(created.f, 10);
        end
        
        function v = t(this, index)
            v = this.f(index).t;
        end
        
        function ret = simulatorValue(this, element, t)
             if this.known
                ret = this.funct{element}(t);
             else
                if size( this.f, 2) == 0
                    ret = this.funct(element);
                else
                    ret = this.calc(element, t, 0);
                end
             end
        end
        
        % compute a certain time given the minResetTime and minorder 
        function compute(this , time)
            [index, upper] = this.findIndex(this.computeTill);
            if this.known == 0 && upper ~= inf
                % those compUnits might not be accurate enough
                this.f(index+1:end) = []; 
            end
            repeatCompute(this.f(index) , this.minOrder);
            u = ceil( time / this.minResetTime );
            status = 0;
            fprintf('Start computing\n');
            for x = 1 : u
                unit = this.createUnit(this.computeTill + x * this.minResetTime);
                repeatCompute(unit , this.minOrder);
                if x/u - status > 0.01
                    status = x/u;
                    fprintf('Computing ... %2d %%\n', uint8(status*100));
                end
            end
            fprintf('Finish computing\n');
            this.computeTill = this.computeTill + u * this.minResetTime;
        end
                
        % note that tt should be a tiem array in ascending order
        function vv = calc(this, element, tt, order)
            vv = tt ;
            [segn, upper] = this.findIndex(tt(1));
            for i = 1 : size(tt , 2)
                if tt(i) > upper
                    [segn, upper] = this.findIndex(tt(i), segn);
                end
                vv(i) = this.f(segn).adder(element).calc( tt(i) - this.t(segn), order);
                continue;
            end
        end
        
        function [index, upper] = findIndex(this, t, pre)
            high = size(this.f, 1);
            if nargin > 3 && pre + 2 <= high
                if this.t(pre+1) < t && this.t(pre+2) > t
                    index = pre + 1;
                    upper = this.t(pre+2);
                    return;
                end
            end
            if high == 1
                index = 1;
                upper = inf;
                return;
            end
            if t >= this.t(high)
                index = high;
                upper = inf;
                return;
            end
            if t < this.t(2)
                index = 1;
                upper = this.t(2);
                return;
            end
            low = 1;
            while(1)
                k = (high - low) / (this.t(high) - this.t(low));
                index = floor((t - this.t(low)) * k) + low;
                if index <= low || index >= high
                    while(t > this.t(index+1))
                        index = index + 1;
                    end
                    while(t < this.t(index))
                        index = index - 1;
                    end
                    upper = this.t(index + 1);
                    return;
                end
                if this.t(index) <= t
                    if this.t(index + 1) > t
                        upper = this.t(index + 1);
                        return;
                    end
                    low = index;
                else
                    if this.t(index - 1) <= t
                        index = index - 1;
                        upper = this.t(index);
                        return;
                    end
                    high = index - 1;
                end
            end
        end
        
        % plot the function and make comparasion
        function plot(this , tt , compare)
            tts = min(tt): (max(tt)-min(tt))/70 : max(tt);
            plot( tt , this.calc(1, tt, 0) , '-'  , tts , compare(tts) , '.');             
        end
        
        % plot the comparative error
        function plotError(this , tt , compare)
            err(tt, this.calc(1, tt, 0) , compare);
        end
               
        % plot the derivative
        function plotDeriv(this , tt , order)
            hold on
            plot( tt , this.calc(1, tt, order) , 'y');  
        end

        % plot the curve to show convergence. will be used to find inverse laplace
        % It does not necessary needed to be called after the simulator has compute
        % in this range.
        % It uses funct to initialize an array of comps used to cacluate
        % the derivative, so it depends on derivAcc but not on func().
        % We can use this function immediately after initialization
        function vv = converge(this, tt, kk)
            if size(tt, 2) ~= size(kk, 2)
                if size(tt, 1) == 1 && size(tt, 2) == 1 
                    tt = tt * ones(1, size(kk,2));
                end
                if size(kk, 1) == 1 && size(kk, 2) == 1 
                    kk = kk * ones(1, size(tt,2));
                end
            end
            vv = zeros(1, size(tt,2));
            status = 0;
            u = size(kk,2);
            fprintf('Start computing converge\n');
            for i = 1 : size(kk,2)
                vv(i) = this.postInversion(kk(i), tt(i));
                if i/u - status > 0.01
                    status = i/u;
                    fprintf('Computing %2d%% ... k = %2d t = %2f \n',uint8(status*100), kk(i), tt(i));
                end
            end
            fprintf('Finish computing converge\n');
        end
                
        function v = postInversion(this, k, t)
            a = multFactor.stir(k);
            b = (k+1) * log(t);
            [c , s] = this.derivAcclog(k/t , k);
            v = exp( a - b + c );
            if (s > 0) == mod(k,2) 
                v = - v;
            end
        end
        
        function [v , s] = derivAcclog(this , t , k)
            unit = this.createUnit(t);
            repeatCompute(unit, k);
            [v , s] = unit.adder(1).derivLog(k + 1);
        end
   
        
        % create a computational unit with initial value provided with 
        % this.simulatorValue(), which return the accurate function value
        % if known, otherwise estimate with PSM.
        function unit = createUnit(this, initTime)
            [index, upper] = this.findIndex(initTime);
            if this.t(index) == initTime
                unit = this.f(index);
            else
                unit = compUnit(this, initTime);
                if upper == inf
                    this.f = [this.f ; unit];
                else
                    this.f = [this.f(1:index); unit; this.f(index+1:end)];
                end
%                 if initTime > this.computeTil & initTime <= this.computeTil + this.minResetTime
%                     this.computeTil = this;
%                 end
            end
        end
        
    end
    
end


% repeat compute all comps order times.
function repeatCompute(unit, order)
    for k = 1 : order
        for i = unit.multer
            i.compute();
        end
        for i = unit.adder
            i.compute();
        end
    end
    
end
