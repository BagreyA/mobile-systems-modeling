function deinterleave_mass = deinterleave(x, ran_index)
    for i = 1:length(x)
        deinterleave_mass(ran_index(i)) = x(i);
    end
end
