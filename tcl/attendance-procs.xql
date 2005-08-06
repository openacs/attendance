<?xml version="1.0"?>
<queryset>

    <fullquery name="attendance::get_grade_info.getgradeid">
        <querytext>	
		select eg.grade_id as grade_id, eg.grade_item_id as grade_item_id, eg.grade_plural_name
   	 	from evaluation_grades eg, acs_objects ao, cr_items cri
		where cri.live_revision = eg.grade_id
          	and eg.grade_item_id = ao.object_id
   		and ao.context_id = :package_id
		and eg.grade_name = 'Attendance'
        </querytext>
    </fullquery>

    <fullquery name="attendance::create_task.checkmap">
        <querytext>	
		select task_item_id from evaluation_cal_task_map where cal_item_id = :cal_item_id
        </querytext>
    </fullquery>

    <fullquery name="attendance::create_task.link_content">
        <querytext>	
		 update cr_revisions set content = :url where revision_id = :revision_id
        </querytext>
    </fullquery>

    <fullquery name="attendance::create_task.set_storage_type">
        <querytext>	
		 update cr_items set storage_type = 'text' where item_id = :item_id
        </querytext>
    </fullquery>

    <fullquery name="attendance::create_task.content_size">
        <querytext>	
		update cr_revisions set content_length = :content_length where revision_id = :revision_id
        </querytext>
    </fullquery>

    <fullquery name="attendance::create_task.insert_cal_mapping">
        <querytext>	
		insert into evaluation_cal_task_map (task_item_id,cal_item_id) values (:item_id,:cal_item_id)
        </querytext>
    </fullquery>

</queryset>
