function massage = encode(x)
    massage = [];
    for i = 1:length(x)
        ascii = double(x(i));            % Получаем ASCII-код
        bits = dec2bin(ascii, 7) - '0';  % Переводим в массив битов
        massage = [massage, bits];       % Добавляем к общей последовательности
    end
end
