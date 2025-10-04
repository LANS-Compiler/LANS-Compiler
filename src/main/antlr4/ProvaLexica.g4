lexer grammar ProvaLexica;

// Fragments (no emeten token)
fragment DIGIT : '0'..'9' ;
fragment LETTER : 'a'..'z' | 'A'..'Z' | 'À'..'ÿ' ; // suport bàsic Unicode llatí
fragment SIGNE: ('+' | '-') ;
fragment EXPONENT : 'E' SIGNE? DIGIT+ ;
fragment TRUE : 'cert' ;
fragment FALSE : 'fals' ;

// Paraules clau (abans que IDENT!)
PROGRAMA : 'programa' ;
FPROGRAMA : 'fprograma' ;
TIPUS : 'tipus';
FTIPUS : 'ftipus';
VECTOR : 'vector';
TUPLA : 'tupla';
FTUPLA : 'ftupla';
ACCIO : 'accio';
FACCIO : 'facció';
FUNCIO : 'funcio';
FFUNCIO : 'ffuncio';
VARIABLES : 'variables';
FVARIABLES : 'fvariables';
ENT : 'ent';
ENTSOR : 'entsor';

// Constants
ENTER : SIGNE? DIGIT+ ;
REAL: SIGNE? DIGIT+ '.' DIGIT+ EXPONENT? ;
COMPLEXA: '#' SIGNE? REAL ',' SIGNE? REAL '#' ;
BOOLEA: TRUE | FALSE;

// Identificadors
IDENT : LETTER (LETTER | DIGIT | '_')* ;


// Separadors o Caràcters Especials


// Operadors


// Símbols
LPAREN : '(' ;
RPAREN : ')' ;
PLUS: '+' ;
MINUS: '-';
STAR : '*' ;
DIVISOR: '/';
//ENTER_DIVISOR: '\';
MODUL: '%';

SEMI : ';' ;

// Comentaris i espais
LINE_COMMENT : '//' ~[\r\n]* -> skip ;
WS : [ \t\r\n]+ -> skip ;