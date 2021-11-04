%% REminer 결과 그래프에서 패턴을 분리하여 여러 기능을 수행하는 프로그램
clear;
Pixels = zeros(49,3);
WeightedPixels = zeros(49,3);
Arrays = zeros(49,1);
WeightedArrays = zeros(49,1);
load('name.mat');

for ecoli = 1:49
    clearvars -except ecoli Pixels Arrays name WeightedPixels WeightedArrays;
    str = sprintf('Screenshot_%d.png',ecoli);
    img = uint8(imread(str)); %0~255의 색상값을 가지는 이미지를 0~1로 바꿔주기 위함
    img(:,:,1) = 2*img(:,:,1);
    img = sum(img,3);                       %흑백으로 변환
    img = img/max(max(img));                                 %변환된 이미지의 계산을 위해 생성
    [sizey, sizex] = size(img);          %이미지 파일의 x,y,color 크기

    %% 이미지에서 그래프의 값 부분만 추출
    for i = 1:sizex                             %이미지의 x,y축을 변경
        for j = 1:sizey
            temp2(i,j) = img(sizey+1-j,i);
        end
    end

    for i = 1:sizey                             %그래프의 y축 시작위치를 찾기 위함
        if temp2(i,sizey) == 0
            break;
        end
    end

    startx = i;

    for j = 1:sizex                             %그래프의 x축 시작위치를 찾기 위함
        if temp2(startx,j) == 0
            break;
        end
    end
    starty = j;

    len = min(sizex-startx,sizey-starty);
    Data = zeros(len,len);  %그래프의 축 뒤의 데이터만 따로 저장

    for i = startx+1:startx+len
        for j = starty+1:starty+len
            Data(i-startx,j-starty) = 1-temp2(i,j);
        end
    end

    [sizex, sizey] = size(Data);         %실제 데이터 부분만의 사이즈를 다시 정의
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

    %% 이미지 내보내기

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