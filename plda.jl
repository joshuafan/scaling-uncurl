# Pkg.add("StatsBase")

include("plda_utils.jl")
include("utils.jl")
using PLDAUtils
using Utils
using MAT
using StatsBase

topic_document = parse_result_file("/tmp/linear_result.txt")
word_topic = parse_model_file("/tmp/linear_model.txt")

# Compare the results with the true M/W for SYNTHETICLINEAR
println(compare_synthetic_linear(word_topic, topic_document))


