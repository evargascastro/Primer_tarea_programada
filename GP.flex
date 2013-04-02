/**
 * Scanner para la gramática de la primer tarea programada del curso de Compiladores e Intérpretes.
 */
%%

%class Scanner
%unicode
//%debug
%line
%column
%type Symbol
%function nextToken

%eofval{
	return symbol(sym.EOF);
%eofval}

%{
  StringBuffer string = new StringBuffer();

  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} 

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}

Identifier = ([:jletter:] | "_" | "$") ([:jletterdigit:] | "_" | "$")*

DecIntegerLiteral = 0 | [1-9][0-9]*

%state STRING


%%

/* Palabras reservadas */

<YYINITIAL> "int"    	 	     { return symbol(sym.TINT,yytext()); }
<YYINITIAL> "String"             { return symbol(sym.TSTRING,yytext()); }
<YYINITIAL> "import"             { return symbol(sym.IMPORT,yytext()); }
<YYINITIAL> "class"              { return symbol(sym.CLASS,yytext()); }
<YYINITIAL> "public"             { return symbol(sym.PUBLIC,yytext()); }
<YYINITIAL> "static"             { return symbol(sym.STATIC,yytext()); }
<YYINITIAL> "void"               { return symbol(sym.VOID,yytext()); }
<YYINITIAL> "main"               { return symbol(sym.MAIN,yytext()); }
<YYINITIAL> "return"             { return symbol(sym.RETURN,yytext()); }
<YYINITIAL> "boolean"            { return symbol(sym.BOOL,yytext()); }
<YYINITIAL> "if"                 { return symbol(sym.IF,yytext()); }
<YYINITIAL> "else"               { return symbol(sym.ELSE,yytext()); }
<YYINITIAL> "while"              { return symbol(sym.WHILE,yytext()); }
<YYINITIAL> "this"               { return symbol(sym.THIS,yytext()); }
<YYINITIAL> "true"               { return symbol(sym.TRUE,yytext()); }
<YYINITIAL> "false"              { return symbol(sym.FALSE,yytext()); }
<YYINITIAL> "new"                { return symbol(sym.NEW,yytext()); }
<YYINITIAL> "System"             { return symbol(sym.SYSTEM,yytext()); }
<YYINITIAL> "out"                { return symbol(sym.OUT,yytext()); }
<YYINITIAL> "println"            { return symbol(sym.PRINTln,yytext()); }
<YYINITIAL> "length"             { return symbol(sym.LENGTH,yytext()); }
<YYINITIAL> "exit"               { return symbol(sym.EXIT,yytext()); }
<YYINITIAL> "in"                 { return symbol(sym.IN,yytext()); }
<YYINITIAL> "read"               { return symbol(sym.READ,yytext()); }

<YYINITIAL> {
  /* identificadores */ 
  {Identifier}                   { return symbol(sym.ID,yytext()); }
 
  /* literales enteros positivos */
  {DecIntegerLiteral}            { return symbol(sym.NUM,yytext()); }
  \"                             { string.setLength(0); yybegin(STRING); }
 
  /* operadores */
  "+"                            { return symbol(sym.SUMA,yytext()); }
  "-"                            { return symbol(sym.RESTA,yytext()); }
  "*"                            { return symbol(sym.MULT,yytext()); }
  "/"                            { return symbol(sym.DIV,yytext()); }
  "!="                           { return symbol(sym.DIF,yytext()); }
  "=="                           { return symbol(sym.IG_IG,yytext()); }
  "<"                            { return symbol(sym.MEN,yytext()); }
  "<="                           { return symbol(sym.MEN_IG,yytext()); }
  ">="                           { return symbol(sym.MAY_IG,yytext()); }
  ">"                            { return symbol(sym.MAY,yytext()); }
  "="                            { return symbol(sym.ASIGN,yytext()); }
  "!"                            { return symbol(sym.NEG,yytext()); }
  "||"                           { return symbol(sym.OR,yytext()); }
  "&&"                           { return symbol(sym.AND,yytext()); }
    
  /* otros simbolos válidos */
  "{"                            { return symbol(sym.LLAVEi,yytext()); }
  "}"                            { return symbol(sym.LLAVEd,yytext()); }
  "["                            { return symbol(sym.CORCHi,yytext()); }
  "]"                            { return symbol(sym.CORCHd,yytext()); }
  "("                            { return symbol(sym.PARENi,yytext()); }
  ")"                            { return symbol(sym.PARENd,yytext()); }
  ";"                            { return symbol(sym.PyCOMA,yytext()); }
  "."                            { return symbol(sym.PUNTO,yytext()); }
  ","                            { return symbol(sym.COMA,yytext()); }
  
  
  /* commentarios */
  {Comment}                      { /* ignore */ }
 
  /* espacios en blanco */
  {WhiteSpace}                   { /* ignore */ }
}

<STRING> {
  \"                             { yybegin(YYINITIAL); 
                                   return symbol(sym.STRING, string.toString()); }
  [^\n\r\"\\]+                   { string.append( yytext() ); }
  \\t                            { string.append('\t'); }
  \\n                            { string.append('\n'); }

  \\r                            { string.append('\r'); }
  \\\"                           { string.append('\"'); }
  \\                             { string.append('\\'); }
}

/* caracteres no válidos */
.|\n                             { System.out.println("Error caracter inválido: <" + yytext() + "> en fila: " + yyline + " columna: " + yycolumn );
				   /*throw new Error("Caracter no permitido <"+
                                                    yytext()+">");*/ }

