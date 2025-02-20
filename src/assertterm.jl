function assertterm(a::Variable)
    if a isa Expr
        @assert a.head === :call "the head of the expression `$a` should be :call"
        @assert a.args[1] === :^ || a.args[1] === :⋅ || a.args[1] === :⊕ "$a is not a term"
    end
end