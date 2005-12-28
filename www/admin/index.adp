<master>
<property name=title>@page_title@</property>
<property name="context">"@context;noquote@"</property>

<if @attendance_msg@ defined>
	@attendance_msg;noquote@
</if>
<else>
	<if @attendance_tasks:rowcount@ ne 0>
		<listtemplate name="attendance_tasks"></listtemplate>
	</if>
	<else>
		<p> No attendance tasks for this class. Please create a session.
	</else>
</else>

