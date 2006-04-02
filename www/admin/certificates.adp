<master>
<formtemplate id="certificates">
<table>
<tr>
<td colspan="3">Current logo image: <formwidget id="image_info"></td>
</tr>
<tr>
<td colspan="3">Upload logo image: <formwidget id="image_file"><if @site_wide_admin_p@ true><formwidget id="set_sw_submit"></if><formwidget id="use_sw_submit"></td>
</tr>
<tr>
<td colspan="3">
<formwidget id="certificate">
</td>
</tr>
<tr>
<td colspan="3">
<formwidget id="this_certifies">
</td>
</tr>
<tr>
<td colspan="3">
Participant Name Goes Here
</td>
</tr>
<tr>
<td colspan="3">
<formwidget id="attended">
</td>
</tr>
<tr>
<td colspan="3">
<formwidget id="community_name">
</td>
</tr>
<tr>
<td colspan="3">
<formwidget id="date">
</td>
</tr>
<tr>
<td colspan="3">
Instructors<br />
<formwidget id="instructors">
</td>
</tr>
<tr>
<td colspan="3" valign="top">
<formwidget id="description_label">&nbsp;<formwidget id="course_description">
</td>
<tr>
<td colspan="3">
Enter signature information
</td>
</tr>
<tr>
<td><formwidget id="signature_1"></td>
<td><formwidget id="signature_2"></td>
<td><formwidget id="signature_3"></td>
</tr>
<tr>
<td><formwidget id="signature_4"></td>
<td><formwidget id="signature_5"></td>
<td><formwidget id="signature_6"></td>
</tr>
<tr>
<td colspan="3">
<formwidget id="continuing_ed_credit_info">
</td>
</tr>
</tr>
</table>
<p><input type=submit value='Preview/Print Certificates'></p>
</formtemplate>