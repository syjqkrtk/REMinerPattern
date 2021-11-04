% z = 100;
% w = [5 7 10 12 14];
% sp = [0 3 10 30 100];
% 
% for n = 1:5
%     for m = 1:5
%         if (w(n)==5) && (sp(m)==100)
%         else
%             title = sprintf('z%d_w%d_sp%d',z,w(n),sp(m));
%             MergeImage();
%             MergeImage2();
%         end
%     end
% end

z = 100;
w = 14;
sp = 3;
minl = [14 20 28 40 56];

for n = 1:5
    title = sprintf('z%d_w%d_sp%d_l%d',z,w,sp,minl(n));
    MergeImage();
    MergeImage2();
end