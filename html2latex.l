%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int list_type;
%}

%option       noyywrap nounput yylineno
%x            COMMENT PARA PRE OL UL LI

%%

"<h1>"[^<]*"</h1>" {
    /**************************************************************************
     * Matched an HTML H1 header so print it out as a LateX section title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\section{%s}\n", yytext+4 );
}

"<h2>"[^<]*"</h2>" {
  /***************************************************************************
   * Matched an HTML H2 header so print it out as a LateX subsection title.
   * The beginning and ending tags need to be stripped off before the title
   * can be formatted in LateX.
   ***************************************************************************/
  yytext[yyleng-5] = 0;
  printf("\\subsection{%s}\n", yytext+4);
}

"<h3>"[^<]*"</h3>" {
  /*************************************************************************
   * Matched an HTML H3 header so print it out as a Latex subsubsection title.
   * The beginning and ending tags need to be stripped off before the title
   * can be formatted in LateX.
   **************************************************************************/
  yytext[yyleng-5] = 0;
  printf("\\subsubsection{%s}\n", yytext+4);
}

"<pre>"[^<]*"</pre>" {
  /***************************************************************************
   * Matched an HTML pre header so print it out verbatim
   * ************************************************************************/
  yytext[yyleng-6] = 0;
  printf("\\begin{verbatim}%s\\end{verbatim}\n", yytext+5);
}

"<p>" {
  /**************************************************************************
   * Matched and HTML paragraph tag so print it out with the other html tags
   * within the beginning and ending tags. 
   * The tags are stripped off before printed.
   **************************************************************************/
   BEGIN PARA;
}

"<ul>" {
  printf("\\begin{itemize}");
  BEGIN UL;
}

"<ol>" {
  printf("\\begin{enumerate}");
  BEGIN OL;
}

<UL>"</ul>" {
  printf("\\end{itemize}\n");
  BEGIN 0;
}

<UL>[ \t] {
  printf("%s", yytext);
}

<UL>"<li>" {
  printf("\\item");
}

<UL>"</li>" {
  printf("\n");
}

<UL>"<small>"[^<]*"</small>" {
   yytext[yyleng-8] = 0;
   printf("{\\scriptsize %s}", yytext+7);
}

<UL>"<big>"[^<]*"</big>" {
  yytext[yyleng-6] = 0;
  printf("{\\Large %s}", yytext + 5);
}

<UL>"<b>"[^<]*"</b>" {
  yytext[yyleng-4] = 0;
  printf("\\textbf{%s}", yytext+3);
}

<UL>"<i>"[^<]*"</i>" {
  yytext[yyleng-4] = 0;
  printf("\\textit{%s}", yytext+3);
}

<UL>"<strong>"[^<]*"</strong>" {
  yytext[yyleng-9] = 0;
  printf("\\textmd{%s}", yytext+8);
}

<UL>"<em>"[^<]*"</em>" {
  yytext[yyleng-5] = 0;
  printf("\\emph{%s}", yytext+4);
}

<UL>"<sup>"[^<]*"</sup>" {
  yytext[yyleng-6] = 0;
  printf("\\textsuperscript{%s}", yytext+5);
}

<UL>"<sub>"[^<]*"</sub>" {
  yytext[yyleng-6] = 0;
  printf("\\textsubscript{%s}", yytext+5);
}

<UL>[ \t] {
  /***************************************************************************
   * Matched some white space while parsing an HTML ul. Print out the 
   * white space as is.
   ***************************************************************************/
  printf("%s", yytext);
}

<UL>. {
  /**************************************************************************
   * Matched any other text while parsing an HTML ul. Print out the 
   * text as is.
   ***************************************************************************/
  printf("%s", yytext);
}

<OL>"</ol>" {
  printf("\\end{enumerate}\n");
  BEGIN 0;
}

<OL>[ \t] {
  printf("%s", yytext);
}

<OL>"<li>" {
  printf("\\item");
}

<OL>"</li>" {
  printf("\n");
}

<OL>"<small>"[^<]*"</small>" {
   yytext[yyleng-8] = 0;
   printf("{\\scriptsize %s}", yytext+7);
}

<OL>"<big>"[^<]*"</big>" {
  yytext[yyleng-6] = 0;
  printf("{\\Large %s}", yytext + 5);
}

<OL>"<b>"[^<]*"</b>" {
  yytext[yyleng-4] = 0;
  printf("\\textbf{%s}", yytext+3);
}

<OL>"<i>"[^<]*"</i>" {
  yytext[yyleng-4] = 0;
  printf("\\textit{%s}", yytext+3);
}

<OL>"<strong>"[^<]*"</strong>" {
  yytext[yyleng-9] = 0;
  printf("\\textmd{%s}", yytext+8);
}

<OL>"<em>"[^<]*"</em>" {
  yytext[yyleng-5] = 0;
  printf("\\emph{%s}", yytext+4);
}

<OL>"<sup>"[^<]*"</sup>" {
  yytext[yyleng-6] = 0;
  printf("\\textsuperscript{%s}", yytext+5);
}

<OL>"<sub>"[^<]*"</sub>" {
  yytext[yyleng-6] = 0;
  printf("\\textsubscript{%s}", yytext+5);
}

<OL>[ \t] {
  /***************************************************************************
   * Matched some white space while parsing an HTML ol. Print out the 
   * white space as is.
   ***************************************************************************/
  printf("%s", yytext);
}

<OL>. {
  /**************************************************************************
   * Matched any other text while parsing an HTML ol. Print out the 
   * text as is.
   ***************************************************************************/
  printf("%s", yytext);
}

"<!--" {
    /**************************************************************************
     * Matched an HTML comment so print it out as a LateX comment. The
     * beginning and ending tags are stripped off before the LateX comment
     * is emitted.
     *************************************************************************/
    printf( "%% " );
    BEGIN COMMENT;
}

[ \t\n\r]+ {
    /**************************************************************************
     * Matched some whitespace that is not inside of an HTML tag. We
     * just ignore the whitespace.
     *************************************************************************/
}

. {
    /**************************************************************************
     * Matched something that we did not expect to see. Issue an error and
     * exit the program with a failure message.
     *************************************************************************/
    fprintf( stderr, "Unexpected input at line %d: '%s'\n", yylineno, yytext );
    exit( 1 );
}

<PARA>"</p>" {
  /***************************************************************************
   * Matched an HTML end paragraph tag. Print out a new line
   * and continue normal parsing.
   ***************************************************************************/
  printf("\n\n");
  BEGIN 0;
}

<PARA>"<small>"[^<]*"</small>" {
  /***************************************************************************
   * Matched an HTML small tag while parsing a paragraph. Print out with the 
   * scriptsize LateX tag and strip off the beginning and ending tags
   ***************************************************************************/
   yytext[yyleng-8] = 0;
   printf("{\\scriptsize %s}", yytext+7);
}

<PARA>"<big>"[^<]*"</big>" {
  yytext[yyleng-6] = 0;
  printf("{\\Large %s}", yytext + 5);
}

<PARA>"<b>"[^<]*"</b>" {
  yytext[yyleng-4] = 0;
  printf("\\textbf{%s}", yytext+3);
}

<PARA>"<i>"[^<]*"</i>" {
  yytext[yyleng-4] = 0;
  printf("\\textit{%s}", yytext+3);
}

<PARA>"<strong>"[^<]*"</strong>" {
  yytext[yyleng-9] = 0;
  printf("\\textmd{%s}", yytext+8);
}

<PARA>"<em>"[^<]*"</em>" {
  yytext[yyleng-5] = 0;
  printf("\\emph{%s}", yytext+4);
}

<PARA>"<sup>"[^<]*"</sup>" {
  yytext[yyleng-5] = 0;
  printf("\\textsuperscript{%s}", yytext+4);
}

<PARA>"<sub>"[^<]*"</sub>" {
  yytext[yyleng-5] = 0;
  printf("\\textsubscript{%s}", yytext+4);
}

<PARA>[ \t] {
  /***************************************************************************
   * Matched some white space while parsing an HTML paragraph. Print out the 
   * white space as is.
   ***************************************************************************/
  printf("%s", yytext);
}

<PARA>. {
  /**************************************************************************
   * Matched any other text while parsing an HTML paragraph. Print out the 
   * text as is.
   ***************************************************************************/
  printf("%s", yytext);
}

<COMMENT>"-->" {
    /**************************************************************************
     * Matched an HTML end comment while parsing an HTML comment. Print out
     * a new line and resume normal parsing.
     *************************************************************************/
    printf( "\n" );
    BEGIN 0;
}

<COMMENT>[\n](\r)? {
    /**************************************************************************
     * Matched a newline and possible carriage return while parsing an HTML
     * comment. Print out a new line making sure to mark the next line as a
     * comment as well.
     *************************************************************************/
    printf( "\n%% " );
}

<COMMENT>[ \t] {
    /**************************************************************************
     * Matched some white space while parsing an HTML comment. Print out
     * the white space as is.
     *************************************************************************/
    printf( "%s", yytext );
}

<COMMENT>. {
    /**************************************************************************
     * Matched any other text while parsing an HTML comment. Print out
     * the text as is.
     *************************************************************************/
    printf( "%s", yytext );
}

%%

/**************************************************************************
 * The main function for the HTML to LateX converter. Here we do three
 * things:
 *  1. Print out the LateX document header.
 *  2. Invoke the lexer to print out the LateX document
 *  3. Print out the LateX footer.
 *************************************************************************/
int main( int argc, const char *argv[] ) {
    printf( "\\documentclass[12pt]{article}\n" );
    printf( "\\usepackage{fixltx2e}\n" );
    printf( "\n" );
    printf( "\\setlength{\\parindent}{0.0in}\n" );
    printf( "\\setlength{\\parskip}{0.125in}\n" );
    printf( "\n\n" );
    printf( "\\begin{document}\n" );
    yylex();
    printf( "\\end{document}\n" );
    return 0;
}
