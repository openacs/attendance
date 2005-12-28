	<listtemplate name="session_list"></listtemplate>
	<if @item_type_id@ defined>
	<ul>
		<li><a href="@calendar_url@cal-item-new?item_type_id=@item_type_id@&calendar_id=@calendar_id@&view=day&return_url=@current_url@" >Create a new event with Attendance Tracking</a>
		Note: To add attendance tracking to an existing event in your calendar edit the event and change the "Type" to "Session".
	</ul>
	</if>
	<else>
		@attendance_msg;noquote@
	</else>
