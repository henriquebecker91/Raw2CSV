#!/bin/bash
# -*- mode: julia -*-
#=
exec julia --project=@. --compile=min -O0 --startup-file=no -e "include(popfirst!(ARGS))" "${BASH_SOURCE[0]}" "$@"
=#

using Raw2CSV

if !isone(length(ARGS))
	println("usage: ./martin_three.jl <path_to_folder_with_non_grid_outputs>")
	println("Note: the script will consider every file inside the folder.")
	exit()
end

csv = gather_csv_from_folder(ARGS[1], [
	key_equals("instancePath", NoDefault{String}()),
	key_equals("instanceName", NoDefault{String}()),
	key_equals("rotationOfItems", NoDefault{Int}()),
	key_equals("exportMPS", NoDefault{Int}()),
	key_equals("sheetLength", 0),
	key_equals("sheetWidth", 0),
	key_equals("numberItemTypes", 0),
	key_equals("numberCopies", 0),
	key_equals("boxesPattern", 0),
	key_equals("treeSize", 0),
	key_equals("numberOfVariables", 0),
	key_equals("numberOfConstraints", 0),
	key_equals("ip_initial_value", 0.0),
	key_equals("ip_solving_value", 0.0),
	key_equals("lp_solving_value", 0.0),
	key_equals("ip_solving_upperbound", 0.0),
	key_equals("ip_solving_gap", 0.0),
	key_equals("ip_solving_time", 0.0),
	key_equals("lp_solving_time", 0.0),
	key_equals("preprocessing_time", 0.0),
	key_equals("model_building_time", 0.0),
	key_equals("ub1Area", 0.0),
	key_equals("ub2Profit", 0.0),
])
print(csv)

