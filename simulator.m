classdef simulator < handle
    
    properties (SetAccess = public)
        funct; % ideal function of each term 
        adderRel; % calculate multipler relationship
        multRel; % calculate multipler relationship
        f ;
        t ; % start time of each segment
        seg; % the last segment
        minResetTime = 0.05; % default minResetTime
        minOrder = 20; % default minOrder
    end

    methods
        % take three terms -- funct (the function of comps)
        %                  -- initTime (the time to start compute)
        %                  -- relation (the relation of comps)
        function created = simulator(funct , initTime , relation)
            created.t = initTime;
            created.funct = funct;
            [created.adderRel, created.multRel] = rephraseRel(relation);
            created.seg = 1;
            created.f = created.createUnit(initTime);
            repeatCompute(created.f, 10);
        end
        
        % compute a certain time given the minResetTime and minorder 
        function compute(this , time)
            repeatCompute(this.f(this.seg) , this.minOrder);
            u = time / this.minResetTime ;
            status = 0;
            for x = 1 : u
                this.reset(this.minResetTime);
                repeatCompute(this.f(this.seg) , this.minOrder);
                if x/u - status > 0.01
                    status = x/u;
                    fprintf('Computing ... %2d %%\n', uint8(status*100));
                end
            end
            fprintf('Finish computing\n');
        end
        
        % reset the computation process at segDuration time after the last
        % seg starts
        function reset(this , segDuration)
            resetTime = segDuration + this.t(this.seg);
            this.t = [this.t resetTime];
            newSegComp = this.f(1,:);
            for k = 1 : size( this.f , 2 )
                newSegComp(k) = getAdder( this.f(this.seg,k).calc( resetTime - this.t(this.seg) , 0) ) ;
            end
            this.f = [this.f ; newSegComp];
            this.seg = this.seg + 1;
            start(this.relation , newSegComp, this.t(this.seg) );
        end
       
        % used to find the threshold hold to turn into the next segment.
        % used for func() and deriv()
        function thresh = findThresh(this, seg)
            if size(this.t , 2) < seg + 1
                thresh = inf;
            else
                thresh = this.t(seg + 1);
            end
        end
       
        % calculate the value of time array tt
        function vv = func(this , tt)
            vv = tt ;
            segn = 1;
            upper = this.findThresh(1);
            for i = 1 : size(tt , 2)
                while tt(i) > upper
                    segn = segn + 1;
                    upper = this.findThresh(segn);
                end
                vv(i) = this.f(segn).adder(1).calc( tt(i) - this.t(segn) , 0);
            end
        end
        
        % find the value of k-th order derivative of time arry tt
        function vv = deriv(this , tt , k)
            vv = tt ;
            segn = 1;
            upper = this.findThresh(1);
            for i = 1 : size(tt , 2)
                while tt(i) > upper
                    segn = segn + 1;
                    upper = this.findThresh(segn);
                end
                vv(i) = this.f(segn).adder(1).calc( tt(i) - this.t(segn) , k );
                continue;
            end
        end
        
        % plot the function and make comparasion
        function plot(this , tt , compare)
            tts = min(tt): (max(tt)-min(tt))/70 : max(tt);
            plot( tt , this.func(tt) , '-'  , tts , compare(tts) , '.');             
        end
        
        % plot the comparative error
        function plotError(this , tt , compare)
            plot( tt , this.func(tt)./compare(tt)-1 );             
        end
        
        % plot the derivative
        function plotDeriv(this , tt , order)
            hold on
            plot( tt , this.deriv(tt , order) , 'y');  
        end

        % plot the curve to show convergence. will be used to find inverse laplace
        % It does not necessary needed to be called after the simulator has compute
        % in this range.
        % It uses funct to initialize an array of comps used to cacluate
        % the derivative, so it depends on derivAcc but not on func().
        % We can use this function immediately after initialization
        function vv = converge(this, t, kk , answer)
            vv = kk;
            aa = kk;
            aa(:) = answer;
            stepSize = 60;
            next = 0;
            for i = 1 : size(kk,2)
                k = kk(i);
                kt = k / t;
                a = multFactor.stir(k);
                b = (k+1) * log(t);
                [c , s] = this.derivAcclog(kt , k);
                vv(i) = exp( a - b + c );
                if (s > 0) == mod(k,2) 
                    vv(i) = - vv(i);
                end
                if k >=  next
                    next = (floor(kk(i)/stepSize)+1) * stepSize;
                    fprintf('Computing converge ... k = %2d \n', k);
                end
            end
            fprintf('Finish computing converge\n');
            plot(kk , vv ,'-', kk , aa , '.');
        end
        
        function [v , s] = derivAcclog(this , t , k)
            unit = this.createUnit(t);
            repeatCompute(unit, k);
            [v , s] = unit.adder(1).lastTermLog();
        end
        
        function unit = createUnit(this, initTime)
            for i = 1 : size(this.funct, 2)
                unit.adder(i) = Adder( this.funct{i}(initTime) );
            end
            for i = 1 : size(this.multRel, 2)
                mult = this.multRel(i);
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
                unit.multer(i) = Multipler(a, b);
            end
            
            for i = 1 : size(this.adderRel, 2)
                for k = this.adderRel(i).list
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


% repeat compute all comps order times.
function repeatCompute(unit, order)
    for k = 1 : order
        if ~ isfield( unit , 'multer')
            for i = unit.multer
                i.compute();
            end
        end
        for i = unit.adder
            i.compute();
        end
    end
    
end
