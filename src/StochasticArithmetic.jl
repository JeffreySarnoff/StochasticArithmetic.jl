module StochasticArithmetic
export UP, DWN, RND, DFloat64, DFloat32, SFloat64, SFloat32, value, @reliable_digits
using DoubleFloats

include("EFT.jl")
include("rounding.jl")
include("sfloat.jl")

end # module
