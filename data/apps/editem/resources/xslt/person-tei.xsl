<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cmdp="http://www.clarin.eu/cmd/1/profiles/clarin.eu:cr1:p_1772521921675"
    xmlns:tei="ttp://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math cmdp"
    version="3.0">
    
    <xsl:param name="q" select="()"/>
    
    <xsl:param name="cwd" select="'file:/Users/menzowi/Documents/GitHub/hi-editem-editor'"/>
    <xsl:param name="app" select="'editem'"/>
    <xsl:param name="prof" select="'clarin.eu:cr1:p_1772521921675'"/>

    <xsl:variable name="recs" select="concat($cwd, '/data/apps/', $app, '/profiles/', $prof, '/records')"/>
    
    <xsl:template match="text()"/>
    
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-model">href="https://xmlschema.huygens.knaw.nl/editem-biolist.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
        <tei:TEI>
            <tei:teiHeader>
                <tei:fileDesc>
                    <tei:titleStmt>
                        <tei:title>
                            <xsl:choose>
                                <xsl:when test="normalize-space($q)!=''">
                                    <xsl:value-of select="concat('project[',$q,']')"/>
                                </xsl:when>
                                <xsl:when test="null">
                                    <xsl:value-of select="'all persons'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('person[',//cmdp:Person/cmdp:id,']')"/>                                    
                                </xsl:otherwise>
                            </xsl:choose>
                        </tei:title>
                    </tei:titleStmt>
                    <!--<tei:publicationStmt></tei:publicationStmt>-->
                    <tei:sourceDesc>
                        <tei:listPerson>
                            <xsl:choose>
                                <xsl:when test="normalize-space($q)!=''">
                                    <xsl:for-each select="collection(concat($recs,'?match=record-\d+\.xml&amp;on-error=warning'))">
                                        <xsl:variable name="rec" select="."/>
                                        <xsl:message expand-text="yes">DBG:rec[{base-uri($rec)}]</xsl:message>
                                        <xsl:if test="exists($rec//cmdp:project[contains(lower-case(.),lower-case($q))])">
                                            <xsl:apply-templates select="$rec//cmdp:Person"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="null">
                                    <xsl:for-each select="collection(concat($recs,'?match=record-\d+\.xml&amp;on-error=warning'))">
                                        <xsl:variable name="rec" select="."/>
                                        <xsl:apply-templates select="$rec//cmdp:Person"/>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tei:listPerson>
                    </tei:sourceDesc>
                </tei:fileDesc>
            </tei:teiHeader>
        </tei:TEI>
    </xsl:template>
    
    <xsl:template match="cmdp:Person">
        <tei:person xml:id="{cmdp:id}">
            <xsl:apply-templates select="(cmdp:gender,cmdp:corresp)"/>
            <xsl:apply-templates select="* except (cmdp:id, cmdp:project,cmdp:gender,cmdp:corresp)"/>
        </tei:person>
    </xsl:template>
    
    <xsl:template match="cmdp:Person/(cmdp:gender | cmdp:corresp | cmdp:full | cmdp:when | cmdp:type)" priority="10">
        <xsl:attribute name="tei:{local-name()}" select="."/>
    </xsl:template>
    
    <xsl:template match="cmdp:id"/>
    <xsl:template match="cmdp:project"/>
    
    <xsl:template match="cmdp:Person//*">
        <xsl:element name="tei:{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
  
    <xsl:template match="cmdp:Person//text()">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="cmdp:note" priority="10">
        <tei:note type="{(../cmdp:type,'bibliography')[1]}">
            <xsl:copy-of select="@xml:lang[normalize-space(.)!='']"/>
            <xsl:value-of select="."/>
        </tei:note>
    </xsl:template>
    
    <xsl:template match="cmdp:Surname" priority="10">
        <tei:surname>
            <xsl:if test="normalize-space(cmdp:type)!=''">
                <xsl:attribute name="type" select="normalize-space(cmdp:type)"/>
            </xsl:if>
            <xsl:value-of select="cmdp:surname"/>
        </tei:surname>
    </xsl:template>
</xsl:stylesheet>