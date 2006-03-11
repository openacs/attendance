<p><a class="button" href="@attendance_by_user_url@">Attendance by student</a></p>
	<if @item_type_id@ defined>
	<listtemplate name="session_list"></listtemplate>
	<ul>
		<li><a href="@calendar_url@cal-item-new?item_type_id=@item_type_id@&calendar_id=@calendar_id@&view=day&return_url=@current_url@" >Create a new event with Attendance Tracking</a>		
	</ul>
	<br>Note: To add attendance tracking to an existing event in your calendar, edit the event and change the "Type" to "Session".
	</if>
	<else>
		@attendance_msg;noquote@
	</else>
