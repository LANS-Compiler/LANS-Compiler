lexer grammar ProvaLexica;

// Fragments (no emeten token)
fragment DIGIT : '0'..'9' ;
fragment LETTER : 'a'..'z' | 'A'..'Z' | 'À'..'ÿ' ; // suport bàsic Unicode llatí

// Paraules clau (abans que IDENT!)
PROGRAMA : 'programa' ;
FPROGRAMA : 'fprograma' ;

// Símbols
LPAREN : '(' ;
RPAREN : ')' ;
STAR : '*' ;
PLUS : '+' ;
SEMI : ';' ;

// Identificadors i nombres
IDENT : LETTER (LETTER | DIGIT | '_')* ;
ENTER : DIGIT+ ;


// Comentaris i espais
LINE_COMMENT : '//' ~[\r\n]* -> skip ;
WS : [ \t\r\n]+ -> skip ;