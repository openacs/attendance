<?xml version="1.0"?>
<queryset>

	<fullquery name="getattpack">      
		<querytext>
			select object_id from acs_objects a, apm_packages b where a.object_id = b.package_id and a.context_id = :package_id and b.package_key = 'attendance'
		</querytext>
	</fullquery>

	<fullquery name="getgradeid">      
		<querytext>
			select eg.grade_item_id as grade_item_id
			from evaluation_grades eg, acs_objects ao, cr_items cri
			where cri.live_revision = eg.grade_id
			and eg.grade_item_id = ao.object_id
			and ao.context_id = :attendance_package_id
			and eg.grade_name = 'Attendance'
		</querytext>
	</fullquery>

</queryset>
