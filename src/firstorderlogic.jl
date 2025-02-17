struct Relation
    symbol::String
    arity::Int8
end

struct Func
    symbol::String
    arity::Int8
end

abstract type Term end

struct Constant <: Term
    func::Func
end

struct Variable <: Term
    symbol::String
end

struct FuncTerm <: Term
    func::Func
    parameters::Vector{Term}
end

abstract type WellFormedFormula end

struct AtomicFormula <: WellFormedFormula
    relation::Relation
    parameters::Vector{Term}
end

struct Boolean <: WellFormedFormula
    symbol::String
end

struct AndWellFormedFormula <: WellFormedFormula
    leftWFF::WellFormedFormula
    rightWFF::WellFormedFormula
end

struct OrWellFormedFormula <: WellFormedFormula
    leftWFF::WellFormedFormula
    rightWFF::WellFormedFormula
end

struct ImpliesWellFormedFormula <: WellFormedFormula
    leftWFF::WellFormedFormula
    rightWFF::WellFormedFormula
end

struct IffWellFormedFormula <: WellFormedFormula
    leftWFF::WellFormedFormula
    rightWFF::WellFormedFormula
end

struct NotWellFormedFormula <: WellFormedFormula
    subWFF::WellFormedFormula
end

struct ForAllWellFormedFormula <: WellFormedFormula
    variable::Variable
    subWFF::WellFormedFormula
end

struct ExistsWellFormedFormula <: WellFormedFormula
    variable::Variable
    subWFF::WellFormedFormula
end

export Relation, Func, Variable, Term, AtomicFormula, AndWellFormedFormula, OrWellFormedFormula, ImpliesWellFormedFormula, IffWellFormedFormula, NotWellFormedFormula, ForAllWellFormedFormula, ExistsWellFormedFormula