
q_counter::Int64 = 0

function gen_q()::Variable
    global q_counter += 1
    return Symbol("q", q_counter)
end
