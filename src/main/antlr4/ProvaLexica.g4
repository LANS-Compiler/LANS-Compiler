grammar ProvaLexica;

// ===== Regles sintàctiques =====
programa:
    bloctipus?
    blocaccionsfuncions?
    PROGRAMA IDENT
    blocvariables?
    sentencia+
    FPROGRAMA
    ;

bloctipus:
    TIPUS
    declaraciotipus+
    FTIPUS
    ;


tipus_basic
    : ENTER_T
    | REAL_T
    | COMPLEX_T
    | BOOLEA_T
    ;


declaraciovector
    : IDENT COLON VECTOR tipus_basic MIDA ENTER(COMMA ENTER)*;

declaraciotupla
    : IDENT COLON TUPLA (IDENT COLON tipus_basic)+ FTUPLA;


declaraciotipus
    : declaraciovector | declaraciotupla;

blocaccionsfuncions:
    (accio | funcio)+
    ;

accio:
    ACCIO IDENT LPAREN parametresformals? RPAREN
        blocvariables?
        sentencia*
    FACCIO
    ;

funcio:
    FUNCIO IDENT LPAREN parametresformals? RPAREN RETORNA tipus_basic
        blocvariables?
        sentencia* RETORNA expresio
        tipus_basic SEMI
    FFUNCIO
    ;

tipusparametre: (ENT | ENTSOR);

parametreformal: tipusparametre? IDENT COLON tipus_basic;

parametresformals:
    parametreformal (COMMA parametreformal)*
    ;


variable:
    (IDENT COLON (tipus_basic | IDENT) SEMI)
    ;

blocvariables:
    VARIABLES
        variable*
    FVARIABLES
    ;

// TODO: fer expressio
expresio:
    variable
    ;

sentencia
    : assignacio
    | condicional
    | per
    | mentre
    | bucle // aquest no ho tinc clar
    | crida_accio
    | instruccio_lectura_escriptura
    ;

assignacio: IDENT ASSIGN expresio SEMI;

condicional:
    SI expr_booleana LLAVORS sentencia*
        altrasi*
        altrament?
    FSI;

altrasi: ALTRASI expr_booleana LLAVORS sentencia*;

altrament: ALTRAMENT sentencia*;

per:
    PER IDENT EN RANG LPAREN ENTER (COMMA ENTER)? RPAREN FER
    sentencia*
    FPER;

mentre:
    MENTRE expr_booleana FER
    sentencia+
    FMENTRE;




// TODO: depen de com entenc que son important que no hi hagi espais entre elements,  com ho faig?

// TODO: fer la coma? potser un complex no es un token sino una regla lexica?

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

ENTER_T   : 'enter' ;
REAL_T    : 'real' ;
COMPLEX_T : 'complex' ;
BOOLEA_T  : 'boolea' ;


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
COMMA : ',';

// Espais
WS : [ \t\r\n]+ -> skip ;