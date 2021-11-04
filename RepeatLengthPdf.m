genenum = 47;
maxrepeat = 30;
simname = sprintf('RepeatLengthPdf');
dataname = sprintf('Hepatitis');
% result = zeros(8,genenum);

for k = 1:8
    result = GetRepeat(sequence, genenum, k, maxlength);
    SaveGram(result, genenum, k, dataname, name);
    dos_test(k, genenum, dataname, simname);
%     result(k,:) = GetMaxRepeatLength(sequence, genenum, k, maxlength);
%     Str = sprintf('vresult%d.mat',k);
%     result = load(Str);
%     SaveGramBac([result.RepeatPdf(1:8,:,:); result.RepeatPdf(10:genenum,:,:)], genenum-1, k, dataname, [name_refer(1:8); name_refer(10:genenum)]);
end