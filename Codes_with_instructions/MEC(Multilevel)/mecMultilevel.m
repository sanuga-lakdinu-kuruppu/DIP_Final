function [arrThresholdValues] = mecMultilevel(img,count)
    %Image reading
    colorImage = img;
    
    %Converting to gray image
    grayImage = rgb2gray(colorImage);
    
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
    
    probabiltyDistribtion = frequency / totalPixelCount;
    
    % ------------------------ Entropy Calculation -------------------------
    
    numberOfThresholds = count;
    numberOfClasses = numberOfThresholds + 1;
    arrThresholdValues = zeros(1,numberOfThresholds);
    thresholds = zeros(1, numberOfThresholds);
    entropy = 0;
    grayValue = 0;
    
    combinations = nmultichoosek(1:255,numberOfThresholds);
    [cr,cc] = size(combinations);
    
    for j = 1 : cr
    
        entropy1 = 0;
        entropy3 = 0;
        entropy2 = 0;
    
        for g = 1 : cc
            thresholds(g) = combinations(j,g);
        end
    
        % Sort the threshold values in ascending order
        thresholds = sort(thresholds);
    
        for f = 1 : cc + 1
            if f == 1
                %Getting entropy value to first class
                totProbS = sum(probabiltyDistribtion(1:thresholds(1,1)));
                for x = 1 :  thresholds(1,1)
                    if probabiltyDistribtion(x) ~= 0 && totProbS ~= 0
                        fractionback = probabiltyDistribtion(x)/totProbS;
                        if fractionback ~= 0
                            entropy1 =  entropy1 + fractionback.* log(fractionback);
                        end
                    end
                end
            elseif f == cc + 1
                %Getting entropy value to last class
                totProbS = sum(probabiltyDistribtion(thresholds(1,f - 1):255));
                for x = thresholds(1,f-1) :  255
                    if probabiltyDistribtion(x) ~= 0 && totProbS ~= 0
                        fractionback = probabiltyDistribtion(x)/totProbS;
                        if fractionback ~= 0
                            entropy3 =  entropy3 + fractionback.* log(fractionback);
                        end
                    end
                end  
            else
                %Getting entropy value to middle classes
                totProbS = sum(probabiltyDistribtion(thresholds(1,f-1):thresholds(1,f)));
                for x = thresholds(1,f-1) :  thresholds(1,f)
                    if probabiltyDistribtion(x) ~= 0 && totProbS ~= 0
                        fractionback = probabiltyDistribtion(x)/totProbS;
                        if fractionback ~= 0
                            entropy2 =  entropy2 + fractionback.* log(fractionback);
                        end
                    end
                end
            end
            
    
        end
    
        %Getting maximum entropy for each combination and getting that
        %index
        if entropy <= -(entropy1 + entropy2 + entropy3)
                entropy = -(entropy1 + entropy2 + entropy3);
                grayValue = j;
        end
        
    end

    for v = 1 : cc
        arrThresholdValues(1,v) = combinations(grayValue,v);
    end
    
    
    last = uint8(zeros(row,col));
    
    %Generating thresholded image (Background -> black, object -> white)
    for a = 1 : row
        for b = 1 : col
            for t = 1 : cc
                if count == 1
                    if arrThresholdValues(1,t) >= grayImage(a,b)
                        last(a,b) = 255;
                        break;
                    end
                else
                    if arrThresholdValues(1,t) >= grayImage(a,b)
                        last(a,b) = arrThresholdValues(1,t);
                        break;
                    else
                        continue;
                    end
                end
            end
        end
    end

    %Generating thresholded image (Background -> white, object -> black)
    last = 255 - last;

    %Show image

    figure,
    subplot(1,3,1), imshow(img), title('Original Image');
    subplot(1,3,2), imshow(grayImage), title('Gray Image Image');
    subplot(1,3,3), imshow(last), title('Segmented Image(MEC Multilevel)');
    
    function combs = nmultichoosek(values, k)
    % Return number of multisubsets or actual multisubsets.
        if numel(values)==1 
            n = values;
            combs = nchoosek(n+k-1,k);
        else
            n = numel(values);
            combs = bsxfun(@minus, nchoosek(1:n+k-1,k), 0:k-1);
            combs = reshape(values(combs),[],k);
        end
    end

end