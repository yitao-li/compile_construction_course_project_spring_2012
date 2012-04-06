
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 5 "parser.y"


#include <fstream>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <map>   //data structure for symbol table
#include <list>
#include <string>
#include "lex.h"

#define YYDEBUG 1
#define YYERROR_VERBOSE 1
#define FW 50
#define SYM_OUTPUT "symtable.out"
#define RULES_OUTPUT "rules.out"

typedef struct id_attr{
	std::string type;
	size_t addr;
} id_attr;

typedef struct scope{
	std::map< std::string, id_attr > symt;
	scope *p;
	scope(void):p(NULL){
		symt["integer"] = {"integer", 0};    //predefined types
		symt["string"] = {"string", 1};
		symt["boolean"] = {"boolean", 2};
	}
	scope(scope *_p):p(_p){}
} scope;

scope prog_scope, *current_scope = &prog_scope;

int argc = 0, current_argc = 0, current_sgn, current_const, current_l, current_u;
std::string current_id, current_type, type, current_typename;
std::list<std::string> current_argv;
std::fstream rules_out(RULES_OUTPUT, std::ios::out | std::ios::trunc);

template <class T>
inline std::string to_string (const T & t){
	std::stringstream ss;
	ss << t;
	return ss.str();
}

int yyerror(const char *), UpdateVar(void), UpdateType(void), LookupVar(scope *, const std::string);
std::string LookupTypeDef(const std::string);



/* Line 189 of yacc.c  */
#line 126 "parser.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     T_AND = 258,
     T_BEGIN = 259,
     T_FORWARD = 260,
     T_DIV = 261,
     T_DO = 262,
     T_ELSE = 263,
     T_END = 264,
     T_FOR = 265,
     T_FUNCTION = 266,
     T_IF = 267,
     T_ARRAY = 268,
     T_MOD = 269,
     T_NOT = 270,
     T_OF = 271,
     T_OR = 272,
     T_PROCEDURE = 273,
     T_PROGRAM = 274,
     T_RECORD = 275,
     T_THEN = 276,
     T_TO = 277,
     T_TYPE = 278,
     T_VAR = 279,
     T_WHILE = 280,
     T_ID = 281,
     T_INT = 282,
     T_STR = 283,
     T_ASSIGNMENT = 284,
     T_RANGE = 285,
     T_RELOP = 286,
     T_MULOP = 287,
     T_ADDOP = 288
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 201 "parser.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   174

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  45
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  72
/* YYNRULES -- Number of rules.  */
#define YYNRULES  115
/* YYNRULES -- Number of states.  */
#define YYNSTATES  208

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   288

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      38,    39,     2,    43,    42,    44,    35,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    37,    34,
       2,    36,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    40,     2,    41,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,    14,    19,    20,    22,    23,    27,
      28,    29,    35,    40,    41,    46,    47,    49,    50,    54,
      55,    57,    58,    62,    64,    66,    67,    68,    78,    79,
      80,    92,    94,    96,    97,    99,   100,   101,   108,   109,
     110,   117,   118,   121,   124,   128,   131,   133,   135,   136,
     138,   140,   144,   149,   151,   157,   162,   171,   172,   175,
     176,   180,   181,   184,   185,   186,   187,   188,   201,   202,
     203,   209,   211,   212,   213,   219,   221,   224,   226,   230,
     232,   234,   237,   241,   243,   245,   248,   249,   253,   255,
     257,   259,   261,   263,   265,   267,   269,   272,   276,   277,
     281,   286,   289,   290,   294,   299,   300,   303,   304,   308,
     309,   313,   314,   315,   320,   322
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      46,     0,    -1,    -1,    19,    26,    47,    34,    49,    57,
      59,    77,    35,    -1,    23,    51,    34,    50,    -1,    -1,
      48,    -1,    -1,    51,    34,    50,    -1,    -1,    -1,    26,
      52,    36,    86,    53,    -1,    24,    55,    34,    58,    -1,
      -1,   112,    37,    86,    56,    -1,    -1,    54,    -1,    -1,
      55,    34,    58,    -1,    -1,    60,    -1,    -1,    61,    34,
      60,    -1,    62,    -1,    65,    -1,    -1,    -1,    18,    26,
      63,    38,    69,    64,    39,    34,    68,    -1,    -1,    -1,
      11,    26,    66,    38,    69,    67,    39,    37,    94,    34,
      68,    -1,    75,    -1,     5,    -1,    -1,    70,    -1,    -1,
      -1,    71,   112,    37,    86,    72,    73,    -1,    -1,    -1,
      34,   112,    37,    86,    74,    73,    -1,    -1,    76,    77,
      -1,    54,    77,    -1,     4,    78,     9,    -1,    79,    85,
      -1,    80,    -1,    83,    -1,    -1,    81,    -1,    82,    -1,
     108,    29,    98,    -1,    26,    38,   110,    39,    -1,    77,
      -1,    12,    98,    21,    79,    84,    -1,    25,    98,     7,
      79,    -1,    10,    26,    29,    98,    22,    98,     7,    79,
      -1,    -1,     8,    79,    -1,    -1,    34,    79,    85,    -1,
      -1,    26,    87,    -1,    -1,    -1,    -1,    -1,    13,    40,
      97,    88,    30,    97,    89,    41,    16,    90,    86,    91,
      -1,    -1,    -1,    20,    92,    95,     9,    93,    -1,    26,
      -1,    -1,    -1,   112,    37,    86,    96,    73,    -1,    27,
      -1,   116,    27,    -1,   100,    -1,   100,    99,   100,    -1,
      31,    -1,    36,    -1,   102,   103,    -1,   116,   102,   103,
      -1,    33,    -1,    17,    -1,   105,   106,    -1,    -1,   101,
     102,   103,    -1,    32,    -1,     6,    -1,    14,    -1,     3,
      -1,    27,    -1,    28,    -1,   108,    -1,   107,    -1,    15,
     105,    -1,    38,    98,    39,    -1,    -1,   104,   105,   106,
      -1,    26,    38,   110,    39,    -1,    26,   109,    -1,    -1,
      35,    26,   109,    -1,    40,    98,    41,   109,    -1,    -1,
      98,   111,    -1,    -1,    42,    98,   111,    -1,    -1,    26,
     113,   114,    -1,    -1,    -1,    42,    26,   115,   114,    -1,
      43,    -1,    44,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    66,    66,    65,    77,    82,    84,    89,    91,    96,
      99,    96,   112,   117,   117,   122,   124,   129,   131,   136,
     138,   143,   145,   150,   152,   158,   161,   157,   170,   172,
     170,   181,   186,   194,   194,   199,   202,   199,   209,   211,
     211,   219,   219,   228,   237,   242,   247,   249,   254,   256,
     258,   263,   268,   273,   275,   277,   279,   284,   286,   291,
     293,   298,   298,   305,   305,   306,   308,   305,   313,   315,
     313,   322,   327,   329,   329,   342,   348,   357,   359,   364,
     366,   371,   373,   378,   380,   385,   390,   392,   397,   399,
     401,   403,   408,   410,   412,   414,   416,   418,   423,   425,
     430,   435,   440,   442,   444,   449,   451,   456,   458,   463,
     463,   471,   473,   473,   481,   487
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "T_AND", "T_BEGIN", "T_FORWARD", "T_DIV",
  "T_DO", "T_ELSE", "T_END", "T_FOR", "T_FUNCTION", "T_IF", "T_ARRAY",
  "T_MOD", "T_NOT", "T_OF", "T_OR", "T_PROCEDURE", "T_PROGRAM", "T_RECORD",
  "T_THEN", "T_TO", "T_TYPE", "T_VAR", "T_WHILE", "T_ID", "T_INT", "T_STR",
  "T_ASSIGNMENT", "T_RANGE", "T_RELOP", "T_MULOP", "T_ADDOP", "';'", "'.'",
  "'='", "':'", "'('", "')'", "'['", "']'", "','", "'+'", "'-'", "$accept",
  "Program", "$@1", "TypeDefinitions", "OptTypeDefinitions",
  "_OptTypeDefinitions", "TypeDefinition", "$@2", "$@3",
  "VariableDeclarations", "VariableDeclaration", "$@4",
  "OptVariableDeclarations", "_OptVariableDeclarations",
  "OptSubprogramDeclarations", "SubprogramDeclarations",
  "SubprogramDeclaration", "ProcedureDeclaration", "$@5", "$@6",
  "FunctionDeclaration", "$@7", "$@8", "DeclarationBody",
  "FormalParameterList", "$@9", "$@10", "$@11", "OptIdentifiers", "$@12",
  "Block", "$@13", "CompoundStatement", "StatementSequence", "Statement",
  "SimpleStatement", "AssignmentStatement", "ProcedureStatement",
  "StructuredStatement", "CloseIf", "Statements", "Type", "$@14", "$@15",
  "$@16", "$@17", "$@18", "$@19", "$@20", "ResultType", "FieldList",
  "$@21", "Constant", "Expression", "RelationalOp", "SimpleExpression",
  "AddOp", "Term", "Summand", "MulOp", "Factor", "Multiplicand",
  "FunctionReference", "Variable", "ComponentSelection",
  "ActualParameterList", "OptExpressions", "IdentifierList", "$@22",
  "Identifiers", "$@23", "Sign", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,    59,    46,    61,    58,    40,    41,
      91,    93,    44,    43,    45
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    45,    47,    46,    48,    49,    49,    50,    50,    52,
      53,    51,    54,    56,    55,    57,    57,    58,    58,    59,
      59,    60,    60,    61,    61,    63,    64,    62,    66,    67,
      65,    68,    68,    70,    69,    71,    72,    69,    73,    74,
      73,    76,    75,    75,    77,    78,    79,    79,    80,    80,
      80,    81,    82,    83,    83,    83,    83,    84,    84,    85,
      85,    87,    86,    88,    89,    90,    91,    86,    92,    93,
      86,    94,    95,    96,    95,    97,    97,    98,    98,    99,
      99,   100,   100,   101,   101,   102,   103,   103,   104,   104,
     104,   104,   105,   105,   105,   105,   105,   105,   106,   106,
     107,   108,   109,   109,   109,   110,   110,   111,   111,   113,
     112,   114,   115,   114,   116,   116
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     9,     4,     0,     1,     0,     3,     0,
       0,     5,     4,     0,     4,     0,     1,     0,     3,     0,
       1,     0,     3,     1,     1,     0,     0,     9,     0,     0,
      11,     1,     1,     0,     1,     0,     0,     6,     0,     0,
       6,     0,     2,     2,     3,     2,     1,     1,     0,     1,
       1,     3,     4,     1,     5,     4,     8,     0,     2,     0,
       3,     0,     2,     0,     0,     0,     0,    12,     0,     0,
       5,     1,     0,     0,     5,     1,     2,     1,     3,     1,
       1,     2,     3,     1,     1,     2,     0,     3,     1,     1,
       1,     1,     1,     1,     1,     1,     2,     3,     0,     3,
       4,     2,     0,     3,     4,     0,     2,     0,     3,     0,
       3,     0,     0,     4,     1,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     2,     1,     0,     5,     0,     6,    15,
       9,     0,     0,    16,    19,     0,     7,   109,     0,     0,
       0,     0,     0,    20,     0,    23,    24,     0,     4,     0,
     111,    17,     0,    28,    25,    48,     0,    21,     0,    68,
      61,    10,     7,     0,   110,     0,    12,    13,     0,     0,
       0,     0,     0,   102,    53,     0,    59,    46,    49,    50,
      47,     0,     3,    22,     0,    72,    62,    11,     8,   112,
      17,    14,    33,    33,     0,     0,   102,    92,    93,     0,
     114,   115,     0,    77,    86,    98,    95,    94,     0,     0,
       0,   105,     0,   101,    44,    48,    45,     0,    75,    63,
       0,     0,     0,   111,    18,    29,    34,     0,    26,     0,
      96,   105,     0,    48,    79,    80,     0,    84,    83,     0,
      81,    91,    89,    90,    88,     0,    85,    86,    48,   102,
     107,     0,     0,    59,    51,     0,    76,    69,     0,   113,
       0,     0,     0,     0,     0,    97,    57,    78,    86,    98,
      82,    55,   103,     0,   106,    52,   102,    60,     0,    70,
      73,     0,     0,     0,     0,   100,    48,    54,    87,    99,
     107,   104,    64,    38,     0,    36,    41,     0,    58,   108,
       0,     0,    74,    71,     0,    38,    32,     0,    27,    31,
       0,    48,     0,     0,    41,    37,    43,    42,    56,    65,
       0,    30,     0,    39,    66,    38,    67,    40
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     5,     8,     9,    28,    29,    15,    67,   187,
      45,    71,    14,    46,    22,    23,    24,    25,    49,   142,
      26,    48,   140,   188,   105,   106,   107,   185,   182,   205,
     189,   190,    54,    55,    56,    57,    58,    59,    60,   167,
      96,    41,    66,   135,   180,   202,   206,    65,   159,   184,
     101,   173,    99,   130,   116,    83,   119,    84,   120,   125,
      85,   126,    86,    87,    93,   131,   154,    19,    30,    44,
     103,    88
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -174
static const yytype_int16 yypact[] =
{
       0,    -9,    20,  -174,  -174,    -7,    12,     2,  -174,    25,
    -174,    16,    27,  -174,     5,    23,     2,  -174,    26,    31,
      44,    46,    69,  -174,    42,  -174,  -174,    58,  -174,    47,
      45,    27,    58,  -174,  -174,    57,    51,     5,    49,  -174,
    -174,  -174,     2,    65,  -174,    59,  -174,  -174,    54,    56,
      70,    -2,    -2,    39,  -174,    88,    64,  -174,  -174,  -174,
    -174,    73,  -174,  -174,    21,    27,  -174,  -174,  -174,  -174,
      27,  -174,    77,    77,    75,    28,    50,  -174,  -174,    -2,
    -174,  -174,    78,     8,    -3,    15,  -174,  -174,    28,    98,
      82,    -2,    -2,  -174,  -174,    57,  -174,    -2,  -174,  -174,
      83,   100,    74,    45,  -174,  -174,  -174,    27,  -174,    -2,
    -174,    -2,    76,    57,  -174,  -174,    -2,  -174,  -174,    28,
    -174,  -174,  -174,  -174,  -174,    28,  -174,    -3,    57,    17,
      71,    81,    80,    64,  -174,    84,  -174,  -174,    58,  -174,
      85,    79,    86,    90,    87,  -174,   109,  -174,    -3,    15,
    -174,  -174,  -174,    -2,  -174,  -174,    17,  -174,    21,  -174,
    -174,    91,    58,    89,    -2,  -174,    57,  -174,  -174,  -174,
      71,  -174,  -174,    93,    96,  -174,    10,   122,  -174,  -174,
      94,    27,  -174,  -174,    97,    93,  -174,    69,  -174,  -174,
      69,    57,   116,    99,    10,  -174,  -174,  -174,  -174,  -174,
      58,  -174,    58,  -174,  -174,    93,  -174,  -174
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -174,  -174,  -174,  -174,  -174,    92,   130,  -174,  -174,   129,
     127,  -174,  -174,    72,  -174,   103,  -174,  -174,  -174,  -174,
    -174,  -174,  -174,   -53,   101,  -174,  -174,  -174,  -173,  -174,
    -174,  -174,   -21,  -174,   -91,  -174,  -174,  -174,  -174,  -174,
      11,   -32,  -174,  -174,  -174,  -174,  -174,  -174,  -174,  -174,
    -174,  -174,   -15,   -46,  -174,    29,  -174,   -79,  -117,  -174,
     -67,    -1,  -174,   -33,  -118,    35,   -23,   -62,  -174,    48,
    -174,   -57
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -36
static const yytype_int16 yytable[] =
{
      47,    36,    61,   102,   133,    82,    89,   100,   110,   127,
     150,   152,   195,    75,   117,   186,    20,     3,   121,     1,
       4,   122,   146,    21,    76,    77,    78,     6,    10,   123,
     118,   168,   207,   112,    12,     7,    79,   151,   171,   114,
     148,    80,    81,    75,   115,   141,   132,   124,    98,    12,
      16,   134,    90,    17,    76,    77,    78,    92,   149,    27,
      31,    35,    61,   143,    80,    81,    79,    50,    32,    51,
      33,    38,    34,    35,    90,   178,    37,    91,    39,    92,
      61,    42,    52,    53,    40,    90,    62,    43,   111,    64,
      92,    69,    72,    70,    73,    61,    74,    94,    95,   113,
     198,   100,    97,   -35,   109,   128,   160,   170,   129,   137,
     136,   138,   164,   153,   158,   145,   162,   166,   177,   193,
     155,   156,   183,   176,   161,   163,   165,   181,   174,   191,
     175,   194,   199,    61,    68,   192,   200,    11,    13,    18,
      63,   201,   104,   172,   157,   147,   144,   179,   169,     0,
       0,   139,     0,     0,     0,     0,     0,     0,    61,     0,
       0,     0,     0,     0,     0,     0,   196,     0,   203,   197,
     204,     0,     0,     0,   108
};

static const yytype_int16 yycheck[] =
{
      32,    22,    35,    65,    95,    51,    52,    64,    75,    88,
     127,   129,   185,    15,    17,     5,    11,    26,     3,    19,
       0,     6,   113,    18,    26,    27,    28,    34,    26,    14,
      33,   148,   205,    79,    24,    23,    38,   128,   156,    31,
     119,    43,    44,    15,    36,   107,    92,    32,    27,    24,
      34,    97,    35,    26,    26,    27,    28,    40,   125,    36,
      34,     4,    95,   109,    43,    44,    38,    10,    37,    12,
      26,    13,    26,     4,    35,   166,    34,    38,    20,    40,
     113,    34,    25,    26,    26,    35,    35,    42,    38,    40,
      40,    26,    38,    34,    38,   128,    26,     9,    34,    21,
     191,   158,    29,    26,    29,     7,   138,   153,    26,     9,
      27,    37,    22,    42,    30,    39,    37,     8,   164,   181,
      39,    41,    26,    34,    39,    39,    39,    34,    37,     7,
     162,    34,    16,   166,    42,    41,    37,     7,     9,    12,
      37,   194,    70,   158,   133,   116,   111,   170,   149,    -1,
      -1,   103,    -1,    -1,    -1,    -1,    -1,    -1,   191,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   187,    -1,   200,   190,
     202,    -1,    -1,    -1,    73
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    19,    46,    26,     0,    47,    34,    23,    48,    49,
      26,    51,    24,    54,    57,    52,    34,    26,    55,   112,
      11,    18,    59,    60,    61,    62,    65,    36,    50,    51,
     113,    34,    37,    26,    26,     4,    77,    34,    13,    20,
      26,    86,    34,    42,   114,    55,    58,    86,    66,    63,
      10,    12,    25,    26,    77,    78,    79,    80,    81,    82,
      83,   108,    35,    60,    40,    92,    87,    53,    50,    26,
      34,    56,    38,    38,    26,    15,    26,    27,    28,    38,
      43,    44,    98,   100,   102,   105,   107,   108,   116,    98,
      35,    38,    40,   109,     9,    34,    85,    29,    27,    97,
     116,    95,   112,   115,    58,    69,    70,    71,    69,    29,
     105,    38,    98,    21,    31,    36,    99,    17,    33,   101,
     103,     3,     6,    14,    32,   104,   106,   102,     7,    26,
      98,   110,    98,    79,    98,    88,    27,     9,    37,   114,
      67,   112,    64,    98,   110,    39,    79,   100,   102,   105,
     103,    79,   109,    42,   111,    39,    41,    85,    30,    93,
      86,    39,    37,    39,    22,    39,     8,    84,   103,   106,
      98,   109,    97,    96,    37,    86,    34,    98,    79,   111,
      89,    34,    73,    26,    94,    72,     5,    54,    68,    75,
      76,     7,    41,   112,    34,    73,    77,    77,    79,    16,
      37,    68,    90,    86,    86,    74,    91,    73
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:

/* Line 1455 of yacc.c  */
#line 66 "parser.y"
    {
	current_scope -> symt[std::string("program ").append(std::string(yytext_ptr))] = {"program", current_scope -> symt.size()};
;}
    break;

  case 3:

/* Line 1455 of yacc.c  */
#line 70 "parser.y"
    {
	rules_out<<"Program\n";
;}
    break;

  case 4:

/* Line 1455 of yacc.c  */
#line 77 "parser.y"
    {rules_out<<"TypeDefinitions\n";;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 82 "parser.y"
    {rules_out<<"OptTypeDefinitions\n";;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 84 "parser.y"
    {rules_out<<"OptTypeDefinitions\n";;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 89 "parser.y"
    {rules_out<<"_OptTypeDefinitions\n";;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 91 "parser.y"
    {rules_out<<"_OptTypeDefinitions\n";;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 96 "parser.y"
    {
	current_id = std::string("typedef ").append(current_typename = std::string(yytext_ptr));
;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 99 "parser.y"
    {
	current_scope -> symt[current_id] = {current_type, current_scope -> symt.size()};
	prog_scope.symt[current_typename] = {LookupTypeDef(current_type), current_scope -> symt.size()};
	
	//std::cout<<current_typename<<" IS "<<LookupTypeDef(current_type)<<std::endl;
	
	current_type = "";
;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 107 "parser.y"
    {rules_out<<"TypeDefinition\n";;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 112 "parser.y"
    {rules_out<<"VariableDeclarations\n";;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 117 "parser.y"
    {UpdateVar();;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 117 "parser.y"
    {rules_out<<"VariableDeclaration\n";;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 122 "parser.y"
    {rules_out<<"OptVariableDeclarations\n";;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 124 "parser.y"
    {rules_out<<"OptVariableDeclarations\n";;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 129 "parser.y"
    {rules_out<<"_OptVariableDeclarations\n";;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 131 "parser.y"
    {rules_out<<"_OptVariableDeclarations\n";;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 136 "parser.y"
    {rules_out<<"OptSubprogramDeclarations\n";;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 138 "parser.y"
    {rules_out<<"OptSubprogramDeclarations\n";;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 143 "parser.y"
    {rules_out<<"SubprogramDeclarations\n";;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 145 "parser.y"
    {rules_out<<"SubprogramDeclarations\n";;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 150 "parser.y"
    {rules_out<<"SubprogramDeclaration\n";;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 152 "parser.y"
    {rules_out<<"SubprogramDeclaration\n";;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 158 "parser.y"
    {
	current_id = std::string(yytext_ptr);
;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 161 "parser.y"
    {
	current_scope -> symt[std::string("procedure ").append(current_id)] = {to_string<int>(argc), current_scope -> symt.size()};
	current_type = "";
	argc = 0;
;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 165 "parser.y"
    {rules_out<<"ProcedureDeclaration\n";;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 170 "parser.y"
    {
	current_id = std::string(yytext_ptr);
;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 172 "parser.y"
    {
	current_scope -> symt[std::string("function ").append(current_id)] = {to_string<int>(argc), current_scope -> symt.size()};
	current_type = "";
	argc = 0;
;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 176 "parser.y"
    {rules_out<<"FunctionDeclaration\n";;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 182 "parser.y"
    {
	rules_out<<"DeclarationBody\n";
;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 187 "parser.y"
    {
	rules_out<<"DeclarationBody\n";
;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 194 "parser.y"
    {
	argc = 0;
;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 197 "parser.y"
    {rules_out<<"FormalParameterList\n";;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 199 "parser.y"
    {
	argc = 0;
;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 202 "parser.y"
    {
	UpdateType();
;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 204 "parser.y"
    {rules_out<<"FormalParameterList\n";;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 209 "parser.y"
    {rules_out<<"OptIdentifiers\n";;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 211 "parser.y"
    {
	UpdateType();
;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 214 "parser.y"
    {rules_out<<"OptIdentifiers\n";;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 219 "parser.y"
    {
	current_scope = new scope(current_scope);
;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 223 "parser.y"
    {
	rules_out<<"Block\n";
	current_scope = current_scope -> p;
;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 229 "parser.y"
    {
	rules_out<<"Block\n";
	current_scope = current_scope -> p;
;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 237 "parser.y"
    {rules_out<<"CompoundStatement\n";;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 242 "parser.y"
    {rules_out<<"StatementSequence\n";;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 247 "parser.y"
    {rules_out<<"Statement\n";;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 249 "parser.y"
    {rules_out<<"Statement\n";;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 254 "parser.y"
    {rules_out<<"SimpleStatement\n";;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 256 "parser.y"
    {rules_out<<"SimpleStatement\n";;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 258 "parser.y"
    {rules_out<<"SimpleStatement\n";;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 263 "parser.y"
    {rules_out<<"AssignmentStatement\n";;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 268 "parser.y"
    {rules_out<<"ProcedureStatement\n";;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 273 "parser.y"
    {rules_out<<"StructuredStatement\n";;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 275 "parser.y"
    {rules_out<<"StructuredStatement\n";;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 277 "parser.y"
    {rules_out<<"StructuredStatement\n";;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 279 "parser.y"
    {rules_out<<"StructuredStatement\n";;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 284 "parser.y"
    {rules_out<<"CloseIf\n";;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 286 "parser.y"
    {rules_out<<"CloseIf\n";;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 291 "parser.y"
    {rules_out<<"Statements\n";;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 293 "parser.y"
    {rules_out<<"Statements\n";;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 298 "parser.y"
    {
	type = std::string(yytext_ptr);
	if (current_type == ""){
		current_type = type;
	}
;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 303 "parser.y"
    {rules_out<<"Type\n";;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 305 "parser.y"
    {current_l = current_const;;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 305 "parser.y"
    {current_u = current_const;;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 306 "parser.y"
    {
	current_type.append("array[").append(to_string<int>(current_l)).append("..").append(to_string<int>(current_u)).append("]_of_");
;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 308 "parser.y"
    {rules_out<<"Type\n";;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 309 "parser.y"
    {
	current_type.append(LookupTypeDef(type));
;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 313 "parser.y"
    {
	current_type.append("record{");
;}
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 315 "parser.y"
    {
	current_type.append("}");
;}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 317 "parser.y"
    {rules_out<<"Type\n";;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 322 "parser.y"
    {rules_out<<"ResultType\n";;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 327 "parser.y"
    {rules_out<<"FieldList\n";;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 329 "parser.y"
    {
	for (int i = 0; i < current_argc; ++i){
	//std::cout<<"line 350: current_argc == "<<current_argc<<std::endl;
		current_type.append(LookupTypeDef(type)).append(",");
	}
	current_argv.clear();
	current_argc = 0;
;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 337 "parser.y"
    {rules_out<<"FieldList\n";;}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 343 "parser.y"
    {
	current_const = atoi(yytext_ptr);
	rules_out<<"Constant\n";
;}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 349 "parser.y"
    {
	current_const = current_sgn * atoi(yytext_ptr);
	rules_out<<"Constant\n";
;}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 357 "parser.y"
    {rules_out<<"Expression\n";;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 359 "parser.y"
    {rules_out<<"Expression\n";;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 364 "parser.y"
    {rules_out<<"RelationalOp\n";;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 366 "parser.y"
    {rules_out<<"RelationalOp\n";;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 371 "parser.y"
    {rules_out<<"SimpleExpression\n";;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 373 "parser.y"
    {rules_out<<"SimpleExpression\n";;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 378 "parser.y"
    {rules_out<<"AddOp\n";;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 380 "parser.y"
    {rules_out<<"AddOp\n";;}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 385 "parser.y"
    {rules_out<<"Term\n";;}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 390 "parser.y"
    {rules_out<<"Summand\n";;}
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 392 "parser.y"
    {rules_out<<"Summand\n";;}
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 397 "parser.y"
    {rules_out<<"MulOp\n";;}
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 399 "parser.y"
    {rules_out<<"MulOp\n";;}
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 401 "parser.y"
    {rules_out<<"MulOp\n";;}
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 403 "parser.y"
    {rules_out<<"MulOp\n";;}
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 408 "parser.y"
    {rules_out<<"Factor\n";;}
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 410 "parser.y"
    {rules_out<<"Factor\n";;}
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 412 "parser.y"
    {rules_out<<"Factor\n";;}
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 414 "parser.y"
    {rules_out<<"Factor\n";;}
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 416 "parser.y"
    {rules_out<<"Factor\n";;}
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 418 "parser.y"
    {rules_out<<"Factor\n";;}
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 423 "parser.y"
    {rules_out<<"Multiplicand\n";;}
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 425 "parser.y"
    {rules_out<<"Multiplicand\n";;}
    break;

  case 100:

/* Line 1455 of yacc.c  */
#line 430 "parser.y"
    {rules_out<<"FunctionReference\n";;}
    break;

  case 101:

/* Line 1455 of yacc.c  */
#line 435 "parser.y"
    {rules_out<<"Variable\n";;}
    break;

  case 102:

/* Line 1455 of yacc.c  */
#line 440 "parser.y"
    {rules_out<<"ComponentSelection\n";;}
    break;

  case 103:

/* Line 1455 of yacc.c  */
#line 442 "parser.y"
    {rules_out<<"ComponentSelection\n";;}
    break;

  case 104:

/* Line 1455 of yacc.c  */
#line 444 "parser.y"
    {rules_out<<"ComponentSelection\n";;}
    break;

  case 105:

/* Line 1455 of yacc.c  */
#line 449 "parser.y"
    {rules_out<<"ActualParameterList\n";;}
    break;

  case 106:

/* Line 1455 of yacc.c  */
#line 451 "parser.y"
    {rules_out<<"ActualParameterList\n";;}
    break;

  case 107:

/* Line 1455 of yacc.c  */
#line 456 "parser.y"
    {rules_out<<"OptExpressions\n";;}
    break;

  case 108:

/* Line 1455 of yacc.c  */
#line 458 "parser.y"
    {rules_out<<"OptExpressions\n";;}
    break;

  case 109:

/* Line 1455 of yacc.c  */
#line 463 "parser.y"
    {
	current_argv.push_back(std::string(yytext_ptr));
	++current_argc;
;}
    break;

  case 110:

/* Line 1455 of yacc.c  */
#line 466 "parser.y"
    {rules_out<<"IdentifierList\n";;}
    break;

  case 111:

/* Line 1455 of yacc.c  */
#line 471 "parser.y"
    {rules_out<<"Identifiers\n";;}
    break;

  case 112:

/* Line 1455 of yacc.c  */
#line 473 "parser.y"
    {
	current_argv.push_back(std::string(yytext_ptr));
	++current_argc;
;}
    break;

  case 113:

/* Line 1455 of yacc.c  */
#line 476 "parser.y"
    {rules_out<<"Identifiers\n";;}
    break;

  case 114:

/* Line 1455 of yacc.c  */
#line 482 "parser.y"
    {
	current_sgn = 1;
	rules_out<<"Sign\n";
;}
    break;

  case 115:

/* Line 1455 of yacc.c  */
#line 488 "parser.y"
    {
	current_sgn = -1;
	rules_out<<"Sign\n";
;}
    break;



/* Line 1455 of yacc.c  */
#line 2471 "parser.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 494 "parser.y"


int yyerror(const char *s){
	std::cerr<<s<<std::endl;
	return 0;
}

int UpdateVar(void){
	for (std::list<std::string>::iterator itr = current_argv.begin(); itr != current_argv.end(); ++itr){
		current_scope -> symt[std::string("var ").append(*itr)] = {type, current_scope -> symt.size()};
	}
	current_argv.clear();
	current_argc = 0;
	return 0;
}

int UpdateType(void){
	for (int i = 0; i < current_argc; ++i){
		current_type.append(LookupTypeDef(type)).append(",");
	}
	current_argv.clear();
	argc += current_argc;
	current_argc = 0;
	return 0;
}

int LookupVar(scope *current_scope, const std::string name){
	while (current_scope){
		if (current_scope -> symt.find(name) != current_scope -> symt.end()){
			return 1;    //found
		}
		current_scope = current_scope -> p;
	}
	return 0;  //not found
}

std::string LookupTypeDef(const std::string type){
	std::string eq_type = type;
//	std::cout<<"LOOKING UP "<<eq_type<<std::endl;
	std::map< std::string, id_attr >::iterator it;
	while ( (it = prog_scope.symt.find(eq_type)) != prog_scope.symt.end() ){
		if (it -> second.type == eq_type){
			return eq_type;
		}
		//std::cout<<"LOOKING UP "<<eq_type<<std::endl;
		eq_type = it -> second.type;
	}
	return eq_type;   //type is not pre-defined
}
	
int main(void){
	int ret = yyparse();
	std::fstream sym_out(SYM_OUTPUT, std::ios::out | std::ios::trunc);
	if (ret == 1){
		std::cout<<"\nsyntax error found\n";
	}else if (ret == 2){
		std::cout<<"\nmemory exhausted\n";
	}else{
		std::cout<<"\nno syntax error found\n";
	}
	std::cout<<"\n";
	sym_out<<std::setw(FW)<<std::left<<"Symbol"<<std::setw(FW)<<std::left<<"Type"<<std::setw(FW)<<"Address"<<"\n\n";
	for (std::map<std::string, id_attr>::iterator itr = current_scope -> symt.begin(); itr != current_scope -> symt.end(); ++itr){
		sym_out<<std::setw(FW)<<std::left<<itr->first<<std::setw(FW)<<std::left<<itr->second.type<<std::setw(FW)<<std::left<<itr->second.addr<<"\n";
	}
	sym_out.close();
	rules_out.close();
	return 0;
}

