
set current_url [ad_conn url]?[ad_conn query]

if {![info exists package_id]} {
    set package_id [ad_conn package_id]
}

if {![info exists community_id]} {
    set community_id [dotlrn_community::get_community_id]
}

if {![info exists show_non_session_calendar_links]} {
    set show_non_session_calendar_links 1
}

set attendance_package_id [db_string "getattpack" ""]
set attendance_url [apm_package_url_from_id $attendance_package_id]
set calendar_id [dotlrn_calendar::get_group_calendar_id -community_id $community_id]
set calendar_url [calendar_portlet_display::get_url_stub $calendar_id]

if { ! [db_0or1row item_type_id {  }] } {
	set item_type_id [calendar::item_type_new -calendar_id $calendar_id -type "Session"]
}

set grade_item_id [db_string "getgradeid" ""]

# ns_log Notice " -- Attendance Package ID : $attendance_package_id, Grade Item : $grade_item_id --"

attendance::add_sessions -community_id $community_id -grade_item_id $grade_item_id -package_id $attendance_package_id

template::list::create \
    -name session_list \
    -multirow session_list \
    -pass_properties { attendance_url current_url calendar_url calendar_id item_type_id } \
    -key task_id \
    -no_data "No sessions" \
    -elements {
	session_name {
	    label "Session"
	    display_template { <a href="@calendar_url@cal-item-view?cal_item_id=@session_list.cal_item_id@">@session_list.session_name@</a> }
	}
	date_time {
	    label "Date and Time"
	}
	action {
	    label "Actions"
	    html "nowrap"
	    display_template { <a href="@calendar_url@cal-item-new?cal_item_id=@session_list.cal_item_id@&return_url=@current_url@">Edit</a>  | <a href="@attendance_url@admin/mark?item_id=@session_list.item_id@&return_url=@current_url@">Attendance</a> | <a href="@attendance_url@admin/print?item_id=@session_list.item_id@" target='_blank'>Print</a> <br> <a href="@attendance_url@admin/task-delete?task_id=@session_list.task_id@&grade_id=@session_list.grade_id@&return_url=@current_url@"> Delete</a> | <a href="@attendance_url@admin/spam?item_id=@session_list.cal_item_id@&return_url=@current_url@">Email Attendees</a> }
	}
    }

db_multirow -extend {session_name cal_item_id date_time grade_id} session_list get_sessions { } {
    set cal_item_id [db_string "getcalid" "select cal_item_id from evaluation_cal_task_map where task_item_id=:item_id" -default ""]
    set session_name [db_string "geteventname" "select name from acs_events where event_id=:cal_item_id" -default ""]
    set grade_id [db_string "getgradeid" "select grade_id from evaluation_grades where grade_item_id = :grade_item_id" -default ""]
    set date_time [db_string datetime {
	select to_char(start_date, 'Mon dd, yyyy hh:miam-')||to_char(end_date, 'hh:miam')
	from cal_items ci, acs_events e, acs_activities a, timespans s, time_intervals t
	where e.timespan_id = s.timespan_id
	and s.interval_id = t.interval_id
	and e.activity_id = a.activity_id
	and e.event_id = ci.cal_item_id
	and ci.cal_item_id = :cal_item_id
    } -default ""]
}
