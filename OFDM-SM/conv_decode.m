function decode_massage = conv_decode(x, bit)
    trellis = poly2trellis(bit, [171 133]);
    decode_massage = vitdec(x, trellis, bit, 'trunc', 'hard');
end
