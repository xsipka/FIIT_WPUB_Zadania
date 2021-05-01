import lxml.etree as ET

# just some files
PATH = "D:\\Dokumenty\\STU - FIIT\\6. sem\\WEBP\\zadanie 1\\"
xml_file = "zadanie_1.xml"
xsl_file = "zadanie_3.xslt"
output = "graph.svg"

# can transform XML file into whatever (HTML, SVG) using XSLT
dom = ET.parse(PATH + xml_file)
xslt = ET.parse(PATH + xsl_file)
transform = ET.XSLT(xslt)

# creates output file
newdom = transform(dom)
newdom.write(PATH + output, pretty_print=True, xml_declaration=True,   encoding="utf-8")