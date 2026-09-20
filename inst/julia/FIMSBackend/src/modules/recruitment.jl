module Recruitment

export BevertonHolt, Ricker

@inline inv_logit(lower::T, upper::T, x::T) where {T <: Real} =
  lower + (upper - lower) / (one(T) + exp(-x))

struct BevertonHolt{T <: Real}
  logit_steep::T
  log_rzero::T
end

function (r::BevertonHolt{T})(spawners::T, phi_0::T) where {T <: Real}
  steep = inv_logit(T(0.2), one(T), r.logit_steep)
  rzero = exp(r.log_rzero)
  numerator = T(0.8) * rzero * steep * spawners
  denominator = T(0.2) * phi_0 * rzero * ((one(T) - steep) + oftype(steep, sqrt(eps(Float64)))) +
    spawners * (steep - T(0.2))
  numerator / denominator
end

struct Ricker{T <: Real}
  logit_steep::T
  log_rzero::T
end

function (r::Ricker{T})(spawners::T, phi_0::T) where {T <: Real}
  steep = inv_logit(T(0.2), one(T), r.logit_steep)
  rzero = exp(r.log_rzero)
  steep_gap = (one(T) - steep) + oftype(steep, sqrt(eps(Float64)))
  alpha = log((T(5) * steep) / steep_gap) / (T(0.8) * phi_0)
  beta = alpha / (phi_0 * rzero)
  alpha * spawners * exp(-beta * spawners)
end

end
