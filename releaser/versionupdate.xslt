<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:my="http://maven.apache.org/POM/4.0.0">
<xsl:output encoding="UTF-8" method="xml" indent="yes"/>

<xsl:param name="expectedVersion" select="'2.11.0-SNAPSHOT'"/>
<xsl:param name="targetVersion" select="'2.11.0'"/>

    <xsl:template match="@*|node()">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>

    <xsl:template match="/my:project/my:parent/my:version">
      <xsl:if test=".=$expectedVersion">
        <xsl:copy><xsl:value-of select="$targetVersion"/></xsl:copy>
      </xsl:if>
      <xsl:if test=".!=$expectedVersion">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:template>

    <xsl:template match="/my:project/my:version">
      <xsl:if test=".=$expectedVersion">
        <xsl:copy><xsl:value-of select="$targetVersion"/></xsl:copy>
      </xsl:if>
      <xsl:if test=".!=$expectedVersion">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:template>

</xsl:stylesheet>
