<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cmdp="http://www.clarin.eu/cmd/1/profiles/clarin.eu:cr1:p_1772521921675"
    exclude-result-prefixes="xs math cmdp"
    version="3.0">
    
    <xsl:template match="text()"/>
    
    <xsl:template match="cmdp:Person">
        <person xml:id="{cmdp:id}">
            <xsl:apply-templates select="(cmdp:gender,cmdp:corresp)"/>
            <xsl:apply-templates select="* except (cmdp:id,cmdp:gender,cmdp:corresp)"/>
        </person>
    </xsl:template>
    
    <xsl:template match="cmdp:gender | cmdp:corresp | cmdp:full | cmdp:when | cmdp:type" priority="10">
        <xsl:attribute name="{local-name()}" select="."/>
    </xsl:template>
    
    <xsl:template match="cmdp:id"/>
    
    <xsl:template match="cmdp:Person//*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
  
    <xsl:template match="cmdp:Person//text()">
        <xsl:copy/>
    </xsl:template>
</xsl:stylesheet>