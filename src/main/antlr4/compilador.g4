grammar compilador;

@header {
    import java.io.*;
    import java.util.ArrayList;
    import java.util.HashMap;
    import java.util.List;
    import java.util.Map;
    import package symboltable.*
}

@parser::members{
    boolean errorSintactic=false;
    symboltable<Registre> ts = new symboltable<>();  // Taula de símbols global

    public void notifyErrorListeners(Token offendingToken, String msg, RecognitionException e){
        super.notifyErrorListeners(offendingToken,msg,e); //Si volem conservar el comportament inicial
        errorSintactic=true;
    }

    // Mètode auxiliar per determinar tipus
    private char determinarTipusChar(String typeName) {
        switch (typeName) {
            case "enter": return 'E';
            case "real": return 'R';
            case "complex": return 'C';
            case "boolea": return 'Z';
            default: return 'D';  // Tipus definit
        }
    }
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
declaraciovector returns [Vector<Integer> mides]
    @init{
        System.out.println(“Entrem a la regla 'declaraciovector'”);
        $mides = new ArrayList<>();
    }
    @after{System.out.println(“Sortim de la regla 'declaraciovector'”);}
    : VECTOR t_basic=tipus_basic MIDA mida=ENTER (COMMA altra_mida=ENTER)*
    {
        // NO ESTÀ DEL TOT CORRECTE, PERÒ TEN FAS UNA IDEA
        // Altra mida serà una llista de les mides, [] o [n, m, x, y, z, ...]
        // Si alguna de les mides és 0, error
        mides.add(Integer.parseInt($mida.text));

        for (Token midaToken : $altra_mida) {
            mides.add(Integer.parseInt(midaToken.getText()));
        }

        System.out.println("Vector amb " + mides.size() + " dimensions: " + mides);

        // Verificar que cap mida sigui <= 0
        for (int i = 0; i < mides.size(); i++) {
            if (mides.get(i) <= 0) {
                System.err.println("[Error: Dimensió " + (i+1) + " del vector té mida " + mides.get(i) + " (ha de ser > 0)]");
            }
        }
    }
    ;

declaraciotupla returns [Map<String, String> tipusCamps]
    @init{
        System.out.println(“Entrem a la regla 'declaraciotupla'”);
        $tipusCamps = new HashMap<>();
    }
    @after{System.out.println(“Sortim de la regla 'declaraciotupla'”);}
    : TUPLA (nom_camp=IDENT COLON tipus_camp=tipus_basic)+ FTUPLA
    {
        // NO ESTÀ DEL TOT CORRECTE, PERÒ TEN FAS UNA IDEA
        for(int i = 0; i < tipus_camp.size(); i++) {
            String nomCamp = $nom_camp.get(i).getText();
            String tipusCamp = tipus_camp.get(i).getText();

            // Verificar si el camp ja existeix
            if ($tipusCamps.containsKey(nomCamp)) {
                System.err.println("[Error: Camp duplicat '" + nomCamp + "' a la tupla]");
            } else {
                $tipusCamps.put(nomCamp, tipusCamp);
                System.out.println("Camp: " + nomCamp + " : " + tipusCamp);
            }
        }
        System.out.println("[Tupla amb " + $tipusCamps.size() + " camps]");
    }
    ;

// 3. Estructura general d'un programa LANS
// 3.1 Bloc de declaració de tipus
bloctipus
    : TIPUS declaraciotipus+ FTIPUS
    ;

declaraciotipus
    @init{
        System.out.println(“Entrem a la regla 'declaraciotipus'”);
    }
    @after{System.out.println(“Sortim de la regla 'declaraciotipus'”);}
    : id=IDENT COLON (dec_vec=declaraciovector | dec_tup=declaraciotupla) SEMI
    {
        // NO ESTÀ DEL TOT CORRECTE, PERÒ TEN FAS UNA IDEA
        String nomTipus = $id.text;
        // Mirar que tipus no existeixi ja
        Registre nouRegistre = new Registre(nomTipus, 'D', 0);
        if ($dec_vec.mides != null) {
            // És vector - guardar mides
            nouRegistre.setMidesVector($dec_vec.mides);
        } else if (dec_tup.nomsCamps != null) {
            // És tupla - guardar camps
            nouRegistre.setCampsTupla(dec_tup.nomsCamps, dec_tup.tipusCamps);
        }

        st.inserir(nomTipus, nouRegistre);
    }
    ;


// 3.2 Bloc d’accions i funcions
blocaccionsfuncions
    : (accio | funcio)+
    ;

accio
    @init{ System.out.println(“Entrem a la regla 'accio'”);}
    @after{System.out.println(“Sortim de la regla 'accio'”);}
    : ACCIO signatura blocvariables? sentencia* FACCIO
    ;

funcio returns [char tipus]
    @init{ System.out.println(“Entrem a la regla 'funcio'”);}
    @after{System.out.println(“Sortim de la regla 'funcio'”);}
    : FUNCIO signatura RETORNA tipus_esperat=tipus_basic blocvariables? sentencia* RETORNA tipus_retornat=expresio tipus_esperat_2=tipus_basic SEMI FFUNCIO
        {
            // Comprovacions de tipus:
            if($tipus_esperat.text != $tipus_retornat.text){
                System.out.println("El tipus de la signatura, ", tipus_esperat, " no correspon amb el tipus de la funció, ", tipus_retornat);
            } else if( $tipus_esperat.text != $tipus_esperat_2.text){
                System.out.println("El tipus de la signatura, ", tipus_esperat, ", no correspon amb el tipus que es retorna, ", tipus_esperat_2);
            }
        }
    ;

signatura
    @init{ System.out.println(“Entrem a la regla 'signatura'”);}
    @after{System.out.println(“Sortim de la regla 'signatura'”);}
    : IDENT LPAREN parametresformals? RPAREN
    { // Aquí podriem fer una entrada a la taula de símbols de la signatura, amb els tipus de paràmetres, per permetre diferents signatures per un mateix nom de funció
    }
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

variable
    @init{ System.out.println(“Entrem a la regla 'variable'”);}
    @after{System.out.println(“Sortim de la regla 'variable'”);}
    : id=IDENT COLON (t_basic=tipus_basic | t_definit=IDENT) SEMI
    {
        // AQUESTA NO ÉS DEL TOT CORRECTE; PERÒ TEN FAS UNA IDEA
        // Cercar a la taula de simbols si existeix la variable amb el nom (IDENT) entrat
        String nomVariable = id.text;
        String tipusVariable =
            t_basic.text != null
                ? t_basic.text
                : t_definit.text;

        System.out.println("Processant variable: " + nomVariable + " de tipus: " + tipusVariable);

        // Si existeix, error, si no, continuar
        if (ts.existeix(nomVariable)) {
            System.err.println("-[Error: Variable '" + nomVariable + "' ja està declarada]");
        } else {
            char tipusChar = determinarTipusChar(tipusVariable);
            if(tipusChar == 'D'){
                if (!ts.existeix(tipusVariable)) {
                    System.err.println("[Error: Tipus '" + tipusVariable + "' no està definit]");
                }
            }
            // Crear una entrada a la taula de simbols sota el nom entrat, amb el tipus entrat
            Registre nouRegistre = new Registre(nomVariable, tipusChar, 0);
            ts.inserir(nomVariable, nouRegistre);
            System.out.println("[Variable '" + nomVariable + "' afegida a la taula de símbols]");
        }
    }
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
acces_vector [Registre vector] returns [char tipus]
    @init{
        System.out.println(“Entrem a la regla 'acces_vector'”);
        List<ExpresioContext> operands = new ArrayList<>();
    }
    @after{System.out.println(“Sortim de la regla 'acces_vector'”);}
    : (LBRACKET exp=expresio {operands.add(exp)} RBRACKET)+
        {
            // Hem de mirar que tots els accessos siguin números.
            for(ExpresioContext op : operands){
                if(op.tipus != 'E' && op.tipus != 'R'){
                    System.out.println("No es pot accedir al vector amb un índes de tipus ", op.tipus, ", l'índex ha de ser un enter o un real");
                }
            }

            // PER ACCEDIR A VECTOR HEM DE FER ALGO COM A LA REGLA D'ABAIX

        }
    ;

// Un accés a tupla
acces_tuple [Registre tupla] returns [char tipus]
    @init{System.out.println(“Entrem a la regla 'acces_tuple'”);}
    @after{System.out.println(“Sortim de la regla 'acces_tuple'”);}
    : DOT id=IDENT
        {
            // Com a paràmetre la tupla
            // Accedim a element
            // TODO: PREPARAR TEMA DE TUPLA -> CAL QUE REGISTRE DESI EL CONTINGUT DEL REGISTRE (PODRIA SER SEMPRE STRING I FORA FER LA CONVERSIÓ). CAL QUE TUPLA DESI CONTINUGT I TIPUS PER A CADA ELEMENT...
            //
        }
    ;

// Una crida a una funció
crida
    @init{ System.out.println(“Entrem a la regla 'crida'”);}
    @after{System.out.println(“Sortim de la regla 'crida'”);}
    : LPAREN cridaparametres? RPAREN
    ;

cridaparametres
    @init{ System.out.println(“Entrem a la regla 'cridaparametres'”);}
    @after{System.out.println(“Sortim de la regla 'cridaparametres'”);}
    : expresio (COMMA expresio)*
    ;


expresio returns [char tipus]
    @init{
        System.out.println(“Entrem a la regla 'expresio'”);
        List<OperacioRelacionalContext> operands = new ArrayList<>(); //OperacioRelacionalContext és el tipus de OperacioRelacional, o això diu el xat
    }
    @after{System.out.println(“Sortim de la regla 'expresio'”);}
    : op1=operacioRelacional {operands.add(op1);} ((OR | AND) ops=operacioRelacional {operands.add(ops);})*
    {
        // Si hi ha les operacions, TOTS els tipus han de ser boleans, i el resultat boleà
        // Si no hi ha cap operació, retornem el tipus de l'anterior
        $tipus = $op1.tipus; // Default

        if(operands.size() > 1){ // Si hi ha alguna operació
            $tipus = 'Z'; // No cal pero ho fa llegible
            for(OperacioRelacionalContext op : operands){ // Per a cada operació Relacional
                if(op.tipus != 'Z'){
                    // TODO: Promoció número a boleà (si ho fem, hem de mirar que sigui 'R' o 'E')
                    System.err.println("[Error: operació relacional no aplicable a tipus ", op.tipus, "]");
                }
            }
        }
    }
    ;

operacioRelacional returns [char tipus]
    @init{
        System.out.println(“Entrem a la regla 'operacioRelacional'”);
        List<OperacioAdditivaContext> operands = new ArrayList<>(); //OperacioAdditivaContext és el tipus de OperacioAdditiva, o això diu el xat
    }
    @after{System.out.println(“Sortim de la regla 'operacioRelacional'”);}
    : op1=operacioAdditiva {operands.add(op1);} ((NOT_EQUAL | LESS | LESS_EQUAL | GRATER | GRATER_EQUAL | EQUAL) ops=operacioAdditiva {operands.add(ops);})*
        {
            // Si hi ha les operacions, TOTS els tipus han de ser números, i el resultat boleà
            // Si no hi ha cap operació, retornem el tipus de l'anterior
            $tipus = $op1.tipus; // Default

            if(operands.size() > 1){ // Si hi ha alguna operació
                $tipus = 'Z'; // Boleà
                for(OperacioAdditivaContext op : operands){ // Per a cada operació Additiva
                    if(op.tipus != 'E' && op.tipus != 'R'){ //TODO: Poden complexos també?
                        System.err.println("[Error: operació relacional no aplicable a tipus", op.tipus, "]");
                    }
                }
            }
        }
    ;

operacioAdditiva returns [char tipus]
    @init{
        System.out.println(“Entrem a la regla 'operacioAdditiva'”);
        List<OperacioMultiplicativaContext> operands = new ArrayList<>(); //OperacioMultiplicativaContext és el tipus de operacioMultiplicativa, o això diu el xat
    }
    @after{System.out.println(“Sortim de la regla 'operacioAdditiva'”);}
    : op1=operacioMultiplicativa {operands.add(op1);} ((PLUS | MINUS) ops=operacioMultiplicativa {operands.add(ops);})*
        {
            // Si hi ha les operacions, TOTS els tipus han de ser números
            //      Important, la promoció es fa d'enter a real. Si trobem un sol real, el return ha de ser real
            // No hi ha cap operació, retornem el tipus de l'anterior

            $tipus = $op1.tipus; // Default

            if(operands.size() > 1){ // Si hi ha alguna operació
                for(OperacioMultiplicativaContext op : operands){ // Per a cada operació Multiplicativa (inclosa la primera)
                    if(op.tipus != 'E' && op.tipus != 'R'){ //TODO: Poden complexos també?
                        System.err.println("[Error: operació additiva no aplicable a tipus ", op.tipus, "]");
                    } else if(op.tipus == 'R'){
                        $tipus = 'R'; //Promoció
                    }
                }
            }
        }
    ;

operacioMultiplicativa returns [char tipus]
  @init{
    System.out.println(“Entrem a la regla 'operacioMultiplicativa'”);
    List<OperacioUnariaContext> operands = new ArrayList<>(); //OperacioUnitariaContext és el tipus de operacioUnitaria, o això diu el xat
  }
  @after{System.out.println(“Sortim de la regla 'operacioMultiplicativa'”);}
  : op1=operacioUnaria { operands.add(op1); } ((STAR | DIVISOR | ENTER_DIVISOR | MODUL) ops=operacioUnaria { operands.add(ops); })*
        {
            // Si hi ha les operacions, TOTS els tipus han de ser números
            //      Important, la promoció es fa d'enter a real. Si trobem un sol real, el return ha de ser real
            // No hi ha cap operació, retornem el tipus de l'anterior

            $tipus = $op1.tipus; // Default

            if(operands.size() > 1){ // Si hi ha alguna operació
                for(OperacioUnariaContext op : operands){ // Per a cada operació Unaria (inclós el primer)
                    //Si no és num, error
                    if(op.tipus != 'E' && op.tipus != 'R'){ //TODO: Poden complexos també?
                        System.err.println("[Error: operació multiplicativa no aplicable a tipus", op.tipus, "]");
                    } else if(op.tipus == 'R'){
                        $tipus = 'R'; //Promoció
                    }
                }
            }
        }
    ;

operacioUnaria returns [char tipus] // El tipus és, o bé booleà en cas de NOT ('Z'), o número en cas de ('~'), o tipus anterior en cas de res
  @init{ System.out.println(“Entrem a la regla 'operacioUnaria'”);}
  @after{System.out.println(“Sortim de la regla 'operacioUnaria'”);}
  : (minus=MINUS_UNIT | not=NOT) operacio=operacioUnaria
        {
            // Si la operació és un NOT, cal que sigui un boleà
            // SI la operació és un minus (~), cal que sigui un número
            if($not.text != null){
                if($operacio.tipus != 'Z'){
                    System.err.println("[Error: 'NOT' no aplicable a tipus '$operacio.tipus']");
                } else { $tipus = 'Z'; }
            } else if($minus.text != null) {
                if($operacio.tipus != 'E' && $operacio.tipus != 'R'){ //TODO: També es pot fer amb complex el ~?
                    System.err.println("[Error: '~' no aplicable a tipus '$operacio.tipus']");
                } else { $tipus = $operacio.tipus; }  // Manté el tipus del número
            }
        }
    | at=atom { $tipus = $at.tipus; } // Si no hi ha operació, mantenim el tipus anterior
    ;

atom returns [char tipus] // Retorna un tipus qualsevol: 'E', 'R', 'C', 'Z', 'D', 'S' ...
  @init{ System.out.println(“Entrem a la regla 'atom'”);}
  @after{System.out.println(“Sortim de la regla 'atom'”);}
  : LPAREN expr=expresio RPAREN { $tipus = $expr.tipus; }
  | val=valortipusbasic { $tipus = $val.tipus; }
  | id=IDENT (acces_vector | acces_tuple | crida)?
      {
            // Buscar a la taula de simbols
            Registre reg = ts.obtenir($id.text);
            if (reg != null) {
                $tipus = reg.getTipus();
                // Si exsteix, serà del tipus definit, o serà del tipus de retorn de la crida
            } else {
                System.err.println("[Error: Variable '" + $id.text + "' no declarada]");
                $tipus = 'D';
            }
      }
  | STRING {$tipus = 'S';}
  ;


// 7. Sentències
sentencia
    @init{ System.out.println(“Entrem a la regla 'sentencia'”);}
    @after{System.out.println(“Sortim de la regla 'sentencia'”);}
    : IDENT (assignacio | crida)
    | condicional
    | per
    | mentre
    | bucle
    | instruccio_lectura_escriptura
    ;

// 7.1 Assignació
assignacio returns [char tipus]
    @init{ System.out.println(“Entrem a la regla 'assignacio'”);}
    @after{System.out.println(“Sortim de la regla 'assignacio'”);}
    : ASSIGN exp=expresio SEMI
        {
            // Retornem el tipus assignat
            $tipus = $exp.tipus;
        }
    ;

// 7.2 Condicional
condicional
    @init{ System.out.println(“Entrem a la regla 'condicional'”);}
    @after{System.out.println(“Sortim de la regla 'condicional'”);}
    : SI exp=expresio LLAVORS sentencia* altrasi* altrament? FSI
    {
        // Si es boleà, avaluar
        if($exp.tipus != 'Z'){
            // TODO: CONVERTIR A TRULY FALSY?
            System.out.println("ERROR: No podem evaluar una expresió que no sigui boleana");
        }
        // Altrament -> Error o convertir a boleà (truly falsy)
    }
    ;

altrasi
    @init{ System.out.println(“Entrem a la regla 'altrasi'”);}
    @after{System.out.println(“Sortim de la regla 'altrasi'”);}
    : ALTRASI exp=expresio LLAVORS sentencia*
    {
        // Si es boleà, avaluar
        if($exp.tipus != 'Z'){
            // TODO: CONVERTIR A TRULY FALSY?
            System.out.println("ERROR: No podem evaluar una expresió que no sigui boleana");
        }
        // Altrament -> Error o convertir a boleà (truly falsy)
    }
    ;

altrament
    @init{ System.out.println(“Entrem a la regla 'altrament'”);}
    @after{System.out.println(“Sortim de la regla 'altrament'”);}
    : ALTRAMENT sentencia*
    {
    }
    ;

// 7.3 Per
per
    : PER IDENT EN RANG LPAREN ENTER (COMMA ENTER)? RPAREN FER sentencia* FPER
    ;

// 7.4 Mentre
mentre
    @init{ System.out.println(“Entrem a la regla 'mentre'”);}
    @after{System.out.println(“Sortim de la regla 'mentre'”);}
    : MENTRE expr=expresio FER sentencia+ FMENTRE
    {
        // Si es boleà, avaluar
        if(exp.tipus != 'Z'){
            // TODO: CONVERTIR A TRULY FALSY?
            System.out.println("ERROR: No podem evaluar una expresió que no sigui boleana");
        }
        // Altrament -> Error o convertir a boleà (truly falsy)
    }
    ;

// 7.5 Bucle
bucle
    @init{ System.out.println(“Entrem a la regla 'bucle'”);}
    @after{System.out.println(“Sortim de la regla 'bucle'”);}
    : BUCLE sentencia* EXIT expr=expresio SEMI sentencia* FBUCLE
    {
        // Si es boleà, avaluar
        if(exp.tipus != 'Z'){
            // TODO: CONVERTIR A TRULY FALSY?
            System.out.println("ERROR: No podem evaluar una expresió que no sigui boleana");
        }
        // Altrament -> Error o convertir a boleà (truly falsy)
    }
    ;

// 7.7 Lectura/escriptura
lectura
    @init{ System.out.println(“Entrem a la regla 'lectura'”);}
    @after{System.out.println(“Sortim de la regla 'lectura'”);}
    : LLEGIR LPAREN id=IDENT (COLON tipus_entrat=tipus_basic)? RPAREN SEMI
        {
            // CAS 1: ID no té tipus, però no li passem tipus
            // CAS 2: ID no té tipus, i sí li passem tipus
            // CAS 3: ID té tipus, i noli passem tipus
            // CAS 4: ID té tipus, i sí li passem tipus

            // Primer anem a cercar id a la taula de símbols
            if(!ts.existeix(id.text)){
                System.out.println("[ERROR: Intentant llegir a una variable que no està declarada]");
            } else {
                Registre variable = ts.obtenir(id.text);
                char tipus = variable.getTipus();
                if(tipus == 'I'){ // CAS 1 o 2
                    if(tipus_entrat == null){ // CAS 1. Maybe no cal error i podem gestionar un autodetectar tipus de la lectura, però la pràctica diu que cal posar-lo
                        System.out.println("[ERROR: Cal indicar un tipus per a la variable que s'està llegint ja quen o en té]");
                    } else { // CAS 2
                        // Conversió string tipus a char tipus
                        char nouTipus = determinarTipusChar(tipus_entrat.text);
                        variable.putTipus(nouTipus);
                    }
                } else { // CAS 3 o 4
                    if(tipus_entrat != null){ // CAS 4
                        // Conversió string tipus a char tipus
                        char nouTipus = determinarTipusChar(tipus_entrat.text);
                        if(nouTipus != tipus){
                            System.out.println("[ERROR: S'ha especificat un tipus diferent al tipus actual de la variable]");
                        }
                    } // Cas 3 no fem re
                }
            }
        }
    ;

escriptura
    @init{ System.out.println(“Entrem a la regla 'escriptura'”);}
    @after{System.out.println(“Sortim de la regla 'escriptura'”);}
    : ESCRIURE LPAREN cridaparametres RPAREN SEMI
        {
        }
    ;

escripturasalt
    @init{ System.out.println(“Entrem a la regla 'escripturasalt'”);}
    @after{System.out.println(“Sortim de la regla 'escripturasalt'”);}
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