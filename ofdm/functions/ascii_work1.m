clc;

% Пример теста для символа, который можно закодировать
testChrsTrue = 'yes'; 
disp(['Проверка на возможность кодирования символа "', testChrsTrue, '": ', num2str(can_ascii_encode(testChrsTrue))]);

testChrsTrueEncoded = ascii_encode(testChrsTrue);

% Преобразуем закодированный результат в строку, чтобы вывести его как одну строку
encodedString = num2str(testChrsTrueEncoded);
encodedString = regexprep(encodedString, '\s+', '');
disp(['Закодированный символ "', testChrsTrue, '":']);
disp(encodedString);

testChrsTrueDecoded = ascii_decode(testChrsTrueEncoded);
disp(['Исходный символ: "', testChrsTrue, '"']);
disp(['Декодированный символ: ', testChrsTrueDecoded]);