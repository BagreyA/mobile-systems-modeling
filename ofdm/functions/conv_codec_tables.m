function [yzli, ves, add_to_metr, pyt, in_delay_pipe] = conv_codec_tables(k, G1_oct, G2_oct)
    % GENYZL - Генерирует таблицы для декодера (треблес, веса переходов и др.)
    %
    % Входы:
    %   k       - Длина сдвигового регистра (constraint length)
    %   G1_oct  - Первый генератор в восьмеричной системе (например, 171)
    %   G2_oct  - Второй генератор в восьмеричной системе (например, 133)
    %
    % Выходы:
    %   yzli         - Ячейковый массив состояний (строки из k-1 бит)
    %   ves          - Ячейковый массив с ожидаемыми дибитами для переходов
    %   add_to_metr  - Начальные метрики для каждого состояния
    %   pyt          - Таблица переходов (индексы состояний для каждого перехода)
    %   in_delay_pipe- Выходной бит (из сдвигового регистра) для каждого перехода
    
    % Преобразуем генераторы из восьмеричной в двоичный вектор длины k
    G1 = arrayfun(@(x) str2double(x), dec2bin(oct2dec(G1_oct), k));
    G2 = arrayfun(@(x) str2double(x), dec2bin(oct2dec(G2_oct), k));
    
    % Формируем список состояний (без входного бита) в виде строк из (k-1) бит
    numStates = 2^(k-1);
    yzli = cell(1, numStates);
    for i = 0:numStates-1
        yzli{i+1} = dec2bin(i, k-1);
    end
    
    % Формируем таблицу переходов (pyt)
    % Для каждого состояния находим два возможных предшествующих состояния,
    % сопоставляя (k-2) бит (сдвиг без первого бита)
    pyt = zeros(2, numStates);
    for i = 1:numStates
        state = yzli{i};
        suffix = state(2:end); % берём последние k-2 бит
        matches = find(cellfun(@(s) strcmp(s(1:end-1), suffix), yzli));
        if numel(matches) ~= 2
            error('Ошибка при формировании таблицы переходов для состояния %d.', i);
        end
        pyt(:, i) = matches(:);
    end
    
    % Формирование весов (ves): для каждого состояния и перехода вычисляем кодовый дибит
    ves = cell(2, numStates);
    for i = 1:numStates
        for branch = 1:2
            predStateIdx = pyt(branch, i);
            predState = yzli{predStateIdx};
            % Входной бит определяется первым битом текущего состояния
            currentState = yzli{i};
            inputBit = str2double(currentState(1));
            % Сдвиговый регистр: входной бит + биты предшествующего состояния
            shiftReg = [inputBit, arrayfun(@(j) str2double(predState(j)), 1:length(predState))];
            % Вычисляем два выходных бита
            out1 = mod(sum(G1 .* shiftReg), 2);
            out2 = mod(sum(G2 .* shiftReg), 2);
            ves{branch, i} = [out1, out2];
        end
    end
    
    % Инициализация метрик: 0 для первого состояния, большое значение для остальных
    add_to_metr = [0, repmat(20, 1, numStates-1)];
    
    % Формируем in_delay_pipe: для каждого состояния определяем выходной бит
    in_delay_pipe = zeros(2, numStates);
    for i = 1:numStates
        bit = str2double(yzli{i}(1));
        in_delay_pipe(:, i) = bit;
    end
end
    