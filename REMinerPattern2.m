%% REminer ��� �׷������� ������ �и��Ͽ� ���� ����� �����ϴ� ���α׷�
clear;
Pixels = zeros(49,3);
WeightedPixels = zeros(49,3);
Arrays = zeros(49,1);
WeightedArrays = zeros(49,1);
load('name.mat');

for ecoli = 1:49
    clearvars -except ecoli Pixels Arrays name WeightedPixels WeightedArrays;
    str = sprintf('Screenshot_%d.png',ecoli);
    img = uint8(imread(str)); %0~255�� ������ ������ �̹����� 0~1�� �ٲ��ֱ� ����
    img(:,:,1) = 2*img(:,:,1);
    img = sum(img,3);                       %������� ��ȯ
    img = img/max(max(img));                                 %��ȯ�� �̹����� ����� ���� ����
    [sizey, sizex] = size(img);          %�̹��� ������ x,y,color ũ��

    %% �̹������� �׷����� �� �κи� ����
    for i = 1:sizex                             %�̹����� x,y���� ����
        for j = 1:sizey
            temp2(i,j) = img(sizey+1-j,i);
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

    len = min(sizex-startx,sizey-starty);
    Data = zeros(len,len);  %�׷����� �� ���� �����͸� ���� ����

    for i = startx+1:startx+len
        for j = starty+1:starty+len
            Data(i-startx,j-starty) = 1-temp2(i,j);
        end
    end

    [sizex, sizey] = size(Data);         %���� ������ �κи��� ����� �ٽ� ����
    Combine = Data>0.5;
    Reverse = Data<0.5 & Data>0.45;
    Forward = Data<0.45 & Data~=0;

    Pixels(ecoli,1) = sum(sum(Forward));
    Pixels(ecoli,2) = sum(sum(Reverse));
    Pixels(ecoli,3) = sum(sum(Combine));
    for i = 1:sizex
        for j = 1:sizey
            WeightedPixels(ecoli,1) = WeightedPixels(ecoli,1) + (Forward(i,j)==1)*abs(i-j);
            WeightedPixels(ecoli,2) = WeightedPixels(ecoli,2) + (Reverse(i,j)==1)*abs(i-j);
            WeightedPixels(ecoli,3) = WeightedPixels(ecoli,3) + (Combine(i,j)==1)*abs(i-j);
        end
    end

    %% �̹��� ��������

    Image = ones(sizex,sizey,3);
    Image(:,:,1) = ~Forward&~Combine;
    Image(:,:,2) = ~Forward&~Reverse;
    Image(:,:,3) = ~Reverse&~Combine;
    Forward = Forward|Combine;
    Reverse = Reverse|Combine;
    Combine = Forward|Reverse;

    for i = 1:sizex
        for j = 1:sizex
    %         Conv(i,j) = sum((Forward(i,:)&Forward(j,:))|(Reverse(i,:)&Reverse(j,:)));
            Conv(i,j) = sum(Combine(i,:)&Combine(j,:));
    %         if sum(Combine(j,:)) ~= 0
    %             Conv(i,j) = sum(Combine(i,:)&Combine(j,:))/sum(Combine(j,:));
    %         end
        end
    end

    % REarray = sum(Conv)>30;
    REarray = sum(Conv)>200;
    zerox = find(REarray);

    count = 1;
    count2 = 0;
    flag = 1;
    for i = 1:length(zerox)-1
        if ((zerox(i+1)-zerox(i)) < 5) && (flag == 1)
            count2 = count2 + 1;
            zeroy{count}(count2) = zerox(i+1);
        end

        if ((zerox(i+1)-zerox(i)) < 5) && (flag == 0)
            flag = 1;
            count = count + 1;
            count2 = 1;
            zeroy{count}(count2)  = zerox(i);
            count2 = 2;
            zeroy{count}(count2)  = zerox(i+1);
        end

        if ((zerox(i+1)-zerox(i)) >= 5) && (flag == 1)
            flag = 0;
        end
    end

    if size(zeroy{1})==0
        count = 0;
        for i = 2:length(zeroy)
            if zeroy{i}(end)-zeroy{i}(1) > 5
                count = count + 1;
                zeroz(count) = zeroy{i}(1);
                count = count + 1;
                zeroz(count) = zeroy{i}(end);
            end
        end
    else
        count = 0;
        for i = 1:length(zeroy)
            if zeroy{i}(end)-zeroy{i}(1) > 5
                count = count + 1;
                zeroz(count) = zeroy{i}(1);
                count = count + 1;
                zeroz(count) = zeroy{i}(end);
            end
        end
    end
    
    Arrays(ecoli,1) = length(zeroz);
    for i = 1:length(Arrays)
        for j = 1:length(Arrays)
            WeightedArrays(ecoli) = WeightedArrays(ecoli) + abs(Arrays(i)-Arrays(j));
        end
    end
    Image(zeroz,:,:) = Image(zeroz,:,:) - 0.5;
    Image(:,zeroz,:) = Image(:,zeroz,:) - 0.5;

    str = sprintf('test_%d.png',ecoli);
    imwrite(Image,str);
    disp(str);
end

Pixels = [sum(Pixels(1:35,:),2)' sum(Pixels(37:49,:),2)'];
[temp, index] = sort(Pixels);
for i = 1:48
    PixelName{i} = name{index(i)};
end

WeightedPixels = [sum(WeightedPixels(1:35,:),2)' sum(WeightedPixels(37:49,:),2)'];
[temp2, index] = sort(WeightedPixels);
for i = 1:48
    WeightedPixelName{i} = name{index(i)};
end

Arrays = [Arrays(1:35,:)' Arrays(37:49,:)'];
[temp3, index] = sort(Arrays);
for i = 1:48
    ArrayName{i} = name{index(i)};
end

WeightedArrays = [WeightedArrays(1:35,:)' WeightedArrays(37:49,:)'];
[temp4, index] = sort(WeightedArrays);
for i = 1:48
    WeightedArrayName{i} = name{index(i)};
end

for i = 1 : length(temp)
   

    sorted_name{i} = ' ';
    sorted_number(i) = i;
    
end

plot(temp);
xticks(1:48);
xticklabels(PixelName);
xtickangle(45);

figure

plot(temp2);
xticks(1:48);
xticklabels(WeightedPixelName);
xtickangle(45);

figure

plot(temp3);
xticks(1:48);
xticklabels(ArrayName);
xtickangle(45);

figure

plot(temp4);
xticks(1:48);
xticklabels(WeightedArrayName);
xtickangle(45);