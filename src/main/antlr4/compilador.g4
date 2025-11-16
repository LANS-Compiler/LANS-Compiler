grammar compilador;

@header {
    import java.io.*;
}


@parser::members{
    SymTable<Registre> TS = new SymTable<Registre>(1000);
    boolean errorsem = false;
    int ultimaAdreca=0;

    //override method
    public void notifyErrorListeners(Token offendingToken, String msg, RecognitionException e)    {
        super.notifyErrorListeners(offendingToken,msg,e);
        error=true;
    }
}
// ===== Regles sintàctiques =====

programa
    : bloctipus? blocaccionsfuncions? PROGRAMA IDENT blocvariables? sentencia+ FPROGRAMA EOF
    ;


// 2. Tipus de dades En LANS tenim tipus bàsics de dades i tipus definits.
// 2.1 Tipus bàsics
tipus_basic returns [char tipus]
    : ENTER_T {$tipus = 'E';}
    | REAL_T {$tipus = 'R';}
    | COMPLEX_T {$tipus = 'C';}
    | BOOLEA_T {$tipus = 'Z';}
    ;

// 2.2 Tipus definits
declaraciovector
    : VECTOR tipus_basic MIDA ENTER (COMMA ENTER)*
    ;

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

// 3.3 Bloc de declaració de variables de tipus definit
blocvariables
    : VARIABLES variable* FVARIABLES
    ;

variable returns [char tipus]
    : i=IDENT COLON
        (
            tb=tipus_basic
            {
                $tipus = $tb.tipus;
            }
        | ti=IDENT
        {
            if (TS.existeix($ti.text)) {
                Registre r = TS.obtenir($ti.text);
                $tipus = r.getTipus();
            } else {
                errorsem = true;
                System.out.println(
                    "Error de tipus detectat a la línia " + $ti.getLine()
                );
            }
        }
        )
        {
              if (!errorsem) {
                  if (!TS.existeix($i.text)) {
                      TS.inserir($i.text, new Registre($i.text, $tipus, ultimaAdreca++));
                  } else {
                      errorsem = true;
                      System.out.println(
                          "Variable ja declarada a la línia " + $i.getLine()
                      );
                  }
              }
        }
        SEMI
    ;


// 6. Expressions
// Un valor constant de tipus bàsic
valortipusbasic returns [char tipus]
    @init{ System.out.println(“Entrem a la regla 'valortipusbasic'”);}
    @after{System.out.println(“Sortim de la regla 'valortipusbasic'”);}
    : ENTER {$tipus = 'E';}// E (Enter)
    | REAL {$tipus = 'R';}// R (Real)
    | COMPLEXA {$tipus = 'C';}// C (Complex)
    | BOOLEA {$tipus = 'Z';}// B (Boleà)
    ;

// Un accés a vector

// S'hauria de retornar el tipus del vector sempre que l'acces fos dintre els limits
acces_vector
    : (LBRACKET expresio RBRACKET)+
    ;

// Un accés a tupla
//S'hauria de retornar e ltipus del camp de la tuple sempre que existis
acces_tuple
    : DOT IDENT
    ;

// Una crida a una funció
crida
    : LPAREN cridaparametres? RPAREN
    ;

cridaparametres
    : expresio (COMMA expresio)*
    ;


// Una operació sobre una o vàries expressions
expresio
    : operacioRelacional ((OR | AND) operacioRelacional)*
    ;

operacioRelacional
    : operacioAdditiva ((NOT_EQUAL | LESS | LESS_EQUAL | GRATER | GRATER_EQUAL | EQUAL) operacioAdditiva)*
    ;

operacioAdditiva
    : operacioMultiplicativa ((PLUS | MINUS) operacioMultiplicativa)*
    ;

operacioMultiplicativa
    : operacioUnaria ((STAR | DIVISOR | ENTER_DIVISOR | MODUL) operacioUnaria)*
    ;

operacioUnaria
    : (MINUS_UNIT | NOT) operacioUnaria
    | atom
    ;

atom
  : LPAREN expresio RPAREN
  | valortipusbasic
  | IDENT (acces_vector | acces_tuple | crida)?
  | STRING
  ;


// 7. Sentències
sentencia
    : IDENT (assignacio | crida)
    | condicional
    | per
    | mentre
    | bucle
    | instruccio_lectura_escriptura
    ;

// 7.1 Assignació
assignacio
    : ASSIGN expresio SEMI
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
    : lectura
    | escriptura
    | escripturasalt
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

NOT: 'no';



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

AND: '&';
OR: '|';

// 7. Sentències
// 7.1 Assignació
ASSIGN: ':=';

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