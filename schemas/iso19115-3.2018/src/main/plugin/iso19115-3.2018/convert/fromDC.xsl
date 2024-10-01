<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:sr="http://www.w3.org/2005/sparql-results#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:spdx="http://spdx.org/rdf/terms#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:adms="http://www.w3.org/ns/adms#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcat="http://www.w3.org/ns/dcat#"
                xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:schema="http://schema.org/"
                xmlns:locn="http://www.w3.org/ns/locn#"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:mdcat="http://data.vlaanderen.be/ns/metadata-dcat#"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gn-fn-sparql="http://geonetwork-opensource.org/xsl/functions/sparql"
				xmlns:mds="http://standards.iso.org/iso/19115/-3/mds/2.0"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:import href="ISO19139/utility/create19115-3Namespaces.xsl"/>

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:param name="uuid" as="xs:string?"/>

  <xsl:template match="/">
  
      <mdb:MD_Metadata>
        <xsl:call-template name="add-iso19115-3.2018-namespaces"/>


        <xsl:variable name="uuid" select=".//dct:identifier"/>

        <mdb:metadataIdentifier>
          <mcc:MD_Identifier>
            <mcc:code>
              <gco:CharacterString>
                <xsl:value-of select="$uuid"/>
              </gco:CharacterString>
            </mcc:code>
          </mcc:MD_Identifier>
        </mdb:metadataIdentifier>

        <xsl:for-each select=".//(dct:language|dc:language)">
          <xsl:call-template name="build-language">
            <xsl:with-param name="element" select="'mdb:defaultLocale'"/>
            <xsl:with-param name="languageUri" select="."/>
          </xsl:call-template>
        </xsl:for-each>

        <mdb:metadataScope>
          <mdb:MD_MetadataScope>
            <mdb:resourceScope>
              <mcc:MD_ScopeCode codeList="" codeListValue="dc:type"/>
            </mdb:resourceScope>
          </mdb:MD_MetadataScope>
        </mdb:metadataScope>

        <mdb:contact>
          <cit:CI_Responsibility>
            <cit:role>
              <cit:CI_RoleCode codeList="codeListLocation#CI_RoleCode" codeListValue="pointOfContact">pointOfContact</cit:CI_RoleCode>
            </cit:role>
            <cit:party>
              <cit:CI_Organisation>
                <cit:name>
                  <gco:CharacterString/>
                </cit:name>
                <cit:contactInfo>
                  <cit:CI_Contact>
                    <cit:address>
                      <cit:CI_Address>
                        <cit:electronicMailAddress>
                          <gco:CharacterString/>
                        </cit:electronicMailAddress>
                      </cit:CI_Address>
                    </cit:address>
                  </cit:CI_Contact>
                </cit:contactInfo>
                <cit:individual>
                  <cit:CI_Individual>
                    <cit:name>
                      <gco:CharacterString/>
                    </cit:name>
                    <cit:positionName>
                      <gco:CharacterString/>
                    </cit:positionName>
                  </cit:CI_Individual>
                </cit:individual>
              </cit:CI_Organisation>
            </cit:party>
          </cit:CI_Responsibility>
        </mdb:contact>

        <xsl:for-each select=".//dct:created">
          <xsl:call-template name="build-date">
            <xsl:with-param name="element" select="'mdb:dateInfo'" />
            <xsl:with-param name="date" select="." />
            <xsl:with-param name="dateType" select="'creation'" />
          </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select=".//dct:modified">
          <xsl:call-template name="build-date">
            <xsl:with-param name="element" select="'mdb:dateInfo'" />
            <xsl:with-param name="date" select="." />
            <xsl:with-param name="dateType" select="'revision'" />
          </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select=".//dct:issued">
          <xsl:call-template name="build-date">
            <xsl:with-param name="element" select="'mdb:dateInfo'" />
            <xsl:with-param name="date" select="." />
            <xsl:with-param name="dateType" select="'publication'" />
          </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select=".//dct:dateSubmitted">
          <xsl:call-template name="build-date">
            <xsl:with-param name="element" select="'mdb:dateInfo'" />
            <xsl:with-param name="date" select="." />
            <xsl:with-param name="dateType" select="'published'" />
          </xsl:call-template>
        </xsl:for-each>



        <mdb:metadataStandard>
          <cit:CI_Citation>
            <cit:title>
              <gco:CharacterString>ISO 19115-3</gco:CharacterString>
            </cit:title>
          </cit:CI_Citation>
        </mdb:metadataStandard>


        <mdb:metadataLinkage>
          <cit:CI_OnlineResource>
            <cit:linkage>
              <!--  Not supplied by Dublin Core -->
              <gco:CharacterString></gco:CharacterString>
            </cit:linkage>
            <cit:function>
              <cit:CI_OnLineFunctionCode
                codeList="http://standards.iso.org/iso/19139/resources/codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                codeListValue="completeMetadata"/>
            </cit:function>
          </cit:CI_OnlineResource>
        </mdb:metadataLinkage>

          <mdb:identificationInfo>
            <xsl:choose>
              <xsl:when test=".//dc:type = 'service'"></xsl:when>
              <xsl:otherwise>
                <mri:MD_DataIdentification>
                  <mri:citation>
                    <cit:CI_Citation>
                      <cit:title>
                        <gco:CharacterString>
                          <xsl:value-of select=".//(dct:title|dc:title)"/>
                        </gco:CharacterString>
                      </cit:title>

			          <xsl:for-each select=".//dct:created">
			            <xsl:call-template name="build-date">
			              <xsl:with-param name="element" select="'mdb:dateInfo'" />
                          <xsl:with-param name="date" select="." />
                          <xsl:with-param name="dateType" select="'creation'" />
                        </xsl:call-template>
                      </xsl:for-each>
                      <xsl:for-each select=".//dct:modified">
                        <xsl:call-template name="build-date">
                          <xsl:with-param name="element" select="'mdb:dateInfo'" />
			              <xsl:with-param name="date" select="." />
			              <xsl:with-param name="dateType" select="'revision'" />
			            </xsl:call-template>
			          </xsl:for-each>
			          <xsl:for-each select=".//dct:issued">
			            <xsl:call-template name="build-date">
			              <xsl:with-param name="element" select="'mdb:dateInfo'" />
			              <xsl:with-param name="date" select="." />
			              <xsl:with-param name="dateType" select="'publication'" />
			            </xsl:call-template>
			          </xsl:for-each>
			          <xsl:for-each select=".//dct:dateSubmitted">
			            <xsl:call-template name="build-date">
			              <xsl:with-param name="element" select="'mdb:dateInfo'" />
			              <xsl:with-param name="date" select="." />
			              <xsl:with-param name="dateType" select="'published'" />
			            </xsl:call-template>
			          </xsl:for-each>


                      <xsl:variable name="identifier" select=".//(dct:identifier|dc:identifier)"/>
                      <xsl:if test="$identifier != ''">
                        <cit:identifier>
                          <mcc:MD_Identifier>
                            <mcc:code>
                              <gco:CharacterString>
                                <xsl:value-of select="$identifier"/>
                              </gco:CharacterString>
                            </mcc:code>
                          </mcc:MD_Identifier>
                        </cit:identifier>
                      </xsl:if>
                    </cit:CI_Citation>
                    <xsl:for-each select=".//dc:creator">
                      <cit:citedResponsibleParty>
                        <cit:CI_Responsibility>
                          <cit:role>
                            <cit:CI_RoleCode codeList="https://schemas.isotc211.org/Resources/codelists.xml#ISO19115-1.1.cit.CI_RoleCode" codeListValue="originator"/>
                          </cit:role>
                          <cit:party>
                            <!-- This mapping to a CI_Organization name, if the name is an individual it must be corrected post-important as it can't be determined programmatically. -->
                            <cit:CI_Organisation>
                              <cit:name>
                                <gco:CharacterString><xsl:value-of select="." /></gco:CharacterString>
                              </cit:name>
                            </cit:CI_Organisation>
                          </cit:party>
                        </cit:CI_Responsibility>
                      </cit:citedResponsibleParty>
                    </xsl:for-each>
                    <xsl:for-each select=".//dc:publisher">
                      <cit:citedResponsibleParty>
                        <cit:CI_Responsibility>
                          <cit:role>
                            <cit:CI_RoleCode codeList="https://schemas.isotc211.org/Resources/codelists.xml#ISO19115-1.1.cit.CI_RoleCode" codeListValue="publisher"/>
                          </cit:role>
                          <cit:party>
                            <!-- This mapping to a CI_Organization name, if the name is an individual it must be corrected post-important as it can't be determined programmatically. -->
                            <cit:CI_Organisation>
                              <cit:name>
                                <gco:CharacterString><xsl:value-of select="." /></gco:CharacterString>
                              </cit:name>
                            </cit:CI_Organisation>
                          </cit:party>
                        </cit:CI_Responsibility>
                      </cit:citedResponsibleParty>
                    </xsl:for-each>
                    
                  </mri:citation>
                  <mri:abstract>
                    <gco:CharacterString>
                      <xsl:value-of select=".//(dct:description|dc:description)"/>
                    </gco:CharacterString>
                  </mri:abstract>

                  <!--
                  <dcat:spatialResolutionInMeters>25000</dcat:spatialResolutionInMeters>
                  -->

                  <!--
                  <mri:topicCategory>
                    <mri:MD_TopicCategoryCode>inlandWaters</mri:MD_TopicCategoryCode>
                  </mri:topicCategory>
                  -->

                  <!--
                    <dct:spatial>
                        <dct:Location>
                            <locn:geometry>{"coordinates":[[[6.755991,45.788744],[10.541824,45.788744],[10.541824,47.517566],[6.755991,47.517566],[6.755991,45.788744]]],"type":"Polygon"}</locn:geometry>
                        </dct:Location>
                    </dct:spatial>
                   -->
                  <!--<xsl:for-each select="dct:spatial[. != '']">
                    <xsl:for-each select="locn:geometry">
                      <xsl:variable name="coordByPipe"
                                    select="util:geoJsonGeomToBbox(string(.))"/>
                      <xsl:if test="$coordByPipe != ''">
                        <xsl:variable name="coords"
                                      select="tokenize($coordByPipe, '\|')"/>
                        <mri:extent>
                          <gex:EX_Extent>
                            <gex:geographicElement>
                              <gex:EX_GeographicBoundingBox>
                                <gex:westBoundLongitude>
                                  <gco:Decimal><xsl:value-of select="$coords[1]"/></gco:Decimal>
                                </gex:westBoundLongitude>
                                <gex:eastBoundLongitude>
                                  <gco:Decimal><xsl:value-of select="$coords[3]"/></gco:Decimal>
                                </gex:eastBoundLongitude>
                                <gex:southBoundLatitude>
                                  <gco:Decimal><xsl:value-of select="$coords[2]"/></gco:Decimal>
                                </gex:southBoundLatitude>
                                <gex:northBoundLatitude>
                                  <gco:Decimal><xsl:value-of select="$coords[4]"/></gco:Decimal>
                                </gex:northBoundLatitude>
                              </gex:EX_GeographicBoundingBox>
                            </gex:geographicElement>
                          </gex:EX_Extent>
                        </mri:extent>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:for-each>-->
                  <xsl:for-each select=".//dc:coverage[. != '']">
                  	<mri:extent>
                  	  <gex:EX_Extent>
                  	    <gex:geographicElement>
                  	      <gex:EX_GeographicBoundingBox>
                  	        <xsl:for-each select="tokenize(., ',|\..*')">
                  	          <xsl:variable name="component" select="normalize-space(.)" />
                  	          <xsl:choose>
                  	            <xsl:when test="starts-with($component, 'North')">
                  	              <gex:northBoundLatitude>
                  	                <gco:Decimal><xsl:value-of select="normalize-space(substring-after($component, 'North'))" /></gco:Decimal>
                  	              </gex:northBoundLatitude>
                  	            </xsl:when>
                  	            <xsl:when test="starts-with($component, 'South')">
                  	              <gex:southBoundLatitude>
                  	                <gco:Decimal><xsl:value-of select="normalize-space(substring-after($component, 'South'))" /></gco:Decimal>
                  	              </gex:southBoundLatitude>
                  	            </xsl:when>
                  	            <xsl:when test="starts-with($component, 'East')">
                  	              <gex:eastBoundLongitude>
                  	                <gco:Decimal><xsl:value-of select="normalize-space(substring-after($component, 'East'))" /></gco:Decimal>
                  	              </gex:eastBoundLongitude>
                  	            </xsl:when>
                  	            <xsl:when test="starts-with($component, 'West')">
                  	              <gex:westBoundLongitude>
                  	                <gco:Decimal><xsl:value-of select="normalize-space(substring-after($component, 'West'))" /></gco:Decimal>
                  	              </gex:westBoundLongitude>
                  	            </xsl:when>
                  	          </xsl:choose>
                  	        </xsl:for-each>
                  	      </gex:EX_GeographicBoundingBox>
                  	    </gex:geographicElement>
                  	  </gex:EX_Extent>
                  	</mri:extent>
                  </xsl:for-each>

                  <xsl:for-each select=".//dct:accrualPeriodicity">

                    <xsl:variable name="euPrefix"
                                  select="'http://publications.europa.eu/resource/authority/frequency/'"/>
                    <xsl:variable name="frequency"
                                  select="if(starts-with(., $euPrefix))
                                          then substring-after(., $euPrefix)
                                          else ."/>
                    <mri:resourceMaintenance>
                      <mmi:MD_MaintenanceInformation>
                        <mmi:maintenanceAndUpdateFrequency>
                          <mmi:MD_MaintenanceFrequencyCode codeListValue="{$frequency}"
                                                           codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_MaintenanceFrequencyCode"/>
                        </mmi:maintenanceAndUpdateFrequency>
                      </mmi:MD_MaintenanceInformation>
                    </mri:resourceMaintenance>
                  </xsl:for-each>

                  <mri:descriptiveKeywords>
                    <xsl:for-each select=".//dc:subject">
                      <mri:keyword>
                        <gco:CharacterString><xsl:value-of select="." /></gco:CharacterString>
                      </mri:keyword>
                    </xsl:for-each>
                  </mri:descriptiveKeywords>

                  <xsl:for-each select=".//dc:rights">
                    <mri:resourceConstraints>
                      <mco:MD_LegalConstraints>
                        <mco:useConstraints>
                          <mco:MD_RestrictionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"
                          						  codeListValue="otherRestrictions" />
                        </mco:useConstraints>
                        <mco:otherConstraints>
                          <gco:CharacterString><xsl:value-of select="." /></gco:CharacterString>
                        </mco:otherConstraints>
                      </mco:MD_LegalConstraints>
                    </mri:resourceConstraints>
                  </xsl:for-each>


                  <xsl:for-each select=".//dct:language">
                    <xsl:call-template name="build-language">
                      <xsl:with-param name="element" select="'mri:defaultLocale'"/> <!-- FIXME: This appropriate? -->
                      <xsl:with-param name="languageUri" select="."/>
                    </xsl:call-template>
                  </xsl:for-each>

                </mri:MD_DataIdentification>
              </xsl:otherwise>
            </xsl:choose>
          </mdb:identificationInfo>


          <xsl:variable name="lineage"
                        select=".//dct:provenance"/>

          <xsl:if test="$lineage != ''">
            <mdb:resourceLineage>
              <mrl:LI_Lineage>
                <mrl:statement xsi:type="lan:PT_FreeText_PropertyType">
                  <gco:CharacterString><xsl:value-of select="$lineage"/> </gco:CharacterString>
                </mrl:statement>
                <mrl:scope>
                  <mcc:MD_Scope>
                    <mcc:level>
                      <mcc:MD_ScopeCode codeList="https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_ScopeCode"
                                        codeListValue="dataset">dataset</mcc:MD_ScopeCode>
                    </mcc:level>
                  </mcc:MD_Scope>
                </mrl:scope>
              </mrl:LI_Lineage>
            </mdb:resourceLineage>
          </xsl:if>
          
          <mds:distributionInfo>
            <mrd:MD_Distribution>
              <mrd:transferOptions>
                <xsl:for-each select=".//dc:references">
                  <mrd:MD_DigitalTransferOptions>
                    <mrd:onLine>
                      <cit:CI_OnlineResource>
                        <cit:linkage>
                          <gco:CharacterString><xsl:value-of select="." /></gco:CharacterString>
                        </cit:linkage>
                      </cit:CI_OnlineResource>
                    </mrd:onLine>
                  </mrd:MD_DigitalTransferOptions>
                </xsl:for-each>
              </mrd:transferOptions>
              <!-- What's "references"? -->
              <!--<mrd:distributionFormat>
                <xsl:for-each select="references"> 
                  <mrd:MD_Format>
                    <mrd:formatSpecificationCitation>
                      <cit:CI_Citation>
                        <cit:title>
                          <gco:CharacterString><xsl:value-of select="." /></gco:CharacterString>
                        </cit:title>
                      </cit:CI_Citation>
                    </mrd:formatSpecificationCitation>
                  </mrd:MD_Format>
                </xsl:for-each>
              </mrd:distributionFormat>-->
              <xsl:for-each select=".//dc:format">
                <mrd:distributionFormat>
                  <mrd:MD_Format>
                    <mrd:name>
                      <gco:CharacterString><xsl:value-of select="." /></gco:CharacterString>
                    </mrd:name>
                  </mrd:MD_Format>
                </mrd:distributionFormat>
              </xsl:for-each>
            </mrd:MD_Distribution>
          </mds:distributionInfo>
      </mdb:MD_Metadata>
  </xsl:template>


  <xsl:template name="build-date">
    <xsl:param name="element" as="xs:string"/>
    <xsl:param name="date" as="xs:string"/>
    <xsl:param name="dateType" as="xs:string"/>

    <xsl:element name="{$element}">
      <cit:CI_Date>
        <cit:date>
          <gco:DateTime><xsl:value-of select="$date"/></gco:DateTime>
        </cit:date>
        <cit:dateType>
          <cit:CI_DateTypeCode codeList="https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_DateTypeCode"
                               codeListValue="{$dateType}"></cit:CI_DateTypeCode>
        </cit:dateType>
      </cit:CI_Date>
    </xsl:element>
  </xsl:template>


  <xsl:template name="build-language">
    <xsl:param name="element" as="xs:string"/>
    <xsl:param name="languageUri" as="xs:string"/>

    <xsl:variable name="euPrefix"
                  select="'(http://publications\.europa\.eu/resource/authority/language/|http://lexvo\.org/id/iso639-3/)([A-Za-z]+)'"/>

    <xsl:element name="{$element}">
      <lan:PT_Locale>
        <lan:language>
          <lan:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="{if (matches($languageUri, $euPrefix))
                                then lower-case(replace($languageUri, $euPrefix, '$2'))
                                else $languageUri}"/>
        </lan:language>
        <lan:characterEncoding>
          <lan:MD_CharacterSetCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_CharacterSetCode"
                                   codeListValue="utf8"/>
        </lan:characterEncoding>
      </lan:PT_Locale>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
