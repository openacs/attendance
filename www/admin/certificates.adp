<master>
<property name="header_stuff"><style>.cert-info {text-align:center;}</style></property>
<formtemplate id="certificates">
<table align="center">
<tr>
<td colspan="3">Current image: <formwidget id="image_info"></td>
</tr>
<tr>
<td colspan="3">Use default image: <formwidget id="use_sw_submit"></td>
</tr>
<tr>
<td colspan="2">Upload custom image: <formwidget id="image_file"><formwidget id="new_image"><if @site_wide_admin_p@ true><formwidget id="set_sw_submit"></if></td>
</tr>
<tr>
<td colspan="3" class="cert-info">
<formwidget id="certificate">
</td>
</tr>
<tr>
<td colspan="3" class="cert-info">
<formwidget id="this_certifies">
</td>
</tr>
<tr>
<td colspan="3" class="cert-info">
[Name]
</td>
</tr>
<tr>
<td colspan="3" class="cert-info">
<formwidget id="attended">
</td>
</tr>
<tr>
<td colspan="3" class="cert-info">Title: 
<formwidget id="community_name">
</td>
</tr>
<tr>
<td colspan="3" class="cert-info">
Date: <formwidget id="date">
</td>
</tr>
<tr>
<td colspan="3" class="cert-info">
Instructors<br />
<formwidget id="instructors">
</td>
</tr>
<tr>
<td colspan="3" valign="top" class="cert-info">
<formwidget id="description_label">&nbsp;<formwidget id="course_description">
</td>
<tr>
<td colspan="3" class="cert-info">
Enter names of signers here (only two lines allowed &mdash; press shift-return to add second line)
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
<td colspan="3" class="cert-info">
<formwidget id="continuing_ed_credit_info">
</td>
</tr>
</tr>
</table>
<p><input type=submit value='Preview/Print Certificates'></p>
</formtemplate>