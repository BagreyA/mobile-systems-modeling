clc; 

src_string = 'word.'; 

if ~can_ascii_encode(src_string) 
    disp("Я не могу закодировать эту строку");
else 
    disp("Я могу закодировать эту строку");
end 

encoded_string = ascii_encode(src_string);
disp('Закодированная строка:');
disp(encoded_string);

% 3-я лабораторная работа: Перемешивание битов
[interleaved_bits, deinterleaved_bits] = bit_interleaver(encoded_string);
disp('Перемешанные биты:');
disp(interleaved_bits);

decoded_string = ascii_decode(deinterleaved_bits);
disp('Декодированная строка после перемешивания:');
disp(decoded_string);

conv_encoded_string = conv_encoder(interleaved_bits);
disp('Длина исходной и кодированной строки:');
disp([length(interleaved_bits), length(conv_encoded_string)]);

conv_decoded_string = conv_decoder(conv_encoded_string);
disp('Декодированная строка после сверточного декодирования:');
disp(conv_decoded_string);

result_string = ascii_decode(conv_decoded_string);
disp('Результат восстановления строки:');
disp(decoded_string);

% 4-я лабораторная работа: Модуляция QPSK, добавление шума, демодуляция и проверка ошибок
main;

function result = can_ascii_encode(str)
    % Функция для проверки, можно ли закодировать строку в ASCII
    result = all(str <= 127);
end

function encoded_str = ascii_encode(str)
    % Функция для кодирования строки в ASCII
    encoded_str = [];
    for i = 1:length(str)
        encoded_str = [encoded_str, dec2bin(str(i), 8) - '0'];
    end
end

function decoded_str = ascii_decode(encoded_str)
    decoded_str = '';
    for i = 1:8:length(encoded_str)
        byte = encoded_str(i:i+7);
        decoded_str = [decoded_str, char(bin2dec(num2str(byte)))];
    end
end

function encoded = conv_encoder(bits)
    % Простой сверточный кодировщик (R=1/2, [1 1] полиномы)
    constraint_length = 7;
    code_rate = 1/2;
    trellis = poly2trellis(constraint_length, [171 133]);  % Используем стандартные полиномы
    encoded = convenc(bits, trellis);
end

function decoded = conv_decoder(bits)
    % Простой сверточный декодировщик
    constraint_length = 7;
    trellis = poly2trellis(constraint_length, [171 133]);
    decoded = vitdec(bits, trellis, length(bits) / 2, 'trunc', 'hard');
end

function [interleaved_bits, deinterleaved_bits] = bit_interleaver(bits)
    % Фиксированный псевдослучайный закон перестановки
    rng(42);
    N = length(bits);
    perm_idx = randperm(N); % Генерация перестановки
    
    % Прямое перемежение
    interleaved_bits = bits(perm_idx);
    
    % Обратное перемежение
    [~, reverse_perm_idx] = sort(perm_idx); % Вычисляем обратную перестановку
    deinterleaved_bits = interleaved_bits(reverse_perm_idx);
end

% Функция для модуляции QPSK
function symbols = modulate_qpsk(bits)
    % Проверяем, что число битов четное, если нет - дополняем
    if mod(length(bits), 2) ~= 0
        bits = [bits, 0];
    end
    
    % Карта символов QPSK
    symbol_map = [ 0.707 + 0.707j, ... % 00
                   0.707 - 0.707j, ... % 01
                  -0.707 + 0.707j, ... % 10
                  -0.707 - 0.707j];    % 11
              

    % Преобразуем биты в комплексные символы
    num_symbols = length(bits) / 2;
    symbols = zeros(1, num_symbols);
    
    for k = 1:num_symbols
        b0 = bits(2*k-1);
        b1 = bits(2*k);
        index = b0 * 2 + b1 + 1;
        symbols(k) = symbol_map(index);
    end
end

% Функция для демодуляции QPSK
function bits = demodulate_qpsk(symbols)
    % Таблица модуляции для обратного преобразования
    symbol_map = [ 0.707 + 0.707j, ... % 00
                   0.707 - 0.707j, ... % 01
                  -0.707 + 0.707j, ... % 10
                  -0.707 - 0.707j];    % 11
                
    bit_map = [0 0; 0 1; 1 0; 1 1]; % Соответствующие пары битов
    
    % Демодуляция
    num_symbols = length(symbols);
    bits = zeros(1, num_symbols * 2);
    
    for k = 1:num_symbols
        % Определяем ближайший символ созвездия
        [~, index] = min(abs(symbols(k) - symbol_map));
        bits(2*k-1 : 2*k) = bit_map(index, :);
    end
end

% Основная функция для моделирования QPSK с ошибками и шумом
function main
    % Исходные битовые данные
    bits = randi([0,1], 1, 20); % случайный битовый поток длиной 20 бит

    % Вносим случайные ошибки в биты с вероятностью 5%
    error_probability = 0.05; % Вероятность ошибки в бите
    error_mask = rand(size(bits)) < error_probability;
    bits(error_mask) = ~bits(error_mask); % Инвертируем биты с ошибками

    % Модуляция
    symbols = modulate_qpsk(bits);
    
    % Имитация шума (добавление случайного шума)
    noise = (randn(size(symbols)) + 1j * randn(size(symbols))) * 0.05; % Уменьшили уровень шума
    noisy_symbols = symbols + noise;

    % Демодуляция
    demod_bits = demodulate_qpsk(noisy_symbols);

    % Проверка ошибок
    num_errors = sum(bits ~= demod_bits);

    % Вывод модулированных символов (чистых)
    disp('Модулированные символы:');
    disp(symbols);

    % Вывод символов перед демодуляцией (с шумом)
    disp('Символы перед демодуляцией (с шумом):');
    disp(noisy_symbols);

    % Вывод демодулированных битов
    disp('Демодулированные биты:');
    disp(demod_bits);

    % Вывод результатов
    fprintf('Количество ошибок: %d\n', num_errors);

    % Построение графиков
    figure;
    subplot(1,2,1);
    plot(real(symbols), imag(symbols), 'bo', 'MarkerSize', 8, 'LineWidth', 2);
    grid on;
    xlabel('I (Re)');
    ylabel('Q (Im)');
    title('Созвездие модулированных символов');
    axis([-1 1 -1 1]);

    subplot(1,2,2);
    plot(real(noisy_symbols), imag(noisy_symbols), 'rx', 'MarkerSize', 8, 'LineWidth', 2);
    grid on;
    xlabel('I (Re)');
    ylabel('Q (Im)');
    title('Созвездие символов с шумом');
    axis([-1 1 -1 1]);
end
