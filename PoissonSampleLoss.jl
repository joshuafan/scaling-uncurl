using LowRankModels

import Base: scale!, *, convert
import Optim.optimize
import LowRankModels.evaluate
import LowRankModels.grad
import LowRankModels.M_estimator

export PoissonSampleLoss, evaluate, grad, M_estimator

type PoissonSampleLoss<:Loss
    scale::Float64
    domain::Domain
end

PoissonSampleLoss(max_count::Int, scale=1.0::Float64; domain=CountDomain(max_count)::Domain) = PoissonSampleLoss(scale, domain)

EPSILON = 0.001
evaluate(l::PoissonSampleLoss, u::Float64, a::Number) = l.scale*(u - a*log(u+EPSILON))

grad(l::PoissonSampleLoss, u::Float64, a::Number) = l.scale*(1.0 - (a / u))

M_estimator(l::PoissonSampleLoss, a::AbstractArray) = mean(a)
