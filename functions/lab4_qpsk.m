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
    noise = (randn(size(symbols)) + 1j * randn(size(symbols))) * 0.1;
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
