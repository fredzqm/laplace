function [adderRel, multRel] = rephraseRel(relation)
    pq = PriorityQueue();
    for rel = relation
        addedList = sort(rel.comps);
        if ~ pq.contains(addedList)
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
        for i = size(multRel, 2) : 1
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
                for j = size(multRel, 2) : 1
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
                    pq.add(list, size(list, 2));
                    pq.add(diffList, size(diffList, 2));
                end
                break;
            end
        end
        if flag == 0
            pq.add(list, size(list, 2));
            pq.add(list(1:2), 2);
            pq.add(list(3:end), size(list,2) - 2);
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
            adderRel(rel.addTo).list.coefficient = added.coefficient;
            adderRel(rel.addTo).list.order = added.order;
            adderRel(rel.addTo).list.multer = added.multer;
        end
    end



