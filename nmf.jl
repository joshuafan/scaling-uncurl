# These packages need to be installed first. Run these statements from the "julia" commandline or from this script.
# Pkg.add("Distributions")
# Pkg.add("Mat")
# Pkg.add("LowRankModels")
# Pkg.add("StatsBase")

include("PoissonSampleLoss.jl")
include("plda_utils.jl")
include("utils.jl")

using LowRankModels
using Distributions
using MAT
using Utils
using PLDAUtils


# Dimensions of data (note: if not generating yourself,
# "r" and "c" will get overwritten)
r,c,k = 1000,100,5

# There are a few options for obtaining the initial data matrix.

# 1. Read from mat file
# file = matopen("Zeisel_data.mat")
# file = matopen("SyntheticLinear.mat")
# vars = matread("Zeisel_data.mat")
# println(vars)
# D = read(file, "Dat")
# close(file)

# 2. Generate M and W matrices randomly and produce the data matrix by sampling from a Poisson distribution
D, M_act, W_act = generate_poisson_data(r,c,k)

# 3. Read a matrix formatted in PLDA format.
#D = parse_plda_input("data/plda_big.txt")

println("Dimensions of data matrix: $(size(D))")
(r,c) = size(D)
println("Rank: $(k)")



# From the data matrix, create a PLDA input file.
create_plda_file(D, "small_input.txt")
println("file created")

# Use our own custom "Poisson sampling loss"
losses = fill(PoissonSampleLoss(1), c)

# Constraints: NonNeg forces every entry to be nonnegative. Simplex
# enforces non-negativity, and forces every row or column (?) to sum to 1 
rx = SimplexConstraint()
ry = NonNegConstraint()

# Set up GLRM model
glrm = GLRM(D,losses,rx,ry,k)

# Initialize the GLRM, either using kmeans++ or NNDSVD (omit this
# for a default random initialization). If you want to initialize
# with some other data, I believe you can pass it in as glrm.X or
# glrm.Y (not sure about this)
# init_kmeanspp!(glrm)
init_nndsvd!(glrm)

# Fit the GLRM
println("Fitting GLRM!!!")
M,W,ch = fit!(glrm)

M = M.'
println(M)
println(W)
println(ch)

# Compare generated M/W with actual, IF true M and W matrices are available.
println(compare(M, W, M_act, W_act, D))

cost_value = cost(D, M, W)
println("Cost: $cost_value")
