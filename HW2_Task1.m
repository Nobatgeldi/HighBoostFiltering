% Ayse ERTAS 14035050

%kullanicidan resim almak için
[file,path] = uigetfile('*.tif;*.jpg;*.png');

% kullanici iptal ederse 
if isequal(file,0) 
    disp('User selected Cancel');
else
    disp(['Secilen resim:', fullfile(path,file)]);
    
    %mean filtirleme icin filter size
    % filter size -> 3 5 9 15
    prompt = 'An odd integer to specify the size of the averaging filter kernel:';
    w = input(prompt);
    
    %sharp olmasi icin deger
    prompt = ' Strength coefficient for highboost filter :';
    k = input(prompt);
    
    I = imread(fullfile(path,file));
    
    %Eger resim RGB ise grayscale yapmak
    if size(I,3)==3
        I = rgb2gray(I);
    end
    
    padding = (w-1)/2; %padding size
    iPad = zeros(size(I) + padding*2); % image with padding

    %Image with padding
    for x=1:size(I,1)
        for y=1:size(I,2)
            iPad(x+padding,y+padding) = I(x,y);
        end
    end

    %Mean filter to the image
    newI = zeros(size(I));
    for k=1:size(I,1)
        for l=1:size(I,2)
            sum=0;
            for x=1:w
                for y=1:w                
                    sum = sum + iPad(k+x-1,l+y-1);
                end
            end        
            newI(k,l) = sum/(w*w);
        end
    end
    newI = uint8(newI);

    %subtracting blurred image from the original image
    subI = zeros(size(I));
    for x=1:size(I,1)
        for y=1:size(I,2)
            subI(x,y) = I(x,y) - newI(x,y);
        end
    end
    subI = uint8(subI);
    
    %normalization
    img = ( subI - min(subI(:)) ) ./ ( max(subI(:)) - min(subI(:)) );

    %sharpening the image
    shrpI = zeros(size(I));
    for x=1:size(I,1)
        for y=1:size(I,2)
            shrpI(x,y) = I(x,y) + (subI(x,y)*k);%adding image the subtracted values --> (Image + (Image - Filter))
        end
    end
    shrpI = uint8(shrpI);
    
    figure('Name','Homework 2 Ayse ERTAS','NumberTitle','off'),subplot(2,2,1),imshow(I),subplot(2,2,2), imshow(shrpI),subplot(2,2,3), imshow(newI),subplot(2,2,4), imshow(subI);
end