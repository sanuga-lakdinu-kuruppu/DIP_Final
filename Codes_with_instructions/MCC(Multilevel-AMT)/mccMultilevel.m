function [thresholdArray] = mccMultilevel(img)
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

%Creating Probability Distribution using frequencies
probabiltyDistribtion = frequency / totalPixelCount;

thresholdValueArray(1,1) = 255;
thresholdValueArray = sort(thresholdValueArray);  
costFunctionValue = 0;


meanFirstClass = 0;
meanLastClass = 0;
meanMiddleClasses = 0;
varLastClass = 0;
varFirstClass = 0;
previousHighetVar = 0;
previousHishetVarClass = 0;
varMiddleClasses = 0;
discrepencyFirstClass = 0;
discrepencyLastClass = 0;
discrepencyMiddleClasses = 0;

%Getting best thresohld values 
for k = 1 : 256
    discrepencyFirstClass = 0;
    discrepencyLastClass = 0;
    discrepencyMiddleClasses = 0;

    %Traverse through all the classed based on current thresholdvalues
    for a = 1 : k
        meanFirstClass = 0;
        meanLastClass = 0;
        meanMiddleClasses = 0;
        varLastClass = 0;
        varFirstClass = 0;
        varMiddleClasses = 0;

        if a == 1
            %Getting discrepany of first class
            totProbS = sum(probabiltyDistribtion(1:thresholdValueArray(1,1)));

            %Getting mean value of first class
            for x = 1 :  thresholdValueArray(1,1)
                if probabiltyDistribtion(x) ~= 0 && totProbS ~= 0
                    meanFirstClass = meanFirstClass + x * probabiltyDistribtion(x)/totProbS;
                end
            end

            %Getting variance value of first class
            for x = 1 :  thresholdValueArray(1,1)
                if probabiltyDistribtion(x) ~= 0 && totProbS ~= 0
                    varFirstClass = varFirstClass + (x - meanFirstClass).^2 * probabiltyDistribtion(x)/totProbS;
                end
            end
            discrepencyFirstClass = discrepencyFirstClass + totProbS * varFirstClass;

            %Getting highest varied(Highest variance) class
            if varFirstClass >= previousHighetVar
                previousHighetVar = varFirstClass;
                previousHishetVarClass = a;
            end
        elseif a == k
            %Getting discrepany of last class
            totProbS = sum(probabiltyDistribtion(thresholdValueArray(1,k-1):255));

            %Getting mean value of last class
            for x = thresholdValueArray(1,k-1) :  255
                if probabiltyDistribtion(x) ~= 0 && totProbS ~= 0
                    meanLastClass = meanLastClass + x * probabiltyDistribtion(x)/totProbS;
                end
            end

            %Getting variance value of last class
            for x = thresholdValueArray(1,k-1) :  255
                if probabiltyDistribtion(x) ~= 0 && totProbS ~= 0
                    varLastClass = varLastClass + (x - meanLastClass).^2 * probabiltyDistribtion(x)/totProbS;
                end
            end
            discrepencyLastClass = discrepencyLastClass + totProbS * varLastClass;

            %Getting highest varied(Highest variance) class
            if varLastClass >= previousHighetVar
                previousHighetVar = varLastClass;
                previousHishetVarClass = a;
            end
        else
            %Getting discrepany of middle classes
            totProbS = sum(probabiltyDistribtion(thresholdValueArray(1,a-1):thresholdValueArray(1,a)));

            %Getting mean value of middle class
            for x = thresholdValueArray(1,a-1) :  thresholdValueArray(1,a)
                if probabiltyDistribtion(x) ~= 0 && totProbS ~= 0
                    meanMiddleClasses = meanMiddleClasses + x * probabiltyDistribtion(x)/totProbS;
                end
            end

            %Getting variance value of middle class
            for x = thresholdValueArray(1,a-1) :  thresholdValueArray(1,a)
                if probabiltyDistribtion(x) ~= 0 && totProbS ~= 0
                    varMiddleClasses = varMiddleClasses + (x - meanMiddleClasses).^2 * probabiltyDistribtion(x)/totProbS;
                end
            end
            discrepencyMiddleClasses = discrepencyMiddleClasses + totProbS * varMiddleClasses;

            %Getting highest varied(Highest variance) class
            if varMiddleClasses >= previousHighetVar
                previousHighetVar = varMiddleClasses;
                previousHishetVarClass = a;
            end
        end
    end
    if k == 1
        costFunctionValue = 255;
    end
    
    %Calculating Cost Function value and getting optimal number of
    %thresholds
    if costFunctionValue > 0.8 * sqrt(discrepencyFirstClass+discrepencyMiddleClasses+discrepencyLastClass) + (log2(k))^2

        %if new cost funtion value is less than previous one 
        %that means we can divide that classes further using highest
        %variance class
        costFunctionValue = 0.8 * sqrt(discrepencyFirstClass+discrepencyMiddleClasses+discrepencyLastClass) + (log2(k)).^2;
        if previousHishetVarClass == 1
            thresholdValueArray(1,k+1) = mccBilevel(probabiltyDistribtion(1:thresholdValueArray(1,previousHishetVarClass)),1,thresholdValueArray(1,previousHishetVarClass));
        elseif previousHishetVarClass == k-1
            thresholdValueArray(1,k+1) = mccBilevel(probabiltyDistribtion(thresholdValueArray(1,previousHishetVarClass) : 255),thresholdValueArray(1,previousHishetVarClass),255);
        else
            thresholdValueArray(1,k+1) = mccBilevel(probabiltyDistribtion(thresholdValueArray(1,previousHishetVarClass-1),thresholdValueArray(1,previousHishetVarClass)),thresholdValueArray(1,previousHishetVarClass-1),thresholdValueArray(1,previousHishetVarClass));
        end

        thresholdValueArray = sort(thresholdValueArray);

    else
        %if new cost funtion value is greater than previous one 
        %that means previous number of thresholds is the optimal value
        break;
    end
end

thresholdArray = thresholdValueArray;

end