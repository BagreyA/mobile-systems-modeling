function [interleaved_bits, deinterleaved_bits] = bit_interleaver(bits)
    % Фиксированный псевдослучайный закон перестановки
    rng(42); % Устанавливаем зерно генератора случайных чисел для воспроизводимости
    N = length(bits);
    perm_idx = randperm(N); % Генерация перестановки
    
    % Прямое перемежение
    interleaved_bits = bits(perm_idx);
    
    % Обратное перемежение
    [~, reverse_perm_idx] = sort(perm_idx); % Вычисляем обратную перестановку
    deinterleaved_bits = interleaved_bits(reverse_perm_idx);
end

% Пример использования
rng('shuffle'); % Перемешиваем генератор случайных чисел
bits = randi([0, 1], 1, 10); % Генерация случайного битового вектора длины 10
[interleaved, deinterleaved] = bit_interleaver(bits);
disp('Исходные биты:'), disp(bits);
disp('Перемешанные биты:'), disp(interleaved);
disp('Восстановленные биты:'), disp(deinterleaved);