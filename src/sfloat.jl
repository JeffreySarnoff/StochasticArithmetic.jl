abstract type SFloat <: Number end

"""
Stochastic Double64

This type represents a double-precision (64-bit) floating-point number, on which
every operation gets randomly rounded upwards or downwards.
"""
struct DFloat64 <: SFloat
    value :: Double64
end
DFloat64(x::DFloat64) = DFloat64(x.value)

"""
Stochastic Float64

This type represents a double-precision (64-bit) floating-point number, on which
every operation gets randomly rounded upwards or downwards.
"""
struct SFloat64 <: SFloat
    value :: Float64
end
SFloat64(x::SFloat64) = SFloat64(x.value)

"""
Stochastic Float32

This type represents a single-precision (32-bit) floating-point number, on which
every operation gets randomly rounded upwards or downwards.
"""
struct SFloat32 <: SFloat
    value :: Float32
end
SFloat32(x::SFloat32) = SFloat32(x.value)


value(x::SFloat) = x.value

Base.promote_rule(::Type{SFloat64}, ::Type{SFloat32}) = SFloat64
Base.promote_rule(::Type{SFloat32}, ::Type{SFloat64}) = SFloat64
Base.promote_rule(::Type{T},        ::Type{<:Number}) where T<:SFloat = T
Base.promote_rule(::Type{<:Number}, ::Type{T})        where T<:SFloat = T
Base.promote_rule(::Type{T},        ::Type{T})        where T<:SFloat = T
result_type(x::T1, y::T2) where {T1, T2} = promote_rule(T1, T2)

import Base: +, -, *, /
+(a::SFloat, b::SFloat) = result_type(a, b)(+(RND, a.value,  b.value))
*(a::SFloat, b::SFloat) = result_type(a, b)(*(RND, a.value,  b.value))
-(a::SFloat, b::SFloat) = result_type(a, b)(+(RND, a.value, -b.value))
/(a::SFloat, b::SFloat) = result_type(a, b)(/(RND, a.value,  b.value))

Base.zero(::T)       where T<:SFloat = T(0.)
Base.zero(::Type{T}) where T<:SFloat = T(0.)
Base.one(::Type{T})  where T<:SFloat = T(1.)
Base.abs(x::T)       where T<:SFloat = T(abs(value(x)))

Base.conj(x::SFloat) = x

Base.isless(x::SFloat, y::Number) = isless(value(x), y)
Base.isless(x::Number, y::SFloat) = isless(x,        value(y))
Base.isless(x::SFloat, y::SFloat) = isless(value(x), value(y))



using Statistics, Formatting

value(x::Number) = x
deref(x) = x
deref(x::Array{T,0}) where T = x[]
macro reliable_digits(expr)
    return quote
        x = [value.($(esc(expr))) for i = 1:10]
        mu = mean(x)
        sigma = std(x)
        s = -log10.((/).(sigma, abs.(mu)))
        n = trunc(Int, s)
        zip(mu, n) |> collect |> deref
    end
end
