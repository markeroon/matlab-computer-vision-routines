data = rand(4000,4000);
data2 = ones(size(data));

tic
for i=1:size(data,1)
    for j=1:size(data,2)
        data2(i,j) = data(i,j);
    end
end
toc

tic
for j=1:size(data,2)
    for i=1:size(data,1)
        data2(i,j) = data(i,j);
    end
end
toc