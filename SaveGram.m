function SaveGram(RepeatPdf, genenum, k, dataname, name)

%% 얻은 Repeat length Pdf Matrix에서 Phylogenetic Tree를 그리는 프로그램

[temp1 temp2 maxrepeat] = size(RepeatPdf);

result = reshape(RepeatPdf,[genenum,maxrepeat*4^k]);
% DistanceMatrix = pdist(result, 'euclidean');
% Repeattree = seqlinkage(DistanceMatrix, 'average', name);
Z = linkage(result,'average','euclidean');
Repeattree = phytree(Z,name);
% DistanceMatrix = pdist(result, 'euclidean');
% Repeattree = seqneighjoin(DistanceMatrix, 'equivar', name);
Str = sprintf('Data\\RFdistance\\%s\\%s_%d_tree.dnd', dataname, dataname, k);
phytreewrite(Str,Repeattree,'BRANCHNAMES',false);

end