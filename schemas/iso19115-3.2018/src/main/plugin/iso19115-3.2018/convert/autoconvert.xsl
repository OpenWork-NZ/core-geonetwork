<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="schema" select="'iso19115-3.2018'" />

	<xsl:template match="/">
	  <xsl:if test="$schema = 'iso19115-3.2018'"><xsl:copy-of select="." /></xsl:if>
	  <xsl:if test="$schema = 'iso19139'">
	  	<redirect>schema:iso19115-3.2018:convert/fromISO19139</redirect>
	  </xsl:if>
	  <xsl:if test="$schema = 'dublin-core'">
	  	<redirect>schema:iso19115-3.2018:convert/fromMWLR-DC</redirect>
	  </xsl:if>
	</xsl:template>
</xsl:stylesheet>