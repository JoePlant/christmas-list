<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

	<xsl:output method="xml" indent="yes" />
	<xsl:param name="links-file">..\links.xml</xsl:param>
	
	<xsl:key name='people-by-name' match='Family/*' use='@name'/>
	
	<xsl:template match="/" >
		<xsl:comment>
People:
	- <xsl:value-of select='count(//Family)'/> Families
	- <xsl:value-of select='count(//Adult)'/> adults
	- <xsl:value-of select='count(//Child)'/> children
</xsl:comment>
		<xsl:comment>
</xsl:comment>
		<xsl:apply-templates select='People'/>
	</xsl:template>

	<xsl:template match='People'>
		<xsl:element name='graph'>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match='Family'>
		<xsl:element name='cluster'>
			<xsl:apply-templates select="@*"/>
			<xsl:for-each select='Adult|Child'>
				<xsl:element name='node'>
					<xsl:apply-templates select="@*"/>
					<xsl:attribute name='type'><xsl:value-of select='name()'/></xsl:attribute>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select='Adult|Child'>
				<xsl:variable name='from' select='@name'/>
	
				<xsl:for-each select='BuysFor[@name] | BuysFor/*[@name]'>
					<xsl:variable name='lookup' select="key('people-by-name', @name)"/>
					<xsl:variable name='error'>
						<xsl:choose>
							<xsl:when test='count($lookup) = 0'>
								<xsl:value-of select="concat('', @name, ' not found.')"/>
							</xsl:when>
							<xsl:when test='count($lookup) = 1'/>
							<xsl:otherwise>
								<xsl:value-of select="concat(@name, ' found ', count($lookup), ' times')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test='string-length($error) = 0'>
							<xsl:element name='link'>	
								<xsl:attribute name='from'><xsl:value-of select='$from'/></xsl:attribute>
								<xsl:attribute name='to'><xsl:value-of select='@name'/></xsl:attribute>
								<xsl:attribute name='type'><xsl:value-of select='name()'/></xsl:attribute>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:comment><xsl:value-of select='$error'/></xsl:comment>
							<error id='{generate-id()}' from='{$from}' msg='{$error}'/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
	
</xsl:stylesheet>

