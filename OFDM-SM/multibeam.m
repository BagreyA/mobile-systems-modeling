function Srx = multibeam(Nb,L,B,F0,N0, Stx)
    D = [];
    G = [];
    t = [];
    for i = 1:Nb
        x = randi([10 500]);
        D(i) = x;
    end
    fprintf("\nмассив длин: ");
    D = sort(D);
    disp(D);
    LightSpeed = 3 * 10^8; %m/s

    for i = 1:Nb
        t(i)=round((D(i)-D(1))/(LightSpeed*(1/B)));
    end
    for i = 1:Nb
        G(i) = LightSpeed / (4 * pi * D(i) * F0);
    end
     S_i = zeros(Nb,L+max(t));

    for i = 1:Nb
        for k = 1:(L+t(i))
            
            if k <= t(i)
                S_i(i,k) = complex(0,0);
            end
            if k > t(i)
                S_i(i,k) = Stx(k-t(i));
            end
        end
    end
    for i = 1:Nb
        for k = 1:(L+t(i))
            S_i(i,k) = S_i(i,k) * G(i);

        end
    end
    Smpy = sum(S_i,1);
    n = transpose(wgn(length(Smpy),1,N0));
    Srx = Smpy + n;
    Srx = Srx(1:L);
end