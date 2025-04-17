function [signal, Heq, H, c] = ofdm_demodulation(ofdm_ch, Nz, DRS, pilot, pref, ofdm_len)
    cut_dem_ch = ofdm_ch(pref+2:length(ofdm_ch));
    ofdm = fft(cut_dem_ch,ofdm_len);
    c = ofdm(Nz+1:(length(ofdm)-Nz));
    array_index = 1:DRS:length(c);
    Rtx = ones(1,length(array_index)) * pilot;
    Rrx = transpose(reshape(c(1:DRS:end), [], 1));
    H = [];

    for i=1:length(Rrx)
        H(i) = Rrx(i)/Rtx(i);
    end

    ts = linspace(1, length(c), length(c));
    Heq = interp1(array_index, H, ts,'linear');
    
    %экввалайзер
    Ceq = c ./ Heq;
    Ceq(1:DRS:end) = [];
    signal = Ceq;

end