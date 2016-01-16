function [ret, diffList] = includedIn(a, b)
    if ~all(ismember(a, b))
        ret = 0;
        return;
    end
    ret = 1;
    diffList = setdiff(b,a);
    if size(diffList,1) == 0 % two set equal, no need to worry
        error('identical comps');
    end
end