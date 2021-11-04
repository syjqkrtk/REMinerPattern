%% Rand index
Real = [ones(1,divnum(1)) 2*ones(1,divnum(2)) 3*ones(1,divnum(3))];
TP = 0;
FP = 0;
FN = 0;
TN = 0;

%% Pair ºñ±³
for i = 1:30-1
    for j = i+1:30
        TP = TP + ((idx(i)==idx(j))&&(Real(i)==Real(j)));
        FP = FP + ((idx(i)==idx(j))&&(Real(i)~=Real(j)));
        FN = FN + ((idx(i)~=idx(j))&&(Real(i)==Real(j)));
        TN = TN + ((idx(i)~=idx(j))&&(Real(i)~=Real(j)));
    end
end

RI = (TP+TN)/(TP+FP+FN+TN);
pixel = sum(sum(cell2mat(Pattern)));