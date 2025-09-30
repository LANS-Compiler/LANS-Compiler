// Generated from C:/Users/naraf/IdeaProjects/bestcompilador/src/main/antlr4/ProvaLexica.g4 by ANTLR 4.13.2
package org.example;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast", "CheckReturnValue", "this-escape"})
public class ProvaLexica extends Lexer {
	static { RuntimeMetaData.checkVersion("4.13.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		PROGRAMA=1, FPROGRAMA=2, LPAREN=3, RPAREN=4, STAR=5, PLUS=6, SEMI=7, IDENT=8, 
		ENTER=9, LINE_COMMENT=10, WS=11;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"DIGIT", "LETTER", "PROGRAMA", "FPROGRAMA", "LPAREN", "RPAREN", "STAR", 
			"PLUS", "SEMI", "IDENT", "ENTER", "LINE_COMMENT", "WS"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'programa'", "'fprograma'", "'('", "')'", "'*'", "'+'", "';'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "PROGRAMA", "FPROGRAMA", "LPAREN", "RPAREN", "STAR", "PLUS", "SEMI", 
			"IDENT", "ENTER", "LINE_COMMENT", "WS"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}


	public ProvaLexica(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "ProvaLexica.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\u0004\u0000\u000b\\\u0006\uffff\uffff\u0002\u0000\u0007\u0000\u0002\u0001"+
		"\u0007\u0001\u0002\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004"+
		"\u0007\u0004\u0002\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007"+
		"\u0007\u0007\u0002\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002\u000b"+
		"\u0007\u000b\u0002\f\u0007\f\u0001\u0000\u0001\u0000\u0001\u0001\u0001"+
		"\u0001\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001"+
		"\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0003\u0001\u0003\u0001"+
		"\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001"+
		"\u0003\u0001\u0003\u0001\u0004\u0001\u0004\u0001\u0005\u0001\u0005\u0001"+
		"\u0006\u0001\u0006\u0001\u0007\u0001\u0007\u0001\b\u0001\b\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0005\tA\b\t\n\t\f\tD\t\t\u0001\n\u0004\nG\b\n\u000b"+
		"\n\f\nH\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0005\u000bO\b"+
		"\u000b\n\u000b\f\u000bR\t\u000b\u0001\u000b\u0001\u000b\u0001\f\u0004"+
		"\fW\b\f\u000b\f\f\fX\u0001\f\u0001\f\u0000\u0000\r\u0001\u0000\u0003\u0000"+
		"\u0005\u0001\u0007\u0002\t\u0003\u000b\u0004\r\u0005\u000f\u0006\u0011"+
		"\u0007\u0013\b\u0015\t\u0017\n\u0019\u000b\u0001\u0000\u0003\u0003\u0000"+
		"AZaz\u00c0\u00ff\u0002\u0000\n\n\r\r\u0003\u0000\t\n\r\r  _\u0000\u0005"+
		"\u0001\u0000\u0000\u0000\u0000\u0007\u0001\u0000\u0000\u0000\u0000\t\u0001"+
		"\u0000\u0000\u0000\u0000\u000b\u0001\u0000\u0000\u0000\u0000\r\u0001\u0000"+
		"\u0000\u0000\u0000\u000f\u0001\u0000\u0000\u0000\u0000\u0011\u0001\u0000"+
		"\u0000\u0000\u0000\u0013\u0001\u0000\u0000\u0000\u0000\u0015\u0001\u0000"+
		"\u0000\u0000\u0000\u0017\u0001\u0000\u0000\u0000\u0000\u0019\u0001\u0000"+
		"\u0000\u0000\u0001\u001b\u0001\u0000\u0000\u0000\u0003\u001d\u0001\u0000"+
		"\u0000\u0000\u0005\u001f\u0001\u0000\u0000\u0000\u0007(\u0001\u0000\u0000"+
		"\u0000\t2\u0001\u0000\u0000\u0000\u000b4\u0001\u0000\u0000\u0000\r6\u0001"+
		"\u0000\u0000\u0000\u000f8\u0001\u0000\u0000\u0000\u0011:\u0001\u0000\u0000"+
		"\u0000\u0013<\u0001\u0000\u0000\u0000\u0015F\u0001\u0000\u0000\u0000\u0017"+
		"J\u0001\u0000\u0000\u0000\u0019V\u0001\u0000\u0000\u0000\u001b\u001c\u0002"+
		"09\u0000\u001c\u0002\u0001\u0000\u0000\u0000\u001d\u001e\u0007\u0000\u0000"+
		"\u0000\u001e\u0004\u0001\u0000\u0000\u0000\u001f \u0005p\u0000\u0000 "+
		"!\u0005r\u0000\u0000!\"\u0005o\u0000\u0000\"#\u0005g\u0000\u0000#$\u0005"+
		"r\u0000\u0000$%\u0005a\u0000\u0000%&\u0005m\u0000\u0000&\'\u0005a\u0000"+
		"\u0000\'\u0006\u0001\u0000\u0000\u0000()\u0005f\u0000\u0000)*\u0005p\u0000"+
		"\u0000*+\u0005r\u0000\u0000+,\u0005o\u0000\u0000,-\u0005g\u0000\u0000"+
		"-.\u0005r\u0000\u0000./\u0005a\u0000\u0000/0\u0005m\u0000\u000001\u0005"+
		"a\u0000\u00001\b\u0001\u0000\u0000\u000023\u0005(\u0000\u00003\n\u0001"+
		"\u0000\u0000\u000045\u0005)\u0000\u00005\f\u0001\u0000\u0000\u000067\u0005"+
		"*\u0000\u00007\u000e\u0001\u0000\u0000\u000089\u0005+\u0000\u00009\u0010"+
		"\u0001\u0000\u0000\u0000:;\u0005;\u0000\u0000;\u0012\u0001\u0000\u0000"+
		"\u0000<B\u0003\u0003\u0001\u0000=A\u0003\u0003\u0001\u0000>A\u0003\u0001"+
		"\u0000\u0000?A\u0005_\u0000\u0000@=\u0001\u0000\u0000\u0000@>\u0001\u0000"+
		"\u0000\u0000@?\u0001\u0000\u0000\u0000AD\u0001\u0000\u0000\u0000B@\u0001"+
		"\u0000\u0000\u0000BC\u0001\u0000\u0000\u0000C\u0014\u0001\u0000\u0000"+
		"\u0000DB\u0001\u0000\u0000\u0000EG\u0003\u0001\u0000\u0000FE\u0001\u0000"+
		"\u0000\u0000GH\u0001\u0000\u0000\u0000HF\u0001\u0000\u0000\u0000HI\u0001"+
		"\u0000\u0000\u0000I\u0016\u0001\u0000\u0000\u0000JK\u0005/\u0000\u0000"+
		"KL\u0005/\u0000\u0000LP\u0001\u0000\u0000\u0000MO\b\u0001\u0000\u0000"+
		"NM\u0001\u0000\u0000\u0000OR\u0001\u0000\u0000\u0000PN\u0001\u0000\u0000"+
		"\u0000PQ\u0001\u0000\u0000\u0000QS\u0001\u0000\u0000\u0000RP\u0001\u0000"+
		"\u0000\u0000ST\u0006\u000b\u0000\u0000T\u0018\u0001\u0000\u0000\u0000"+
		"UW\u0007\u0002\u0000\u0000VU\u0001\u0000\u0000\u0000WX\u0001\u0000\u0000"+
		"\u0000XV\u0001\u0000\u0000\u0000XY\u0001\u0000\u0000\u0000YZ\u0001\u0000"+
		"\u0000\u0000Z[\u0006\f\u0000\u0000[\u001a\u0001\u0000\u0000\u0000\u0006"+
		"\u0000@BHPX\u0001\u0006\u0000\u0000";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}