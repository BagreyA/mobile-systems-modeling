function [arrayBitsOrFalse] = ascii_encode(inputString)
    [~, encodeTbl] = ascii_table();

    if ~can_ascii_encode(inputString) 
        arrayBitsOrFalse = false;
        return;
    end 

    len = length(inputString);
    arrayBitsOrFalse = zeros(1, len * 7);
    
    bitIndex = 1;
    for i = 1:len
        bitString = encodeTbl(inputString(i));
        arrayBitsOrFalse(bitIndex:bitIndex+6) = arrayfun(@(x) str2double(x), bitString);
        bitIndex = bitIndex + 7;
    end
end