<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!--List of keys -->
  <xsl:key name='actor_by_id' match='actor' use='@actor_id'/>
  <xsl:key name='director_by_id' match='director' use='@director_id'/>
  <xsl:key name='user_by_id' match='user' use='@user_id'/>
  
  
  <!-- Table header -->
  <xsl:variable name='table_header'>
    <tr>
      <th>Actor</th>
      <th>Character name</th>
    </tr>
  </xsl:variable>
  
  
  <!-- XPath vyrazy, ktore su sice spravne, ale v XSLT nefunguju -->
  <!-- Vrati film, ktory zarobil najviac:
          //movie[not(..//movie//gross/number(translate(.," ,$","")) > .//gross/number(translate(.," ,$","")))]/title -->
  
  <!-- Vrati film, s najvacsim poctom recenzii:
          //movie[not(count(reviews/review) < //movie/reviews/count(review))]/title/text() -->
  
  
  
  <!-- Hlavny template -->
  <xsl:template match="/">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>

    <html>
      <head>
        <title>Movie database</title>
        <link rel="stylesheet" href="style.css"/>
        <link rel="stylesheet" media="print" href="print_style.css"/>
      </head>
      
      <body>
        <!-- Vytvori header -->
        <xsl:element name='div'>
          <xsl:attribute name='class'>header</xsl:attribute>
          <h1>Movie database</h1>
          <p>Reviews, ratings &amp; movie info</p>
        </xsl:element>
        
        <!-- Vyuzitie atributu "mode", na tuto cast budeme aplikovat aj iny template -->
        <xsl:element name='div'>
          <xsl:attribute name='class'>movie_list</xsl:attribute>  
          <xsl:apply-templates select='/movie_database/movies/movie' mode='info'/>
        </xsl:element>
        
        <!-- Vyuzitie atributu "mode", novy template pouzivame na rovnaku cast ako predtym -->
        <xsl:element name='div'>
          <xsl:attribute name='class'>trivia</xsl:attribute>
          <h2>Random trivia</h2>
          <xsl:apply-templates select='/movie_database/movies/movie' mode='trivia'/>
        </xsl:element>
        
      </body>
    </html>
  </xsl:template>

  
  
  <!-- Zoznam filmov -->
  <xsl:template match='/movie_database/movies/movie' mode='info'>
    
    <!-- Zavola template print title s parametrom "title" -->
    <xsl:element name='div'>
      <xsl:attribute name='class'>movie</xsl:attribute>
      <h2>
        <xsl:call-template name='print_title'>
          <xsl:with-param name='title' select='title'/>
        </xsl:call-template>
      </h2>

      <!-- Vytvori div elementy s atributom class -->
      <xsl:element name='div'>
        <xsl:attribute name='class'>directors</xsl:attribute>
        <p>
          Directed by <xsl:call-template name='print_directors'/>
        </p>
      </xsl:element> 
      
      <xsl:element name='div'>
        <xsl:attribute name='class'>description</xsl:attribute>
        <p>
          <xsl:value-of select='description'/>
        </p>       
      </xsl:element>

      
      <!-- div element pre herecke obsadenie filmu -->
      <xsl:element name='div'>
        <xsl:attribute name='class'>cast</xsl:attribute>
        <xsl:apply-templates select='cast'/>
      </xsl:element>

      <!-- div element pre recenzie na dany film -->
      <xsl:element name='div'>
        <xsl:attribute name='class'>reviews</xsl:attribute>
        <xsl:apply-templates select='reviews'/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  
  
  <!-- Vypise nazov filmu -->
  <xsl:template name='print_title'>
    
    <xsl:param name='title'/>
    
    <!-- Nazvu filmu pridelime atribut movie_id -->
    <xsl:attribute name='movie_id'>
      <xsl:value-of select='@movie_id'/>
    </xsl:attribute>
    
    <xsl:value-of select='$title'/>
  </xsl:template>
  
  
  
  <!-- Obsadenie -->
  <xsl:template match='cast'>

    <h3>Cast</h3>
    
    <!-- Vytvorime tabulku s class atributom cast_table -->
    <table>
      <xsl:attribute name='class'>cast_table</xsl:attribute>
      
      <!-- Skopirujeme header tabulky -->
      <xsl:copy-of select='$table_header'/>
      
      <!-- V cykle vypiseme meno postavy a herca, ktory ju hra -->
      <xsl:for-each select='character'>
        <tr>
          <td>
            <xsl:value-of select="key('actor_by_id', @actor_id)/name"/>
          </td>
          <td>
            <xsl:value-of select='character_name'/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  
  
  
  <!-- Reziseri -->
  <xsl:template name='print_directors'>    
    
    <!-- Najde reziserov podla ich id a v cykle ich vypise -->
    <xsl:variable name='dir' select='@director_id'/>   
    <xsl:for-each select='//directors/director[contains($dir, @director_id)]/name'>
      <xsl:value-of select='.'/>
      
      <!-- Oddeli jednotlivych reziserov znakmi "," a "&"-->
      <xsl:choose>
        <xsl:when test='position() &lt; last()-1'>
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:when test='position()=last()-1'>
          <xsl:text> &amp; </xsl:text>   
        </xsl:when>
      </xsl:choose>
      
    </xsl:for-each>    
  </xsl:template>

  
  
  <!-- Recenzie -->
  <xsl:template match='reviews'>

    <h3>Reviews</h3>
    
    <!-- Zoznam jednotlivych recenzii -->
    <xsl:for-each select='review'>
      <xsl:element name='div'>
        <xsl:attribute name='class'>review</xsl:attribute>
        
        <!-- Prida atribut user_id k recenzii -->
        <xsl:attribute name='user_id'>
          <xsl:value-of select='@user_id'/>
        </xsl:attribute>
          
        <!-- Vypise meno autora recenzie a rating -->
        <xsl:element name='review_head'>
          <xsl:value-of select="key('user_by_id', @user_id)/username"/>     
          <xsl:if test="@rating">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="@rating"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
          <xsl:text>:  </xsl:text>
        </xsl:element>
        
        <!-- Vypise text recenzie -->
        <xsl:element name='review_text'>
          <xsl:value-of select="."/>
        </xsl:element>
        <br/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  
  
  <!-- Random zaujmavosti o kazdom z filmov -->
  <xsl:template match='/movie_database/movies/movie' mode='trivia'>

    <xsl:element name='div'>
      <xsl:attribute name='class'>movie_trivia</xsl:attribute>

      <!-- Vypise nazov filmu a prida k nemu movie_id -->
      <xsl:element name='div'>
        <xsl:attribute name='class'>movie_title</xsl:attribute>
        <h4>
          <xsl:attribute name='movie_id'>
            <xsl:value-of select='@movie_id'/>
          </xsl:attribute>
          <xsl:value-of select='title'/>
        </h4>
      </xsl:element>

      <!-- Vypise zoznam faktov o danom filme -->
      <xsl:element name='div'>
        <xsl:attribute name='class'>trivia_list</xsl:attribute>
        <ul>
          <xsl:for-each select='trivia'>
            <li>
              <xsl:value-of select='.'/>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
