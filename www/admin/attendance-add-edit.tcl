ad_page_contract {

    Add or Edit Attendance Tasks
    list the different attendance tasks
	
    @author Hamilton Chua  (hamilton.chua@gmail.com)
    @creation-date 2004-05-17
    @version $Id$

} {
	{ task_id:integer,optional }
	{ item_id:integer,optional }
	{ grade_id:integer,optional }

}

# initial vars
set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]
set new_p [ad_form_new_p -key task_id] 

# get assigntment type (evaluation_grade) info for attendance
# db_0or1row "getgradeid" "select eg.grade_id as grade_id, eg.grade_item_id as grade_item_id, eg.grade_plural_name
#   	 	from evaluation_grades eg, acs_objects ao, cr_items cri
#		where cri.live_revision = eg.grade_id
#          and eg.grade_item_id = ao.object_id
#   		  and ao.context_id = :package_id
#		and eg.grade_name = 'Attendance'"

if { ![attendance::get_grade_info -package_id $package_id] } {
	ad_return_complaint 500 "Server Error"
}

if { $new_p } {
    set page_title "Add Attendance"
} else {
    set page_title "Edit Attendance"
}

set context $page_title

# create the attendance task
ad_form -name new_attendance_task -export { item_id grade_id } -form {
	task_id:key(acs_object_id_seq)
	{ task_name:text
		{ label "Task Name" } }
    	{description:richtext,optional  
		{label "Description"}
		{html {rows 4 cols 40 wrap soft}} }	
	{due_date:date,to_sql(linear_date),from_sql(sql_date),optional
		{label "Date"}
		{format "MONTH DD YYYY HH24 MI SS"}
		{today}
		{help} }
	{url:text(text),optional
		{label "URL"} 
		{value "http://"} }
} -edit_request {
    
    db_1row task_info { select et.task_name, et.description, to_char(et.due_date,'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
		       et.weight, et.number_of_members, et.online_p, et.late_submit_p, et.requires_grade_p
		from evaluation_tasksi et
		where task_id = :task_id }

    set due_date [template::util::date::from_ansi $due_date_ansi "YYYY-MM-DD HH24:MI:SS"]
    set weight [lc_numeric %.2f $weight]

} -on_submit {

	db_transaction {

		set storage_type "lob"

		set title [evaluation::safe_url_name -name $task_name]
		set cal_due_date [calendar::to_sql_datetime -date $due_date -time $due_date -time_p 1]
		set due_date_ansi [db_string "get_date" "select to_timestamp('[template::util::date::get_property linear_date $due_date]','YYYY MM DD HH24 MI SS')"]
		
		if { [ad_form_new_p -key task_id] } {
			set item_id $task_id
		} 

		set revision_id [evaluation::new_task -new_item_p [ad_form_new_p -key grade_id] -item_id $item_id \
							 -content_type evaluation_tasks \
							 -content_table evaluation_tasks \
							 -content_id task_id \
							 -name $task_name \
							 -description $description \
							 -weight "0" \
							 -grade_item_id $grade_item_id \
							 -number_of_members "1" \
							 -storage_type $storage_type \
							 -due_date  $due_date_ansi \
							 -requires_grade_p "f" \
							 -title $title ]
		
		content::item::set_live_revision -revision_id $revision_id

		db_dml update_date {
			update evaluation_tasks set due_date = (select to_date(:due_date,'YYYY-MM-DD HH24:MI:SS') from dual)
			where task_id = :revision_id
		}
		
		if { ![string eq $url "http://"] } {
			db_dml link_content { update cr_revisions set content = :url where revision_id = :revision_id }
			db_dml set_storage_type { update cr_items set storage_type = 'text' where item_id = :item_id }
			set content_length [string length $url]
			db_dml content_size { update cr_revisions set content_length = :content_length where revision_id = :revision_id }
		}
		
		set url [dotlrn_community::get_community_url $community_id]	
		array set community_info [site_node::get -url "${url}calendar"]
		set community_package_id $community_info(package_id)
		set calendar_id [db_string get_cal_id { select calendar_id from calendars where private_p = 'f' and package_id = :community_package_id }]

		#set calendar_id [dotlrn_calendar::get_group_calendar_id -community_id $community_id]
		#set item_type_id [db_string item_type_id "select item_type_id from cal_item_types where type='Session' and  calendar_id = :calendar_id"]


		# add to calendar
		if { ![db_0or1row calendar_mappings { select cal_item_id from evaluation_cal_task_map where task_item_id = :item_id }] } {
			# create cal_item
			set cal_item_id [calendar::item::new -start_date $cal_due_date -end_date $cal_due_date -name "$task_name" -description $description -calendar_id $calendar_id]
			db_dml insert_cal_mapping { insert into evaluation_cal_task_map (task_item_id,cal_item_id) values (:item_id,:cal_item_id) }
		} else {
			# edit previous cal_item
			calendar::item::edit -cal_item_id $cal_item_id -start_date $due_date_ansi -end_date $due_date_ansi -name "$task_name" -description $description -calendar_id $calendar_id
		}

	}

} -after_submit {
	ad_returnredirect "index"
}
	