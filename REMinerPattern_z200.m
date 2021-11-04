%% REminer 결과 그래프에서 패턴을 분리하여 여러 기능을 수행하는 프로그램
[sizex, sizey] = size(result);          %이미지 파일의 x,y,color 크기
Pattern = cell(59,59);                 %59*59개의 각 조합에 대한 9*9 이미지
data = zeros(59,2,2);
zerolength = 50;

%% 그래프에서 분할된 선들을 찾아내 59*59개의 패턴으로 분할할 수 있게 해줌
countx=0;
county=0;

for i = 1:sizex                               %각 대응 부분들 마다의 픽셀크기가 달라 그 측정을 위해 한 선이 0인 부분을 zerox, zeroy에 저장해 구역을 나눴다
    if(result(i,1:sizey,1)==1)
        countx = countx+1;
        zerox(countx)=i;
    end
    Str = sprintf('(%d/%d) zerox finding', i, sizex);
    disp(Str);
end
for i = 1:sizey
    if(result(1:sizex,i,1)==1)
        county = county+1;
        zeroy(county)=i;
    end
    Str = sprintf('(%d/%d) zeroy finding', i, sizey);
    disp(Str);
end

%% 그래프를 59*59개의 작은 패턴들로 나누기
countx = 1;                                 %i*j번째 조합의 k,l 번째 픽셀임을 위해 변수를 지정
county = 1;
flagx = 1;                                  %zerox나 zeroy를 만났을 때, countx, county를 늘려주기 위함
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
        Pattern(i,j) = num2cell((1-result(data(i,1,1):data(i,2,1),data(j,1,2):data(j,2,2))~=0),[1 2]);
        Str = sprintf('(%d/59, %d/59) pattern is now processing, %3.2f%% is completed', i, j, (59*(i-1)+j)*100/(59*59));
        disp(Str);
    end
end