function [can] = can_ascii_encode(inputString)
    [~, encodeTbl] = ascii_table();
    
    result = true;
    
    for i = 1:length(inputString)
        if ~isKey(encodeTbl, inputString(i))
            result = false;
            break;
        end
    end
    
    can = result;
end
