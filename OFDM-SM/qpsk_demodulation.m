function qpsk_desequence = qpsk_demodulation(qpsk)
   qpsk_desequence = [];
    for i = 1:length(qpsk)
        if real(qpsk(i))>0 && imag(qpsk(i))>0
            qpsk_desequence = [qpsk_desequence 0 0];
        elseif real(qpsk(i))<0 && imag(qpsk(i))>0
            qpsk_desequence = [qpsk_desequence 1 0];
        elseif real(qpsk(i))>0 && imag(qpsk(i))<0
            qpsk_desequence = [qpsk_desequence 0 1];
        elseif real(qpsk(i))<0 && imag(qpsk(i))<0
            qpsk_desequence = [qpsk_desequence 1 1];
        end
    end
end