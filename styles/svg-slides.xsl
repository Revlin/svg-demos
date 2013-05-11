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
	<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" 
		  width="640" height="360" onclick="rotateSlide();">
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
		<g id="slide-0" /><xsl:apply-templates select="PLANT" />
	</defs>
					
	<g style="clip-path:url(#clip-top)">
		<g>
			<rect x="10" y="20" width="620" height="320" fill="#777777">
				<animateColor id="shiftTopDark"
				  attributeName="fill"
				  from="#777777"
				  to="#111111"
				  dur="1s" 
				  begin="shiftTop1.begin" />
				<animateColor id="shiftTopLight"
				  attributeName="fill"
				  from="#111111"
				  to="#777777"
				  dur="1s" 
				  begin="shiftTopDark.end" />
			</rect>
			<use id="slide-display1" xlink:href="#slide-0" x="10" y="20" />
		        <animateTransform id="shiftTop1"
					  attributeName="transform"
                      attributeType="XML"
                      type="translate"
					  additive="sum"
                      from="0"
                      to="320 55"
                      dur="1s" />
		        <animateTransform id="shiftTop2"
					  attributeName="transform"
                      attributeType="XML"
                      type="scale"
					  additive="sum"
                      from="1 1"
                      to="0.01, 1"
                      dur="1s" />
		        <animateTransform  id="shiftTop3"
					  attributeName="transform"
                      attributeType="XML"
                      type="skewY"
					  additive="sum"
                      from="0"
                      to="-12.5"
                      dur="1s"
					  onend="changeSlide('slide-display1','slide-display2');" />
		        <animateTransform 
					  attributeName="transform"
                      attributeType="XML"
                      type="translate"
					  additive="sum"
                      from="320 -55"
                      to="0"
                      dur="1s" 
					  begin="shiftTop1.end" />
		        <animateTransform attributeName="transform"
                      attributeType="XML"
                      type="scale"
					  additive="sum"
                      from="0.01, 1"
                      to="1 1"
                      dur="1s"
					  begin="shiftTop2.end" />
		        <animateTransform attributeName="transform"
                      attributeType="XML"
                      type="skewY"
					  additive="sum"
                      from="12.5"
                      to="0"
                      dur="1s"
					  begin="shiftTop3.end" />
		</g>
	</g>
	<clipPath id="clip-top">
		<rect stroke="#FFFFFF" fill="none"
		  x="0" y="0" width="100%" height="50%" />
	</clipPath>
	  
	<g style="clip-path:url(#clip-bottom)">
		<g>
			<rect x="10" y="20" width="620" height="320" fill="#777777">
				<animateColor id="shiftBottomDark"
				  attributeName="fill"
				  from="#777777"
				  to="#111111"
				  dur="1s" 
				  begin="shiftTop1.begin" />
				<animateColor id="shiftBottomLight"
				  attributeName="fill"
				  from="#111111"
				  to="#777777"
				  dur="1s" 
				  begin="shiftBottomDark.end" />
			</rect>
			<use id="slide-display2" xlink:href="#slide-0" x="10" y="20" />
		        <animateTransform id="shiftBot1"
					  attributeName="transform"
                      attributeType="XML"
                      type="translate"
					  additive="sum"
                      from="0"
                      to="320 -55.5"
                      dur="1s" />
		        <animateTransform id="shiftBot2"
					  attributeName="transform"
                      attributeType="XML"
                      type="scale"
					  additive="sum"
                      from="1 1"
                      to="0.01, 1"
                      dur="1s" />
		        <animateTransform  id="shiftBot3"
					  attributeName="transform"
                      attributeType="XML"
                      type="skewY"
					  additive="sum"
                      from="0"
                      to="12.5"
                      dur="1s" />
		        <animateTransform
					  attributeName="transform"
                      attributeType="XML"
                      type="translate"
					  additive="sum"
                      from="320 55"
                      to="0"
                      dur="1s"
					  begin="shiftBot1.end" />
		        <animateTransform attributeName="transform"
                      attributeType="XML"
                      type="scale"
					  additive="sum"
                      from="0.01, 1"
                      to="1 1"
                      dur="1s"
					  begin="shiftBot2.end" />
		        <animateTransform attributeName="transform"
                      attributeType="XML"
                      type="skewY"
					  additive="sum"
                      from="-12.5"
                      to="0"
                      dur="1s"
					  begin="shiftBot3.end" />
		</g>
	</g>
	<clipPath id="clip-bottom">
		<rect stroke="#FFFFFF" fill="none"
		  x="0" y="50%" width="100%" height="50%" />
	</clipPath>

	<script type="text/ecmascript" xlink:href="scripts/slides.js"/>
	</xsl:template>

	<xsl:template match="PLANT">
	<g id="slide-{position()}">
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
