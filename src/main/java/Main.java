import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class Main {

    public static void main(String[] args) {
        try {
            String filename = (args != null && args.length > 0)
                    ? args[0]
                    : askFilenameInteractive();

            Path path = Paths.get(filename);
            if (!Files.exists(path)) {
                System.err.println("No s'ha trobat el fitxer: " + filename);
                System.exit(1);
            }

            // 1) Crear el CharStream des del fitxer
            CharStream cs = CharStreams.fromPath(path);

            // 2) Lexer
            compiladorLexer lexer = new compiladorLexer(cs);
            CommonTokenStream tokens = new CommonTokenStream(lexer);

            // --- AMB PARSER (recomanat) ---
            compiladorParser parser = new compiladorParser(tokens);

            // (Opcional) Mostrar errors més clars:
            parser.removeErrorListeners();
            parser.addErrorListener(new DiagnosticErrorListener());

            // 3) Crida a la regla inicial (adapta-la si la teva és una altra: expr, start, etc.)
            ParseTree tree = parser.programa();

            // 4) Imprimir l’arbre sintàctic en format LISP
            System.out.println(tree.toStringTree(parser));

            // 5) OBRIR VISOR GRÀFIC
            org.antlr.v4.gui.Trees.inspect(tree, parser);  // ← obre una finestra Swing amb l’arbre



        } catch (IOException e) {
            System.err.println("Error d'E/S: " + e.getMessage());
            System.exit(1);
        } catch (Exception e) {
            System.err.println("Error inesperat: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }

    private static String askFilenameInteractive() throws IOException {
        System.out.print("Introdueix el nom del fitxer a parsejar: ");
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String line = br.readLine();
        if (line == null || line.trim().isEmpty()) {
            throw new IllegalArgumentException("No s'ha proporcionat cap fitxer.");
        }
        return line.trim();
    }
}