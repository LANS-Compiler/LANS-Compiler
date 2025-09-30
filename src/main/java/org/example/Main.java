package org.example;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.nio.file.*;


public class Main {
    public static void main(String[] args) throws Exception {
        String input = Files.readString(Path.of(args.length > 0 ? args[0] : "-"));
        CharStream cs = CharStreams.fromString(input);
        ProvaLexica lexer = new ProvaLexica(cs);
        CommonTokenStream ts = new CommonTokenStream(lexer);
        ts.fill();
        for (Token t : ts.getTokens()) {
            System.out.printf("%-15s '%s' @%d:%d\n",
                    ProvaLexica.VOCABULARY.getSymbolicName(t.getType()),
                    t.getText(), t.getLine(), t.getCharPositionInLine());
        }
    }
}