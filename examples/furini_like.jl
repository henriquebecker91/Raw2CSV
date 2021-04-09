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
	("instancePath", key_equals_extractor("instance_path", NoDefault{String}())),
	("instanceName", wrap(basename,
		key_equals_extractor("instance_path", NoDefault{String}()))),
	("rotationOfItems", wrap(Int,
		p_args_key_extractor("PPG2KP-allow-rotation", NoDefault{Bool}()))),
	("exportMPS", wrap(isempty,
		p_args_key_extractor("save-model", NoDefault{String}()))),
	("numberOfVariables", key_equals_extractor("num_vars", 0)),
	("numberOfConstraints", key_equals_extractor("num_constrs", 0)),
	("preprocessing_time", key_equals_extractor("enumeration_time", NaN)),
	("model_building_time", key_equals_extractor("build_time", NaN)),
	("is_faithful",
		p_args_key_extractor("PPG2KP-faithful2furini2016", NoDefault{Bool}())),
	("use_mirror_plates",
		p_args_key_extractor("PPG2KP-mirror-plates", false)),
	key_equals("qt_pevars_after_preprocess", -1),
	key_equals("qt_cmvars_after_preprocess", -1),
	key_equals("qt_plates_after_preprocess", -1),
	key_equals("qt_pevars_after_purge", -1),
	key_equals("qt_cmvars_after_purge", -1),
	key_equals("qt_plates_after_purge", -1),
	key_equals("build_stop_reason", "REASON_NOT_FOUND"),
	key_equals("save_model_time", NaN),
	key_equals("run_total_time", NaN),
	("exception_detected",
		key_equals_extractor("run_ended_by_exception", false)),
])

print(csv)

