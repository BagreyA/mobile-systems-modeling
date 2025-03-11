clc;

src_string = 'word.'; 

if ~can_ascii_encode(src_string) 
    disp("Я не могу закодировать эту строку");
else 
    disp("Я могу закодировать эту строку");
end 

encoded_string = ascii_encode(src_string);
disp(encoded_string);

decoded_string = ascii_decode(encoded_string);

disp(src_string);
disp(decoded_string);

conv_encoded_string = conv_encoder(encoded_string);

disp([length(encoded_string), length(conv_encoded_string)]);

conv_decoded_string = conv_decoder(conv_encoded_string);

disp(conv_decoded_string)

result_string = ascii_decode(encoded_string);

disp(result_string)