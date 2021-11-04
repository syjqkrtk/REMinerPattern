z = 100;
w = [5 7 10 12 14];
sp = [0 3 10 30 100];
% FroDist = zeros(5,5);
% pur = zeros(5,5);
pix = zeros(5,5);
res = zeros(5,5);

for n = 1:size(w,2)
    for m = 1:size(sp,2)
        if (w(n)==5) && (sp(m)==100)
        else
            title = sprintf('w%d_sp%d',z,w(n),sp(m));
            REMinerPattern
            REMinerProcess
            function_test160909
            RandMeasure
%             kmeansclustering
%             RandMeasure2
%             loaddst
%             Frobenius
%             FroDist(n,m) = result;
%             Clustersimilarity
%             pur(n,m) = result;
            pix(n,m) = pixel;
            res(n,m) = RI;
        end
    end
end
