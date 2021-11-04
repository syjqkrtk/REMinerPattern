%% REminer ��� �׷������� ���� �̾� ū �̹����� ����� ���α׷�
z = 8;
siz = 35;

for ber = 1:siz
    clear result sizex sizey sizec img temp temp2 startx starty resultx resulty MTGenome i j k y2 fixx fixy Str;
    for num = 1:siz
        tic;
        Str = sprintf('Image\\Screenshot_%d.png',num+(ber-1)*siz);
        img=double(imread(Str))/255; %0~255�� ������ ������ �̹����� 0~1�� �ٲ��ֱ� ����
        temp = img;                                 %��ȯ�� �̹����� ����� ���� ����
        [sizey, sizex, sizec] = size(img);          %�̹��� ������ x,y,color ũ��
        temp2 = zeros(sizex,sizey,sizec);           %�̹����� x,y���� ���Ǹ� ���� ����

        %% �̹������� �׷����� �� �κи� ����
        for i = 1:sizex                             %�̹����� x,y���� ����
            for j = 1:sizey
                temp2(i,j,:) = temp(sizey+1-j,i,:);
            end
        end

        for i = 1:sizey                             %�׷����� y�� ������ġ�� ã�� ����
            if temp2(i,sizey,1) == 0
                break;
            end
        end

        startx = i;

        for j = 1:sizex                             %�׷����� x�� ������ġ�� ã�� ����
            if temp2(startx,j,1) == 0
                break;
            end
        end
        starty = j;

        MTGenome = zeros(sizex-startx,sizey-starty,sizec);  %�׷����� �� ���� �����͸� ���� ����

        for i = startx+1:sizex
            for j = starty+1:sizey
                MTGenome(i-startx,j-starty,:) = temp2(i,j,:);
            end
        end

        MTGenome = 1 - MTGenome;
        [sizex, sizey, sizec] = size(MTGenome);         %���� ������ �κи��� ����� �ٽ� ����

        %% �̹��� �̾���̱�
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