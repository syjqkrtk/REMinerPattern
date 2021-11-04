z = 100;
siz = z/10;

result = false(800*siz,800*siz);

for num = 1:siz
    tic;
    Str = sprintf('Image_%s\\Processed\\temp%d.bmp',title,num);
    img=double(imread(Str))/255; %0~255�� ������ ������ �̹����� 0~1�� �ٲ��ֱ� ����
    temp = rot90(img,3);                                 %��ȯ�� �̹����� ����� ���� ����
    result(800*(num-1)+1:800*(num-1)+800,1:800*siz) = (temp(1:800,1:800*siz)>0.5);
    
    
    Str = sprintf('(%d/%d) image is now processing, %3.2f%% is completed', num,siz, num*100/(siz));
    disp(Str);
end 

result = rot90(result);

Str = sprintf('Image_%s\\Processed\\59MTimage.bmp',title);
imwrite(result,Str);