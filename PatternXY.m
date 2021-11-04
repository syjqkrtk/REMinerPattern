function result = PatternXY(x,y,Pattern)
%x,y번째 조합의 이미지를 꺼내오자

temp = cell2mat(Pattern(x,y));
[sizex sizey] = size(temp);
for i = 1:sizex
    for j = 1:sizey
        result(i,j) = 1-temp(j,10-i);
    end
end

name = strcat('REMiner Pattern (',int2str(x),',',int2str(y),').bmp');
char(name)
imwrite(result, name);

end

