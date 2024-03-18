# Homework Assignment 13

![Assignment 13](https://github.com/PGE383-HPC/assignment13/actions/workflows/main.yml/badge.svg)


In [Homework Assignment 9](https://github.com/PGE383-HPC/assignment9) we wrote a program that would process a data file, converting the raw data to true stress and strain, and compute the toughness.  In this assignment, we will make the integration (i.e. toughness computation) a parallel task.

Your assignment is to complete the Julia module [assignment13.jl](src/assignment13.jl).  Specifically, you must complete the functions `partition_data(strain::AbstractArray, stress::AbstractArray, comm::MPI.Comm)` and `compute_toughness_parallel(filename::String, comm::MPI.Comm)`. 

In `partition_data()`, the `strain`/`stress` arguments are `Array`s that contain the entire stress and strain data only on the root processor (i.e. rank 0) and `comm` is an `MPI.COMM_WORLD` object.  This function should distribute the `strain`/`stress` data appropriately and as evenly as possible to all available processors.

`compute_toughness_parallel()` is already partially implemented, but must be completed with a parallel *reduction* summation operation to the root processor.  This function should return the toughness value after reduction. You should use the implemented `trapz()` function to perform the integration on each processor before reduction.

When the script is executed with the following command in the Terminal application from the root of the assignment repository

```bash
$HOME/.julia/bin/mpiexecjl --project=. -np 2 julia src/assignment13.jl 'data/data.csv'
```

it will print the toughness value to the screen. Your code should be parallel consistent, i.e. it should produce the exact same answer independent of the number of processors you specify.

If you haven't already done so, please run the following commands from the Julia REPL *one time* before starting your assignment to install the *project aware* version of `mpiexec`.

```julia
using MPI; MPI.install_mpiexecjl()
```

## Testing

To see if your answer is correct, run the following command at the Terminal
command line from the repository's root directory

```bash
julia --project=. -e "using Pkg; Pkg.test()"
```

the tests will run and report if passing or failing.
