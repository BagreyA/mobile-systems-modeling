function [outputStringOrFalse] = ascii_decode(arrayBits)
    [decodeTbl, ~] = ascii_table();
    
    if mod(length(arrayBits), 7) ~= 0
        outputStringOrFalse = false;
        return;
    end
    
    numChars = length(arrayBits) / 7;
    outputString = "";
    
    for i = 1:numChars
        bitSegment = arrayBits((i-1)*7 + 1 : i*7);
        bitString = num2str(bitSegment(:)');
        bitString = regexprep(bitString, '\s+', '');
        
        if isKey(decodeTbl, bitString)
            outputString = outputString + decodeTbl(bitString);
        else
            outputStringOrFalse = false;
            return;
        end
    end
    
    outputStringOrFalse = outputString;
end
