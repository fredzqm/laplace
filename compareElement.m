function ret = compareElement(a , b)
    ret = size(a,2) - size(b,2);
    for i = 1 : min(size(a,2), size(b,2))
        if a(i) < b(i)
            ret = -1;
            return;
        elseif a(i) > b(i)
            ret = 1;
            return;
        end
    end
end