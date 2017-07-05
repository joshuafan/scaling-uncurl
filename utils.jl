# Contains utility functions to process the input/output to PLDA# Pkg.add("StatsBase")
# Pkg.add("Mat")

module Utils
using Distributions
using MAT
using StatsBase

export generate_gaussian_data, generate_poisson_data, cost, compare, compare_synthetic_linear


# Generate random M and W matrices, and then generate the data matrix
# from M*W with Gaussian noise.
function generate_gaussian_data(r, c, k)
  M_act = 10 * rand((r, k))
  W_act = rand((k, c))
  for i = 1:c
    W_act[:, i] = W_act[:, i] / sum(W_act[:, i])
  end
  true_data = M_act*W_act
  for i = 1:r
    for j = 1:c
      true_data[i,j] = true_data[i,j] + randn()
    end
  end
  return true_data, M_act, W_act
end


# M is a (gene x archetype) matrix, or a (word x topic) matrix. Each column
# of M (an "archetype" or "topic") sums to 1.
# W is a (archetype x cell) matrix, or a (topic x document) matrix. Each column
# of W (a "cell" or a "document") sums to 1, but then each column is scaled by a random
# factor to account for the fact that some cells have more gene expression in total
# (or some documents are longer).
function generate_poisson_data(r, c, k)
  M_act = rand((r, k))
  W_act = rand((k, c))

  for i = 1:k
    M_act[:, i] = M_act[:, i] / sum(M_act[:, i])
  end
  for i = 1:c
    W_act[:, i] = W_act[:, i] / sum(W_act[:, i])
  end

  expression_levels = (20*r) * rand(c)
  for i = 1:c
    W_act[:, i] = W_act[:, i] * expression_levels[i]
  end
  true_data = M_act*W_act
  for i = 1:r
    for j = 1:c
      d = Poisson(true_data[i,j])
      true_data[i,j] = rand(d)
    end
  end
  return true_data, M_act, W_act
end


# Return the cost of our M,W compared to the true data matrix X
function cost(X, M, W)
  (r, c) = size(X)
  eps = 0.001
  cost = (1.0/c) * sum(M*W - (X .* log(M*W + eps)))
  return cost
end

# Compare the M and W matrices produced with the actual ones (M_act and W_act)
function compare(M, W, M_act, W_act, D)
  # Normalize the M and W matrices produced so that they're on the
  # same scale as the actual M_act and W_act (check this!!!)
  for i = 1:size(W, 2)
    W[:, i] = W[:, i] / sum(W[:, i])
  end
  for j = 1:size(M, 2)
    M[:, j] = M[:, j] / sum(M[:, j])
  end
  M = (mean(M_act) / mean(M)) * M
  W = (mean(W_act) / mean(W)) * W

  println(M)
  println(M_act)
  println("W_act")
  println(W_act)
  println("1")
  println(W[1,:])
  println("2")
  println(W[2,:])
  #println("3")
  #println(W[3,:])
  
  # Compute Spearman rank correlation (not always relevant)
  println()
  println("Spearman rank correlations:")
  for i = 1:size(W, 1)
    println(corspearman(W[i, :], W_act[i, :]))
  end

  # Compute the cost function
  cost_value = cost(D, M, W)

  # Compute the norm of (M_act*W_act - M*W)
  norm = vecnorm(M_act*W_act - M*W)
  return norm
end

# An example use of the "comapre" function on the SyntheticLinear dataset
function compare_synthetic_linear(M, W)
  file = matopen("data/SyntheticLinear.mat")
  # M_act = read(file, "M")
  M_act = read(file, "Means")
  W_act = read(file, "Xact")
  D = read(file, "Dat")
  return compare(M, W, M_act, W_act, D)
end

end