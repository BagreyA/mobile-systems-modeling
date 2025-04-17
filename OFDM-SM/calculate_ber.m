function BER = calculate_ber(original,decode_massage)
    fail = 0;
    all = length(original);
    
    for i =1:length(original)
        if original(i) ~= decode_massage(i)
            fail = fail + 1;
        end
    end

    BER = fail/all;
end