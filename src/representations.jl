
function |(a::Variable=:a, b::Variable=:b)
    assertterm(a)
    assertterm(b)
    q = gen_q()
    return :(∃($q, $q ≤ $b, $a ⋅ $q == $b))
end

function isprime(a::Variable=:a)
    assertterm(a)
    q = gen_q()
    return :(∀($q, $q < $a, ($q > 1) ⩓ (¬($q | $a))))
end

function isadjacentprime(a::Variable=:a, b::Variable=:b)
    q = gen_q()
    return :(⩓(isprime($a), isprime($b), ¬(∃($q, $q < $b, ($a < $q) ⩓ (isprime($q))))))
end

function nthprime(a::Variable=:a, b::Variable=:b)
    c = gen_q()
    q = gen_q()
    r = gen_q()
    j = gen_q()
    return :(∃($c, $c ≤ ($b^($a^2)),
        ⩓(
            ¬(2 | $c),
            ∀($q, $q < $b,
                ∀($r, $r < $b,
                    (isadjacentprime($q, $r)) ⟹
                    (
                        ∀($j, $j < $c,
                        (($q^$j) | $c) ⟺
                        (($r^($j ⊕ 1)) | $c)
                    )
                    )
                )
            ),
            ($b^$a) | $c,
            ¬(($b^($a ⊕ 1)) | $c)
        )))
end

export |, isprime, isadjacentprime, nthprime

