
q_counter::Int64 = 0

function gen_q()::Variable
    global q_counter = Base.:+(q_counter, 1)
    return Symbol("q", q_counter)
end

function resetcounter()
    global q_counter = 0
    return
end

export resetcounter