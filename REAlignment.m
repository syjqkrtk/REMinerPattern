Str = sprintf('%s\\Forward\\0.0_5000000.5000000\\0_1000000',title);

diff = 1850;

list = ls(Str);
seq1 = zeros(size(list,1)-2,2);
seq2 = zeros(size(list,1)-2,2);
score = zeros(size(list,1)-2,1);
identity = zeros(size(list,1)-2,3);
gap = zeros(size(list,1)-2,3);

for i = 3:size(list,1)
    filename = sprintf('%s\\%s',Str,list(i,:));
    file = fopen(filename,'r');
    temp = fgetl(file);
    seq1(i-2,:) = sscanf(temp, 'Seq1 : %d - %d');
    temp = fgetl(file);
    seq2(i-2,:) = sscanf(temp, 'Seq2 : %d - %d');
    temp = fgetl(file);
    score(i-2,:) = sscanf(temp, 'Score : %d');
    temp = fgetl(file);
    identity(i-2,:) = sscanf(temp, 'Identity : %d / %d (%d %%)');
    temp = fgetl(file);
    gap(i-2,:) = sscanf(temp, 'Gap : %d / %d (%d %%)');
    fclose(file);
end

seq = [seq1 seq2 identity(:,1:2)];
seq = sortrows(seq);
count = 0;
pair = zeros(1,6);

for i = 1:size(list,1)-2
    if ~ismember(pair, seq(i,:), 'rows')
        count = count+1;
        pair(count,:) = seq(i,:);
    end
end
pair = sortrows(pair,1);
save = pair;

last_size = 0;

while sum(last_size ~= size(pair))
    last_size = size(pair);
    pair(count+1,:) = zeros(1,6);
    count = 0;
    temp = zeros(1,6);
    i = 0;
    while (i < size(pair,1)-1)
        i = i + 1;
        if (pair(i+1,1) - pair(i,2) < diff) && (min([abs(pair(i+1,3) - pair(i,3)),abs(pair(i+1,3) - pair(i,4)),abs(pair(i+1,4) - pair(i,3)),abs(pair(i+1,4) - pair(i,4))]) < diff)
            count = count+1;
            temp(count,1) = min(pair(i,1),pair(i+1,1));
            temp(count,2) = max(pair(i,2),pair(i+1,2));
            temp(count,3) = min(pair(i,3),pair(i+1,3));
            temp(count,4) = max(pair(i,4),pair(i+1,4));
            temp(count,5) = pair(i,5)+pair(i+1,5);
            temp(count,6) = pair(i,6)+pair(i+1,6);
            i = i + 1;
        else
            count = count+1;
            temp(count,:) = pair(i,:);
        end
    end
    pair = 0;
    pair = temp;
end

count = 0;
i = 0;
temp = zeros(1,6);

while (i < size(pair,1)-1)
    i = i + 1;
    if (pair(i,2)-pair(i,1) < diff) || (pair(i,4)-pair(i,3) < diff)
    else
        count = count+1;
        temp(count,:) = pair(i,:);
    end
end
pair = temp;

i = 0;
count = 2;

while (i < size(pair,1)-1)
    i = i + 1;
    if (pair(i+1,1)-pair(i,2) > diff)
        pair(i,7) = count;
        count = count + 1;
    else
        pair(i,7) = count;
    end
end
pair(i+1,7) = count;
pair = sortrows(pair,3);

i = 0;
count = 1;

while (i < size(pair,1)-1)
    i = i + 1;
    if (pair(i+1,3)-pair(i,4) > diff)
        pair(i,8) = count;
        count = count + 1;
    else
        pair(i,8) = count;
    end
end
pair(i+1,8) = count;
pair = sortrows(pair);

set = cell(max(max(pair(:,7:8))),max(max(pair(:,7:8))));

for i = 1:size(pair,1)-1
    set{pair(i,7),pair(i,8)} = [set{pair(i,7),pair(i,8)}; i];
end

result = zeros(30,30,4);
distance = zeros(30,30);
for i = 2:30
    for j = 1:i-1
        result(i,j,1) = min(pair(set{i,j},1));
        result(i,j,2) = max(pair(set{i,j},2));
        result(i,j,3) = min(pair(set{i,j},3));
        result(i,j,4) = max(pair(set{i,j},4));
        result(i,j,5) = sum(pair(set{i,j},5));
        result(i,j,6) = sum(pair(set{i,j},6));
        distance(i,j) = result(i,j,5)/result(i,j,6);
    end
end

distance = 1-squareform(distance, 'tovector');
for i = 1:30
    Str = sprintf('%s\n',GetName(i));
    name(i) = cellstr(Str);
end
REMtree = seqlinkage(distance, 'average', name);
Str = sprintf('Data\\Alignmentbased\\MTgenome30\\test.dnd');
phytreewrite(Str,REMtree,'BRANCHNAMES',false);
phytreeviewer(REMtree);

Str = sprintf('java -jar D:\\Download\\MATLAB\\phylonet_v2_4\\phylonet_v2_4\\phylonet_v2_4.jar rf -m D:\\Download\\MATLAB\\REMinerPattern\\Data\\Alignmentbased\\MTgenome30\\CLUSTAL-X.ph -e D:\\Download\\MATLAB\\REMinerPattern\\Data\\Alignmentbased\\MTgenome30\\test.dnd -o D:\\Download\\MATLAB\\REMinerPattern\\Data\\Alignmentbased\\MTgenome30\\test2.txt');
[status, result] = dos(Str);
disp(Str);