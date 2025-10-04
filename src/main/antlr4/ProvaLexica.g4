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
MIDA : 'mida';

TUPLA : 'tupla';
FTUPLA : 'ftupla';

ACCIO : 'accio';
FACCIO : 'facció';

FUNCIO : 'funcio';
RETORNA: 'retorna' ;
FFUNCIO : 'ffuncio';

VARIABLES : 'variables';
FVARIABLES : 'fvariables';

ENT : 'ent';
ENTSOR : 'entsor';

SI : 'si' ;
LLAVORS : 'llavors' ;
ALTRASI : 'altrasi' ;
ALTRAMENT : 'altrament' ;
FSI : 'fsi';

PER : 'per' ;
EN : 'en' ;
FER : 'fer' ;
FPER : 'fper' ;

MENTRE : 'mentre' ;
FMENTRE : 'fmentre' ;

BUCLE : 'bucle' ;
EXIT : 'exit' ;
FBUCLE : 'fbucle' ;

// no tinc clar els següents
LLEGIR : 'llegir' ;
ESCRIURE : 'escriure' ;
ESCRIURELN : 'escriureln' ;
RANG : 'rang';

// Constants
ENTER : SIGNE? DIGIT+ ;
REAL: SIGNE? DIGIT+ '.' DIGIT+ EXPONENT? ;
COMPLEXA: '#' SIGNE? REAL ',' SIGNE? REAL '#' ;
BOOLEA: TRUE | FALSE;

// Identificadors
IDENT : LETTER (LETTER | DIGIT)* ;


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


// Espais
WS : [ \t\r\n]+ -> skip ;

// Comentaris i espais
LINE_COMMENT : '//' ~[\r\n]* -> skip ;
MULTI_LINE_COMMENT : '/*' .*? '*/' ;