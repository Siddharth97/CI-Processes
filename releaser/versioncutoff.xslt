<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:my="http://maven.apache.org/POM/4.0.0">
<xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <xsl:template match="@*|node()">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>

    <xsl:template match="/my:project/my:parent/my:version/text()[.='2.10.0-SNAPSHOT']">2.11.0-SNAPSHOT</xsl:template>
    <xsl:template match="/my:project/my:version/text()[.='2.10.0-SNAPSHOT']">2.11.0-SNAPSHOT</xsl:template>

</xsl:stylesheet>
