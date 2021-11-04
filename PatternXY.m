function result = PatternXY(x,y,Pattern)
%x,y��° ������ �̹����� ��������

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

