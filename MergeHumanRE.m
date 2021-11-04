%% REminer 결과 그래프들을 전부 이어 큰 이미지로 만드는 프로그램
z = 8;
siz = 35;

for ber = 1:siz
    clear result sizex sizey sizec img temp temp2 startx starty resultx resulty MTGenome i j k y2 fixx fixy Str;
    for num = 1:siz
        tic;
        Str = sprintf('Image\\Screenshot_%d.png',num+(ber-1)*siz);
        img=double(imread(Str))/255; %0~255의 색상값을 가지는 이미지를 0~1로 바꿔주기 위함
        temp = img;                                 %변환된 이미지의 계산을 위해 생성
        [sizey, sizex, sizec] = size(img);          %이미지 파일의 x,y,color 크기
        temp2 = zeros(sizex,sizey,sizec);           %이미지의 x,y축의 편의를 위해 생성

        %% 이미지에서 그래프의 값 부분만 추출
        for i = 1:sizex                             %이미지의 x,y축을 변경
            for j = 1:sizey
                temp2(i,j,:) = temp(sizey+1-j,i,:);
            end
        end

        for i = 1:sizey                             %그래프의 y축 시작위치를 찾기 위함
            if temp2(i,sizey,1) == 0
                break;
            end
        end

        startx = i;

        for j = 1:sizex                             %그래프의 x축 시작위치를 찾기 위함
            if temp2(startx,j,1) == 0
                break;
            end
        end
        starty = j;

        MTGenome = zeros(sizex-startx,sizey-starty,sizec);  %그래프의 축 뒤의 데이터만 따로 저장

        for i = startx+1:sizex
            for j = starty+1:sizey
                MTGenome(i-startx,j-starty,:) = temp2(i,j,:);
            end
        end

        MTGenome = 1 - MTGenome;
        [sizex, sizey, sizec] = size(MTGenome);         %실제 데이터 부분만의 사이즈를 다시 정의

        %% 이미지 이어붙이기
        if num == 1
            result = MTGenome;
        end

        for k = 1:800
            y2 = (800*(num-1) + k);
            result(:,y2,:) = MTGenome(:,k,:);
        end
        
        [resultx, resulty, resultc] = size(result);
        Str = sprintf('(%d/%d,%d/%d) image is now processing, %3.2f%% is completed', ber,siz, num,siz, ((ber-1)*siz+num)*100/(siz*siz));
        disp(Str);
        toc;
    end

    resultimgr = zeros(resulty, resultx);
    resultimgg = zeros(resulty, resultx);
    resultimgb = zeros(resulty, resultx);

    for i = 1:resulty
        for j = 1:resultx
            resultimgr(i,j) = 1-(result(j,resulty+1-i,1)<result(j,resulty+1-i,3));
            resultimgg(i,j) = 1-((result(j,resulty+1-i,1)==result(j,resulty+1-i,3))*(result(j,resulty+1-i,2)~=0));
            resultimgb(i,j) = 1-(result(j,resulty+1-i,1)>result(j,resulty+1-i,3));
        end
    end
    Str = sprintf('Image\\Processed\\temp%dr.bmp',ber);
    imwrite(resultimgr,Str);
    Str = sprintf('Image\\Processed\\temp%dg.bmp',ber);
    imwrite(resultimgg,Str);
    Str = sprintf('Image\\Processed\\temp%db.bmp',ber);
    imwrite(resultimgb,Str);
end