# Language is a dictionary that maps a string(the representation of relation or function) to a relation or a function
const Language = Dict{String,Union{Relation,Func}}

# The Language of natural numbers
const NATURALNUMBER = Language(
    "0" => Func("0", 0),
    "s" => Func("s", 1),
    "<" => Relation("<", 2),
    "+" => Func("+", 2),
    "⋅" => Func("⋅", 2),
    "E" => Func("E", 2),
)

# the language currently using
baselanguage::Language = merge(Language("=" => Relation("=", 2)), NATURALNUMBER)

"""
`setbaselanguage(L::Language)`

## Description
sets the base language of the package to `L`

## Parameters

- L::Language, the language you want to use

"""
function setbaselanguage(L::Language)
    global baselanguage = merge(Language("=" => Relation("=", 2)), L)
end

"""
`@p_str(s)`

## Description
convert the string `s`` to a `WellFormedFormula`

## Parameters

- s::String

"""
macro p_str(s)
    expr = Meta.parse(s)
    return parseWFF(expr)
end

function parseWFF(expr::Expr)
    if expr.head != :call
        return parseatomic(expr)
    end
    operator = string(expr.args[1])
    if operator == "⟹"
        if length(expr.args) != 3
            @error " formula must be of the form A ⟹ B"
        end
        return ImpliesWellFormedFormula(parseWFF(expr.args[2]), parseWFF(expr.args[3]))
    elseif operator == "⩓"
        if length(expr.args) != 3
            @error " formula must be of the form A ⩓ B"
        end
        return AndWellFormedFormula(parseWFF(expr.args[2]), parseWFF(expr.args[3]))
    elseif operator == "⩔"
        if length(expr.args) != 3
            @error " formula must be of the form A ⩔ B"
        end
        return OrWellFormedFormula(parseWFF(expr.args[2]), parseWFF(expr.args[3]))
    elseif operator == "⟺"
        if length(expr.args) != 3
            @error " formula must be of the form A ⟺ B"
        end
        return IffWellFormedFormula(parseWFF(expr.args[2]), parseWFF(expr.args[3]))
    elseif operator == "¬"
        if length(expr.args) != 2
            @error " formula must be of the form ¬A"
        end
        return NotWellFormedFormula(parseWFF(expr.args[2]))
    elseif operator[1] == '∀'
        if length(expr.args) != 2
            @error " formula must be of the form ∀xA"
        end
        return ForAllWellFormedFormula(Variable(operator[4:end]), parseWFF(expr.args[2]))
    elseif operator[1] == '∃'
        if length(expr.args) != 2
            @error " formula must be of the form ∃xA"
        end
        return ExistsWellFormedFormula(Variable(operator[4:end]), parseWFF(expr.args[2]))
    else
        return parseatomic(expr)
    end

end

function parseWFF(expr::Symbol)
    return Boolean(string(expr))
end

function parseatomic(expr::Expr)
    if expr.head == :(=) || expr.head == :kw
        if length(expr.args) != 2
            @error " = is an arity-2 relation"
        end
        return AtomicFormula(baselanguage["="], [parseatomic(expr.args[1]), parseatomic(expr.args[2])])
    end
    operator = string(expr.args[1])
    try
        operation = baselanguage[operator]
        if operation isa Relation
            if length(expr.args) != operation.arity + 1
                @error "`$operation` is an arity-$(operation.arity) relation"
            end
            return AtomicFormula(operation, [parseatomic(t) for t in expr.args[2:end]])
        end
        if operation isa Func
            if length(expr.args) != operation.arity + 1
                @error "`$operation` is an arity-$(operation.arity) function"
            end
            return Term(operation, [parseatomic(t) for t in expr.args[2:end]])
        end
    catch
        @error "formatting error or `$operator` is not in the language, call setbaselanguage() to change the language"
    end
end

function parseatomic(expr::Symbol)
    try
        operator = baselanguage[string(expr)]
        if operator isa Func
            if operator.arity == 0
                return Constant(operator)
            end
        end
        return operator
    catch
        return Variable(string(expr))
    end
end

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

export @p_str, parseWFF, parseatomic, setbaselanguage, Language, NATURALNUMBER, baselanguage