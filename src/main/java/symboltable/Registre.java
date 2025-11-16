package symboltable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Registre  {


    String lexema; // Nom
    char tipus; // TIPUS DEFINITS ('E', 'R', 'C', 'Z') o definits ('D')
    int adreca; // Per a generació de codi, encara no toca
    Map<String, String> campsTupla;    // Per tuples: ["edat:enter", "nom:string"]
    List<Integer> midesVector;  // Per vectors: [5, 10]


    public Registre() {
        lexema="";
        tipus='I'; // Indefinit
        adreca=0;
        campsTupla = new HashMap<>();
        midesVector = new ArrayList<>();
    }


    public Registre(String l) {
        lexema=l;
        tipus='I';
        adreca=0;
        campsTupla = new HashMap<>();
        midesVector = new ArrayList<>();
    }
    public Registre(String l, char t) {
        lexema=l;
        tipus=t;
        adreca=0;
        campsTupla = new HashMap<>();
        midesVector = new ArrayList<>();
    }
    public Registre(String l, char t, int a) {
        lexema=l;
        tipus=t;
        adreca=a;
        campsTupla = new HashMap<>();
        midesVector = new ArrayList<>();
    }
    public String getLexema() {
        return (lexema);
    }
    public char getTipus() {
        return (tipus);
    }
    public Integer getAdreca() {
        return (adreca);
    }

    public void putLexema(String l) {
        lexema=l;
    }
    public void putTipus(char t) {
        tipus=t;
    }
    public void putAdreca(int a) {
        adreca=a;
    }

    public void setCampsTupla(Map<String, String> camps) {
        this.campsTupla = camps;
    }

    public void setMidesVector(List<Integer> midesVector){
        this.midesVector.addAll(midesVector);
    }

}

