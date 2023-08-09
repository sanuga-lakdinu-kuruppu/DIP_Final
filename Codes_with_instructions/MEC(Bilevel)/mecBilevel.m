function [thresholdValue] = mecBilevel(img)
    %Image reading
    colorImage = img;
    
    %Converting to gray image
    grayImage = rgb2gray(colorImage);
    
    %Calculating image size
    [row, col] = size(grayImage);
    totalPixelCount = row * col;
    
    % Create a frequency array of size 256
    frequency = zeros(1, 256);
    
    % Iterate over grayscale image matrix 
    % for every possible intensity value
    % and count them
    for i = 1 : 256
        frequency(i) = sum(sum(grayImage == i-1));
    end
    
    %Creating Probability Distribution using frequencies
    probabiltyDistribtion = frequency / totalPixelCount;
    
    % ------------------------ Entropy Calculation -------------------------
    
    entropyBackground = 0;
    entropyFrontground = 0;
    entropy = 0;
    grayValue = 0;
    
    for z = 0 : 255 

        %Getting P(s) for each gray value
        totProbS = sum(probabiltyDistribtion(1:z));

        entropyFrontground = 0;
        entropyBackground = 0;

        %Getting total entropy of background( <=gray value)
        for x = 1 : z
            if probabiltyDistribtion(x) ~= 0 && totProbS ~= 0
                fractionback = probabiltyDistribtion(x)/totProbS;
                if fractionback ~= 0
                    entropyBackground =  entropyBackground +fractionback.* log(fractionback);
                end
            end
        end
        
        %Getting total entropy of object( >=gray value)
        for y = z+1 : 256
            if probabiltyDistribtion(y) ~= 0 && totProbS ~= 1
                fractionfront = probabiltyDistribtion(y)/(1 - totProbS);
                if fractionfront ~= 0
                    entropyFrontground = entropyFrontground + fractionfront.* log(fractionfront);
                end
            end
        end

        %Getting maximum entropy for each gray value and getting that gray
        %value
        if entropy <= -(entropyFrontground + entropyBackground)
            entropy = -(entropyFrontground + entropyBackground);
            grayValue = z;
        end
    end
    
    %Generating thresholded image (Background -> black, object -> white)
    last = zeros(row,col);
    for a = 1 : row
        for b = 1 : col
            if grayValue > grayImage(a,b)
                last(a,b) = 255;
            end
        end
    end

    %Generating thresholded image (Background -> white, object -> black)
     last = 255 - last;

     %Return threshold value
    thresholdValue = grayValue;
    
    %Show image

    figure,
    subplot(1,3,1), imshow(img), title('Original Image');
    subplot(1,3,2), imshow(grayImage), title('Gray Image Image');
    subplot(1,3,3), imshow(last), title('Segmented Image(MEC Bilevel)');
end