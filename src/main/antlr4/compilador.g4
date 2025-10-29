grammar compilador;

@header {
    import java.io.*;
}
// ===== Regles sintàctiques =====

programa
    : bloctipus? blocaccionsfuncions? PROGRAMA IDENT blocvariables? sentencia+ FPROGRAMA EOF
    ;

bloctipus
    : TIPUS declaraciotipus+ FTIPUS
    ;

tipus_basic
    : ENTER_T
    | REAL_T
    | COMPLEX_T
    | BOOLEA_T
    ;

declaraciovector
    : VECTOR tipus_basic MIDA ENTER (COMMA ENTER)*
    ;

declaraciotupla
    : TUPLA (IDENT COLON tipus_basic)+ FTUPLA
    ;


declaraciotipus
    : IDENT COLON (declaraciovector | declaraciotupla) SEMI
    ;

blocaccionsfuncions
    : (accio | funcio)+
    ;


tipusparametre
    : ENT
    | ENTSOR
    ;

parametreformal
    : tipusparametre? IDENT COLON tipus_basic
    ;

parametresformals
    : parametreformal (COMMA parametreformal)*
    ;

signatura
    : IDENT LPAREN parametresformals? RPAREN
    ;

accio
    : ACCIO signatura blocvariables? sentencia* FACCIO
    ;

// Sincerament no entenc com s'escriu una funcio (o sigui aixo es el que esta posat al document pero ho veig lios)
funcio
    : FUNCIO signatura RETORNA tipus_basic blocvariables? sentencia* RETORNA expresio tipus_basic SEMI FFUNCIO
    ;

variable
    : (IDENT COLON (tipus_basic | IDENT) SEMI)
    ;

blocvariables
    : VARIABLES variable* FVARIABLES
    ;


valortipusbasic
    : ENTER
    | REAL
    | COMPLEXA
    | BOOLEA
    ;

acces_vector
    : (LBRACKET expresio RBRACKET)+
    ;

acces_tuple
    : DOT IDENT
    ;

cridaparametres
    : expresio (COMMA expresio)*
    ;

crida
    : LPAREN cridaparametres? RPAREN
    ;



// TODO: definir tot el tema de operacions tenint en compte l'ordre

expresio
    : valortipusbasic
    | IDENT (acces_vector | acces_tuple | crida)?
    // operacio sobre una o varies expressions
    | STRING
    ;


// Es normal que una cosa la pugui veure tant com una expressio com una sentencia? o sigui una crida pot ser interpretat com les dos....

sentencia
    : assignacio
    | condicional
    | per
    | mentre
    | bucle // aquest no ho tinc clar
    | crida // accio
    | instruccio_lectura_escriptura
    ;

assignacio
    : IDENT ASSIGN expresio SEMI
    ;

condicional
    : SI expresio LLAVORS sentencia* altrasi* altrament? FSI
    ;

altrasi
    : ALTRASI expresio LLAVORS sentencia*
    ;

altrament
    : ALTRAMENT sentencia*
    ;

per
    : PER IDENT EN RANG LPAREN ENTER (COMMA ENTER)? RPAREN FER sentencia* FPER
    ;

bucle
    : BUCLE FBUCLE
    ;

mentre
    : MENTRE expresio FER sentencia+ FMENTRE
    ;


lectura
    : LLEGIR LPAREN IDENT (COLON tipus_basic)?
    ;

escriptura
    : ESCRIURE LPAREN cridaparametres
    ;

escripturasalt
    : ESCRIURELN LPAREN cridaparametres?
    ;

instruccio_lectura_escriptura
    : (lectura | escriptura | escripturasalt) RPAREN SEMI
    ;

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
REAL: SIGNE? DIGIT+ DOT DIGIT+ EXPONENT? ;
COMPLEXA: HASH SIGNE? REAL COMMA SIGNE? REAL HASH ;
BOOLEA: TRUE | FALSE;

STRING : '"' ~["\r\n]* '"';

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
DOT : '.';
HASH : '#';

// Espais
WS : [ \t\r\n]+ -> skip ;