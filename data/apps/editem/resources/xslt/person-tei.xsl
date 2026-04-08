<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cmdp="http://www.clarin.eu/cmd/1/profiles/clarin.eu:cr1:p_1772521921675"
    exclude-result-prefixes="xs math cmdp"
    version="3.0">
    
    <xsl:param name="q" select="()"/>
    
    <xsl:param name="cwd" select="'file:/Users/menzowi/Documents/GitHub/hi-editem-editor'"/>
    <xsl:param name="app" select="'editem'"/>
    <xsl:param name="prof" select="'clarin.eu:cr1:p_1772521921675'"/>

    <xsl:variable name="recs" select="concat($cwd, '/data/apps/', $app, '/profiles/', $prof, '/records')"/>
    
    <xsl:template match="text()"/>
    
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="normalize-space($q)!=''">
                <tei q="{$q}">
                    <xsl:for-each select="collection(concat($recs,'?match=record-\d+\.xml&amp;on-error=warning'))">
                        <xsl:variable name="rec" select="."/>
                        <xsl:message expand-text="yes">DBG:rec[{base-uri($rec)}]</xsl:message>
                        <xsl:if test="exists($rec//cmdp:project[contains(lower-case(.),lower-case($q))])">
                            <xsl:apply-templates select="$rec//cmdp:Person"/>
                        </xsl:if>
                    </xsl:for-each>
                </tei>
            </xsl:when>
            <xsl:when test="null">
                <tei>
                    <xsl:for-each select="collection(concat($recs,'?match=record-\d+\.xml&amp;on-error=warning'))">
                        <xsl:variable name="rec" select="."/>
                        <xsl:apply-templates select="$rec//cmdp:Person"/>
                    </xsl:for-each>
                </tei>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="cmdp:Person">
        <person xml:id="{cmdp:id}">
            <xsl:apply-templates select="(cmdp:gender,cmdp:corresp)"/>
            <xsl:apply-templates select="* except (cmdp:id, cmdp:project,cmdp:gender,cmdp:corresp)"/>
        </person>
    </xsl:template>
    
    <xsl:template match="cmdp:gender | cmdp:corresp | cmdp:full | cmdp:when | cmdp:type" priority="10">
        <xsl:attribute name="{local-name()}" select="."/>
    </xsl:template>
    
    <xsl:template match="cmdp:id"/>
    <xsl:template match="cmdp:project"/>
    
    <xsl:template match="cmdp:Person//*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
  
    <xsl:template match="cmdp:Person//text()">
        <xsl:copy/>
    </xsl:template>
</xsl:stylesheet>