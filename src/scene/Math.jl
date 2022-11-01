"""Mathematics used in 2D & 3D scenes."""
module Math
import StaticArrays

export VecN, Vec2, Vec3, Vec4
const VecN{N, T} = StaticArrays.SVector{N, T}
const Vec2{T} = VecN{2, T}
const Vec3{T} = VecN{3, T}
const Vec4{T} = VecN{4, T}

export MatNxM, Mat2, Mat3, Mat4
const MatNxM{N, M, T} = StaticArrays.SMatrix{N, M, T}
const Mat2{T} = MatNxM{2, 2, T}
const Mat3{T} = MatNxM{3, 3, T}
const Mat4{T} = MatNxM{4, 4, T}

export Quaternion
struct Quaternion{T<:Real}
  a::T
  b::T
  c::T
  d::T
end
Quaternion(a::Real, b::Real, c::Real, d::Real) = Quaternion{promote_type(typeof.((a, b, c, d))...)}(a, b, c, d)
Quaternion(quat::Quaternion) = Quaternion(vec(quat)...)

Base.one(::Type{Quaternion{T}}) where {T<:Real} = Quaternion(one(T), 0, 0, 0)
Base.one(::Type{Quaternion}) = one(Quaternion{Float32})

Base.abs(quat::Quaternion) = sqrt(sum(vec(quat).^2))
Base.:(==)(lhs::Quaternion, rhs::Quaternion) = vec(lhs) == vec(rhs)

Base.:(/)(lhs::Quaternion, rhs::Real) = Quaternion((vec(lhs)./rhs)...)
Base.:(*)(lhs::Quaternion, rhs::Real) = Quaternion((vec(lhs).*rhs)...)
Base.:(*)(lhs::Real, rhs::Quaternion) = rhs * lhs

export normalize
normalize(args...; kwargs...) = throw(MethodError(normalize, (kwargs, args...)))
normalize(quat::Quaternion) = quat / abs(quat)

vec(quat::Quaternion) = (quat.a, quat.b, quat.c, quat.d)

end # module Math
