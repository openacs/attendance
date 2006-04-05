<?xml version="1.0"?>
<queryset>
  <rdbms>
    <type>postgresql</type>
    <version>7.1</version>
  </rdbms>

	<fullquery name="item_type_id">
	<querytext>
		select item_type_id from cal_item_types where type='Session' and  calendar_id = :calendar_id limit 1
	</querytext>
	</fullquery>

	<fullquery name="get_sessions">      
		<querytext>
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
			order by due_date asc
		</querytext>
	</fullquery>


</queryset>