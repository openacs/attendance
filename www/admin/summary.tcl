ad_page_contract {
    
	Display a summary of attendance per user
    
    @author Hamilton Chua (hamilton.chua@gmail.com)
    @creation-date May 2005
    @cvs-id $Id$
} {
    {min_days:integer 0}
    clear:optional
} 

set page_title "Summary"
set context $page_title

# determine total number of sessions
set community_id [dotlrn_community::get_community_id]
set community_url [dotlrn_community::get_community_url $community_id]
set calendar_id [dotlrn_calendar::get_group_calendar_id -community_id $community_id]
set calendar_url [calendar_portlet_display::get_url_stub $calendar_id]
set item_type_id [db_string item_type_id "select item_type_id from cal_item_types where type='Session' and  calendar_id = :calendar_id"]
set num_sessions [db_string num_sessions "select count(cal_item_id) from cal_items where on_which_calendar = :calendar_id and item_type_id = :item_type_id"]

# generate attendance summary per student

ad_form -name min_days -form {
    {min_days:integer(text) {label "Show students who have attended at least this many sessions"}}
    {ok:text(submit) {label "OK"}}
    {clear:text(submit) {label "Clear"}}
}

if {[info exists clear]} { 
    ad_returnredirect "summary"
    ad_script_abort
}

if {[attendance_certificate::reportlab_available_p]} {
    set bulk_actions {"Print Certificates" "certificates" "Print Course Completion Certificates"}
} else {
    set bulk_actions ""
}
template::list::create \
    -name summary \
    -multirow summary \
    -bulk_actions $bulk_actions \
    -actions {
	"Back to Attendance Tasks" "index" ""
    } -key user_id \
    -no_data "No summary" \
    -elements {
	member_name { label "Student" }
	attendance { label "Attendance" }
	rate { label "Rate" display_template {<div style="text-align:right;">@summary.rate@</div>}}
    }

set users [dotlrn_community::list_users  $community_id]

template::multirow create summary member_name attendance rate user_id

foreach user $users {
	set user_id [ns_set get $user user_id]
	set attendance [db_string "count" "select count(user_id) from attendance_cal_item_map where user_id = :user_id and cal_item_id in (select cal_item_id from cal_items where on_which_calendar = :calendar_id and item_type_id = :item_type_id )" ]
    if { $num_sessions == 0 } { set rate "0" } else  { set rate [format "% .0f" [expr (${attendance}.0/$num_sessions)*100]] }
    if {$attendance >= $min_days} {	template::multirow append summary "[ns_set get $user first_names] [ns_set get $user last_name]"  "$attendance of $num_sessions" "$rate %" $user_id
    }
}

