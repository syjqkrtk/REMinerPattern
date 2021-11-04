clear;

z = 8;
siz = 35;

resultr = false(800*siz,800*siz);

for num = 1:siz
    tic;
    Str = sprintf('Image\\Processed\\temp%dr.bmp',num);
    imgr=logical(imread(Str)/255); %0~255의 색상값을 가지는 이미지를 0~1로 바꿔주기 위함
    resultr(1:800*siz,800*(num-1)+1:800*(num-1)+800) = imgr(1:800*siz,1:800);

    Str = sprintf('(%d/%d) image is now processing, %3.2f%% is completed', num,siz, num*100/(siz));
    disp(Str);
end 

imwrite(resultr,'Data\\HumanREimgr.bmp');

clear;

z = 8;
siz = 35;

resultg = false(800*siz,800*siz);

for num = 1:siz
    tic;
    Str = sprintf('Image\\Processed\\temp%dg.bmp',num);
    imgg=logical(imread(Str)/255); %0~255의 색상값을 가지는 이미지를 0~1로 바꿔주기 위함
    resultg(1:800*siz,800*(num-1)+1:800*(num-1)+800) = imgg(1:800*siz,1:800);


    Str = sprintf('(%d/%d) image is now processing, %3.2f%% is completed', num,siz, num*100/(siz));
    disp(Str);
end 

imwrite(resultg,'Data\\HumanREimgg.bmp');

clear;

z = 8;
siz = 35;

resultb = logical(zeros(800*siz,800*siz));

for num = 1:siz
    tic;
    Str = sprintf('Image\\Processed\\temp%db.bmp',num);
    imgb=logical(imread(Str)/255); %0~255의 색상값을 가지는 이미지를 0~1로 바꿔주기 위함
    resultb(1:800*siz,800*(num-1)+1:800*(num-1)+800) = imgb(1:800*siz,1:800);


    Str = sprintf('(%d/%d) image is now processing, %3.2f%% is completed', num,siz, num*100/(siz));
    disp(Str);
end 

imwrite(resultb,'Data\\HumanREimgb.bmp');

clear;