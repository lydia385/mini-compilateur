flex projet.l
bison -d projetSynt_.y
gcc lex.yy.c projetSynt_.tab.c  -o pp.exe
pp.exe youcef.txt