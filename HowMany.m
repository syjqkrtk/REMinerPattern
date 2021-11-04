function result = HowMany(Pattern)

result = zeros(30,30);
img = zeros(30,30);

for x = 1:30
    for y = 1:30
        temp = cell2mat(Pattern(x,y));
        result(x,y)=sum(sum(temp(:,:)));
    end
end

for i = 1:30
    for j = 1:30
        img(i,j) = 1-result(j,31-i)/max(max(result));
    end
end

imwrite(img, 'Data\30 MT genome Pattern.bmp');