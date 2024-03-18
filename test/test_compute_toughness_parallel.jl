using Test
using MPI
using assignment13

MPI.Init()

comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)

file_path = dirname(@__FILE__)*"/../data/data.csv" 

ans = compute_toughness_parallel(file_path, comm)

if rank == 0
    @test isapprox(ans, 70836.1434834513, atol=1.0e-3)
end

MPI.Finalize()
