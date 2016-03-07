function [adderRel, multRel] = rephraseRel(relation)
    displayRelation(relation); % display relationship inputed
    multRel = [];
    pq = PriorityQueue();
    for rel = relation
        addedList = sort(rel.comps);
        if ~pq.contains(addedList)
            pq.insert( addedList , size(addedList,2) );
        end
    end
    index = 0;
    while ~pq.isEmpty()
        list = pq.pop();
        if size(list,2) <= 1
            continue;
        end
        if size(list,2) == 2
            index = index + 1;
            multRel(index).list = list;
            multRel(index).a.t = 0; % for adder
            multRel(index).b.t = 0; % for adder
            multRel(index).a.i = list(1);
            multRel(index).b.i = list(2);
            continue;
        end
        flag = 0;
        for i = size(multRel, 2): -1 : 1
            [flag, diffList] = includedIn(multRel(i).list, list);
            if flag
                if size(diffList, 2) == 1
                    index = index + 1;
                    multRel(index).list = list;
                    multRel(index).a.t = 1; % for adder
                    multRel(index).b.t = 0; % for multiplier
                    multRel(index).a.i = i;
                    multRel(index).b.i = diffList(1);
                    break;
                end
                found = 0;
                for j = size(multRel, 2): -1 : 1
                    if compareElement(multRel(j).list, diffList) == 0
                        index = index + 1;
                        multRel(index).list = list;
                        multRel(index).a.t = 1; % for multiplier
                        multRel(index).b.t = 1; % for multiplier
                        multRel(index).a.i = i;
                        multRel(index).b.i = j;
                        found = 1;
                        break;
                    end
                end
                if found == 0
                    if ( minCompList(list) >= minCompList(diffList) + 1 )
                        pq.insert(list, size(list, 2));
                        pq.insert(diffList, size(diffList, 2));
                    else
                        flag = 0;
                        continue;
                    end
                end
                break;
            end
        end
        if flag == 0
              pq.insert(list, size(list, 2) );
              [a , b] = splitList(list)
              if size(b, 2) == 0
                  s = floor( size(a, 2) / 2 );
                  if s == 1
                      pq.insert(list(1: 2), 2);
                  else
                      pq.insert(list(1: s), s);
                  end
              else
                  pq.insert(a, size(a, 2));
                  pq.insert(b, size(b, 2));
              end
        end
    end
    
    for rel = relation
        added.coefficient = rel.coefficient ;
        added.order = rel.order ;
        if size(rel.comps, 2) == 1
            added.multer.t = 0;
            added.multer.i = rel.comps;
        else
            for i = 1 : size(multRel, 2)
                if compareElement(rel.comps, multRel(i).list) == 0
                    added.multer.t = 1;
                    added.multer.i = i;
                    break;
                end
            end
        end
        if ~ isfield( added , 'multer')
            display(rel);
            error('cannot find needed multiplier!');
        end
        if exist( 'adderRel' , 'var' )
            if size(adderRel, 2) < rel.addTo
                len = 0;
            else
                len = size( adderRel(rel.addTo).list , 2);
            end
            adderRel(rel.addTo).list(len+1) = added;
        else
            adderRel(rel.addTo).list(1).coefficient = added.coefficient;
            adderRel(rel.addTo).list(1).order = added.order;
            adderRel(rel.addTo).list(1).multer = added.multer;
        end
    end
    
    displayConvertedRel(adderRel, multRel); % display processed relationship
end

    
function [ret, diffList] = includedIn(a, b)
    ret = 0;
    diffList = b;
    for x = a
        found = 0;
        for i = 1 : size(diffList,2)
            if diffList(i) == x
                diffList(i) = [];
                found = 1;
                break;
            end
        end
        if found == 0
            return;
        end
    end
    ret = 1;
    if size(diffList,1) == 0 % two set equal, no need to worry
        error('identical comps');
    end
end

function displayRelation(relation)
    display('Input relation meaning');
    for k = relation
        compstr = '';
        for i = 1 : size(k.comps,2)
            if i ~= 1
                compstr = strcat(compstr, ' * ');
            end
            compstr = strcat(compstr, sprintf('Comp%d', k.comps(i)) );
        end
        display(sprintf('Comp%d += %s * t^%d * %s', k.addTo , ...
               realNum(k.coefficient), k.order, compstr));
    end
    display(' ');
end


function displayConvertedRel(adderRel, multRel)
    display('Output computational model meaning');
    for i = 1 : size(adderRel, 2)
        adder = '';
        for j = 1 : size(adderRel(i).list, 2)
            added = sprintf(' %s * t^%d * %s  ' , realNum(adderRel(i).list(j).coefficient), ...
                adderRel(i).list(j).order, str(adderRel(i).list(j).multer) );
            if j ~= 1
                adder = strcat(adder, '  +  ');
            end
            adder = strcat(adder, added);
        end
        display(sprintf('Adder %d''\t=%s', i , adder ) );
    end
    for i = 1 : size(multRel, 2)
        list = '';
        for k = multRel(i).list
            list = strcat(list, sprintf(' %d',k));
        end
        display(sprintf('Multer%d''\t= %s * %s \t\t\t (%s )', ...
            i, str(multRel(i).a), str(multRel(i).b), list));
    end
    display(' ');
end


function s = str(a)
    if a.t == 0
        s = sprintf('Adder %d', a.i);
    else
        s = sprintf('Multer%d', a.i);
    end
end

function s = realNum(x)
    if ceil(x) == x
        s = sprintf('%d', x);
    else
        [N,D] = rat(x);
        s = sprintf('%d/%d', N, D);
    end
end

function [totalCount] = minCompList(list)
    totalCount = 0;
    if size(list, 2) == 0
        return
    end
    num = list(1);
    sameCount = 1;
    for i = 2 : size(list, 2)
        if ( num == list(i))
            sameCount = sameCount + 1;
        else
            totalCount = totalCount + 1 + minCompMono(sameCount);
            sameCount = 1;
            num = list(i);
        end
    end
    totalCount = totalCount + minCompMono(sameCount);
end

function [count] = minCompMono(c)
    count = -2;
    while (c ~= 0)
        count = count + mod(c, 2) + 1;
        c = floor( c / 2 );
    end
end


function [a, b] = splitList(list)
    for i = 1 : size(list,2)
        if list(i) ~= list(1)
            i = i - 1;
            break;
        end
    end
    a = list(1:i);
    b = list(i+1:end);
end


