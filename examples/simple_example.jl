#!/bin/bash
# -*- mode: julia -*-
#=
exec julia --project=@. --compile=min -O0 --startup-file=no -e "include(popfirst!(ARGS))" "${BASH_SOURCE[0]}" "$@"
=#

using Raw2CSV

# Basically:
#
# `gather_csv_from_folder`: takes one folder and a list of fields to extract,
# extract all fields from all files inside the folder and return an String
# with a CSV.
#
# Alternative:
# `gather_csv_from_folders`: the same as above but take a list of folders
#  (i.e., consider all files inside all folders).
#
# `key_equals` takes two arguments: the name of the field to extract (this
# is both the name in the output file and the name of the column in the CSV),
# and the default value (if the field is not found). If there is no default
# value, then you need to pass `NoDefault{TypeOfTheField}()` so the code knows
# which is the type of the field (to better print the CSV). Valid types for
# fields are: `Int` (for integer data), `Float64` (for floating point data),
# and `String` (for categories and everything else that may be parsed later).
#
# If you wanna to have a column name different from the name of the field
# inside the files then, instead of `key_equals` just use:
#
# ("column_name", key_equals_extractor("field_name_in_log", <default>))
#

csv = gather_csv_from_folder("./data", [
	# The code unfortunately does not automatically save the name of the log
	# file in a column (so you know exactly from where each line came), you
	# need to save the name in the log and extract it.
	key_equals("output_filename", NoDefault{String}()),
	# Here we extract a field that only exists in some files and say that,
	# if the field does not appear in the file, the default is 0 (the code
	# knows the field has integers because 0 is an integer).
	key_equals("only_in_1_and_2", 0),
	# If the above was instead:
	#
	# key_equals("only_in_1_and_2", NoDefault{Int}()),
	#
	# then you would have an error message because one of the files
	# does not have this field. If it was:
	#
	# key_equals("only_in_1_and_2", 0.0),
	#
	# then the numbers would be saved as floating point values in the CSV.
	("custom_column_name", key_equals_extractor("in_all", NoDefault{String}())),
	# float_data field exists in all files, but there is no problem in
	# having a default if you do not want to trigger errors in case it
	# could not be present.
	key_equals("float_data", 0.0)
])
print(csv)

