clear;
a = PriorityQueue();
a.insert([1] , 1)
a.insert([1 2],2)
a.insert([1 2 3 4],4)
a.insert([1 3],2)
a.insert([1 3 3],3)
a.insert([1 5],2)
a.insert([2],1)
a.insert([2 5],2)
a.insert([2 9],2)
a.insert([1 2 4 3],4)

a.contains([1 2 3 4])
a.contains([0])
while (~a.isEmpty())
    a.pop()
end