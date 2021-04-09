#!/bin/bash
# -*- mode: julia -*-
#=
exec julia --project=@. --compile=min -O0 --startup-file=no -e "include(popfirst!(ARGS))" "${BASH_SOURCE[0]}" "$@"
=#

using Raw2CSV

if isempty(ARGS)
	println("usage: ./$PROGRAM_FILE <list of all files>")
	exit()
end

csv = gather_csv_from_files(ARGS, [
	key_equals("instancePath", NoDefault{String}()),
	key_equals("instanceName", NoDefault{String}()),
	key_equals("rotationOfItems", NoDefault{Int}()),
	key_equals("exportMPS", NoDefault{Int}()),
	key_equals("sheetLength", 0),
	key_equals("sheetWidth", 0),
	key_equals("numberItemTypes", 0),
	key_equals("numberCopies", 0),
	key_equals("boxesPattern", 0),
	key_equals("numberOfVariables", 0),
	key_equals("numberOfConstraints", 0),
	key_equals("preprocessing_time", 0.0),
	key_equals("model_building_time", 0.0),
	key_equals("ub1Area", 0.0),
	key_equals("ub2Profit", 0.0),
])
print(csv)

