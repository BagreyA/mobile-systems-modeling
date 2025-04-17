function interleave_mass = interleave(x, ran_index)
    interleave_mass = zeros(1, length(x));
    for i = 1:length(x)
        interleave_mass(i) = x(ran_index(i));
    end
end
