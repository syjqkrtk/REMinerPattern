%% Rand measure
Real = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 2 2 2 1 1 1 1 1 1 1 1];

score = 0;
TP = 0;
FP = 0;
TN = 0;
FN = 0;

%% Pair ºñ±³
for i = 1:47-1
    for j = i+1:47
        TP = TP + ((node(i)==node(j))&&(Real(i)==Real(j)));
        FP = FP + ((node(i)==node(j))&&(Real(i)~=Real(j)));
        FN = FN + ((node(i)~=node(j))&&(Real(i)==Real(j)));
        TN = TN + ((node(i)~=node(j))&&(Real(i)~=Real(j)));
    end
end

RepeatRM = (TP+TN)/(TP+FP+FN+TN);