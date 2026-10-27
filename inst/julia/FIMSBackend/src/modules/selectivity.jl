module Selectivity

export DoubleLogisticSelectivity, Logistic3DSelectivity, LogisticSelectivity

@inline logistic_curve(inflection_point::T, slope::T, x::T) where {T <: Real} =
  one(T) / (one(T) + exp(-slope * (x - inflection_point)))

struct LogisticSelectivity{T <: Real}
  inflection_point::T
  slope::T
end

(s::LogisticSelectivity{T})(age::T) where {T <: Real} =
  logistic_curve(s.inflection_point, s.slope, age)
(s::LogisticSelectivity)(age::Real) = s(promote(age, s.inflection_point)[1])

struct DoubleLogisticSelectivity{T <: Real}
  inflection_point_asc::T
  slope_asc::T
  inflection_point_desc::T
  slope_desc::T
end

function (s::DoubleLogisticSelectivity{T})(age::T) where {T <: Real}
  ascending = logistic_curve(s.inflection_point_asc, s.slope_asc, age)
  descending = logistic_curve(s.inflection_point_desc, s.slope_desc, age)
  ascending * (one(T) - descending)
end
(s::DoubleLogisticSelectivity)(age::Real) = s(promote(age, s.inflection_point_asc)[1])

struct Logistic3DSelectivity{T <: Real}
  inflection_point_x::T
  slope_x::T
  inflection_point_y::T
  slope_y::T
  inflection_point_z::T
  slope_z::T
end

function (s::Logistic3DSelectivity{T})(x::T, y::T, z::T) where {T <: Real}
  logistic_curve(s.inflection_point_x, s.slope_x, x) *
    logistic_curve(s.inflection_point_y, s.slope_y, y) *
    logistic_curve(s.inflection_point_z, s.slope_z, z)
end

end
