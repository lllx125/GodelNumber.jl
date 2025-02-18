
# how the well formed formulas in the language is printed

# relations
function Base.show(io::IO, r::Relation)
    print(io, r.symbol)
end

# functions
function Base.show(io::IO, f::Func)
    print(io, f.symbol)
end

# constant
function Base.show(io::IO, c::Constant)
    print(io, c.func.symbol)
end

# variables
function Base.show(io::IO, v::Variable)
    print(io, v.symbol)
end

# terms
function Base.show(io::IO, t::Term)
    @assert length(t.parameters) == t.func.arity
    print("(")
    if t.function.arity == 0
        print(io, t.func)
    elseif t.func.arity == 1
        print(io, t.func, t.parameters[1])
    elseif t.func.arity == 2
        print(io, t.parameters[1], " ", t.func, " ", t.parameters[2])
    else
        print(io, t.func, "(", t.parameters...)
        print(io, ")")
    end
    print(")")
end

# atomic formulas
function Base.show(io::IO, a::AtomicFormula)
    @assert length(a.parameters) == a.relation.arity
    print("(")
    if a.relation.arity == 0
        print(io, a.relation)
    elseif a.relation.arity == 1
        print(io, a.relation, a.parameters[1])
    elseif a.relation.arity == 2
        print(io, a.parameters[1], " ", a.relation, " ", a.parameters[2])
    else
        print(io, a.relation, "(", a.parameters...)
        print(io, ")")
    end
    print(")")
end

# boolean
function Base.show(io::IO, wff::Boolean)
    print(io, wff.symbol)
end

# A ⩓ B
function Base.show(io::IO, wff::AndWellFormedFormula)
    print(io, "(", wff.leftWFF, " ⩓ ", wff.rightWFF, ")")
end
# A ⩔ B
function Base.show(io::IO, wff::OrWellFormedFormula)
    print(io, "(", wff.leftWFF, " ⩔ ", wff.rightWFF, ")")
end
# A ⟹ B
function Base.show(io::IO, wff::ImpliesWellFormedFormula)
    print(io, "(", wff.leftWFF, " ⟹ ", wff.rightWFF, ")")
end
# A ⟺ B
function Base.show(io::IO, wff::IffWellFormedFormula)
    print(io, "(", wff.leftWFF, " ⟺ ", wff.rightWFF, ")")
end
# ¬A
function Base.show(io::IO, wff::NotWellFormedFormula)
    print(io, "(¬", wff.subWFF, ")")
end
# ∀xA
function Base.show(io::IO, wff::ForAllWellFormedFormula)
    print(io, "(∀", wff.variable, wff.subWFF, ")")
end
# ∃xA
function Base.show(io::IO, wff::ExistsWellFormedFormula)
    print(io, "(∃", wff.variable, wff.subWFF, ")")
end
