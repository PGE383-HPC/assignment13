#!/usr/bin/env julia

# Copyright 2022 John T. Foster
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
module assignment13

using CSV
using Tables
using MPI

function read_data_file(filename::String)
    CSV.File(filename; header=false, skipto=6) |> Tables.matrix
end

function parse_width_and_thickness(filename::String)
    l::String = ""
    for (i, line) in enumerate(eachline(filename))
        l = line
        if i == 3
          break
        end
   end
   first_split_string = split(l, ",")
   width = parse(Float64, strip(split(first_split_string[3], "=")[2], '"'))
   thickness = parse(Float64, split(split(first_split_string[4], "=")[2], '"')[1])
   (width, thickness)
end

function convert_to_true_stress_and_strain(filename::String)
    width, thickness =  parse_width_and_thickness(filename)
    data =  read_data_file(filename)

    true_strain = log.(1 .+ data[:, 3])
    true_stress = data[:, 4] / width / thickness .* (1 .+ data[:, 3])
    (true_strain, true_stress)
end

function trapz(strain::AbstractArray, stress::AbstractArray,)
    0.5 .* sum((stress[2:end] + stress[1:(end-1)]) .*  
               (strain[2:end] - strain[1:(end-1)]))
end

function partition_data(strain::AbstractArray, stress::AbstractArray, comm::MPI.Comm)
    # Function should partition the strain/stress arguments appropriately and
    # as equally as possible, so that the integration can be carried out on
    # each processor independently.  This function should only do the
    # partitioning and return the distributed stress/strain arrays.  It's common
    # to use the variable prefix "my_" for local (to processor) variables so you
    # might choose to return:
    # (my_strain, my_stress)
end

function compute_toughness_parallel(filename::String, comm::MPI.Comm)
    if MPI.Comm_rank(comm) == 0
        strain, stress = convert_to_true_stress_and_strain(filename)
    else
        strain, stress = [], []
    end
    # Uncomment the line below once you've implemented partition_data
    # my_strain, my_stress = partition_data(strain, stress, comm)
    
    # Integrate the partial stress-strain curves on each processor with trapz(),
    # then return the result of a parallel reduction summation to the root
    # (i.e.\ rank 0) processor.
end

function run_parallel(filename::String)
    MPI.Init()
    comm = MPI.COMM_WORLD
    ans = compute_toughness_parallel(filename, comm)
    if MPI.Comm_rank(comm) == 0
        println(ans)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_parallel(ARGS[1])
end

export compute_toughness_parallel, run_parallel

end

