<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all"
  version="2.0">

  <xsl:output method="text"/>

  <xsl:include href="dc-to-jsonld.xsl"/>

  <xsl:template match="/">
    <textResponse>
      <xsl:apply-templates mode="getJsonLD"
                           select="simpledc"/>
    </textResponse>
  </xsl:template>
</xsl:stylesheet>


