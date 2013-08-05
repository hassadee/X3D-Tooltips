<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:saxon="http://icl.com/saxon"
	saxon:trace="true"
	extension-element-prefixes="saxon">
  <xsl:param name="tooltipLanguage"/>
  <xsl:param name="version"><xsl:text>3.1</xsl:text></xsl:param>

<!--
  <head>
   <meta name="filename"    content="X3dToolTipConversions.xslt" />
   <meta name="author"      content="Don Brutzman" />
   <meta name="created"     content="15 April 2002" />
   <meta name="revised"     content="6 May 2006" />
   <meta name="description" content="XSL stylesheet to build the X3D Tooltips (originally used for SIGGRAPH Online pages).  Additional HTML improvements by Juan Gril and Jeff Weekley." />
   <meta name="url"         content="http://www.web3d.org/x3d/content/X3dToolTipConversions.xslt" />
  </head>

Recommended tools:
-  SAXON XML Toolkit (and Instant Saxon) from Michael Kay of ICL, http://saxon.sourceforge.net
   Especially necessary since this stylesheet uses saxon-specific extensions for file handling
-  XML Spy can be configured to use latest Saxon.  See README.txt in this directory.

Invocation:
-  cd   C:\www.web3d.org\x3d\content
   make tooltips
   (or)
   saxon -t -o X3dToolTips.html 	x3d-3.1.profile.xml X3dTooltipConversions.xslt

-->
	<xsl:strip-space elements="*"/>
	<xsl:output method="html" encoding="utf-8" media-type="text/html" indent="yes"/>
	
	<xsl:variable name="x3dSpecificationUrlBase">
                <!-- v3.3 includes bookmarks for each node in Node Index clause -->
		<xsl:text>http://www.web3d.org/files/specifications/19775-1/V3.3/</xsl:text>
                <!-- prior specification versions not used since less authoritative and (for 3.1) only include changes -->
		<!-- <xsl:text>http://www.web3d.org/files/specifications/19775-1/V3.2/</xsl:text> -->
	</xsl:variable>

        <!-- $schemaDocumentationUrl and $doctypeDocumentationUrl moved here by Hyokwang Lee -->
        <!-- http://www.web3d.org/specifications/X3dSchemaDocumentation3.3/x3d-3.3_Layer.html -->
        <xsl:variable name="schemaDocumentationUrl">
            <xsl:text>http://www.web3d.org/specifications/X3dSchemaDocumentation</xsl:text>
            <xsl:value-of select="$version"/>
            <xsl:text>/x3d-</xsl:text>
            <xsl:value-of select="$version"/>
            <xsl:text>.html</xsl:text>
        </xsl:variable>

        <!-- http://www.web3d.org/specifications/X3dDoctypeDocumentation3.3.html#AudioClip -->
        <xsl:variable name="doctypeDocumentationUrl">
            <xsl:text>http://www.web3d.org/specifications/X3dDoctypeDocumentation</xsl:text>
            <xsl:value-of select="$version"/>
            <xsl:text>.html</xsl:text>
        </xsl:variable>        
        
	<xsl:variable name="x3dSpecificationTop">
		<xsl:text>Part01/Architecture.html</xsl:text>
	</xsl:variable>
	<xsl:variable name="x3dSpecificationNodeIndex">
		<xsl:text>Part01/versionContent.html</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="pageName">
		<xsl:text>X3dTooltips</xsl:text>
		<xsl:if test="($tooltipLanguage != 'English')">
			<xsl:value-of select="$tooltipLanguage"/>
		</xsl:if>
		<xsl:text>.html</xsl:text>
	</xsl:variable>

	<xsl:variable name="todaysDate">
		<xsl:value-of select="fn:day-from-date(current-date())"/>
		<xsl:text> </xsl:text>
                <!-- adapted from http://www.xsltfunctions.com/xsl/functx_month-name-en.html -->
                <xsl:sequence select="
   ('January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December')
   [fn:month-from-date(current-date())]"/>
	   <!-- <xsl:value-of select="fn:month-from-date(current-date())"/> -->
		<xsl:text> </xsl:text>
		<xsl:value-of select="fn:year-from-date(current-date())"/>
	</xsl:variable>
	
	<!-- ****** root:  start of file ****************************************************** -->
	<xsl:template match="/">
		<xsl:message>
			<xsl:text>Processing X3D ToolTips</xsl:text>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$version"/>
			<xsl:if test="$tooltipLanguage">
				<xsl:text> in </xsl:text>
				<xsl:value-of select="$tooltipLanguage"/>
			</xsl:if>
			<xsl:text> ...</xsl:text>
		</xsl:message>
<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

]]></xsl:text>
		<!-- first pass through entire tooltip file generates the output HTML files. -->
		<xsl:apply-templates/>
		<xsl:message>... X3D ToolTip help-page generation complete.</xsl:message>
		<!-- perform other versions and schema next -->

	</xsl:template>

	<!-- ****** DTDProfile: topmost element****************************************************** -->
	<xsl:template match="DTDProfile">
                 <xsl:variable name="langValue">
                     <xsl:choose>
                            <!-- TODO m17 add here for Chinese-->
                            <xsl:when test="$tooltipLanguage='Chinese'">
                                    <xsl:text>zh</xsl:text>
                            </xsl:when>								
                            <xsl:when test="$tooltipLanguage='French'">
                                    <xsl:text>fr</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='German'">
                                    <xsl:text>de</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='Italian'">
                                    <xsl:text>it</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='Korean'">
                                    <xsl:text>kr</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='Portuguese'">
                                    <xsl:text>pt</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='Spanish'">
                                    <xsl:text>es</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='Thai'">
                                    <xsl:text>th</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='English'">
                                    <xsl:text>en</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage">
                                    <xsl:value-of select="$tooltipLanguage"/>
                            </xsl:when>
                    </xsl:choose>
                </xsl:variable>

		<html lang="{$langValue}">
                    
			<head>
				<title>
					<xsl:text> X3D Tooltips </xsl:text>
					<xsl:text> </xsl:text>
							<xsl:choose>								
								<xsl:when test="$tooltipLanguage='Chinese'">
				              				<!-- TODO m17 add here for Chinese-->	
									<xsl:text> 中文版 </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='French'">
									<xsl:text> en Fran&#231;ais </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='German'">
									<xsl:text> auf Deutsch </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Italian'">
									<xsl:text> in Italiano </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Korean'">
									<xsl:text> 한국어 </xsl:text> <!-- Hyokwang Lee -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Portuguese'">
									<xsl:text> em Portugu&#234;s </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Spanish'">
									<xsl:text> en Español </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Thai'">
									<xsl:text> in Thai </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage">
									<xsl:text> in </xsl:text>
									<xsl:value-of select="$tooltipLanguage"/>
								</xsl:when>
							</xsl:choose>
					<xsl:text> version </xsl:text>
                                        <xsl:value-of select="$version"/>
				</title>
				<link rel="shortcut icon" href="icons/X3DtextIcon16.png" title="X3D" />
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
			</head>
			<!-- #000080 = navy -->
			<!--  marginheight="10" marginwidth="10" topmargin="10" leftmargin="0" -->
			<body bgcolor="#99cccc" link="navy" vlink="#447777" alink="#447777" style="margin: 10px">

					<h1 align="center">
						<xsl:element name="a">
							<xsl:attribute name="name">
								<xsl:text>top</xsl:text>
							</xsl:attribute>
							<xsl:text>&#10;</xsl:text>
							<xsl:text>Extensible&#160;3D&#160;(X3D) </xsl:text>
                                                        <xsl:value-of select="$version"/>
							<xsl:text> Tooltips</xsl:text>
							<xsl:choose>
								<!-- TODO m17 add here for Chinese-->
								<xsl:when test="$tooltipLanguage='Chinese'">
									<xsl:text> 中文版 </xsl:text>
								</xsl:when>								
								<xsl:when test="$tooltipLanguage='French'">
									<xsl:text> en&#160;Fran&#231;ais </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='German'">
									<xsl:text> auf Deutsch </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Italian'">
									<xsl:text> in Italiano </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Korean'">
									<xsl:text> 한국어 </xsl:text> <!-- Hyokwang Lee -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Portuguese'">
									<xsl:text> Em&#160;Portugu&#234;s </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Spanish'">
									<xsl:text> en&#160;Español </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Thai'">
									<xsl:text> in Thai </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='English'">
									<!-- no output -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage">
									<xsl:text> in </xsl:text>
									<xsl:value-of select="$tooltipLanguage"/>
								</xsl:when>
							</xsl:choose>
						</xsl:element>
					</h1>
					<xsl:text>&#10;</xsl:text>

					<!-- introduction paragraph -->
					<table width="85%" summary="" align="center" border="0" cellspacing="0" cellpadding="6">
						<tr>
							<td align='center'>
	
							<!-- translations go here -->
							<xsl:choose>
								<!-- TODO m17 add here for Chinese-->
								<xsl:when test="$tooltipLanguage='Chinese'">
									<xsl:text>此工具提示提供了每个X3D节点(元素)和域(属性)的描述和创作技巧，也为 
									</xsl:text>
										<a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit 创作工具</a>
									<xsl:text> 和 </xsl:text>

                                                                        <!-- TODO
									<xsl:text>提供了上下文敏感的支持，此工具提示也将整合到将来的
									</xsl:text>
										<a href="http://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text> 中。&#10;</xsl:text>
                                                                        -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='French'">
									<xsl:text>Ces tooltips fournissent des descriptions r&#232;capitulatives pour
									chaque noeud (&#232;l&#232;ment) et chaque zone (attribut) X3D. Ils fournissent un
									support pour le outil de création
									</xsl:text>
                                                                        <a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a>
									<xsl:text> et le </xsl:text>

                                                                        <!-- TODO
									<xsl:text>
									et seront int&#232;gr&#232;s dans le prochain
									</xsl:text>
										<a href="http://www.web3d.org/specifications" target="_blank">sch&#232;ma de X3D</a>
									<xsl:text>.</xsl:text>
									<xsl:text>&#10;</xsl:text>
                                                                        -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='German'">
									<xsl:text>F&#252;r alle X3D-Knoten (Elemente) und deren Felder (Attribute) existieren Tooltips mit kurzen Beschreibungen und
									Hinweisen f&#252;r Szenenautoren. Diese dienen als kontextsensitive Hilfe f&#252;r das
									</xsl:text>
                                                                        <a href="https://savage.nps.edu/X3D-Edit" target="_blank">Autorenwerkzeug X3D-Edit</a>
									<xsl:text> und der </xsl:text>
                                                                        <!-- TODO
									<xsl:text>
									und werden auch im k&#252;nftigen 
									</xsl:text>
										<a href="http://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text> integriert sein.</xsl:text>
									<xsl:text>&#10;</xsl:text>
                                                                        -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Italian'">
									<xsl:text>Questi commenti forniscono delle descrizioni riassuntive e dei consigli
									utili per ogni nodo (elemento) e campo (attributo) di X3D. Essi
									forniscono supporto dipendente dal contesto per lo strumento di sviluppo 
									</xsl:text>
                                                                        <a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a>
									<xsl:text> e la </xsl:text>

                                                                        <!-- TODO
									<xsl:text> e saranno integrati nel futuro 
									</xsl:text>
										<a href="http://www.web3d.org/specifications" target="_blank">Schema X3D</a>
									<xsl:text>.&#10;</xsl:text>
                                                                        -->
								</xsl:when>
                                                                
                                                                <!-- Hyokwang Lee -->
								<xsl:when test="$tooltipLanguage='Korean'">
									<xsl:text>
										X3D 툴팁(Tooltips)은 버전 
									</xsl:text>
                                                                        <xsl:value-of select="$version"/>
									<xsl:text> 사양(Specification)의 각 X3D 노드(엘리먼트)와 필드(속성)에 대한 
                                                                                간략한 설명과 저작(authoring) 힌트를 제공한다. 
									</xsl:text>
									<a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a>
                                                                        <xsl:text>과 같은 툴 및 저자들을 위한 상황 대응적인 지원(context-sensitive support)이 제공되며, 
                                                                                또한 각 노드 별로 
                                                                        </xsl:text>
                                                                        <xsl:element name="a">
                                                                                <xsl:attribute name="href">
                                                                                        <xsl:value-of select="$x3dSpecificationUrlBase"/>
                                                                                        <xsl:value-of select="$x3dSpecificationTop"/>
                                                                                </xsl:attribute>
                                                                                <xsl:attribute name="target">
                                                                                        <xsl:text>_blank</xsl:text>
                                                                                </xsl:attribute>
                                                                                <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;추상&amp;nbsp;사양</xsl:text>
                                                                        <xsl:text disable-output-escaping="yes"> (X3D&amp;nbsp;Abstract Specification)
                                                                        </xsl:text>
                                                                        </xsl:element><xsl:text>,
                                                                        </xsl:text>
                                                                        <xsl:element name="a">
                                                                            <xsl:attribute name="target">
                                                                                <xsl:text>_blank</xsl:text>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="title">
                                                                                <xsl:value-of select="@name"/>
                                                                                <xsl:text> documentation, X3D Schema</xsl:text>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="alt">
                                                                                <xsl:value-of select="@name"/>
                                                                                <xsl:text> documentation, X3D Schema</xsl:text>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="href">
                                                                                <xsl:value-of select="$schemaDocumentationUrl"/>
                                                                            </xsl:attribute>
                                                                            <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;스키마&amp;nbsp;문서</xsl:text>
                                                                        <xsl:text disable-output-escaping="yes"> (X3D&amp;nbsp;Schema Documentation)</xsl:text>
                                                                        </xsl:element><xsl:text>,
									</xsl:text>
                                                                        <xsl:element name="a">
                                                                            <xsl:attribute name="target">
                                                                                <xsl:text>_blank</xsl:text>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="title">
                                                                                <xsl:value-of select="@name"/>
                                                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="alt">
                                                                                <xsl:value-of select="@name"/>
                                                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="href">
                                                                                <xsl:value-of select="$doctypeDocumentationUrl"/>
                                                                            </xsl:attribute>
                                                                            <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;DOCTYPE&amp;nbsp;문서</xsl:text>
                                                                        <xsl:text disable-output-escaping="yes"> (X3D&amp;nbsp;DOCTYPE Documentation)</xsl:text>
                                                                        </xsl:element>                                                                        
                                                                        <xsl:text>에 대한 적절한 링크가 제공된다.
									</xsl:text>                                                                        
								</xsl:when>
                                                                                                                                
								<xsl:when test="$tooltipLanguage='Portuguese'">
									<xsl:text>Estas dicas de ferramentas (tooltips) fornecem uma descri&#231;&#227;o
									resumida e dicas de uso para cada n&#243; X3D (elemento) e campo (atributo).
									Elas fornecem ajuda sens&#237;vel ao contexto para a ferramenta de edi&#231;&#227;o
									</xsl:text>
                                                                        <a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a>
									<xsl:text> eo </xsl:text>

                                                                        <!-- TODO
									<xsl:text>
									e ser&#225; integrada com o
									</xsl:text>
										<a href="http://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text>
									que esta para surgir.&#10;</xsl:text>
                                                                        -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Spanish'">
									<xsl:text>Estas notas de ayuda proporcionan descripciones resumidas y sugerencias de
									autor&#237;a para cada nodo (elemento) X3D y campo (atributo). Proporcionan
									ayuda contextual en la herramienta de autor 
									</xsl:text>
                                                                        <a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a>
									<xsl:text> y el </xsl:text>

                                                                        <!-- TODO
									<xsl:text> y se integrar&#225;n en el pr&#243;ximo 
									</xsl:text>
										<a href="http://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text>.&#10;</xsl:text>
                                                                        -->
								</xsl:when>
                                                                <!-- Hassadee Pimsuwan -->
								<xsl:when test="$tooltipLanguage='Thai'"> 
									<xsl:text>
										The X3D tooltips provide summary descriptions and authoring hints for each
										X3D node (element) and field (attribute) in the version 
									</xsl:text>
                                                                        <xsl:value-of select="$version"/>
									<xsl:text> specification.
										They provide context-sensitive support for authors and tools (such as
									</xsl:text>
									<a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a><xsl:text>)</xsl:text>
                                                                        <xsl:text>, with each node also providing appropriate links to the
									</xsl:text>

                                                                        <!-- TODO
                                                                        <xsl:text> and will be integrated with the
									</xsl:text>
										<a href="http://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text>.&#10;</xsl:text>
                                                                        -->
								</xsl:when>
 
								<xsl:otherwise> <!-- English -->
									<xsl:text>
										The X3D tooltips provide summary descriptions and authoring hints for each
										X3D node (element) and field (attribute) in the version 
									</xsl:text>
                                                                        <xsl:value-of select="$version"/>
									<xsl:text> specification.
										They provide context-sensitive support for authors and tools (such as
									</xsl:text>
									<a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a><xsl:text>)</xsl:text>
                                                                        <xsl:text>, with each node also providing appropriate links to the
									</xsl:text>

                                                                        <!-- TODO
                                                                        <xsl:text> and will be integrated with the
									</xsl:text>
										<a href="http://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text>.&#10;</xsl:text>
                                                                        -->
								</xsl:otherwise>
							</xsl:choose>
                                                        <!-- common header finish for all languages -->


                                    <!-- this will not be applied to korean edition. Hyokwang Lee -->
                                    <xsl:if test="not($tooltipLanguage='Korean')">

                                        <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                        <xsl:value-of select="$x3dSpecificationUrlBase"/>
                                                        <xsl:value-of select="$x3dSpecificationTop"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">
                                                        <xsl:text>_blank</xsl:text>
                                                </xsl:attribute>
                                                <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;Abstract&amp;nbsp;Specification</xsl:text>
                                        </xsl:element>
                                        <xsl:text>, the&#10;</xsl:text>

                                        <xsl:element name="a">
                                            <xsl:attribute name="target">
                                                <xsl:text>_blank</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="title">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D Schema</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D Schema</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$schemaDocumentationUrl"/>
                                            </xsl:attribute>
                                            <xsl:text disable-output-escaping="yes">X3D Schema Documentation</xsl:text>
                                        </xsl:element>
                                                                    <xsl:text>&#10;</xsl:text>
                                                                    <xsl:text>and the </xsl:text>
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>

                                        <xsl:element name="a">
                                            <xsl:attribute name="target">
                                                <xsl:text>_blank</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="title">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$doctypeDocumentationUrl"/>
                                            </xsl:attribute>
                                            <xsl:text disable-output-escaping="yes">X3D DOCTYPE Documentation</xsl:text>
                                        </xsl:element>
                                        <xsl:text>.&#10;</xsl:text>

                                    </xsl:if>
                                                    
                                </td>
                            </tr>

                            <xsl:if test="not($version='3.3')">
                                <tr>
                                    <td align='center'>
                                        <xsl:text>&#10;</xsl:text>
                                        <xsl:text>Complete support for the latest X3D specification can be found in the </xsl:text>
                                        <!-- relative link for local/online use -->
                                        <a href="X3dTooltips.html">X3D Tooltips version 3.3</a>
                                        <xsl:text>.</xsl:text>
                                        <xsl:text>&#10;</xsl:text>
                                    </td>
                                </tr>
                            </xsl:if>
                                            
                        </table>

                    <xsl:apply-templates/>
			
                </body>
            </html>

        </xsl:template>

	<!-- ****** "elements" element****************************************************** -->
	<xsl:template match="elements">
	
		<!-- table of contents index, which would be better as a sorted column -->

		<blockquote style="text-align: justify; align: center" >
			<xsl:text>&#10;</xsl:text>
			<xsl:for-each select="element[not(starts-with(@name,'XML_')) and not(@name='USE')]">
				<xsl:sort select="@name" order="ascending" case-order="lower-first"/>
				<font size="-1">
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>#</xsl:text>
							<xsl:value-of select="@name"/>
						</xsl:attribute>
						<xsl:value-of select="@name"/>
					</xsl:element>
				</font>
				<xsl:text>&#160;&#160;&#10;</xsl:text>
				<!-- &#160; = &nbsp; -->
			</xsl:for-each>
		</blockquote>
		<xsl:text>&#10;&#10;</xsl:text>


		<!-- Detailed table containing names and tooltips for elements, attributes -->
		
		<blockquote>
		<!-- width="900" -->
		<table summary="" align="center" width="98%" border="1" cellspacing="0" cellpadding="1">

			<xsl:apply-templates select="element[not(starts-with(@name,'XML_'))]">
			   <xsl:sort select="@name" order="ascending" case-order="lower-first"/>
			</xsl:apply-templates>
                        
		<!-- bookmark links row-->
		<tr align="left">
                    <td bgcolor="#669999" align="right" valign="top">
                            <!-- bookmark -->
                            <xsl:element name="a">
                                    <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                                    <font size="-1">
                                            <xsl:text>&#160;</xsl:text>
                                            <!-- &#160; = &nbsp; -->
                                    </font>
                            </xsl:element>
                    </td>
                    <!--m17 add here "width="600"" for word wrap 	width="600"-->
                    <td bgcolor="#669999" align="right" valign="top" colspan="2">
                        <xsl:element name="a">
                        <!--	<xsl:attribute name="href"><xsl:value-of select="$pageName"/></xsl:attribute> -->
                        <!--	<xsl:attribute name="target"><xsl:text>_self</xsl:text></xsl:attribute> -->
                                <xsl:attribute name="href"><xsl:text>#top</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>Top</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#accessType</xsl:text></xsl:attribute>
                                <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>accessType and type</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#credits</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>Credits</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>../content/examples/X3dResources.html</xsl:text></xsl:attribute>
                                <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>X3D Resources</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                    </td>
		</tr>

		</table>
		<xsl:text>&#10;&#10;</xsl:text>

                <div width="95%">
                    
                </div>
                
		<!-- Summary information table  -->
						
		<table summary="" width="95%" align="center" border="0" cellspacing="0" cellpadding="1">

			<tr>
                            <td colspan="3">

                                <a name="accessType"><h3><i>accessType</i> Definitions</h3></a>

                                <p>
                                    <i>accessType</i> determines whether a field corresponds to event input, event output, or persistent state information.
                                    Events are strictly typed values with a corresponding timestamp.
                                    ROUTE connections must match <i>accessType</i> between source field and target field.
                                <ul>
                                    <li>
                                        <i>initializeOnly</i>:
                                        can be initialized, but cannot send or receive events.
                                        This is usually the case for fields that are considered too computationally expensive to change at run time.
                                    </li>
                                    <li>
                                        <i>inputOutput</i>:
                                        can be initialized, and can also send or receive events.
                                    </li>
                                    <li>
                                        <i>inputOnly</i>:
                                        cannot be initialized or included in a scene file, but can receive input event values via a ROUTE.
                                    </li>
                                    <li>
                                        <i>outputOnly</i>:
                                        cannot be initialized or included in a scene file, but can send output event values via a ROUTE.
                                    </li>
                                </ul>
                                </p>
                                <p>
                                    X3D <i>accessType</i> design keeps 3D graphics rendering fast and interactive,
                                    also helping to keep X3D players small and lightweight.
                                </p>
                            </td>
                        </tr>

			<tr>
                            <td colspan="3">

                                <a name="type"><h3><i>type</i> Definitions</h3></a>

                                <p>
                                    <a href="http://en.wikipedia.org/wiki/Data_types">Data types</a> classify the possible values for a variable.
                                    X3D is a strongly typed language, meaning that data types must match for a scene to be correct.
                                    Each field in each node (i.e. each XML attribute) has a strictly defined data type.
                                    Multiple data types are provided for boolean, integer, floating-point and string values.
                                </p>
                                
                                <ul>
                                
                                    <li>
                                        Each of the base types are either single-value or multiple-value.
                                        Examples:  SFFloat (single-value), SFVec2f (2-tuple), SFVec3f (3-tuple), SFOrientation (4-tuple for axis-angle values).
                                    </li>

                                    <li>
                                        Arrays are also provided for all base types.  Nomenclature:
                                        <b>SF = Single Field</b> (single  value of base type), <b>MF = Multiple Field</b> (array of base-type values).
                                    </li>

                                    <li>
                                        The X3D Schema is able to validate numeric type information and array tuple sizes in X3D scenes
                                        for <i>initializeOnly</i> and <i>inputOutput</i> field initializations that appear within an X3D file.
                                    </li>
 
                                    <li>
                                        ROUTEs pass events, which are strictly typed values with a corresponding timestamp.
                                        ROUTE connections must match type between source field and target field.
                                        Since they are transient, event values themselves cannot appear within an X3D file.
                                    </li>

                                    <li>
                                        <!-- TODO check scene authoring hints -->
                                        For MF multiple-field arrays, commas between values are normally treated as whitespace.
                                        However, X3D Schema validation will not accept commas that appear within vector values, only between values.
                                        MFColor examples: color="0.25 0.5 0.75, 1 1 0" is valid while color="0.25, 0.5, 0.75, 1, 1, 0" is invalid.
                                        This is an authoring assist to help authors troubleshoot errors in long arrays of values.
                                    </li>

                                    <li>
                                        Failure to match data types correctly is an error!
                                        Types must match during scene validation, scene loading, and at run time.
                                        This is A Good Thing since it allows authors to find problems when they exist,
                                        rather than simply hoping (perhaps mistakenly) that everything will work for end users.
                                    </li>
                                    
                                </ul>
                                <p>
                                    Several Extensible Markup Language (XML) data types are also included in these tooltips.
                                </p>
                                <ul>
                                    <li>
                                        <b><a href="http://www.w3.org/TR/REC-xml/#syntax">CDATA</a></b> 
                                        is an XML term for 
                                        <a href="http://www.w3.org/TR/REC-xml/#syntax">Character Data</a>.  
                                        The base type for all XML attributes
                                        consists of CDATA characters.  
                                        CDATA is used throughout the X3D DOCTYPE definitions, which can only check
                                        for the presence of legal strings and thus are not able to validate numeric type information.
                                        Strictly speaking, a few CDATA attributes (such as those for the <i>meta</i> element
                                        and other elements appearing inside the head element)
                                        are not fields of X3D nodes and thus do not have corresponding X3D data types.
                                    </li>

                                    <li>
                                        <b><a href="http://www.w3.org/TR/REC-xml/#FixedAttr">FIXED</a></b> 
                                        indicates that no other value is allowed.  When used with an empty string &quot;&quot; value,
                                        this is used to indicate that
                                        X3D inputOnly and outputOnly fields are not allowed to appear in an X3D file.
                                    </li>

                                    <li>
                                        <b><a href="http://www.w3.org/TR/REC-xml/#sec-attribute-types">ID</a></b> 
                                        is a NMTOKEN that is unique within the scene, corresponding to the DEF label in X3D.
                                    </li>

                                    <li>
                                        <b><a href="http://www.w3.org/TR/REC-xml/#sec-attribute-types">IDREF</a></b> 
                                        is a reference to one of these unique scene IDs, corresponding to the USE label in X3D.
                                    </li>

                                    <li>
                                        <b><a href="http://www.w3.org/TR/REC-xml/#sec-common-syn">NMTOKEN</a></b>
                                        is an XML term for 
                                        <a href="http://www.w3.org/TR/REC-xml/#sec-common-syn">Name Token</a>.  
                                        NMTOKEN is also a CDATA string
                                        but must also match naming requirements for legal characters with no embedded spaces.
                                    </li>
                                </ul>
                                
                                <p>
                                    The following table provides a complete list of X3D data type names, descriptions and example values.
                                </p>
                                
                                <table border="1" cellpadding="2" align="center">
                                    <tr>
                                        <th>
                                            Field-type names
                                        </th>
                                        <th>
                                            Description
                                        </th>
                                        <th>
                                            Example values
                                        </th>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFBoolAndMFBool" target="blank">SFBool</a>
                                        </td>
                                        <td>
                                            Single-field boolean value 
                                        </td>
                                        <td>
                                            <b>true</b> or <b>false</b> (XML syntax in .x3d files), 
                                            <br />
                                            TRUE or FALSE (ClassicVRML syntax in .wrl or .x3dv files)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFBoolAndMFBool" target="blank">MFBool</a>
                                        </td>
                                        <td>
                                            Multiple-field boolean array, containing an ordered list of SFBool values
                                        </td>
                                        <td>
                                            <b>true false false true</b> (XML syntax in .x3d files),
                                            <br />
                                            [ TRUE FALSE FALSE TRUE ] (ClassicVRML syntax in .wrl or .x3dv files)
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFColorAndMFColor" target="blank">SFColor</a>
                                        </td>
                                        <td>
                                            Single-field color value, red-green-blue
                                        </td>
                                        <td>
                                            0 0.5 1.0
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFColorAndMFColor" target="blank">MFColor</a>
                                        </td>
                                        <td>
                                             Multiple-field color array, containing an ordered list of SFColor values
                                        </td>
                                        <td>
                                            1 0 0, 0 1 0, 0 0 1
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFColorRGBAAndMFColorRGBA" target="blank">SFColorRGBA</a>
                                        </td>
                                        <td>
                                            Single-field color value, red-green-blue alpha (opacity)
                                        </td>
                                        <td>
                                            0 0.5 1.0 0.75
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFColorRGBAAndMFColorRGBA" target="blank">MFColorRGBA</a>
                                        </td>
                                        <td>
                                            Multiple-field color array, containing an ordered list of SFColor values
                                        </td>
                                        <td>
                                            1 0 0 0.25, 0 1 0 0.5, 0 0 1 0.75
                                            (red green blue, with varying opacity)
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFInt32AndMFInt32" target="blank">SFInt32</a>
                                        </td>
                                        <td>
                                            Single-field 32-bit integer value
                                        </td>
                                        <td>
                                            0
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFInt32AndMFInt32" target="blank">MFInt32</a>
                                        </td>
                                        <td>
                                            Multiple-field 32-bit integer array, containing an ordered list of SFInt32 values
                                        </td>
                                        <td>
                                            1 2 3 4 5
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFFloatAndMFFloat" target="blank">SFFloat</a>
                                        </td>
                                        <td>
                                            Single-field single-precision floating-point value
                                        </td>
                                        <td>
                                            1.0
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFFloatAndMFFloat" target="blank">MFFloat</a>
                                        </td>
                                        <td>
                                            Multiple-field single-precision floating-point array, containing an ordered list of SFFloat values
                                        </td>
                                        <td>
                                            −1 2.0 3.14159
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFDoubleAndMFDouble" target="blank">SFDouble</a>
                                        </td>
                                        <td>
                                            Single-field double-precision floating-point value
                                        </td>
                                        <td>
                                            2.7128
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFDoubleAndMFDouble" target="blank">MFDouble</a>
                                        </td>
                                        <td>
                                            Multiple-field double-precision array, containing an ordered list of SFDouble values
                                        </td>
                                        <td>
                                            −1 2.0 3.14159
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFImageAndMFImage" target="blank">SFImage</a>
                                        </td>
                                        <td>
                                            Single-field image value 
                                        </td>
                                        <td>
                                            Contains special pixel-encoding values, see
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFImageAndMFImage" target="blank">X3D Specification</a>
                                            for details
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFImageAndMFImage" target="blank">MFImage</a>
                                        </td>
                                        <td>
                                             Multiple-field image value, containing an ordered list of SFImage values
                                        </td>
                                        <td>
                                            Contains special pixel-encoding values, see
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFImageAndMFImage" target="blank">X3D Specification</a>
                                            for details
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFRotationAndMFRotation" target="blank">SFRotation</a>
                                        </td>
                                        <td>
                                             Single-field rotation value using 3-tuple axis, radian angle form
                                        </td>
                                        <td>
                                            0 1 0 1.57
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFRotationAndMFRotation" target="blank">MFRotation</a>
                                        </td>
                                        <td>
                                             Multiple-field rotation array, containing an ordered list of SFRotation values
                                        </td>
                                        <td>
                                            0 1 0 0, 0 1 0 1.57, 0 1 0 3.14
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFStringAndMFString" target="blank">SFString</a>
                                        </td>
                                        <td>
                                            Single-field string value
                                        </td>
                                        <td>
                                            Example: an SFString is a simple string value.
                                            <br />
                                            <font color="#ee5500">Warning:</font> do not wrap quotation marks around SFString values.
                                            <br />
                                            <font color="#447777">Hint:</font> insert backslash characters prior to \&quot;embedded quotation marks\&quot; within an SFString value.
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFStringAndMFString" target="blank">MFString</a>
                                        </td>
                                        <td>
                                            Multiple-field string array, containing an ordered list of SFString values
                                        </td>
                                        <td>
                                            “EXAMINE” “FLY” “WALK” “ANY”
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFTimeAndMFTime" target="blank">SFTime</a>
                                        </td>
                                        <td>
                                            Single-field time value in seconds, specified as a double-precision floating point number.
                                        </td>
                                        <td>
                                            0, 10, or -1 (which means no update was provided to change the default value).
                                            <br />
                                            <font color="#447777">Hint:</font> Time values are usually either a system time or else a duration.
                                            <br />
                                            <font color="#447777">Hint:</font> Typically, SFTime fields represent the number of seconds since Jan 1, 1970, 00:00:00 GMT.
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFTimeAndMFTime" target="blank">MFTime</a>
                                        </td>
                                        <td>
                                             Multiple-field time array, containing an ordered list of SFTime values
                                        </td>
                                        <td>
                                            −1 0 1 567890
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFNodeAndMFNode" target="blank">SFNode</a>
                                        </td>
                                        <td>
                                            SFNode Single-field node. Default value is NULL.
                                        </td>
                                        <td>
                                            &lt;Shape/&gt; or Shape
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFNodeAndMFNode" target="blank">MFNode</a>
                                        </td>
                                        <td>
                                             Multiple-field node array, containing an ordered list of SFNode values.  Default value is an empty list.
                                        </td>
                                        <td>
                                            &lt;Shape/&gt; &lt;Group/&gt; &lt;Transform/&gt;
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec2fAndMFVec2f" target="blank">SFVec2f</a>
                                        </td>
                                        <td>
                                            Single-field 2-tuple single-precision float vector
                                        </td>
                                        <td>
                                            0.5 0.5
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec2fAndMFVec2f" target="blank">MFVec2f</a>
                                        </td>
                                        <td>
                                            Multiple-field array of 2-tuple single-precision float vectors, containing an ordered list of SFVec2f values
                                        </td>
                                        <td>
                                            0 0, 0 1, 1 1, 1 0
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec2dAndMFVec2d" target="blank">SFVec2d</a>
                                        </td>
                                        <td>
                                            Single-field 2-tuple double-precision float vector
                                        </td>
                                        <td>
                                            0.5 0.5
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec2dAndMFVec2d" target="blank">MFVec2d</a>
                                        </td>
                                        <td>
                                            Multiple-field array of 2-tuple double-precision float vectors, containing an ordered list of SFVec2d values
                                        </td>
                                        <td>
                                            0 0, 0 1, 1 1, 1 0
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec3fAndMFVec3f" target="blank">SFVec3f</a>
                                        </td>
                                        <td>
                                            Single-field 3-tuple single-precision float vector
                                        </td>
                                        <td>
                                            0.0 0.0 0.0
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec3fAndMFVec3f" target="blank">MFVec3f</a>
                                        </td>
                                        <td>
                                            Multiple-field array of 3-tuple single-precision float vectors, containing an ordered list of SFVec3f values
                                        </td>
                                        <td>
                                            0 0 0, 0 0 1, 0 1 1, 0 1 0, 1 0 0, 1 0 1, 1 1 1, 1 1 0
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec3dAndMFVec3d" target="blank">SFVec3d</a>
                                        </td>
                                        <td>
                                            Single-field 3-tuple double-precision float vector
                                        </td>
                                        <td>
                                            0.0 0.0 0.0
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec3dAndMFVec3d" target="blank">MFVec3d</a>
                                        </td>
                                        <td>
                                            Multiple-field array of 3-tuple double-precision float vectors, containing an ordered list of SFVec3d values
                                        </td>
                                        <td>
                                            0 0 0, 0 0 1, 0 1 1, 0 1 0, 1 0 0, 1 0 1, 1 1 1, 1 1 0
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec4fAndMFVec4f" target="blank">SFVec4f</a>
                                        </td>
                                        <td>
                                            Single-field 4-tuple single-precision float vector
                                        </td>
                                        <td>
                                            1.0 2.0 3.0 4.0
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec4fAndMFVec4f" target="blank">MFVec4f</a>
                                        </td>
                                        <td>
                                            Multiple-field array of 4-tuple single-precision float vectors, containing an ordered list of SFVec4f values
                                        </td>
                                        <td>
                                            1 1 1 1, 2 2 2 2, 3 3 3 3, 4 4 4 4
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec4dAndMFVec4d" target="blank">SFVec4d</a>
                                        </td>
                                        <td>
                                            Single-field 4-tuple double-precision float vector
                                        </td>
                                        <td>
                                            1.0 2.0 3.0 4.0
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFVec4dAndMFVec4d" target="blank">MFVec4d</a>
                                        </td>
                                        <td>
                                            Multiple-field array of 4-tuple double-precision float vectors, containing an ordered list of SFVec4d values
                                        </td>
                                        <td>
                                            1 1 1 1, 2 2 2 2, 3 3 3 3, 4 4 4 4
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFMatrix3fAndMFMatrix3f" target="blank">SFMatrix3f</a>
                                        </td>
                                        <td>
                                            v3×3 matrix of single-precision floating point numbers
                                        </td>
                                        <td>
                                            1 0 0 0 1 0 0 0 1 (identity matrix, which is also the default value)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFMatrix3fAndMFMatrix3f" target="blank">MFMatrix3f</a>
                                        </td>
                                        <td>
                                            Zero or more 3×3 matrices of single-precision floating point numbers, containing an ordered list of SFMatrix3f values
                                        </td>
                                        <td>
                                            1 0 0 0 1 0 0 0 1, 1 0 0 0 1 0 0 0 1
                                            (default value is empty list)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFMatrix3dAndMFMatrix3d" target="blank">SFMatrix3d</a>
                                        </td>
                                        <td>
                                            Single 3×3 matrix of double-precision floating point numbers
                                        </td>
                                        <td>
                                            1 0 0 0 1 0 0 0 1 (identity matrix, which is also the default value)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFMatrix3dAndMFMatrix3d" target="blank">MFMatrix3d</a>
                                        </td>
                                        <td>
                                            Zero or more 3×3 matrices of double-precision floating point numbers, containing an ordered list of SFMatrix3d values
                                        </td>
                                        <td>
                                            1 0 0 0 1 0 0 0 1, 1 0 0 0 1 0 0 0 1
                                            (default value is empty list)
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFMatrix4fAndMFMatrix4f" target="blank">SFMatrix4f</a>
                                        </td>
                                        <td>
                                            Single 4×4 matrix of single-precision floating point numbers
                                        </td>
                                        <td>
                                            1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 (identity matrix, which is also the default value)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFMatrix4fAndMFMatrix4f" target="blank">MFMatrix4f</a>
                                        </td>
                                        <td>
                                            Zero or more 4×4 matrices of single-precision floating point numbers, containing an ordered list of SFMatrix4f values
                                        </td>
                                        <td>
                                            1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1, 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1
                                            (default value is empty list)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFMatrix4dAndMFMatrix4d" target="blank">SFMatrix4d</a>
                                        </td>
                                        <td>
                                            Single 4×4 matrix of double-precision floating point numbers
                                        </td>
                                        <td>
                                            1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 (identity matrix, which is also the default value)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <a href="http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/fieldsDef.html#SFMatrix4dAndMFMatrix4d" target="blank">MFMatrix4d</a>
                                        </td>
                                        <td>
                                            Zero or more 4×4 matrices of double-precision floating point numbers, containing an ordered list of SFMatrix4d values
                                        </td>
                                        <td>
                                            1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1, 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1
                                            (default value is empty list)
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                </table>
                                <p align="center">
                                    Table adapted from 
                                    <a href="http://x3dgraphics.com/chapters/Chapter01-Technical_Introduction.pdf" target="_blank">Chapter 1 Technical Overview</a>,
                                    Table 1.4 <i>X3D Field Types</i>,
                                    <i><a href="http://x3dgraphics.com" target="_blank">X3D for Web Authors</a></i>,
                                    <br />
                                    Don Brutzman and Leonard Daly,
                                    Morgan Kaufman Publishers, 2007.
                                    Used with permission.                                    
                                </p>
                            </td>
                        </tr>
			<tr>
				<td colspan="3">
                                        <xsl:element name="a">
                                                <xsl:attribute name="name">
                                                        <xsl:text>credits</xsl:text>
                                                </xsl:attribute>
                                                <xsl:text>&#160;</xsl:text>
                                        </xsl:element>
                                        <xsl:text>&#10;</xsl:text>
					<h3>
						<xsl:text>Credits</xsl:text>
					</h3>
					<xsl:text>Many thanks to our contributors and translators.</xsl:text>
				
			 		<ul>
						<li>	<b><a href="X3dTooltipsChinese.html">Chinese tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:m17design@hotmail.com(yiqi%20meng)?subject=X3D%20tooltips%20translation%20feedback%20">yiqi meng</a>
							<xsl:text> of </xsl:text>
							<xsl:text>&#10;</xsl:text>
                                                        <!-- originally http://m17design.myetang.com/x3d -->
							<a href="http://www.chinauniversity.info/2009/12/nanjing-art-institute.html" target="blank"> Nanjing Art Institute</a>
							<xsl:text>, Nanjing China.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltips.html">English tooltips</a></b>
							<xsl:text> (primary reference):  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:brutzman@nps.edu(Don%20Brutzman)?subject=X3D%20tooltips%20translation%20feedback%20">Don Brutzman</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> and students of the U.S. </xsl:text>
							<a href="http://www.nps.navy.mil" target="blank">Naval Postgraduate School (NPS)</a>
							<xsl:text>, Monterey California USA.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsFrench.html">French tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							Antony Beis,
							<a href="mailto:froussille@yahoo.com(Frederic%20Roussille)?subject=X3D%20tooltips%20translation%20feedback%20">Frederic Roussille</a>, 
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:Adrien.GRUNEISEN@wanadoo.fr(Adrien%20Gruneisen)?subject=X3D%20tooltips%20translation%20feedback%20">Adrien Gruneisen</a>
							et
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:nasayann@netcourrier.com(Yann%20Henriet)?subject=X3D%20tooltips%20translation%20feedback%20">Yann Henriet</a>
							<br />
							<xsl:text>of </xsl:text>
							<a href="http://www.enit.fr" target="blank">Ecole Nationale des Ingenieurs de Tarbes (ENIT)</a>
							<xsl:text>, Tarbes France.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsGerman.html">German tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:dachselt@inf.tu-dresden.de(Raimund%20Dachselt)?subject=X3D%20tooltips%20translation%20feedback%20">Raimund Dachselt</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> and </xsl:text>
							<a href="mailto:johnnyri@web.de(Johannes%20Richter)?subject=X3D%20tooltips%20translation%20feedback%20">Johannes Richter</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of the </xsl:text>
							<a href="http://www-mmt.inf.tu-dresden.de" target="blank">Multimedia Technology Group</a>
							<xsl:text>, </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="http://www.tu-dresden.de" target="blank">Dresden University of Technology</a>
							<xsl:text>, Germany.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsItalian.html">Italian tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:ranon@dimi.uniud.it(Roberto%20Ranon)?subject=X3D%20tooltips%20translation%20feedback%20">Roberto Ranon</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of the </xsl:text>
							<a href="http://www.uniud.it" target="blank">L'Universita degli Studi di Udine</a>
							<xsl:text>, Italy.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsKorean.html">Korean tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:surplusz@kaist.ac.kr(Ikjune%20Kim)?subject=X3D%20tooltips%20translation%20feedback%20">Ikjune Kim</a>,
							<a href="mailto:yoo@byoo.net(Byounghyun%20Yoo)?subject=X3D%20tooltips%20translation%20feedback%20">Byounghyun Yoo</a>
                                                        and
							<a href="mailto:adpc9@partdb.com(Hyokwang%20Lee)?subject=X3D%20tooltips%20translation%20feedback%20">Hyokwang Lee</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of the </xsl:text>
							<a href="http://www.kaist.ac.kr" target="blank">Korea Advanced Institute of Science and Technology (KAIST)</a>
                                                        and
							<a href="http://www.partdb.com" target="blank">PartDB Co., Ltd.</a>
							<xsl:text>, Korea.</xsl:text>
						</li>     
						<li>	<b><a href="X3dTooltipsPortuguese.html">Portuguese tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:lsoares@lsi.usp.br(Luciano%20Pereira%20Soares)?subject=X3D%20tooltips%20translation%20feedback%20">Luciano Pereira Soares</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of the </xsl:text>
							<a href="http://www.lsi.usp.br" target="blank">Laborat&#211;rio de Sistemas Integr&#225;veis, Escola Polit&#233;cnica - Universidade de S&#227;o Paulo</a>
							<xsl:text>, Brasil.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsSpanish.html">Spanish tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:gmunoz@escet.urjc.es(Guadalupe%20Munoz%20Martin)?subject=X3D%20tooltips%20translation%20feedback%20">Guadalupe Munoz Martin</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of </xsl:text>
							<a href="http://www.urjc.es" target="blank">University Rey Juan Carlos</a>
							<xsl:text>, Madrid Espana.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsThai.html">Thai tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:hapztron@gmail.com(Hassadee%20Pimsuwan)?subject=X3D%20tooltips%20translation%20feedback%20">Hassadee Pimsuwan</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of </xsl:text>
							<a href="http://web.sut.ac.th/sutnew/sut_en/" target="blank">Suranaree University of Technology</a>
                                                        and
							<a href="http://hassadee.com" target="blank">hassadee.com</a>
							<xsl:text>, Thailand.</xsl:text>
						</li>
					</ul>
                
					<h3>
                                    
                                                <xsl:element name="a">
                                                        <xsl:attribute name="name">
                                                                <xsl:text>versions</xsl:text>
                                                        </xsl:attribute>
                                                        <xsl:text>&#160;</xsl:text>
                                                </xsl:element>
						<xsl:text>Reference Tooltip Versions</xsl:text>
					</h3>
                                        
			 		<ul>
						<li>	
                                                    <a href="X3dTooltips.html">X3D version 3.3 tooltips</a>
                                                   (<a href="x3d-3.3.profile.xml">.xml source</a>)
						</li>
						<li>	
                                                    <a href="X3dTooltips3.2.html">X3D version 3.2 tooltips</a>
						</li>
						<li>	
                                                    <a href="X3dTooltips3.1.html">X3D version 3.1 tooltips</a>
						</li>
						<li>	
                                                    <a href="X3dTooltips3.0.html">X3D version 3.0 tooltips</a>
						</li>
						<li>	
                                                    <a href="README.txt">README.txt</a>
						</li>
					</ul>
				</td>
			</tr>
			
		<!-- 	<tr>
				<td colspan="3">
						<xsl:text>&#160;</xsl:text>
				</td>
			</tr>
		 -->	
			<tr>
				<td align="left">
					<xsl:text>URL for this file: </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>http://www.web3d.org/x3d/content/X3dTooltips</xsl:text>
							<xsl:if test="($tooltipLanguage != 'English')">
								<xsl:value-of select="$tooltipLanguage"/>
							</xsl:if>
                                                        <xsl:if test="not($version='3.3') and ($tooltipLanguage = 'English')">
                                                            <xsl:value-of select="$version"/>
                                                        </xsl:if>
							<xsl:text>.html</xsl:text>
						</xsl:attribute>
							<xsl:text>http://www.web3d.org/x3d/content/X3dTooltips</xsl:text>
							<xsl:if test="($tooltipLanguage != 'English')">
								<xsl:value-of select="$tooltipLanguage"/>
							</xsl:if>
                                                        <xsl:if test="not($version='3.3') and ($tooltipLanguage = 'English')">
                                                            <xsl:value-of select="$version"/>
                                                        </xsl:if>
							<xsl:text>.html</xsl:text>
					</xsl:element>
				</td>
				<td>
						<xsl:text>&#160;</xsl:text>
				</td>
				<td align="right">
					<xsl:text>Tooltip source for this page: </xsl:text>
                                        <xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.profile</xsl:text>
							<xsl:if test="($tooltipLanguage != 'English')">
								<xsl:value-of select="$tooltipLanguage"/>
							</xsl:if>
							<xsl:text>.xml</xsl:text>
						</xsl:attribute>
							<xsl:text>x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.profile</xsl:text>
							<xsl:if test="($tooltipLanguage != 'English')">
								<xsl:value-of select="$tooltipLanguage"/>
							</xsl:if>
							<xsl:text>.xml</xsl:text>
					</xsl:element>
				</td>
                                <!--
				<td align="right">
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>http://www.web3d.org/specifications/x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.xsd</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_blank</xsl:text>
						</xsl:attribute>
							<xsl:text>x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.xsd</xsl:text>
					</xsl:element>
                                        <xsl:text>, </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>http://www.web3d.org/specifications/x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.dtd</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_blank</xsl:text>
						</xsl:attribute>
							<xsl:text>x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.dtd</xsl:text>
					</xsl:element>
					<br />
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>http://www.web3d.org/specifications/x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>-InputOutputFields.dtd</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_blank</xsl:text>
						</xsl:attribute>
							<xsl:text>x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>-InputOutputFields.dtd</xsl:text>
					</xsl:element>
				</td>
                                -->
			</tr>

			<tr>
				<td align="left">
					<xsl:text>X3D Tooltips Conversion Stylesheet: </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>X3dTooltipConversions.xslt</xsl:text>
						</xsl:attribute>
							<xsl:text>X3dTooltipConversions.xslt</xsl:text>
					</xsl:element>
				</td>
				<td>
					<xsl:text>&#160;</xsl:text>
					<!-- &#160; = &nbsp; -->
				</td>
                                <td align="right">
					<xsl:text>All tooltips: </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>http://www.web3d.org/x3d/content/X3dTooltips.zip</xsl:text>
						</xsl:attribute>
						<xsl:text>http://www.web3d.org/x3d/content/X3dTooltips.zip</xsl:text>
					</xsl:element>
				</td>
			</tr>
			<tr>
				<td align="left">
					<xsl:text>Nightly build: </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>https://savage.nps.edu/jenkins/job/X3dTooltips</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_jenkins</xsl:text>
						</xsl:attribute>
						<xsl:text>Savage Jenkins Continuous Integration Server</xsl:text>
					</xsl:element>
				</td>
				<td>
					<xsl:text>&#160;</xsl:text>
					<!-- &#160; = &nbsp; -->
				</td>
				<td align="right">
					<xsl:text>Version history: </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>https://sourceforge.net/p/x3d/code/12736/tree/www.web3d.org/x3d/tooltips</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_sourceforge</xsl:text>
						</xsl:attribute>
						<xsl:text>https://sourceforge.net/p/x3d/code/12736/tree/www.web3d.org/x3d/tooltips</xsl:text>
					</xsl:element>
				</td>
			</tr>
			<tr>
				<td align="left">
					<xsl:text>Contact:</xsl:text>
					<xsl:text>&#10;</xsl:text>
					<xsl:element name="a">
						<!-- Reference:  "The mailto URL scheme"  ftp://ftp.isi.edu/in-notes/rfc2368.txt July 1998 by
						     P. Hoffman (Internet Mail Consortium), L. Masinter (Xerox Corporation), J. Zawinski (Netscape Communications) -->
						<xsl:attribute name="href">
							<xsl:text>mailto:brutzman@nps.edu(Don%20Brutzman)?subject=X3D%20Tooltips</xsl:text>
							<xsl:if test="$tooltipLanguage">
								<xsl:text>%20in%20</xsl:text>
								<xsl:value-of select="$tooltipLanguage"/>
							</xsl:if>
						</xsl:attribute>
						<xsl:attribute name="onMouseOver">
							<xsl:text>status='Click to send mail if you have comments.</xsl:text>
							<xsl:text>';return true</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="onMouseOut">
							<xsl:text>status='';return true</xsl:text>
						</xsl:attribute>
						<font color="blue">
							<xsl:text>Don Brutzman</xsl:text>
						</font>
					</xsl:element>
					<xsl:text>&#10;</xsl:text>
					
					<xsl:text> (</xsl:text>
					<xsl:element name="a">
						<!-- Reference:  "The mailto URL scheme"  ftp://ftp.isi.edu/in-notes/rfc2368.txt July 1998 by
						     P. Hoffman (Internet Mail Consortium), L. Masinter (Xerox Corporation), J. Zawinski (Netscape Communications) -->
						<xsl:attribute name="href">
							<xsl:text>mailto:brutzman@nps.edu(Don%20Brutzman)?subject=X3D%20Tooltips</xsl:text>
							<xsl:if test="$tooltipLanguage">
								<xsl:text>%20in%20</xsl:text>
								<xsl:value-of select="$tooltipLanguage"/>
							</xsl:if>
						</xsl:attribute>
						<xsl:attribute name="onMouseOver">
							<xsl:text>status='Click to send mail if you have comments.</xsl:text>
							<xsl:text>';return true</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="onMouseOut">
							<xsl:text>status='';return true</xsl:text>
						</xsl:attribute>
						<font color="blue">
							<xsl:text>brutzman&#160;at&#160;nps.edu</xsl:text>
						</font>
					</xsl:element>
					<xsl:text>)&#10;</xsl:text>
				</td>
				<td>
					<xsl:text>&#160;</xsl:text>
					<!-- &#160; = &nbsp; -->
				</td>
				<td align="right">
					<xsl:text>Autogenerated </xsl:text>
					<xsl:value-of select="$todaysDate"/>
				</td>
			</tr>

		</table>
		</blockquote>
		
	</xsl:template>

	<!-- ****** "element" element ****************************************************** -->
	<xsl:template match="element[not(@name='USE')]">
	<!-- USE tooltip retained in profile for content correction and debugging, but it is not a valid element -->

		<!-- bookmark links row-->
		<tr align="left">
                    <td bgcolor="#669999" align="right" valign="top">
                            <!-- bookmark -->
                            <xsl:element name="a">
                                    <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                                    <font size="-1">
                                            <xsl:text>&#160;</xsl:text>
                                            <!-- &#160; = &nbsp; -->
                                    </font>
                            </xsl:element>
                    </td>
                    <!--m17 add here "width="600"" for word wrap 	width="600"-->
                    <td bgcolor="#669999" align="right" valign="top" colspan="2">
                        <!-- bookmarks -->
                        <xsl:element name="a">
                        <!--	<xsl:attribute name="href"><xsl:value-of select="$pageName"/></xsl:attribute> -->
                        <!--	<xsl:attribute name="target"><xsl:text>_self</xsl:text></xsl:attribute> -->
                                <xsl:attribute name="href"><xsl:text>#top</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>Top</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#accessType</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>accessType and type</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#credits</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>Credits</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>../content/examples/X3dResources.html</xsl:text></xsl:attribute>
                                <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>X3D Resources</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                    </td>
		</tr>
		<!--	 width="800" -->
                <xsl:variable name="urlReference">
                    <xsl:choose>
                        <xsl:when test="@name='X3D'">
                            <xsl:text>http://www.web3d.org/x3d/content/examples/X3dSceneAuthoringHints.html#Validation</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='head'">
                            <xsl:text>http://www.web3d.org/files/specifications/19776-1/V3.2/Part01/concepts.html#Header</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='component'">
                            <xsl:text>http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/concepts.html#Components</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='unit'">
                            <xsl:text>http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/concepts.html#Standardunitscoordinates</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='meta'">
                            <xsl:text>http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/components/core.html#METAStatement</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ProtoDeclare'">
                            <xsl:text>http://www.web3d.org/files/specifications/19776-1/V3.2/Part01/concepts.html#PrototypeAndFieldDeclarationSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ProtoInterface'">
                            <xsl:text>http://www.web3d.org/files/specifications/19776-1/V3.2/Part01/concepts.html#PrototypeAndFieldDeclarationSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ProtoBody'">
                            <xsl:text>http://www.web3d.org/files/specifications/19776-1/V3.2/Part01/concepts.html#PrototypeAndFieldDeclarationSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ProtoInstance'">
                            <xsl:text>http://www.web3d.org/files/specifications/19776-1/V3.2/Part01/concepts.html#ProtoInstanceAndFieldValueStatement</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ExternProtoDeclare'">
                            <xsl:text>http://www.web3d.org/files/specifications/19776-1/V3.2/Part01/concepts.html#ExternProtoDeclareStatementSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='field'">
                            <xsl:text>http://www.web3d.org/files/specifications/19776-1/V3.2/Part01/concepts.html#PrototypeAndFieldDeclarationSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='fieldValue'">
                            <xsl:text>http://www.web3d.org/files/specifications/19776-1/V3.2/Part01/concepts.html#ProtoInstanceAndFieldValueStatement</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='IS'">
                            <xsl:text>http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/concepts.html#PROTOdefinitionsemantics</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='connect'">
                            <xsl:text>http://www.web3d.org/files/specifications/19776-1/V3.2/Part01/concepts.html#IS_ConnectStatementSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='IMPORT'">
                            <xsl:text>http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/components/networking.html#IMPORTStatement</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='EXPORT'">
                            <xsl:text>http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/components/networking.html#EXPORTStatement</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ROUTE'">
                            <xsl:text>http://www.web3d.org/files/specifications/19775-1/V3.3/Part01/concepts.html#Routes</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$x3dSpecificationUrlBase"/>
                            <xsl:value-of select="$x3dSpecificationNodeIndex"/>
                            <xsl:text>#</xsl:text>
                            <xsl:value-of select="@name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
		<tr align="left">
			<td bgcolor="white" valign="top">
				<xsl:choose>
					<xsl:when test="@icon">
                                            <xsl:element name="a">
                                                    <xsl:attribute name="href">
                                                            <xsl:value-of select="$urlReference"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="target">
                                                            <xsl:text>_blank</xsl:text>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="title">
                                                            <xsl:text>X3D Specification or alternate reference</xsl:text>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="alt">
                                                            <xsl:text>X3D Specification or alternate reference</xsl:text>
                                                    </xsl:attribute>
                                                    <xsl:element name="img">
                                                            <xsl:attribute name="src"><xsl:value-of select="@icon"/></xsl:attribute>
                                                            <xsl:attribute name="alt"><xsl:value-of select="@name"/></xsl:attribute>
                                                            <xsl:attribute name="valign"><xsl:text>top</xsl:text></xsl:attribute>
                                                    </xsl:element>
                                            </xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&#160;&#160;&#160;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>&#10;</xsl:text>
				<xsl:if test="string-length(@name) > 18">
					<br /><!-- skip to next line, below icon -->
				</xsl:if>
				<b valign="top">
                                    <xsl:element name="font">
                                        <xsl:attribute name="color">navy</xsl:attribute>
                                        <xsl:attribute name="valign">top</xsl:attribute>
                                        <xsl:choose>
                                          <xsl:when test="string-length(@name) > 30">
                                                <xsl:attribute name="size">-1</xsl:attribute>
                                          </xsl:when>
                                          <xsl:when test="string-length(@name) > 20">
                                                <xsl:attribute name="size">0</xsl:attribute>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <xsl:attribute name="size">+1</xsl:attribute>
                                          </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:element name="a">
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$urlReference"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="target">
                                                    <xsl:text>_blank</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="title">
                                                    <xsl:text>X3D Specification or alternate reference</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                    <xsl:text>X3D Specification or alternate reference</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="valign">top</xsl:attribute>
                                            <xsl:value-of select="@name"/>
                                        </xsl:element>
                                    </xsl:element>
				</b>
			</td>

			<!--m17 add here "width="600"" for word wrap	width="600"-->
			<td bgcolor="white" valign="top">
				<xsl:text>&#10;</xsl:text>
				<b>
					<font color="navy">
					<!--	<xsl:value-of select="@tooltip"/> -->
						<!-- recursive colorizing and bolding of Hint: and Warning: keywords -->
						<xsl:call-template name="highlight-HintsWarnings">
							<xsl:with-param name="inputString" select="@tooltip"/>
						</xsl:call-template>
					</font>
				</b>
			</td>
                        
                        <!-- Links to X3D Schema and X3D DTD documentation -->
			<td bgcolor="white" valign="middle" align="middle">
                            <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;validation: </xsl:text>
                            <br />
                            <!-- http://www.web3d.org/specifications/X3dSchemaDocumentation3.3/x3d-3.3_Layer.html -->
                            <xsl:variable name="schemaDocumentationUrl">
                                <xsl:text>http://www.web3d.org/specifications/X3dSchemaDocumentation</xsl:text>
                                <xsl:value-of select="$version"/>
                                <xsl:text>/x3d-</xsl:text>
                                <xsl:value-of select="$version"/>
                                <xsl:text>_</xsl:text>
                                <xsl:value-of select="@name"/>
                                <xsl:text>.html</xsl:text>
                            </xsl:variable>
                            <xsl:element name="a">
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="title">
                                    <xsl:value-of select="@name"/>
                                    <xsl:text> documentation, X3D Schema</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                    <xsl:value-of select="@name"/>
                                    <xsl:text> documentation, X3D Schema</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$schemaDocumentationUrl"/>
                                </xsl:attribute>
                                <xsl:text disable-output-escaping="yes">Schema</xsl:text>
                            </xsl:element>
                            <xsl:text disable-output-escaping="yes">,&amp;nbsp;</xsl:text>
                            <!-- http://www.web3d.org/specifications/X3dDoctypeDocumentation3.3.html#AudioClip -->
                            <xsl:variable name="doctypeDocumentationUrl">
                                <xsl:text>http://www.web3d.org/specifications/X3dDoctypeDocumentation</xsl:text>
                                <xsl:value-of select="$version"/>
                                <xsl:text>.html#</xsl:text>
                                <xsl:value-of select="@name"/>
                            </xsl:variable>
                            <xsl:element name="a">
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="title">
                                    <xsl:value-of select="@name"/>
                                    <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                    <xsl:value-of select="@name"/>
                                    <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$doctypeDocumentationUrl"/>
                                </xsl:attribute>
                                <xsl:text disable-output-escaping="yes">DOCTYPE</xsl:text>
                            </xsl:element>
			</td>

		</tr>

		<xsl:apply-templates select="attribute"/>
		
	</xsl:template>

	<!-- ****** "attribute" element****************************************************** -->
	<xsl:template match="attribute">

		<!-- error checking -->
		<xsl:if test="contains(@tooltip,'[') and not(contains(@tooltip,']'))">
			<xsl:message>
				<xsl:text>[Error] element '</xsl:text>
				<xsl:value-of select="../@name"/>
				<xsl:text>' attribute '</xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>' has unmatched [ bracket</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:if test="contains(@tooltip,']') and not(contains(@tooltip,'['))">
			<xsl:message>
				<xsl:text>[Error] element '</xsl:text>
				<xsl:value-of select="../@name"/>
				<xsl:text>' attribute '</xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>' has unmatched ] bracket</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:variable name="signatureSummary" select="substring-before(@tooltip,']')"/>
		<xsl:if test="$signatureSummary and not(@name='DEF') and not(@name='USE') and not(@name='class') and not(@name='containerField') and not(../@name='component') and not(../@name='connect') and not(../@name='field') and not(../@name='fieldValue') and not(../@name='meta') and not(../@name='IMPORT') and not(../@name='EXPORT') and not(../@name='ExternProtoDeclare') and not(../@name='ProtoDeclare') and not(../@name='ProtoInstance') and not(../@name='ROUTE') and not(../@name='unit')and not(../@name='X3D') and not(../@name='XvlShell')">
			<xsl:if test="not(contains($signatureSummary,'initializeOnly')) and not(contains($signatureSummary,'inputOnly')) and not(contains($signatureSummary,'outputOnly')) and not(contains($signatureSummary,'inputOutput'))">
				<xsl:message>
					<xsl:text>[Error] element '</xsl:text>
					<xsl:value-of select="../@name"/>
					<xsl:text>' attribute '</xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text>' is missing accessType information</xsl:text>
				</xsl:message>
			</xsl:if>
			<!-- note that character entities are replaced during parsing prior to applying this test, so no ampersands are included -->
			<xsl:if test="not(contains($signatureSummary,'SF')) and not(contains($signatureSummary,'MF')) and not(contains($signatureSummary,'CDATA')) and not(contains($signatureSummary,'IDREF')) and not(contains($signatureSummary,'NMTOKEN')) and not(contains($signatureSummary,'(') and contains($signatureSummary,')'))">
				<xsl:message>
					<xsl:text>[Error] element '</xsl:text>
					<xsl:value-of select="../@name"/>
					<xsl:text>' attribute '</xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text>' is missing type information</xsl:text>
				</xsl:message>
			</xsl:if>
		</xsl:if>

		<!-- new row  width="800"-->
		<tr align="left">
				
			<td bgcolor="#eeffee" align="left" valign="top">
				<!-- &#160;&#160;&#160;&#160;&#160;&#160; <xsl:text>&#160;</xsl:text>-->
				
				<!-- &#160; = &nbsp; -->
				<xsl:if test="@name">
                                    <b>
					<xsl:element name="font">
						<xsl:attribute name="color">black</xsl:attribute>
						<xsl:choose>
						  <xsl:when test="string-length(@name) > 20">
							<xsl:attribute name="size">-1</xsl:attribute>
						  </xsl:when>
						  <xsl:when test="string-length(@name) > 15">
							<xsl:attribute name="size">0</xsl:attribute>
						  </xsl:when>
						  <xsl:when test="string-length(@name) > 10">
							<xsl:attribute name="size">1</xsl:attribute>
						  </xsl:when>
						  <xsl:otherwise>
							<xsl:attribute name="size">2</xsl:attribute>
						  </xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="@name"/>
					</xsl:element>
                                    </b>
				</xsl:if>
			</td>

			<!-- TODO m17 add here "width="600"" for word wrap 	width="600"-->
			<td bgcolor="#eeffee" colspan="2">
				<xsl:variable name="AttributeSpecification">
                                    <xsl:choose>
                                        <xsl:when test="contains(@tooltip,']')">
                                            <xsl:variable name="initialSubstringBeforeSquareBracket">
                                                <xsl:choose>
                                                    <!-- handle case where nested ] characters appear, such as case when outputOnly has range restriction, e.g. LoadSensor progress -->
                                                    <xsl:when test="contains(@tooltip,'#FIXED &#34;&#34;]')">
                                                        <xsl:value-of select="substring-before(@tooltip,'#FIXED &#34;&#34;]')"/>
                                                        <xsl:text disable-output-escaping="yes">#FIXED &#34;&#34;</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                         <xsl:value-of select="substring-before(@tooltip,']')"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:value-of select="normalize-space($initialSubstringBeforeSquareBracket)"/>
                                            <xsl:text>]</xsl:text>
                                            <!-- also get attribute value bounds [0,infinity) [0,1] etc.,  if any -->
                                            <xsl:variable name="nextSubstring">
                                                <xsl:value-of select="normalize-space(substring-after(@tooltip,concat($initialSubstringBeforeSquareBracket,']')))"/>
                                            </xsl:variable>
                                            <!-- attribute quadruple tooltip diagnostics
                                            <xsl:if test="(@name='geoSystem')">
                                                <xsl:message>
                                                    <xsl:value-of select="../@name"/>
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select="@name"/>
                                                    <xsl:text> $initialSubstringBeforeSquareBracket=</xsl:text>
                                                    <xsl:value-of select="$initialSubstringBeforeSquareBracket"/>
                                                    <xsl:text>, $nextSubstring=</xsl:text>
                                                    <xsl:value-of select="$nextSubstring"/>
                                                </xsl:message>
                                            </xsl:if>
                                            -->
                                            <xsl:if test="starts-with(normalize-space($nextSubstring),'(') or starts-with(normalize-space($nextSubstring),'[')">
                                                <xsl:choose>
                                                    <xsl:when test="contains($nextSubstring,' or -1.')">
                                                        <xsl:value-of select="normalize-space(substring-before($nextSubstring,' or -1.'))"/>
                                                    <xsl:text> or -1.</xsl:text>
                                                    </xsl:when>
                                                    <!-- bound ] more likely to precede parenthetical ), other order leads to problems.  avoid [bracketed information] within tooltips. -->
                                                    <xsl:when test="contains($nextSubstring,']')">
                                                        <xsl:text> </xsl:text>
                                                        <xsl:value-of select="normalize-space(substring-before($nextSubstring,']'))"/>
                                                    <xsl:text>]</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="contains($nextSubstring,')')">
                                                        <xsl:text> </xsl:text>
                                                        <xsl:value-of select="normalize-space(substring-before($nextSubstring,')'))"/>
                                                    <xsl:text>)</xsl:text>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="normalize-space(@tooltip)"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
				</xsl:variable>
                                <!-- quadruple diagnostics
                                <xsl:if test="(@name='geoSystem')">
                                    <xsl:message>
                                        <xsl:value-of select="../@name"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="@name"/>
                                        <xsl:text> normalize-space($AttributeSpecification)=</xsl:text>
                                        <xsl:value-of select="normalize-space($AttributeSpecification)"/>
                                    </xsl:message>
                                </xsl:if>
                                -->
                                <xsl:choose>
                                    <!-- accessType bookmark -->
                                    <xsl:when test="contains($AttributeSpecification,'accessType')">
                                        <xsl:variable name="initialString"   select="substring-before($AttributeSpecification,'accessType')"/>
                                        <xsl:variable name="accessTypeValue" select="substring-before(substring-after($AttributeSpecification,'accessType '),',')"/>
                                        
                                        <b>
                                            <xsl:value-of select="$initialString"/>
                                            <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                    <xsl:text>#accessType</xsl:text>
                                                </xsl:attribute>
                                                <xsl:text>accessType </xsl:text>
                                                <xsl:value-of select="$accessTypeValue"/>
                                            </xsl:element>
                                            <xsl:text>, </xsl:text>
                                            <!-- now get type; watch out for attributes named 'type' by first skipping after 'accessType'  -->
                                            <xsl:variable name="typeValue" select="substring-before(substring-after(substring-after($AttributeSpecification,'accessType'),'type '),' ')"/>
                                            
                                            <!-- quadruple diagnostics
                                            <xsl:if test="(@name='geoSystem')">
                                                <xsl:message>
                                                    <xsl:text>$accessTypeValue=</xsl:text>
                                                    <xsl:value-of select="$accessTypeValue"/>
                                                </xsl:message>
                                                <xsl:message>
                                                    <xsl:text>$typeValue=</xsl:text>
                                                    <xsl:value-of select="$typeValue"/>
                                                </xsl:message>
                                            </xsl:if>
                                            -->
                                            <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                    <xsl:text>#type</xsl:text>
                                                </xsl:attribute>
                                                <xsl:text>type </xsl:text>
                                                <xsl:value-of select="$typeValue"/>
                                            </xsl:element>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="normalize-space(substring-after($AttributeSpecification,$typeValue))"/>
                                        </b>
                                        <br />
                                    </xsl:when>
                                    <xsl:when test="$AttributeSpecification">
                                        <b>
                                            <xsl:value-of select="normalize-space($AttributeSpecification)"/>
                                        </b>
                                        <br />
                                    </xsl:when>
                                </xsl:choose>
                                
				<xsl:variable name="AttributeTooltip">
					<xsl:value-of select="substring-after(normalize-space(@tooltip),normalize-space($AttributeSpecification))"/>
				</xsl:variable>
                                <!-- quadruple diagnostics
                                <xsl:if test="(@name='geoSystem')">
                                    <xsl:message>
                                        <xsl:text>$tooltip=</xsl:text>
                                        <xsl:value-of select="normalize-space(@tooltip)"/>
                                    </xsl:message>
                                    <xsl:message>
                                        <xsl:value-of select="../@name"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="@name"/>
                                        <xsl:text> normalize-space($AttributeTooltip)=</xsl:text>
                                        <xsl:value-of select="normalize-space($AttributeTooltip)"/>
                                    </xsl:message>
                                    <xsl:message>
                                        <xsl:text>================================</xsl:text>
                                    </xsl:message>
                                </xsl:if>
                                -->
                                <!-- recursive colorizing and bolding of Hint: and Warning: keywords -->
                                <xsl:call-template name="highlight-HintsWarnings">
                                    <xsl:with-param name="inputString" select="$AttributeTooltip"/>
                                </xsl:call-template>
			</td>

			<xsl:apply-templates/>

		</tr>
		
	</xsl:template>

<xsl:template name="highlight-HintsWarnings"> <!-- &#38; is &amp; -->
  <xsl:param name="inputString" select="0"/>
  <!--	
       <xsl:text>found... </xsl:text>
        <xsl:text>//###amp###&#10;</xsl:text>
	<xsl:text>### inputString received: </xsl:text>
	<xsl:value-of select="$inputString"/>
	<xsl:text>&#10;</xsl:text> 
  -->
  <xsl:choose>
    <!-- [X3D 3.1] prefix -->
    <xsl:when test="starts-with($inputString,'[X3D 3.1]')">
      <font color="black"><xsl:text>[X3D 3.1]</xsl:text></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'[X3D 3.1]')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- [X3D 3.2] prefix -->
    <xsl:when test="starts-with($inputString,'[X3D 3.2]')">
      <font color="black"><xsl:text>[X3D 3.2]</xsl:text></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'[X3D 3.2]')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- [X3D 3.3] prefix -->
    <xsl:when test="starts-with($inputString,'[X3D 3.3]')">
      <font color="black"><xsl:text>[X3D 3.3]</xsl:text></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'[X3D 3.3]')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Interchange profile hint English -->
    <xsl:when test="contains($inputString,'Interchange profile hint:')    
                    and not(contains(substring-before($inputString,'Interchange profile hint:'),   'Hint:'))   
                    and not(contains(substring-before($inputString,'Interchange profile hint:'),   'Warning:'))
                    and not(contains(substring-before($inputString,'Interchange profile hint:'),   'Example:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Interchange profile hint:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <xsl:if test="string-length(normalize-space(substring-before($inputString,'Interchange profile hint:'))) > 0">
          <br />
      </xsl:if>
      <font color="#553377"><b><xsl:text>Interchange profile hint:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Interchange profile hint:')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="contains($inputString,'Hint for VRML97:')    and not(contains(substring-before($inputString,'Hint:'),   'Warning:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Hint for VRML97:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Hint for VRML97:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Hint for VRML97:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Examples: English -->
    <xsl:when test="contains($inputString,'Example:')    and not(contains(substring-before($inputString,'Example:'),   'Examples:')) and not(contains(substring-before($inputString,'Example:'),   'Hint:')) and not(contains(substring-before($inputString,'Example:'),   'Warning:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Example:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Example:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Example:')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="contains($inputString,'Examples:')    and not(contains(substring-before($inputString,'Examples:'),   'Example:')) and not(contains(substring-before($inputString,'Examples:'),   'Hint:')) and not(contains(substring-before($inputString,'Examples:'),   'Warning:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Examples:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Examples:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Examples:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Hint: English -->
    <xsl:when test="contains($inputString,'Hint:')    and not(contains(substring-before($inputString,'Hint:'),   'Warning:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Hint:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Hint:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Hint:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Interchange profile hint Italian -->
    <xsl:when test="contains($inputString,'Suggerimento per il profilo Interchange:')    and not(contains(substring-before($inputString,'Interchange profile hint:'),   'Attenzione:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Suggerimento per il profilo Interchange:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#553377"><b><xsl:text>Suggerimento per il profilo Interchange:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Suggerimento per il profilo Interchange:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- hint Italian -->
    <xsl:when test="contains($inputString,'Suggerimento:')    and not(contains(substring-before($inputString,'Suggerimento:'),   'Attenzione:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Suggerimento:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Suggerimento:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Suggerimento:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- TODO m17 add here for Chinese-->
    <!-- Interchange profile hint Chinese -->
    <xsl:when test="contains($inputString,'概貌互换提示:')
        and (not(contains(substring-before($inputString,'概貌互换提示:'),   '警告:'))  and not(contains(substring-before($inputString,'概貌互换提示:'),   '提示:')))
        ">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'概貌互换提示:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#553377"><b><xsl:text>概貌互换提示:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'概貌互换提示:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- TODO m17 add here for Chinese-->
    <!-- hint Chinese -->
    <xsl:when test="contains($inputString,'提示:')    and not(contains(substring-before($inputString,'提示:'),   '警告:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'提示:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>提示:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'提示:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- hint French -->
    <xsl:when test="contains($inputString,'Conseil:') and not(contains(substring-before($inputString,'Conseil:'),'Attention:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Conseil:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Conseil:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Conseil:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- hint German -->
    <xsl:when test="contains($inputString,'Hinweis:') and not(contains(substring-before($inputString,'Nota:'),'Warnung:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Hinweis:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Hinweis:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Hinweis:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- hint Portuguese -->
    <xsl:when test="contains($inputString,'Dica:') and not(contains(substring-before($inputString,'Dica:'),'Aten&#231;&#227;o:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Dica:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Dica:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Dica:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- hint Spanish -->
    <xsl:when test="contains($inputString,'Nota:') and not(contains(substring-before($inputString,'Nota:'),'Advertencia:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Nota:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Nota:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Nota:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning English -->
    <xsl:when test="contains($inputString,'Warning:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Warning:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Warning:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Warning:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning Italian -->
    <xsl:when test="contains($inputString,'Attenzione:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Attenzione:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Attenzione:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Attenzione:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- TODO m17 add here for Chinese-->
    <!-- Warning Chinese -->
    <xsl:when test="contains($inputString,'警告:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'警告:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>警告:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'警告:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning French -->
    <xsl:when test="contains($inputString,'Attention:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Attention:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Attention:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Attention:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning German -->
    <xsl:when test="contains($inputString,'Warnung:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Warnung:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Warnung:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Warnung:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning Portuguese -->
    <xsl:when test="contains($inputString,'Aten&#231;&#227;o:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Aten&#231;&#227;o:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Aten&#231;&#227;o:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Aten&#231;&#227;o:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning Spanish -->
    <xsl:when test="contains($inputString,'Advertencia:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:value-of select="substring-before($inputString,'Advertencia:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Advertencia:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputString" select="substring-after($inputString,'Advertencia:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- no more prefixes to highlight -->
    <xsl:otherwise>
        <!-- create hyperlinks out of urls -->
        <xsl:call-template name="hyperlink">
            <xsl:with-param name="string" select="$inputString"/>
        </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
    
    <xsl:template name="hyperlink">
        <!-- Search and replace urls in text:  adapted (with thanks) from 
            http://www.dpawson.co.uk/xsl/rev2/regex2.html#d15961e67 by Jeni Tennison using url regex (http://[^ ]+) -->
        <!-- Justin Saunders http://regexlib.com/REDetails.aspx?regexp_id=37 url regex ((mailto:|(news|(ht|f)tp(s?))://){1}\S+) -->
        <xsl:param name="string" select="string(.)"/>
        <!-- wrap html text string with spaces to ensure no mismatches occur -->
        <xsl:variable name="spacedString">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$string"/>
            <xsl:text> </xsl:text>
        </xsl:variable>
        <!--
        <xsl:if test="contains($spacedString,'http')">
            <xsl:message>
                <xsl:text>spacedString=</xsl:text>
                <xsl:value-of select="normalize-space($spacedString)"/>
            </xsl:message>
        </xsl:if>
        -->
        <!-- First: find and link url values.  Avoid matching encompassing quote marks. -->
        <xsl:analyze-string select="$spacedString" regex='(mailto:|((news|http|https|sftp)://)[a-zA-Z0-9._%+-/#()]+)'>
            <xsl:matching-substring>
                <!-- diagnostic
                <xsl:if test="contains($spacedString,'url1')">
                    <xsl:message>
                        <xsl:text>*regex match success:</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:message>
                </xsl:if>
                -->
                <xsl:element name="a">
                    <xsl:attribute name="target">
                        <xsl:text>_blank</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                        <xsl:if test="(contains(.,'youtube.com') or contains(.,'youtu.be')) and not(contains(.,'rel='))">
                            <!-- prevent advertising other YouTube videos when complete -->
                            <xsl:text disable-output-escaping="yes">&amp;rel=0</xsl:text>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            <!-- <xsl:text> </xsl:text> -->
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <!-- diagnostic
                <xsl:if test="contains($spacedString,'url1')">
                    <xsl:message>
                        <xsl:text>**regex match failure:</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:message>
                </xsl:if>
                -->
                <!-- avoid returning excess whitespace -->
                <xsl:choose>
                    <xsl:when test="(string-length(.) > 0) and (string-length(normalize-space(.)) = 0)">
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space(.)) > 0">
                        <xsl:value-of select="." />
                    </xsl:when>
                </xsl:choose>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

</xsl:stylesheet>

