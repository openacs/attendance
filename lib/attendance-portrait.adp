<?xml version="1.0" encoding="iso-8859-1" standalone="no" ?>
<!DOCTYPE document SYSTEM "rml_1_0.dtd">
<document filename="example_5.pdf">
<template pageSize="(8.5in, 11in)"
          leftMargin="0"
          rightMargin="0"
          topMargin="0"
          bottomMargin="0"
          title="Certificate Template"
          author="MGH LCS"
          showBoundary="0"
          allowSplitting="20"
          >
          <!-- showBoundary means that we will be able to see the            -->
          <!-- limits of frames                                              -->
    <pageTemplate id="main">
          <pageGraphics>
          <lineMode width="2" cap="round"/>
 	   <lines>.2in 10.8in 8.3in 10.8in
		  .2in .2in 8.3in .2in
                  .2in .2in .2in 10.8in
                  8.3in .2in 8.3in 10.8in
 	   </lines>
	  <if @image_cr_file_path@ not nil>
           <image file="@image_cr_file_path@" x=".5in" y="8.5in" width="6.5in"/>
	  </if>
          </pageGraphics>
          <frame id="f1" x1=".25in" y1="6.5in" width="8in"
              height="1.5in"/>
          <frame id="f2" x1=".25in" y1="5in" width="8in"
              height="1.2in"/>
          <frame id="f3" x1=".25in" y1="3in" width="8in"
              height="2in"/>
          <frame id="f4" x1=".25in" y1="2in" width="8in"
              height=".8in"/>
          <frame id="f5" x1=".25in" y1=".7in" width="8in"
              height=".8in"/>
          <frame id="f6" x1=".25in" y1=".2in" width="8in"
              height=".5in"/>
    </pageTemplate>
</template>
<stylesheet>
    <initialize>
          <name id="FileTitle" value="Clinical Research Program"/>
    </initialize>
    <paraStyle name="h1"
    fontName="Times-Roman"
    fontSize="24"
    leading="21"
    spaceBefore=".4cm"
    spaceAfter=".4cm"
    alignment="CENTER"
     />
    <paraStyle name="h2"
    fontName="Times-Roman"
    fontSize="18"
    leading="19"
    spaceBefore=".1cm"
    spaceAfter=".1cm"
    alignment="CENTER"
     />
     <paraStyle name="p"
     fontName="Times-Roman"
     fontSize="14"
     leading="16"
     leftIndent="5"
     spaceBefore=".1cm"
     spaceAfter=".1cm"
     alignment="CENTER"
     />
     <blockTableStyle id="sig">
     <blockFont name="Times-Roman" size="12"/>
     </blockTableStyle>
     <paraStyle name="sigData"
     fontName="Times-Roman"
     fontSize="12"
     textColor="black"
     alignment="CENTER"
     />
     <paraStyle name="footer"
     fontName="Times-Roman"
     fontSize="10"
     leftIndent="5"
     spaceBefore=".1cm"
     spaceAfter="0cm"
     />
</stylesheet>
<story>
 <multiple name="users">
  <para style="h1">
   @certificate@
  </para>
  <para style="p">
   <b>@this_certifies@</b>
  </para>
  <para style="h2">
   @users.name@
  </para>
  <para style="p">
   <b>@attended@</b>
  </para>
<nextFrame name="f2"/>
  <para style="h2">
   <b>@community_name@</b>
  </para>
  <para style="p">
   <b>@instructors@</b>
  </para>
   <para style="p">
    <b>@date@</b>
   </para>
<nextFrame name="f3"/>
   <para style="p">
    <b>@description_label@ @course_description@</b>
   </para>
<nextFrame name="f4"/>
 <blockTable style="sig">
  <tr>
   <td><para style="sigData">@signature_1;noquote@</para></td>
   <td><para style="sigData">@signature_2;noquote@</para></td>
   <td><para style="sigData">@signature_3;noquote@</para></td>
  </tr>
 </blockTable>
<nextFrame name="f5"/>
 <blockTable style="sig">
  <tr>
   <td><para style="sigData">@signature_4;noquote@</para></td>
   <td><para style="sigData">@signature_5;noquote@</para></td>
   <td><para style="sigData">@signature_6;noquote@</para></td>
  </tr>
 </blockTable>
<nextFrame name="f6"/>
 <para style="footer">
	@continuing_ed_credit_info@
 </para>
 <condPageBreak height="11in"/>
</multiple>
</story>
</document>