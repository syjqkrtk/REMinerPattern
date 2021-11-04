%% ��ü ���� ���� REMiner ���� ����� �м��ϴ� ���α׷�
% result = HowMany(Pattern);
filename = sprintf('Data\\PhyloTree\\%s',title);
for i = 1:30
    temp = Pattern{i,i};
    for j = 1:size(temp,1)
        temp(j,j) = 1;
    end
    Pattern{i,i} = temp; 
end
result = HowMany(Pattern);

%% �ڱ� �ڽſ� ���� REminer ���(i,i) ���� �м�
% result = zeros(30,25);
% 
% for i = 1:30
%     result(i,3:25) = GetName(i);
%     result(i,2) = ':';
%     result(i,1) = int2str(WhatPattern(i,i,Pattern));
% end
% 
% result = char(sortrows(result));

%% ǥ������ ũ�� ������ ���� �м�(���ٸ�)
% name = cell(30,1);
% stdv = zeros(1,30);
% 
% for i = 1:30
%     stdv(1,i) = std(result(i,:));
% end
% 
% plot(stdv);
% 
% [maxstdv idx] = max(stdv);
% 
% for i = 1:30
%     Str = sprintf('%2d:%s\n',result(idx,i),GetName(i));
%     name(i) = cellstr(Str);
% end
% 
% name = sortrows(name);

%% �̹��� ���� ����
% for i = 1:30
%    for j = i:30
%        PatternXY(i,j,Pattern);
%    end
% end

%% Phylogenetic tree �׸���
name = cell(30,1);
divnum = zeros(1,9);
divresult = cell(30,9);
divname = cell(30,9);

for i = 1:30
    Str = sprintf('%s\n',GetName(i));
    name(i) = cellstr(Str);
end

%% Minimum variance algorithm, Data\\PhyloTree\\MT30tree_z100_MVA.dnd
% filename = sprintf('Data\\PhyloTree\\MT59tree_z200_MVA');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z100_MVA');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z50_MVA');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z20_MVA');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z10_MVA');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z5_MVA');
% Z = linkage(result,'ward','euclidean');
% Phylotree = phytree(Z,name);

%% UPGMA, Data\\PhyloTree\\MT59tree_z100_UPGMA.dnd
% filename = sprintf('Data\\PhyloTree\\MT59tree_z200_UPGMA');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z100_UPGMA');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z50_UPGMA');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z20_UPGMA');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z10_UPGMA');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z5_UPGMA');
% DistanceMatrix = pdist(result, 'euclidean');
% Phylotree = seqlinkage(DistanceMatrix, 'average', name);

%% Neighbor joining, Data\\PhyloTree\\MT59tree_z100_neighjoin.dnd
% filename = sprintf('Data\\PhyloTree\\MT59tree_z200_neighjoin');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z100_neighjoin');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z50_neighjoin');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z20_neighjoin');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z10_neighjoin');
% filename = sprintf('Data\\PhyloTree\\MT59tree_z5_neighjoin');
% DistanceMatrix = pdist(result, 'euclidean');
% Phylotree = seqneighjoin(DistanceMatrix, 'equivar', name);

%% �������� ������, Data\\PhyloTree\\MT59tree_z100_%s_%d.dnd
%% 1 - ������, 2 - ���, 3 - ����, 4 - �����, 5 - �缭��
% species = [2;4;2;1;4;1;3;3;3;3;1;1;1;1;1;1;1;1;1;1;1;2;2;5;2;1;1;2;2;2;2;1;1;1;1;1;3;2;1;1;1;1;1;1;1;1;1;2;1;1;1;3;4;2;5;3;1;2;1];
% Real = [2;4;2;1;4;1;3;3;3;3;1;1;1;1;1;1;1;1;1;1;1;2;2;5;2;1;1;2;2;2;2;1;1;1;1;1;3;2;1;1;1;1;1;1;1;1;1;2;1;1;1;3;4;2;2;3;1;2;1];
species = [3;3;3;3;3;3;3;2;2;2;2;2;2;2;2;1;1;1;1;1;1;1;1;2;2;2;2;1;2;1];
Real = [3;3;3;3;3;3;3;2;2;2;2;2;2;2;2;1;1;1;1;1;1;1;1;2;2;2;2;1;2;1];
spec = 3;
% Str = sprintf('_%d',spec);
% filename = strcat(filename,Str);
for i = 1:30
    divnum(species(i)) = divnum(species(i))+1;
    divresult(divnum(species(i)),species(i)) = num2cell(result(i,:), 2);
    divname(divnum(species(i)),species(i)) = name(i);
end

% Z = linkage(cell2mat(divresult(1:divnum(spec),spec)),'ward','euclidean');
% Phylotree = phytree(Z,divname(1:divnum(spec),spec));
% DistanceMatrix = pdist(cell2mat(divresult(1:divnum(spec),spec)), 'euclidean');
% Phylotree = seqlinkage(DistanceMatrix, 'average', divname(1:divnum(spec),spec));
% DistanceMatrix = pdist(cell2mat(divresult(1:divnum(spec),spec)), 'euclidean');
% Phylotree = seqneighjoin(DistanceMatrix, 'equivar', divname(1:divnum(spec),spec));

% Z = linkage([cell2mat(divresult(1:divnum(1),1)); cell2mat(divresult(1:divnum(2),2)); cell2mat(divresult(1:divnum(3),3))], 'ward', 'euclidean');
% Phylotree = phytree(Z, [divname(1:divnum(1),1); divname(1:divnum(2),2); divname(1:divnum(3),3)]);
% DistanceMatrix = pdist([cell2mat(divresult(1:divnum(1),1)); cell2mat(divresult(1:divnum(2),2)); cell2mat(divresult(1:divnum(3),3))], 'euclidean');
% Phylotree = seqlinkage(DistanceMatrix, 'average', [divname(1:divnum(1),1); divname(1:divnum(2),2); divname(1:divnum(3),3)]);
DistanceMatrix = pdist([cell2mat(divresult(1:divnum(1),1)); cell2mat(divresult(1:divnum(2),2)); cell2mat(divresult(1:divnum(3),3));], 'euclidean');
Phylotree = seqneighjoin(DistanceMatrix, 'equivar', [divname(1:divnum(1),1); divname(1:divnum(2),2); divname(1:divnum(3),3);]);
% Z = linkage([cell2mat(divresult(1:divnum(2),2)); cell2mat(divresult(1:divnum(3),3))], 'ward', 'euclidean');
% Phylotree = phytree(Z, [divname(1:divnum(2),2); divname(1:divnum(3),3)]);
% DistanceMatrix = pdist([cell2mat(divresult(1:divnum(1),1)); cell2mat(divresult(1:divnum(2),2))], 'euclidean');
% Phylotree = seqlinkage(DistanceMatrix, 'average', [divname(1:divnum(1),1); divname(1:divnum(2),2)]);
% DistanceMatrix = pdist([cell2mat(divresult(1:divnum(1),1)); cell2mat(divresult(1:divnum(2),2))], 'euclidean');
% Phylotree = seqneighjoin(DistanceMatrix, 'equivar', [divname(1:divnum(1),1); divname(1:divnum(2),2)]);
    
%% phylotree ��� �� clustering
filename = strcat(filename,'.dnd');
phytreewrite(filename,Phylotree,'BRANCHNAMES',false);
% [node,line] = cluster(Phylotree,[],'maxclust',spec);
% 
% h=plot(Phylotree);
% h=plot(Phylotree,'Type','radial','TerminalLabels','false','LeafLabels','true');
% set(h.BranchLines(line==4),'Color','y');
% set(h.BranchLines(line==3),'Color','g');
% set(h.BranchLines(line==2),'Color','r');
% set(h.BranchLines(line==1),'Color','b');