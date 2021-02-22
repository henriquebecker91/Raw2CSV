#!/bin/bash
# -*- mode: julia -*-
#=
exec julia --project=@. --compile=min -O0 --startup-file=no -e "include(popfirst!(ARGS))" "${BASH_SOURCE[0]}" "$@"
=#

using Raw2CSV

if length(ARGS) !== 2
	println(
		"usage: ./solved_mps.jl <solver_name>" *
		" <path_to_folder_with_LP_and_MIP_subdirs>"
	)
	println(
		"Note: the script will consider every file inside the LP and MIP" *
		" subdirectories."
	)
	exit()
end

# In the logfile the CPLEX and Gurobi parameters have their original
# names, so to normalize both, we create extractors with a normalized
# column name that is different from the name in the file.
solver_parameters = if ARGS[1] == "Gurobi"
	[
		("solver_time_limit",
			key_equals_extractor("TimeLimit", NoDefault{Float64}())),
		# for some reason Threads is a floating point in the files
		("solver_threads",
			key_equals_extractor("Threads", NoDefault{Float64}())),
	]
elseif ARGS[1] == "CPLEX"
	[
		("solver_time_limit",
			key_equals_extractor("CPXPARAM_TimeLimit", NoDefault{Float64}())),
		# for some reason Threads is a floating point in the files
		("solver_threads",
			key_equals_extractor("CPXPARAM_Threads", NoDefault{Float64}())),
	]
else
	error("The first argument of the script must be either CPLEX or Gurobi.")
end

function not_found(s)
	return "key '$s' not found in the log"
end

csv = gather_csv_from_folders(
	[joinpath(ARGS[2], "LP"), joinpath(ARGS[2], "MIP")],
	vcat([
		key_equals("formulation", NoDefault{String}()),
		key_equals("instance_name", NoDefault{String}()),
		key_equals("rotation", NoDefault{Int}()),
		key_equals("filename", NoDefault{String}()),
		key_equals("filepath", NoDefault{String}()),
		key_equals("solver", NoDefault{String}()),
		key_equals("relax", NoDefault{Int}()),
	], solver_parameters, [
		key_equals("termination_status", not_found("termination_status")),
		key_equals("raw_status", not_found("raw_status")),
		key_equals("primal_status", not_found("primal_status")),
		key_equals("dual_status", not_found("dual_status")),
		key_equals("simplex_iterations", -1.0),
		key_equals("number_of_variables", -1),
		key_equals("number_of_constraints", -1),
		key_equals("objective_bound", NaN),
		key_equals("objective_value", NaN),
		key_equals("dual_objective_value", NaN),
		key_equals("solve_time", NaN)
	])
)
print(csv)

