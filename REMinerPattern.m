%% REminer ��� �׷������� ������ �и��Ͽ� ���� ����� �����ϴ� ���α׷�
clearvars -except title z w sp FroDist n m pur res pix minl;
Str = sprintf('Image_%s\\Processed\\59MTimage.bmp',title);
img = uint8(imread(Str)); %0~255�� ������ ������ �̹����� 0~1�� �ٲ��ֱ� ����
img = img/max(max(img));                                 %��ȯ�� �̹����� ����� ���� ����
[sizey, sizex] = size(img);          %�̹��� ������ x,y,color ũ��
MTGenome = zeros(sizex,sizey);           %�̹����� x,y���� ���Ǹ� ���� ����
Pattern = cell(30,30);                 %30*30���� �� ���տ� ���� 9*9 �̹���
data = zeros(30,2,2);
datatemp = zeros(30,2,2);
zerolength = 80;
minimum = 80;

%% �̹������� �׷����� �� �κи� ����
for i = 1:sizex                             %�̹����� x,y���� ����
    for j = 1:sizey
        MTGenome(i,j) = img(sizey+1-j,i);
    end
end

[sizex, sizey] = size(MTGenome);         %���� ������ �κи��� ����� �ٽ� ����

%% �׷������� ���ҵ� ������ ã�Ƴ� 30*30���� �������� ������ �� �ְ� ����
countx=0;
county=0;

for i = 1:sizex                               %�� ���� �κе� ������ �ȼ�ũ�Ⱑ �޶� �� ������ ���� �� ���� 0�� �κ��� zerox, zeroy�� ������ ������ ������
    if(MTGenome(i,1:sizey,1)==1)
        countx = countx+1;
        zerox(countx)=i;
    end
    Str = sprintf('(%d/%d) zerox finding', i, sizex);
    disp(Str);
end
for i = 1:sizey
    if(MTGenome(1:sizex,i,1)==1)
        county = county+1;
        zeroy(county)=i;
    end
    Str = sprintf('(%d/%d) zeroy finding', i, sizey);
    disp(Str);
end

%% �׷����� 30*30���� ���� ���ϵ�� ������
countx = 1;                                 %i*j��° ������ k,l ��° �ȼ����� ���� ������ ����
county = 1;
flagx = 1;                                  %zerox�� zeroy�� ������ ��, countx, county�� �÷��ֱ� ����
flagy = 1;

datatemp(1,1,1) = 1;
datatemp(1,1,2) = 1;
zerosizex = size(zerox);
zerosizey = size(zeroy);

for i = 1:zerosizex(2)-zerolength+1
    if flagx == 1
        if zerox(i+zerolength-1)-zerox(i) == zerolength-1
            flagx = 0;
            datatemp(countx,2,1)=zerox(i)-1;
        end
    else
        if zerox(i+zerolength-1)-zerox(i) ~= zerolength-1
            flagx = 1;
            countx = countx+1;
            datatemp(countx,1,1)=zerox(i+zerolength-2)+1;
        end
    end
    Str = sprintf('(%d/%d) zerox spliting', i+1, zerosizex(2));
    disp(Str);
end

for i = 1:zerosizey(2)-zerolength+1
    if flagy == 1
        if zeroy(i+zerolength-1)-zeroy(i) == zerolength-1
            flagy = 0;
            datatemp(county,2,2)=zeroy(i)-1;
        end
    else
        if zeroy(i+zerolength-1)-zeroy(i) ~= zerolength-1
            flagy = 1;
            county = county+1;
            datatemp(county,1,2)=zeroy(i+zerolength-2)+1;
        end
    end
    Str = sprintf('(%d/%d) zeroy spliting', i+1, zerosizey(2));
    disp(Str);
end

countx = 1;
i = 0;
while(i<size(datatemp,1))
    i = i + 1;
    if  datatemp(i,1,1)~=0
        if i < size(datatemp,1)
            if datatemp(i,2,1)-datatemp(i,1,1) < minimum
                if datatemp(i+1,2,1)-datatemp(i+1,1,1) < minimum
                    data(countx,1,1) = datatemp(i,1,1);
                    data(countx,2,1) = datatemp(i+1,2,1);
                    countx = countx+1;
                    i = i + 1;
                else
                    data(countx,:,1) = datatemp(i,:,1);
                    countx = countx+1;
                end
            else
                data(countx,:,1) = datatemp(i,:,1);
                countx = countx+1;
            end
        else
            data(countx,:,1) = datatemp(i,:,1);
            countx = countx+1;
        end
    end
end

county = 1;
i = 0;
while(i<size(datatemp,1))
    i = i + 1;
    if  datatemp(i,1,2)~=0
        if i < size(datatemp,1)
            if datatemp(i,2,2)-datatemp(i,1,2) < minimum
                if datatemp(i+1,2,2)-datatemp(i+1,1,2) < minimum
                    data(county,1,2) = datatemp(i,1,2);
                    data(county,2,2) = datatemp(i+1,2,2);
                    county = county+1;
                    i = i + 1;
                else
                    data(county,:,2) = datatemp(i,:,2);
                    county = county+1;
                end
            else
                data(county,:,2) = datatemp(i,:,2);
                county = county+1;
            end
        else
            data(county,:,2) = datatemp(i,:,2);
            county = county+1;
        end
    end
end

for i = 1:30
    for j = 1:30
        Pattern(i,j) = num2cell((1-MTGenome(data(i,1,1):data(i,2,1),data(j,1,2):data(j,2,2))~=0),[1 2]);
        Str = sprintf('(%d/30, %d/30) pattern is now processing, %3.2f%% is completed', i, j, (30*(i-1)+j)*100/(30*30));
        disp(Str);
    end
end

data(1/((countx==31)*(county==31)));