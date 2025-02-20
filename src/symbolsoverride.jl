import Base: ^
≤(a::Variable=:a, b::Variable=:b) = :(($a < $b) ⩔ ($a == $b))

>(a::Variable=:a, b::Variable=:b) = :($b < $a)

<(a::Variable=:a, b::Variable=:b) = :($a < $b)

≥(a::Variable=:a, b::Variable=:b) = :(($b < $a) ⩔ ($a == $b))

==(a::Variable=:a, b::Variable=:b) = :($a == $b)

^(a::Variable=:a, b::Variable=:b) = :($a^$b)

export ≤, >, ≥, <, ^