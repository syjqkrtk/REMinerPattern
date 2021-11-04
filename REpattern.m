%% REminer 결과 그래프에서 패턴을 분리하여 여러 기능을 수행하는 프로그램
clear;
imgr=logical(imread('Data\\HumanREimgr.bmp')/255); %0~255의 색상값을 가지는 이미지를 0~1로 바꿔주기 위함
imgg=logical(imread('Data\\HumanREimgg.bmp')/255); %0~255의 색상값을 가지는 이미지를 0~1로 바꿔주기 위함
imgb=logical(imread('Data\\HumanREimgb.bmp')/255); %0~255의 색상값을 가지는 이미지를 0~1로 바꿔주기 위함
[sizey, sizex] = size(imgr);          %이미지 파일의 x,y,color 크기
REimg = false(sizex,sizey,3);           %이미지의 x,y축의 편의를 위해 생성
num = 0;

unitsize = 10;
threshold = 2;
alpha = 0.1;
merge = 20;
% unitsize = 5;
% threshold = 0.3;
% merge = 10;

%% 이미지에서 그래프의 값 부분만 추출
for i = 1:sizex                             %이미지의 x,y축을 변경
    for j = 1:sizey
        REimg(i,j,1) = ~imgr(sizey+1-j,i);
        REimg(i,j,2) = ~imgg(sizey+1-j,i);
        REimg(i,j,3) = ~imgb(sizey+1-j,i);
    end
    if mod(i,100)==0
        disp(i);
    end
end
disp('Image processed');

clear imgr imgg imgb;
[sizex, sizey, sizec] = size(REimg);         %실제 데이터 부분만의 사이즈를 다시 정의

% %% 밀도 기준으로 추출
% for i = 1:floor(sizex/unitsize)
%     for j = 1:floor(sizey/unitsize)
%         if (sum(sum(REimg((i-1)*unitsize+1:i*unitsize,(j-1)*unitsize+1:j*unitsize,1))) >= threshold*unitsize*unitsize)||(sum(sum(REimg((i-1)*unitsize+1:i*unitsize,(j-1)*unitsize+1:j*unitsize,3))) >= threshold*unitsize*unitsize)
%             num = num+1;
%             TargetArea(num,1) = (i-1)*unitsize+1;
%             TargetArea(num,2) = (j-1)*unitsize+1;
%         end
%     end
%     if mod(i,100)==0
%         disp(i);
%     end
% end
% disp('Target area');
% disp(num);

%% 밀도 비율로 추출
for i = 1:floor(sizex/unitsize)
    for j = 1:floor(sizey/unitsize)
        ratio = (sum(sum(REimg((i-1)*unitsize+1:i*unitsize,(j-1)*unitsize+1:j*unitsize,1)))+sum(sum(REimg((i-1)*unitsize+1:i*unitsize,(j-1)*unitsize+1:j*unitsize,2)))+alpha*unitsize*unitsize)/(sum(sum(REimg((i-1)*unitsize+1:i*unitsize,(j-1)*unitsize+1:j*unitsize,3)))+sum(sum(REimg((i-1)*unitsize+1:i*unitsize,(j-1)*unitsize+1:j*unitsize,2)))+alpha*unitsize*unitsize);
        if  (ratio >= threshold) || (1/ratio >= threshold)
            num = num+1;
            TargetArea(num,1) = (i-1)*unitsize+1;
            TargetArea(num,2) = (j-1)*unitsize+1;
        end
    end
    if mod(i,100)==0
        disp(i);
    end
end
disp('Target area');
disp(num);

%% 인접한 추출 범위 통합
link = 1:num;

for i = 1:num-1
    for j = i+1:num
        if (abs(TargetArea(i,1)-TargetArea(j,1)) <= merge*unitsize) && (abs(TargetArea(i,2)-TargetArea(j,2)) <= merge*unitsize)
            link(j) = link(i);
        end
    end
    if mod(i,100)==0
        disp(i);
    end
end
disp('Link');

temp = cell(num,1);
for i = 1:num
    temp{link(i)} = [temp{link(i)};i];
end
disp('Temp');

num2 = 0;

clusters=cell(1,1);
for i = 1:num
    if temp{i}
        num2 = num2+1;
        clusters{num2}=temp{i};
    end
end
disp('Clusters');
disp(num2);

UnionArea = zeros(num2,4);
for i = 1:num2
    UnionArea(i,1)=min(TargetArea(clusters{i},1));
    UnionArea(i,2)=max(TargetArea(clusters{i},1))+unitsize-1;
    UnionArea(i,3)=min(TargetArea(clusters{i},2));
    UnionArea(i,4)=max(TargetArea(clusters{i},2))+unitsize-1;
end
disp('Union area');


for i = 1:num2
    resultimg = zeros(UnionArea(i,2)-UnionArea(i,1)+1,UnionArea(i,4)-UnionArea(i,3)+1);
    resultimg(:,:,1) = (REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),1)|(~REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),1)&~REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),2)&~REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),3)));
    resultimg(:,:,2) = (REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),2)|(~REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),1)&~REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),2)&~REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),3)));
    resultimg(:,:,3) = (REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),3)|(~REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),1)&~REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),2)&~REimg(UnionArea(i,1):UnionArea(i,2),UnionArea(i,3):UnionArea(i,4),3)));
    resultimg = resultimg*1.1-0.1;
    
    tempimg = zeros(size(resultimg,2),size(resultimg,1),size(resultimg,3));
    for j = 1:size(resultimg,2)
        for k = 1:size(resultimg,1)
            tempimg(j,k,:) = resultimg(k,size(resultimg,2)+1-j,:);
        end
    end
    
    str = sprintf('Data\\HumanREimg%d.bmp',i);
    imwrite(tempimg, str);
    if mod(i,10)==0
        disp(i);
    end
end
