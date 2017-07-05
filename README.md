<h1>Scaling up UNCURL</h1>

<h2>About</h2>
This repository contains code to experiment with two possible approaches to scale up non-negative sampled matrix factorization:

1. Julia NMF (see chapter 9 of https://web.stanford.edu/~boyd/papers/pdf/glrm.pdf ). This uses proximal gradient descent. (<a href="https://github.com/madeleineudell/LowRankModels.jl">code</a>)

2. Parallel Latent Dirichlet Allocation (<a href="http://openbigdatagroup.github.io/plda/">code</a>) 

<b>Paper:</b> PLDA+: Parallel Latent Dirichlet Allocation with Data Placement and Pipeline Processing. Zhiyuan Liu, Yuzhou Zhang, Edward Y. Chang, Maosong Sun. ACM Transactions on Intelligent Systems and Technology, special issue on Large Scale Machine Learning. 2011.

<h2>Prerequisites</h2>

To my knowledge, PLDA needs to be run on Linux. 

1. For PLDA, you will need to have g++ and mpich installed. Here are instructions for installing mpich: https://www.mpich.org/static/downloads/3.2/mpich-3.2-README.txt

2. Install PLDA (follow <a href="http://openbigdatagroup.github.io/plda/">these instructions</a>)

3. Download the <a href="https://julialang.org/downloads/">Julia programming langauge</a>. You will need to add the Julia installation to the PATH environment variable (see <a href="https://julialang.org/downloads/platform.html">instructions</a>)

<h2>About the code</h2>

<ul>
<li>"nmf.jl" contains the driver file that presents different ways of obtaining the initial data matrix, creates a PLDA input file (for use in PLDA) sets up the GLRM (Generalized Low Rank Model), and then fits it using the Julia implementation.

<b>NOTE:</b> The first time this is run, you need to uncomment out the "Pkg.add()" statements at the top to install the necessary Julia packages.</li>

<li>"utils.jl" contains utility functions to generate synthetic data and evaluate the quality of the results.

<li>"plda_utils.jl" contains utility functions to convert a matrix into the format required by PLDA, and to parse PLDA's output.

<li>"plda.jl" is a driver file for evaluating PLDA results from their output files.

<li>"PoissonSampleLoss.jl" contains a custom implementation of the Poisson sampled loss function for Julia NMF.
</ul>

<h2>Running the code</h2>

To run Julia NMF: uncomment "Pkg.add()" statements the first time. If desired, adjust how the data matrix is initialized, and edit the file name of the PLDA file generated from the data. Then, "julia nmf.jl" can be run.

To run PLDA: Make sure the input file has been created (using nmf.jl first). Then, follow <a href="http://openbigdatagroup.github.io/plda/"> these instructions</a> to run PLDA, making sure to adjust the number of topics and the input/output file names. Finally, make sure that the file names referenced in "plda.jl" are correct, and run "julia plda.jl".
