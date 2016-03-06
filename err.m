function err(tt, vv , answer) 
    curMax = answer(tt);
    for i = 2 : size(curMax,2)
        if abs(curMax(i-1)) > abs(curMax(i))
            curMax(i) = curMax(i-1);
        end
    end
    plot(tt, (vv-answer(tt)) ./ curMax ,'-');
end