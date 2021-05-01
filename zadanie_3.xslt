<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  

  
  <xsl:template match="/">
     
    <svg viewBox="0 0 800 800" role="img" version="1.1" baseProfile="full">
      
      <title>WPUB 3. zadanie - stĺpcový graf</title>
      <desc>
        Rozpočet a zárobok vybraných filmov.
      </desc>
      
      <!-- Osi grafu a ich popis -->
      <g style="font-family:arial;" font-size="18" font-weight="bold">
        
        <!-- os Y -->
        <g  stroke="#000" stroke-width="1" transform="translate(130, 100)">
          <line x1="0" x2="0" y1="0" y2="550"></line>
	      </g>
	      
        <!-- Popis osi Y -->
        <text x="-100" y="375" text-anchor="middle" dominant-baseline="middle" transform="rotate(-90, -50, 320)">
          Množstvo peňazí
        </text>
	      
        <!-- os X -->
        <g  stroke="#000" stroke-width="1" transform="translate(130, 650)">
          <line x1="0" x2="775" y1="0" y2="0"></line>
	      </g>
        
        <!-- Popis osi X -->
        <text x="500" y="740" text-anchor="middle">
          Zoznam jednotlivých filmov
        </text>
      </g> 
      
      
      <!-- Udaje v grafe -->
      <g transform="translate(25,650)" stroke="#222" stroke-width="1">
        
        <!-- Prerusovane pomocne ciary -->
        <g stroke="#ccc" stroke-dasharray="8 8">
          <line x1="105" x2="880" y1="-75" y2="-75"></line>
		      <line x1="105" x2="880" y1="-150" y2="-150"></line>
          <line x1="105" x2="880" y1="-225" y2="-225"></line>
		      <line x1="105" x2="880" y1="-300" y2="-300"></line>
          <line x1="105" x2="880" y1="-375" y2="-375"></line>
		      <line x1="105" x2="880" y1="-450" y2="-450"></line>
          <line x1="105" x2="880" y1="-525" y2="-525"></line>
        </g>
        
        <!-- Odrazky na osi Y -->
        <g>
          <line x1="95" x2="105" y1="-75" y2="-75"></line>
		      <line x1="95" x2="105" y1="-150" y2="-150"></line>
          <line x1="95" x2="105" y1="-225" y2="-225"></line>
		      <line x1="95" x2="105" y1="-300" y2="-300"></line>
          <line x1="95" x2="105" y1="-375" y2="-375"></line>
		      <line x1="95" x2="105" y1="-450" y2="-450"></line>
          <line x1="95" x2="105" y1="-525" y2="-525"></line>
        </g>
        
        <!-- Ciselne hodnoty na osi Y -->
        <g stroke-width="0" text-anchor="end" dominant-baseline="middle">
          <text x="80" y="-75" style="font-family:arial;">$ 25M</text>
		      <text x="80" y="-150" style="font-family:arial;">$ 50M</text>
		      <text x="80" y="-225" style="font-family:arial;">$ 75M</text>
		      <text x="80" y="-300" style="font-family:arial;">$ 100M</text>
		      <text x="80" y="-375" style="font-family:arial;">$ 125M</text>
          <text x="80" y="-450" style="font-family:arial;">$ 150M</text>
		      <text x="80" y="-525" style="font-family:arial;">$ 175M</text>
        </g>
      
      
        <!-- Stlpce a ich popis -->
        <xsl:for-each select="/movie_database/movies/movie">
          
          <xsl:variable name="budget" select="finance_records/budget"/>
          <xsl:variable name="gross" select="finance_records/gross"/>
          
          <!-- Stlpce grafu -->
          <rect x="{position()*150}" y="-{$budget*0.000003}" height="{$budget*0.000003}" width="45" style="fill:rgb(245,50,127);"/>
          <rect x="{position()*150+45}" y="-{$gross*0.000003}" height="{$gross*0.000003}" width="45" style="fill:rgb(50,167,245);"/>
          
          <!-- Popis stlpcov -->
          <g stroke-width="0">
            <text x="{position()*150+45}" y="15" font-size="14" style="font-family:arial;text-anchor:middle;">
              budget gross
            </text>
          
            <text x="{position()*150+45}" y="35" font-size="11" style="font-family:arial;text-anchor:middle;">
              <xsl:value-of select="title"/>
            </text>
          </g>
        </xsl:for-each>
      </g>
    </svg>
      
  </xsl:template>
  
</xsl:stylesheet>
