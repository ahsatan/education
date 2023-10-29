fun sum l =
    let
        fun sum (l, acc) =
            case l of
                [] => acc
              | x :: tl => sum(tl, acc + x)
    in
        sum(l, 0)
    end

fun reverse l =
    let
        fun reverse (l, acc) =
            case l of
                [] => []
              | x :: tl => reverse(tl, x :: acc)
    in
        reverse(l, [])
    end
