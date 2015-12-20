classdef simulator < handle
    
    properties (SetAccess = public)
        relation; % calculate relationship between comps
        funct; % ideal function of each term 
        f = comp(1); % comps used to calcuate taylor series
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
            created.relation = relation;
            for i = 1 : size(funct, 2)
                created.f(i) = comp( funct{i}(initTime) );
            end
            created.seg = 1;
            addRelations(relation , created.f, initTime);
            repeatCompute(created.f, 10);
        end
        
        % compute a certain time given the minResetTime and minorder 
        function compute(this , time)
            u = time / this.minResetTime ;
            repeatCompute(this.f(this.seg, :) , this.minOrder);
            status = 0;
            for x = 1 : u
                this.reset(this.minResetTime);
                repeatCompute(this.f(this.seg, :) , this.minOrder);
                if x/u - status > 0.01
                    status = x/u;
                    fprintf('Computing ... %2d %%\n',uint8(status*100) );
                end
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
                vv(i) = this.f(segn , 1).deriv(tt(i) - this.t(segn) , 0);
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
                vv(i) = this.f(segn , 1).deriv( tt(i) - this.t(segn) , k );
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
            for i = 1 : size(kk,2)
                k = kk(i);
                kt = k / t;
%                 v = (-1)^k  * (kt)^(k+1) /  factorial(k);
            % two lines below are essentially the same when k is big, using
            % stiring approximation
%               v = (-1)^k / factorial(k) * (k/exp(1))^(k+1);
                v = (-1)^k / sqrt(2*pi*k) * (k/exp(1)); %
                v = v * (exp(1)/t)^(k+1);
%               v = (-1)^k * (kt)^(k+1);
%               x = this.deriv(kt , k)  
                x = this.derivAcc(kt , k);
                vv(i) = v * x;
            end
            plot(kk , vv ,'-', kk , aa , '.');
        end
        
        % create an array of comps and calculate the conrresponding
        % derivative
        function v = derivAcc(this , t , k)
            newSegComp = this.f(1,:);
            for q = 1 : size( this.funct , 2 )
                newSegComp(q) = comp( this.funct{q}(t) ) ;
            end
            addRelations(this.relation , newSegComp , t );
            repeatCompute(newSegComp, k);
            v = newSegComp(1).taylor2(k+1);
        end
    end
    
    
    methods (Access = private)
       % used to find the threshold hold to turn into the next segment.
       % used for func() and deriv()
       function thresh = findThresh(this, seg)
            if size(this.t , 2) < seg + 1
                thresh = inf;
            else
                thresh = this.t(seg + 1);
            end
       end
       
       % reset the computation process at segDuration time after the last
       % seg starts
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

% add certain relation to an array of comps, only when they are initialized
% with relations, can they start computing
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

% repeat compute all comps order times.
function repeatCompute(comps, order)
    for k = 1 : order
        for i = comps
            i.compute();
        end
    end
end