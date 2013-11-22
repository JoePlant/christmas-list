rem @echo off
set people=people.xml
set links=links.xml

if EXIST Working goto Working_exists
mkdir Working
:Working_exists

set nxslt=..\lib\nxslt\nxslt.exe
set graphviz=..\lib\GraphViz-2.30.1\bin
set dotml=..\lib\dotml-1.4

@echo === Normalise ===
%nxslt% %people% StyleSheets\render-list.xslt -o Working\render.xml 
%nxslt% Working\render.xml StyleSheets\render-graph.xslt -o Working\graph.dotml 
%nxslt% Working\render.xml StyleSheets\render-record.xslt -o Working\record.dotml 
%nxslt% Working\render.xml StyleSheets\render-node.xslt -o Working\node.dotml 
%nxslt% Working\graph.dotml %dotml%\dotml2dot.xsl -o Working\graph.gv 
%nxslt% Working\record.dotml %dotml%\dotml2dot.xsl -o Working\record.gv 
%nxslt% Working\node.dotml %dotml%\dotml2dot.xsl -o Working\node.gv
%graphviz%\dot.exe -Tpng  Working\graph.gv  -o "Working\graph.png"
%graphviz%\dot.exe -Tpng  Working\record.gv  -o "Working\record.png"
%graphviz%\dot.exe -Tpng  Working\node.gv  -o "Working\node.png"

pause