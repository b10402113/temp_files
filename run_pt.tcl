


source cur.cfg

source ../../../scripts/rm_setup/pt_setup.tcl

source ../../../scripts/rm_pt_scripts/dmsa_mc.tcl



update_timing -full
check_timing -verbose > ${DESIGN_NAME}_check_timing.report
save_session ${DESIGN_NAME}_${MODE}_${CORNER}_ss 

report_constraint -all_violators -sign 4 > ${DESIGN_NAME}_allvios.rpt

#report_timing -crosstalk_delta -slack_lesser_than 0.0 -pba_mode exhaustive -delay min_max -nosplit -input -net -sign 4 >  $REPORTS_DIR/${DESIGN_NAME}_dmsa_report_timing_pba.report
#report_analysis_coverage > $REPORTS_DIR/${DESIGN_NAME}_dmsa_report_analysis_coverage.report 

set_noise_parameters -enable_propagation
check_noise
update_noise

report_noise -nosplit -all_violators -above -low > ${DESIGN_NAME}_report_noise_all_viol_abv_low.report
report_noise -nosplit -nworst 10 -above -low > ${DESIGN_NAME}_report_noise_alow.report
report_noise -nosplit -all_violators -below -high > ${DESIGN_NAME}_report_noise_all_viol_below_high.report
report_noise -nosplit -nworst 10 -below -high > ${DESIGN_NAME}_report_noise_below_high.report

# Clock Network Double Switching Report
# report_si_double_switching -nosplit -rise -fall > ${DESIGN_NAME}_report_si_double_switching.report


