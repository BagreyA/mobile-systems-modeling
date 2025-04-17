function qpsk_sequence = qpsk_modulation(bits)
        % Определение таблицы модуляции
        modulation_table = [0.707 + 0.707i;
            0.707 - 0.707i;
            -0.707 + 0.707i;
            -0.707 - 0.707i];

        % Проверка на корректность длины битовой последовательности
        if rem(length(bits), 2) ~= 0
            error('Длина битовой последовательности должна быть кратна 2.');
        end

        % Преобразование битовой последовательности в символы QPSK
        symbols = zeros(1, length(bits)/2);
        for i = 1:length(bits)/2
            if bits(2*i-1) == 0 && bits(2*i) == 0
                symbols(i) = modulation_table(1);
            elseif bits(2*i-1) == 0 && bits(2*i) == 1
                symbols(i) = modulation_table(2);
            elseif bits(2*i-1) == 1 && bits(2*i) == 0
                symbols(i) = modulation_table(3);
            elseif bits(2*i-1) == 1 && bits(2*i) == 1
                symbols(i) = modulation_table(4);
            end
        end

        qpsk_sequence = symbols;
end