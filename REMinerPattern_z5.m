%% REminer ��� �׷������� ������ �и��Ͽ� ���� ����� �����ϴ� ���α׷�
clear;
img=double(imread('Data\\MT59_w5_s3_m0_z5.bmp'))/255; %0~255�� ������ ������ �̹����� 0~1�� �ٲ��ֱ� ����
temp = img;                                 %��ȯ�� �̹����� ����� ���� ����
[sizey, sizex, sizec] = size(img);          %�̹��� ������ x,y,color ũ��
MTGenome = zeros(sizex,sizey);           %�̹����� x,y���� ���Ǹ� ���� ����
Pattern = cell(59,59);                 %59*59���� �� ���տ� ���� 9*9 �̹���
data = zeros(59,2,2);
zerolength = 3;
temp2 = zeros(sizex,sizey,sizec);

%% �̹������� �׷����� �� �κи� ����
for i = 1:sizex                             %�̹����� x,y���� ����
    for j = 1:sizey
        temp2(i,j) = temp(sizey+1-j,i,1);
    end
end

for i = 1:sizey                             %�׷����� y�� ������ġ�� ã�� ����
    if temp2(i,sizey) == 0
        break;
    end
end

startx = i;

for j = 1:sizex                             %�׷����� x�� ������ġ�� ã�� ����
    if temp2(startx,j) == 0
        break;
    end
end
starty = j;

MTGenome = zeros(sizex-startx,sizey-starty);  %�׷����� �� ���� �����͸� ���� ����

for i = startx+1:sizex
    for j = starty+1:sizey
        MTGenome(i-startx,j-starty) = temp2(i,j);
    end
end

[sizex, sizey] = size(MTGenome);         %���� ������ �κи��� ����� �ٽ� ����

%% �׷������� ���ҵ� ������ ã�Ƴ� 59*59���� �������� ������ �� �ְ� ����
countx=0;
county=0;

for i = 1:sizex                               %�� ���� �κе� ������ �ȼ�ũ�Ⱑ �޶� �� ������ ���� �� ���� 0�� �κ��� zerox, zeroy�� ������ ������ ������
    if(MTGenome(i,1:sizey)==1)
        countx = countx+1;
        zerox(countx)=i;
    end
    Str = sprintf('(%d/%d) zerox finding', i, sizex);
    disp(Str);
end
for i = 1:sizey
    if(MTGenome(1:sizex,i)==1)
        county = county+1;
        zeroy(county)=i;
    end
    Str = sprintf('(%d/%d) zeroy finding', i, sizey);
    disp(Str);
end

%% �׷����� 59*59���� ���� ���ϵ�� ������
countx = 1;                                 %i*j��° ������ k,l ��° �ȼ����� ���� ������ ����
county = 1;
flagx = 1;                                  %zerox�� zeroy�� ������ ��, countx, county�� �÷��ֱ� ����
flagy = 1;

data(1,1,1) = 1;
data(1,1,2) = 1;
zerosizex = size(zerox);
zerosizey = size(zeroy);

for i = 1:zerosizex(2)-zerolength+1
    if flagx == 1
        if zerox(i+zerolength-1)-zerox(i) == zerolength-1
            flagx = 0;
            data(countx,2,1)=zerox(i)-1;
        end
    else
        if zerox(i+zerolength-1)-zerox(i) ~= zerolength-1
            flagx = 1;
            countx = countx+1;
            data(countx,1,1)=zerox(i+zerolength-2)+1;
        end
    end
    Str = sprintf('(%d/%d) zerox spliting', i+1, zerosizex(2));
    disp(Str);
end

for i = 1:zerosizey(2)-zerolength+1
    if flagy == 1
        if zeroy(i+zerolength-1)-zeroy(i) == zerolength-1
            flagy = 0;
            data(county,2,2)=zeroy(i)-1;
        end
    else
        if zeroy(i+zerolength-1)-zeroy(i) ~= zerolength-1
            flagy = 1;
            county = county+1;
            data(county,1,2)=zeroy(i+zerolength-2)+1;
        end
    end
    Str = sprintf('(%d/%d) zeroy spliting', i+1, zerosizey(2));
    disp(Str);
end

for i = 1:59
    for j = 1:59
        Pattern(i,j) = num2cell((1-MTGenome(data(i,1,1):data(i,2,1),data(j,1,2):data(j,2,2))~=0),[1 2]);
        Str = sprintf('(%d/59, %d/59) pattern is now processing, %3.2f%% is completed', i, j, (59*(i-1)+j)*100/(59*59));
        disp(Str);
    end
end

%% ��ü ���� ���� REMiner ���� ����� �м��ϴ� ���α׷�
result = HowMany(Pattern);
