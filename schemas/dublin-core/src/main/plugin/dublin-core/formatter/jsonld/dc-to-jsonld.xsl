<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:owl ="http://www.w3.org/2002/07/owl#"
				xmlns:dcat="http://www.w3.org/ns/dcat#"
				xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:tr="java:org.fao.geonet.api.records.formatters.SchemaLocalizations"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                xpath-default-namespace="http://www.isotc211.org/2005/gmd"
                xmlns:gn-fn-index="http://geonetwork-opensource.org/xsl/functions/index"
                xmlns:schema-org-fn="http://geonetwork-opensource.org/xsl/functions/schema-org"
                xmlns:gn="http://www.fao.org/geonetwork"
                version="2.0"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all">
  <!--
    Convert an ISO19139 records in JSON-LD format


    This JSON-LD can be embeded in an HTML page using
    ```
    <html>
      <script type="application/ld+json">
       {json-ld}
      </script>
    </html>
    ```


     Based on https://schema.org/Dataset


     Tested with https://search.google.com/structured-data/testing-tool

     TODO: Add support to translation https://bib.schema.org/workTranslation
     -->



  <!-- Used for json escape string -->
  <xsl:import href="common/index-utils.xsl"/>

  <!-- Define the root element of the resources
      and a catalogue id. -->
  <!--<xsl:param name="baseUrl"
             select="'https://data.geocatalogue.fr/id/'"/>
     <xsl:variable name="catalogueName"
             select="'/geocatalogue'"/>
  -->
  <xsl:param name="baseUrl"
             select="util:getSettingValue('nodeUrl')"/>
  <xsl:variable name="catalogueName"
                select="''"/>

  <!-- Schema.org document can't really contain
  translated text. So we can produce the JSON-LD
  in one of the language defined in the metadata record.

  Add the lang parameter to the formatter URL `?lang=fr`
  to force a specific language. If translation not available,
  the default record language is used.
  -->
  <xsl:param name="lang"
             select="''"/>

  <!-- <xsl:variable name="defaultLanguage"
                select="//mdb:MD_Metadata/mdb:defaultLocale/*/lan:language/*/@codeListValue"/> -->

  <!-- TODO: Convert language code eng > en_US ? -->


  <xsl:template name="getJsonLD"
                mode="getJsonLD" match="simpledc">
    {
    "@context": "http://schema.org/",
    "@type": "Dataset",
    <!-- TODO: Use the identifier property to attach any relevant Digital Object identifiers (DOIs). -->
    "@id": "<xsl:value-of select="concat($baseUrl, 'api/records/', dc:identifier)"/>",
    "includedInDataCatalog":[{"@type":"DataCatalog","url":"<xsl:value-of select="concat($baseUrl, 'search#', $catalogueName)"/>","name":"<xsl:value-of select="$catalogueName"/>"}],
    <!-- TODO: is the dataset language or the metadata language ? -->
    "inLanguage":"<xsl:value-of select="dc:language"/>", <!-- FIXME: Do we want to use $lang param -->
    <!-- TODO: availableLanguage -->
    "name": <xsl:value-of select="dc:title"/>,

    "dateCreated": [
    <xsl:for-each select="dct:created">
      "<xsl:value-of select="."/>"<xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>],
    "dateModified": [
    <xsl:for-each select="dct:modified">
      "<xsl:value-of select="."/>"<xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>],
    "datePublished": [
    <xsl:for-each select="dct:issued">
      "<xsl:value-of select="."/>"<xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>],
    "description": <xsl:value-of select="dc:description"/>,

    <!-- TODO: Add citation as defined in DOI landing pages -->
    <!-- TODO: Add identifier, DOI if available or URL or text -->
    <xsl:for-each select="dc:identifier">
      "identifier": "<xsl:value-of select="."/>",
    </xsl:for-each>

    <xsl:for-each select="owl:versionInfo|dcat:version"> <!-- NOTE: This branch probably might not ever be taken... -->
      "version": "<xsl:value-of select="."/>",
    </xsl:for-each>


    <!-- Build a flat list of all keywords even if grouped in thesaurus. -->
    "keywords":[
    <xsl:for-each select="dc:subject">
      "<xsl:value-of select="." />"
      <xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>
    ],


    <!--
    TODO: Dispatch in author, contributor, copyrightHolder, editor, funder,
    producer, provider, sponsor
    TODO: sourceOrganization
      <xsl:variable name="role" select="*/gmd:role/gmd:CI_RoleCode/@codeListValue" />
      <xsl:choose>
        <xsl:when test="$role='resourceProvider'">provider</xsl:when>
        <xsl:when test="$role='custodian'">provider</xsl:when>
        <xsl:when test="$role='owner'">copyrightHolder</xsl:when>
        <xsl:when test="$role='user'">user</xsl:when>
        <xsl:when test="$role='distributor'">publisher</xsl:when>
        <xsl:when test="$role='originator'">sourceOrganization</xsl:when>
        <xsl:when test="$role='pointOfContact'">provider</xsl:when>
        <xsl:when test="$role='principalInvestigator'">producer</xsl:when>
        <xsl:when test="$role='processor'">provider</xsl:when>
        <xsl:when test="$role='publisher'">publisher</xsl:when>
        <xsl:when test="$role='author'">author</xsl:when>
        <xsl:otherwise>provider</xsl:otherwise>
      </xsl:choose>

    -->
    "publisher": [<xsl:for-each select="dc:publisher">

          {
          "@type":"Organization",
          "name": "<xsl:value-of select="."/>"
          }
    </xsl:for-each>]

    "creator": [<xsl:for-each select="dc:creator">

          {
          "@type":"Person",
          "name": "<xsl:apply-templates select="."/>"
          }
    </xsl:for-each>]
    <!--
    The overall rating, based on a collection of reviews or ratings, of the item.
    "aggregateRating": TODO
    -->

    <!--
    A downloadable form of this dataset, at a specific location, in a specific format.

    See https://schema.org/DataDownload
    -->
    ,"distribution": [
    <xsl:for-each select="dc:references">
      {
      "@type":"DataDownload",
      "contentUrl": "<xsl:value-of select="." />",
      "encodingFormat": "WWW:LINK-1.0-http--link",
      "name": "Distribution Metadata"
      }
    </xsl:for-each>]

    <xsl:if test="count(dc:format) > 0">
      ,"encodingFormat": [
      <xsl:for-each select="dc:format">
        "<xsl:value-of select="."/>"
        <xsl:if test="position() != last()">,</xsl:if>
      </xsl:for-each>
      ]
    </xsl:if>


    ,"spatialCoverage": [
    <xsl:for-each select="dc:coverage|dct:spatial">
      {"@type":"Place",
      "description": [],
      "geo": [
        {"@type":"GeoShape",
        "box": "<xsl:value-of select="."/>"
        }
      ]
      }<xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>]

    ,"temporalCoverage": [
    <xsl:for-each select="dc:temporal">
      "<xsl:value-of select="."/>"
      <xsl:if test="position() != last()">,</xsl:if>
      <!-- TODO: handle
      "temporalCoverage" : "2013-12-19/.."
      "temporalCoverage" : "2008"
      -->
    </xsl:for-each>]


    <xsl:if test="dc:rights|dct:license">
      ,"license": [<xsl:for-each select="dc:rights">
          "<xsl:value-of select="."/>"
      <xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>]
    </xsl:if>
    <!-- TODO: When a dataset derives from or aggregates several originals, use the isBasedOn property. -->
    <!-- TODO: hasPart -->
    <!-- BC Addition - Citation string as requested by Ant-nz -->

	<!-- FIXME: Consult spreadsheet -->
    , "citation": "<xsl:for-each select="dc:relation|dct:isReferencedBy">

    <xsl:value-of select="."/>

    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:for-each>"

    }
  </xsl:template>
</xsl:stylesheet>
