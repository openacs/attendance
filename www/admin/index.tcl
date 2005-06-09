ad_page_contract {

    Landing page attendance module. 
    list the attendance tasks for the community
	
    @author Hamilton Chua (hamilton.chua@gmail.com)
    @creation-date 2004-05-17
    @version $Id$

} {

}

# initial variables
set page_title "Attendance Tasks"
set context $page_title
set community_id [dotlrn_community::get_community_id]
set package_id [ad_conn package_id]

# get grade info 
attendance::get_grade_info -package_id $package_id

ns_log Notice " -- Attendance Package ID : $package_id, Grade Item : $grade_item_id --"

# check calendar items for session and turn them into attendance tasks
attendance::add_sessions -community_id $community_id -grade_item_id $grade_item_id -package_id $package_id

set elements [list task_name \
		  [list label "Task Name" \
		       link_url_col task_url \
		       orderby_asc {task_name asc} \
		       orderby_desc {task_name desc}] \
		  due_date_pretty \
		  [list label "Date" \
		       orderby_asc {due_date_ansi asc} \
		       orderby_desc {due_date_ansi desc}] \
		  action \
		  [list label "Actions" \
			display_template { <a href="task-delete?return_url=[ad_conn url]&task_id=@attendance_tasks.task_id@&grade_id=@attendance_tasks.grade_id@">Delete</a> | <a href="mark?item_id=@attendance_tasks.item_id@">Mark</a> } ]\
		 ]

template::list::create \
    -name attendance_tasks \
    -multirow attendance_tasks \
    -actions {
	"Attendance by Student" "summary" ""
    } -key task_id \
    -filters { grade_id {} } \
    -no_data "No attendance tasks" \
    -orderby_name assignments_orderby \
    -elements $elements 

db_multirow -extend { due_date_pretty grade_id } attendance_tasks get_tasks { 
	select et.task_name, et.number_of_members, et.task_id,
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
	set due_date_pretty [lc_time_fmt $due_date_ansi "%q %r"]
	set grade_id [db_string "getgradeid" "select grade_id from evaluation_grades where grade_item_id = :grade_item_id"]
}
