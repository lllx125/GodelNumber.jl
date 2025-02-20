macro format(expr)
    return esc(quote
        $format_expr($expr, 0)
    end)
end

function format_expr(expr::Expr, tabs::Int64=0)
    if expr.args[1] === :∀
        if length(expr.args) != 3
            @error "`∀` should have 2 arguments"
        end
        println(repeat("  ", tabs), "∀", expr.args[2])
        format_expr(expr.args[3], tabs + 1)
    elseif expr.args[1] === :∃
        if length(expr.args) != 3
            @error "`∃` should have 2 arguments"
        end
        println(repeat("  ", tabs), "∃", expr.args[2])
        format_expr(expr.args[3], tabs + 1)
    elseif expr.args[1] === :⩓
        for ex in expr.args[2:end-1]
            format_expr(ex, tabs)
            println(repeat("  ", tabs), "⩓")
        end
        format_expr(expr.args[end], tabs)
    elseif expr.args[1] === :⩔
        for ex in expr.args[2:end-1]
            format_expr(ex, tabs)
            println(repeat("  ", tabs), "⩔")
        end
        format_expr(expr.args[end], tabs)
    elseif expr.args[1] === :¬
        if length(expr.args) != 2
            @error "`¬` should have 1 arguments"
        end
        println(repeat("  ", tabs), "¬")
        format_expr(expr.args[2], tabs + 1)
    else
        println(repeat("  ", tabs), string(expr))
    end
end

function format_expr(expr::Variable, tabs::Int64)
    print(repeat("\t", tabs))
    println(string(expr))
end

export @format