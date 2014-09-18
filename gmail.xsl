<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:param name="search" select="'ted@yingted.com'"/>
    <xsl:param name="replace" select="'yingted@gmail.com'"/>

    <xsl:template match="@*|*|comment()|processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@xlink:href">
        <xsl:attribute name="xlink:href">
            <xsl:value-of select="replace(., $search, $replace)"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="replace(., $search, $replace)"/>
    </xsl:template>

</xsl:stylesheet>
