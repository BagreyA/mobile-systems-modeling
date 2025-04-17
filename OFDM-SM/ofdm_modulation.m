function [ofdm, Nz, prefix, N_qpsk,pilot, len_ofdm] = ofdm_modulation(qpsk_sequence, DRS, pref)
    N_qpsk = length(qpsk_sequence);
    N_rs = floor(N_qpsk / DRS);
    pilot = complex(1,1) * 1;
    len_ofdm_pilot = N_qpsk + N_rs;
    q_pilot = qpsk_sequence;
    
    for i = 1:DRS:len_ofdm_pilot
        q_pilot = [q_pilot(1:length(q_pilot) < i), pilot, q_pilot(1:length(q_pilot) >= i)];
    end
    
    C= 0.1;
    ofdm_pilot = q_pilot;
    Nz = round(C*(N_rs+N_qpsk));
    zero = zeros(1,Nz);
    zero_defend = [zero ofdm_pilot zero];
    len_ofdm = length(zero_defend);
    ifft_ofdm = ifft(zero_defend);
    prefix = round(pref * length(ifft_ofdm));
    %переносим префикс
    ofdm = [ifft_ofdm(length(ifft_ofdm)-prefix: length(ifft_ofdm)) ifft_ofdm];
end