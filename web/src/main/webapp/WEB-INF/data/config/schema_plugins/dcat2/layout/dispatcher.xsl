<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:include href="layout.xsl"/>
  <xsl:include href="evaluate.xsl"/>

  <xsl:template name="get-dcat2-is-service">
    <xsl:value-of select="false()"/>
  </xsl:template>

  <!--
    Load the schema configuration for the editor.
      -->
  <xsl:template name="get-dcat2-configuration">
    <xsl:copy-of select="document('config-editor.xml')"/>
  </xsl:template>


  <!-- Dispatching to the profile mode  -->
  <xsl:template name="dispatch-dcat2">
    <xsl:param name="base" as="node()"/>
    <xsl:param name="overrideLabel" as="xs:string" required="no" select="''"/>
    <xsl:param name="refToDelete" as="node()?" required="no"/>
    <xsl:param name="config" as="node()?" required="no"/>

    <xsl:apply-templates mode="mode-dcat2" select="$base">
      <xsl:with-param name="overrideLabel" select="$overrideLabel"/>
      <xsl:with-param name="refToDelete" select="$refToDelete"/>
      <xsl:with-param name="config" select="$config"/>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
