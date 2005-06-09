
set current_url [ad_conn url]

set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]

set attendance_package_id [db_string "getattpack" "select object_id from acs_objects a, apm_packages b where a.object_id = b.package_id and a.context_id = :package_id and b.package_key = 'attendance';"]
set attendance_url [apm_package_url_from_id $attendance_package_id]

set calendar_id [dotlrn_calendar::get_group_calendar_id -community_id $community_id]
set calendar_url [calendar_portlet_display::get_url_stub $calendar_id]
set item_type_id [db_string item_type_id "select item_type_id from cal_item_types where type='Session' and  calendar_id = :calendar_id limit 1" -default 0]

set grade_item_id [db_string "getgradeid" "select eg.grade_item_id as grade_item_id
   	 	from evaluation_grades eg, acs_objects ao, cr_items cri
		where cri.live_revision = eg.grade_id
          	and eg.grade_item_id = ao.object_id
   		and ao.context_id = :attendance_package_id
		and eg.grade_name = 'Attendance'"]

ns_log Notice " -- Attendance Package ID : $attendance_package_id, Grade Item : $grade_item_id --"

attendance::add_sessions -community_id $community_id -grade_item_id $grade_item_id -package_id $attendance_package_id

template::list::create \
    -name session_list \
    -multirow session_list \
    -pass_properties { attendance_url current_url calendar_url calendar_id item_type_id } \
    -key task_id \
    -no_data "No sessions" \
    -elements {
		task_name {
			label "Session"
		}
		action {
			label "Actions"
			display_template { <a href="@calendar_url@cal-item-view?cal_item_id=@session_list.cal_item_id@" target="blank">Edit</a>  | <a href="@attendance_url@admin/mark?item_id=@session_list.item_id@&return_url=@current_url@">Mark Attendance</a> }
		}
	}

db_multirow -extend {cal_item_id} session_list get_sessions { 
	select et.task_name, et.number_of_members, et.task_id, et.grade_item_id,
		to_char(et.due_date,'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
		et.online_p, 
		et.late_submit_p, 
		et.item_id,
		et.task_item_id,
		et.due_date,
		et.requires_grade_p, et.description, et.grade_item_id,
		cr.title as task_title,
		et.data as task_data,
	   	et.task_id as revision_id,
		coalesce(round(cr.content_length/1024,0),0) as content_length,
		et.late_submit_p,
		crmt.label as pretty_mime_type
	from cr_revisions cr, 
		 evaluation_tasksi et,
	         cr_items cri,
		 cr_mime_types crmt
	where cr.revision_id = et.revision_id
	  and grade_item_id = :grade_item_id
	  and cri.live_revision = et.task_id
	  and et.mime_type = crmt.mime_type
} {
	set cal_item_id [db_string "getcalid" "select cal_item_id from evaluation_cal_task_map where task_item_id=:item_id"]
}