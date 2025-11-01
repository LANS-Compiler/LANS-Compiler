grammar compilador;

@header {
    import java.io.*;
}
// ===== Regles sintàctiques =====
programa
    : bloctipus? blocaccionsfuncions? PROGRAMA IDENT blocvariables? sentencia+ FPROGRAMA EOF
    ;

// 2. Tipus de dades En LANS tenim tipus bàsics de dades i tipus definits.
// 2.1 Tipus bàsics
tipus_basic
    : ENTER_T
    | REAL_T
    | COMPLEX_T
    | BOOLEA_T
    ;

// 2.2 Tipus definits
// 2.2.1 Vector
declaraciovector
    : VECTOR tipus_basic MIDA ENTER (COMMA ENTER)*
    ;

// 2.2.2 Tupla
declaraciotupla
    : TUPLA (IDENT COLON tipus_basic)+ FTUPLA
    ;

// 3. Estructura general d'un programa LANS
// 3.1 Bloc de declaració de tipus
bloctipus
    : TIPUS declaraciotipus+ FTIPUS
    ;

declaraciotipus
    : IDENT COLON (declaraciovector | declaraciotupla) SEMI
    ;

// 3.2 Bloc d’accions i funcions
blocaccionsfuncions
    : (accio | funcio)+
    ;

accio
    : ACCIO signatura blocvariables? sentencia* FACCIO
    ;

funcio
    : FUNCIO signatura RETORNA tipus_basic blocvariables? sentencia* RETORNA expresio tipus_basic SEMI FFUNCIO
    ;

signatura
    : IDENT LPAREN parametresformals? RPAREN
    ;

parametresformals
    : parametreformal (COMMA parametreformal)*
    ;

parametreformal
    : tipusparametre? IDENT COLON tipus_basic
    ;

tipusparametre
    : ENT
    | ENTSOR
    ;

// 3.3 Bloc de declaració de variables de tipus definit
blocvariables
    : VARIABLES variable* FVARIABLES
    ;

variable
    : IDENT COLON (tipus_basic | IDENT) SEMI
    ;

// 6. Expressions
// Un valor constant de tipus bàsic
valortipusbasic
    : ENTER
    | REAL
    | COMPLEXA
    | BOOLEA
    ;

// Un accés a tupla
acces_tuple
    : DOT IDENT
    ;

// Un accés a vector
acces_vector
    : (LBRACKET expresio RBRACKET)+
    ;

// Una crida a una funció
crida
    : LPAREN cridaparametres? RPAREN
    ;

cridaparametres
    : expresio (COMMA expresio)*
    ;

// Una operació sobre una o vàries expressions
// Per a les operacions, cal definir una jerarquia d'ordre
atomExpresio
    : valortipusbasic
    | IDENT (acces_vector | acces_tuple | crida)*
    | LPAREN expresio RPAREN
    | STRING
    ;

expresio
    : operacioRelacional ((OR | AND) operacioRelacional)*
    ;

operacioRelacional
    : operacioAdditiva ((NOT_EQUAL | EQUAL | LESS | LESS_EQUAL | GRATER | GRATER_EQUAL) operacioAdditiva)*
    ;

operacioAdditiva
    : operacioMultiplicativa ((PLUS | MINUS) operacioMultiplicativa)*
    ;

operacioMultiplicativa
    : operacioUnitaria ((STAR | DIVISOR | ENTER_DIVISOR | MODUL) operacioUnitaria)*
    ;

operacioUnitaria
    : MINUS_UNIT? atomExpresio
    | NOT+ atomExpresio
    ;

// 7. Sentències
// 7.1 Assignació
assignacio
    : IDENT ASSIGN expresio SEMI
    ;

// 7.2 Condicional
condicional
    : SI expresio LLAVORS sentencia* altrasi* altrament? FSI
    ;

altrasi
    : ALTRASI expresio LLAVORS sentencia*
    ;

altrament
    : ALTRAMENT sentencia*
    ;

// 7.3 Per
per
    : PER IDENT EN RANG LPAREN ENTER (COMMA ENTER)? RPAREN FER sentencia* FPER
    ;

// 7.4 Mentre
mentre
    : MENTRE expresio FER sentencia+ FMENTRE
    ;

// 7.5 Bucle
bucle
    : BUCLE sentencia* EXIT expresio SEMI sentencia* FBUCLE
    ;

// 7.6 Crida a acció
// ...
// 7.7 Lectura/escriptura
lectura
    : LLEGIR LPAREN IDENT (COLON tipus_basic)? RPAREN SEMI
    ;

escriptura
    : ESCRIURE LPAREN cridaparametres RPAREN SEMI
    ;

escripturasalt
    : ESCRIURELN LPAREN cridaparametres? RPAREN SEMI
    ;

instruccio_lectura_escriptura
    : (lectura | escriptura | escripturasalt) // T'he tret els RPAREN SEMI i els he repetit als 3 tipus, per llegibiliatt
    ;

sentencia
    : assignacio
    | condicional
    | per
    | mentre
    | bucle
    | IDENT crida SEMI
    | instruccio_lectura_escriptura
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