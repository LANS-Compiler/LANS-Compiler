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

// 2. Tipus de dades En LANS tenim tipus bàsics de dades i tipus definits.
// 2.1 Tipus bàsics
ENTER : SIGNE? DIGIT+ ;
REAL: SIGNE? DIGIT+ '.' DIGIT+ EXPONENT? ;
COMPLEXA: '#' SIGNE? REAL ',' SIGNE? REAL '#' ;
BOOLEA: TRUE | FALSE;

//2.2 Tipus definits

// 4. Identificadors
IDENT : LETTER (LETTER | DIGIT)* ;

// 5. Comentaris
LINE_COMMENT : '//' ~[\r\n]* -> skip ;
MULTI_LINE_COMMENT : '/*' .*? '*/' ;

// 6. Expressions
// 6.1 Operadors

PLUS: '+' ;
MINUS: '-';
STAR : '*' ;
DIVISOR: '/';
ENTER_DIVISOR: '\\';
MODUL: '%';
MINUS_UNIT: '~';

EQUAL: '==';
NOT_EQUAL: '!=';

LESS: '<';
LESS_EQUAL: '<=';
GRATER: '>';
GRATER_EQUAL: '>=';

NOT: 'no';
AND: '&';
OR: '|';

// 7. Sentències
// 7.1 Assignació
ASSIGN: ':=';

// 7.2 Condicional
SI : 'si' ;
LLAVORS : 'llavors' ;
ALTRASI : 'altrasi' ;
ALTRAMENT : 'altrament' ;
FSI : 'fsi';

// 7.3 Per
PER : 'per' ;
EN : 'en' ;
RANG : 'rang';
FER : 'fer' ;
FPER : 'fper' ;

// 7.4 Mentre
MENTRE : 'mentre' ;
FMENTRE : 'fmentre' ;

// 7.5 Bucle
BUCLE : 'bucle' ;
EXIT : 'exit' ;
FBUCLE : 'fbucle' ;

// 7.7 Lectura/escriptura
LLEGIR : 'llegir' ;
ESCRIURE : 'escriure' ;
ESCRIURELN : 'escriureln' ;

// Separadors o Caràcters Especials
LPAREN : '(' ;
LBRACKET: '[';
RBRACKET: ']';
RPAREN : ')' ;

SEMI : ';' ;
COLON : ':';

// Espais
WS : [ \t\r\n]+ -> skip ;