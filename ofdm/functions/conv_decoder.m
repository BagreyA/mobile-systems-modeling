function vb = conv_decoder(input_bits)
    % CONVDECODER - Декодирование свёрточного кода с использованием алгоритма Витерби.
    %
    % Вход:
    %   input_bits - Вектор принятых бит (длина должна быть чётной)
    %
    % Выход:
    %   vb - Декодированный вектор бит

    k = 7;
    G1_oct = 171;
    G2_oct = 133;
    
    numDibits = length(input_bits) / 2;
    
    % Получение таблиц треблес для декодера
    [yzli, ves, add_to_metr, pyt, ~] = conv_codec_tables(k, G1_oct, G2_oct);
    numStates = length(yzli);
    
    % Инициализация метрик путей (для каждого состояния)
    pathMetrics = add_to_metr;
    % Матрица для хранения предков (для обратной трассировки)
    prevState = zeros(numDibits, numStates);
    
    % Преобразуем входной вектор в ячейку дибитов
    dibits = cell(1, numDibits);
    for i = 1:numDibits
        dibits{i} = input_bits(2*i-1:2*i);
    end
    
    % Основной цикл алгоритма Витерби
    for n = 1:numDibits
        newMetrics = inf(1, numStates);
        newPrev = zeros(1, numStates);
        
        % Для каждого состояния вычисляем возможные переходы
        for state = 1:numStates
            for branch = 1:2
                % Определяем предыдущее состояние для данного перехода
                prevIdx = pyt(branch, state);
                expectedOutput = ves{branch, state};
                % Вычисляем метрику (расстояние Хэмминга)
                metric = sum(xor(dibits{n}, expectedOutput));
                totalMetric = pathMetrics(prevIdx) + metric;
                % Сохраняем переход с минимальной метрикой
                if totalMetric < newMetrics(state)
                    newMetrics(state) = totalMetric;
                    newPrev(state) = prevIdx;
                end
            end
        end
        
        pathMetrics = newMetrics;
        prevState(n, :) = newPrev;
    end
    
    % Выбор состояния с минимальной метрикой на последнем шаге
    [~, finalState] = min(pathMetrics);
    
    % Обратная трассировка для восстановления последовательности состояний
    decodedStates = zeros(1, numDibits);
    decodedStates(numDibits) = finalState;
    for n = numDibits:-1:2
        decodedStates(n-1) = prevState(n, decodedStates(n));
    end
    
    % Извлечение декодированных битов: считаем, что выходной бит - это первый бит состояния
    vb = zeros(1, numDibits);
    for i = 1:numDibits
        vb(i) = str2double(yzli{decodedStates(i)}(1));
    end
end
