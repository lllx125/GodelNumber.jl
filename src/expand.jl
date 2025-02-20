
function expand(expr::Expr, n::Int64=1)
    for _ in 1:n
        expr = expand1(expr)
    end
    return expr
end

function fullexpand(expr::Expr)
    nextexpr = expand1(expr)
    while string(nextexpr) != string(expr)
        expr = nextexpr
        nextexpr = expand1(expr)
    end
    return nextexpr
end

function expand1(expr::Expr)
    try
        args::Vector{Variable} = [variable for variable in expr.args[2:end]]
        return getfield(GodelNumber, expr.args[1])(args...)
    catch
        args = [expand1(ex) for ex in expr.args]
        return Expr(:call, args...)
    end
end

function expand1(expr::Variable)
    return expr
end


export expand, fullexpand