function encode_massage = conv_encode(x)
    encode_massage = [];
    polinom = zeros(1,7);
    for i=1:(length(x))
        polinom = circshift(polinom,1);
        polinom(1)=x(i);
        out_x = xor(xor(xor(xor(polinom(1), polinom(2)), polinom(3)), polinom(4)), polinom(7));
        out_y = xor(xor(xor(xor(polinom(1), polinom(3)), polinom(4)), polinom(6)), polinom(7));
        encode_massage = [encode_massage, out_x, out_y];
    end
end
