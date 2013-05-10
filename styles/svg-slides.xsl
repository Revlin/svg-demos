<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink">
	<!-- Some global XSLT vars -->
	<xsl:variable name="lowercaseNoSpace" select="'_abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="lowercaseSpace" select="' abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercaseSpace" select="' ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<xsl:template match="/">
	<svg width="640" height="360"
	  xmlns="http://www.w3.org/2000/svg"
	  xmlns:xlink="http://www.w3.org/1999/xlink">
		<xsl:comment>This series of slides was produced by the transformation stylesheet: svg-slides.xsl</xsl:comment> 
		<xsl:apply-templates />
	</svg>
	</xsl:template>

	<xsl:template match="CATALOG">
		<xsl:comment>This is the title of our Catalog</xsl:comment>
		<title>PLANTS!</title>
		<rect x="0" y="0" width="100%" height="100%" fill="#000000" />
		<text x="320" y="20" text-anchor="middle"
		  font-family="sans-serif" font-size="24" fill="#00FF00">
			PLANTS!
		</text>
		<xsl:comment>Imported SVG plant drawing as intro</xsl:comment>
		<use xlink:href="bloodroot.svg#path2311" x="0" y="20" stroke="#00FF00" />
		<defs>
			<xsl:apply-templates select="PLANT" />
		</defs>
		<use id="slide-display" 
		  xlink:href="#slide-1" x="10" y="20" 
		  onclick="changeSlide(document.getElementById('slide-display'));" />

		<script type="text/ecmascript" xlink:href="scripts/slides.js"></script>
	</xsl:template>

	<xsl:template match="PLANT">
		<g id="slide-{position()}">
			<rect x="0" y="0" width="620" height="320" fill="#777777" />
			<xsl:apply-templates select="COMMON" />
			<text x="310" y="60" text-anchor="start" 
			  font-family="sans-serif" font-size="14" fill="#FFFFFF">
				<tspan font-size="2em"> 
					<xsl:value-of select="COMMON" />
				</tspan>
				<tspan x="320" dy="30" font-style="italic">
					<xsl:value-of select="BOTANICAL" />
				</tspan>
				<tspan x="320" dy="30">
					Zone <xsl:value-of select="ZONE" />
				</tspan>
			</text>	
		</g>
	</xsl:template>

	<xsl:template match="COMMON">
		<xsl:variable name="common" select="translate(string(), $uppercaseSpace, $lowercaseNoSpace)" />
	    <image xlink:href="images/plant-{$common}.png" x="10" y="20" width="300" height="300" />
	</xsl:template>

</xsl:stylesheet>
