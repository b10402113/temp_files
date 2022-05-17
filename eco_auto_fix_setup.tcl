
proc is_hvt {ref} {
	if {[string match "*_HVT" $ref]} {
		return 1
	} else {return 0}
}
proc is_lvt {ref} {
	if {[string match "*_LVT" $ref]} {
		return 1
	} else {return 0}
}
proc is_svt {ref} {
	if {![is_hvt $ref] && ![is_lvt $ref]} {
		return 1
	} else {return 0}
}

proc get_lvt {ref} {
	if {[is_hvt $ref]} {
		return [string map {"HVT" "LVT"} $ref]
	} elseif {[is_svt $ref]} {
		return "${ref}_LVT"
	} else {
		return $ref
	}
}


#set endp  oc8051_dptr1_data_hi_reg_7_/D

proc eco_auto_fix_setup_on_one_path {path} {
	set points [get_attri $path points]
	foreach_in_coll point $points {
		set obj [get_attri $point object]
		set dir [get_attri $obj direction]
		if {$dir=="in"} {continue}
		set objn [get_attri $obj full_name]
		set inst [file dir $objn]
		set cell [get_cells $inst]
		set isseq [get_attri $cell is_sequential]
		if {$isseq=="true"} {continue}
		set ref [get_attri $cell ref_name]
		echo "$ref \t $inst"
		if {[is_lvt $ref]} {continue}
		set lvt [get_lvt $ref]
		size_cell $inst $lvt
		set ::SIZE_FLAG 1
	}
}
proc eco_auto_fix_setup_to_endp {endp} {
	set path [get_timing_paths -to $endp -group reg2reg]
	set slk [get_attri $path slack]
	set ::SIZE_FLAG 1
	while {$slk<0 && $::SIZE_FLAG==1} {
		set ::SIZE_FLAG 0
		eco_auto_fix_setup_on_one_path $path
		set path [get_timing_paths -to $endp -group reg2reg]
		set slk [get_attri $path slack]
	}
	echo "#break loop."
	echo "#slk = $slk, SIZE_FLAG = \ $::SIZE_FLAG"
}



