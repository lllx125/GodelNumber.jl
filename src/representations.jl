

≤(a::Variable, b::Variable) = :(($a < $b) ⩓ ($a == $b))

>(a::Variable, b::Variable) = :($b < $a)

<(a::Variable, b::Variable) = :($a < $b)

≥(a::Variable, b::Variable) = :(($b < $a) ⩓ ($a == $b))

==(a::Variable, b::Variable) = :($a == $b)

|(a::Variable, b::Variable, q::Variable=gen_q()) = :(∃($q, ($q ≤ $b) ⩓ ($a ⋅ $q == $b)))

isPrime(a::Variable, q::Variable=gen_q()) = :(∀($q, ⩓($q < $a, $q > 1, ¬($q | $a))))

isAdjacentPrime(a::Variable, b::Variable, q::Variable=gen_q()) = :(⩓(isPrime($a), isPrime($b), ¬(∃($q, ⩓($q < $b, $a < $q, isPrime($q))))))

export ≤, |, isPrime, isAdjacentPrime

