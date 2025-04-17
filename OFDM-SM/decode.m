function massage_str = decode(x, bit)
    massage_str = '';
    for i = 1:bit:length(x)
        bits = x(i:i+bit-1);                   % Берём 7 бит
        num = bin2dec(num2str(bits));          % Переводим в число
        massage_str(end+1) = char(num);        % Восстанавливаем символ
    end
end
