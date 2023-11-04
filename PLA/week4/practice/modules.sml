(* structures define modules
   - define: structure MyModule = struct bindings end
   - use: MyModule.binding (e.g. List.size)
*)

structure MyMath = struct

fun fact x = if x = 0 then 1 else x * fact (x - 1)

val half_pi = Math.pi / 2.0

fun doubler y = y + y

end


val pi = MyMath.half_pi + MyMath.half_pi

val doubled = MyMath.doubler 14
