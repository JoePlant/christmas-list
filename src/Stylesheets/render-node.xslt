<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dotml="http://www.martin-loetzsch.de/DOTML" >
	
	<xsl:output method="xml" indent="yes" />
	
	<xsl:variable name="record-color">#EEEEEE</xsl:variable>
	<xsl:variable name="border-color">#AAAAAA</xsl:variable>
	<xsl:variable name="background-color">#FFFFFF</xsl:variable>
	<xsl:variable name="material-color">#87D200</xsl:variable>
	
	<xsl:variable name="focus-color">#C4014B</xsl:variable>
	<xsl:variable name="focus-bgcolor">#EEEEEE</xsl:variable>
	<xsl:variable name="focus-text-color">#FFFFFF</xsl:variable>
	<xsl:variable name="other-color">#333333</xsl:variable>
	
	<xsl:variable name="material-other">#CCCCCC</xsl:variable>
	<xsl:variable name="workcenter-color">#2FB4E9</xsl:variable>
	<xsl:variable name="red-color">#FF0000</xsl:variable>
	
	<xsl:variable name='fontname'>Verdana</xsl:variable>
	<xsl:variable name='font-size-h1'>10.0</xsl:variable>
	<xsl:variable name='font-size-h2'>9.0</xsl:variable>
	<xsl:variable name='font-size-h3'>8.0</xsl:variable>
	
	<xsl:template match="/" >

		<dotml:graph file-name="christmas-list" label="Christmas List" rankdir="TB" fontname="{$fontname}" fontcolor="{$focus-color}" fontsize="{$font-size-h1}" labelloc='t' >			
			<xsl:apply-templates select='/graph/cluster'/>
			<xsl:apply-templates select='/graph/cluster' mode='link'/>
		</dotml:graph>
	</xsl:template>
		
	<xsl:template match='cluster'>
		<xsl:apply-templates select='node[@type="Adult"]'/>
		<xsl:apply-templates select='node[@type="Child"]'/>
		<xsl:apply-templates select='error[@msg]'/>
		
		<xsl:if test="count(node[@type='Adult'])>1">
			<xsl:variable name="a1" select="node[@type='Adult'][1]/@name"/>
			<xsl:variable name="a2" select="node[@type='Adult'][2]/@name"/>
			<!--
			<dotml:edge style='invis' from='{$a1}' to='{$a2}' />
			<dotml:edge style='invis' from='{$a2}' to='{$a1}' /> 
			-->
		</xsl:if>
    <xsl:for-each select="node[@type='Adult'][1]">
      <xsl:variable name="from" select="@name"/>
      <xsl:for-each select="../node[@type='Child']">
	  <!--
        <dotml:edge style='invis' from='{$from}' to='{@name}' />
	  -->
      </xsl:for-each>
    </xsl:for-each>
    

  </xsl:template>
	
	<xsl:template match='node'>
		<xsl:variable name='shape'>
			<xsl:choose>
				<xsl:when test="@type='Adult'">box</xsl:when>
				<xsl:otherwise>oval</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<dotml:node id='{@name}' style="solid" shape="{$shape}" label='{@name}' fillcolor='{$focus-bgcolor}' color="{$focus-color}" fontname="{$fontname}" fontcolor="{$focus-color}" fontsize="{$font-size-h2}"/>
	</xsl:template>
	
	<xsl:template match='error'>
		<dotml:node id='{@id}' style="solid" shape="box" label='{@msg}' fillcolor='white' color="red" fontcolor='red'/>
	</xsl:template>
	
	<xsl:template match='cluster' mode='link'>
		<xsl:for-each select='link'>
			<dotml:edge from="{@from}" to="{@to}" color='darkgreen' />
		</xsl:for-each>
		
		<xsl:for-each select='error'>
			<dotml:edge from="{@from}" to="{@id}" color='red' />
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
