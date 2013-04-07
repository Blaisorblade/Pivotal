\documentclass[]{sigplanconf}                    % onecolumn (standard format)

\usepackage{alltt}
\usepackage{graphicx}
\usepackage{upgreek}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{url}
\usepackage{stmaryrd}
\usepackage{ifpdf}
\usepackage[usenames]{color}
\definecolor{citationcolour}{rgb}{0,0.4,0.2}
\definecolor{linkcolour}{rgb}{0,0,0.8}
\usepackage{hyperref}
\hypersetup{colorlinks=true,
            urlcolor=linkcolour,
            linkcolor=linkcolour,
            citecolor=citationcolour,
            pdftitle=How to Keep Your Neighbours in Order,
            pdfauthor={Conor McBride},
            pdfkeywords={}}  

%include lhs2TeX.fmt
%include lhs2TeX.sty
%include polycode.fmt

\DeclareMathAlphabet{\mathkw}{OT1}{cmss}{bx}{n}
%subst keyword a = "\mathkw{" a "}"
%subst conid a = "\V{" a "}"
%subst varid a = "\V{" a "}"
%subst numeral a = "\C{" a "}"

\usepackage{color}
\newcommand{\redFG}[1]{\textcolor[rgb]{0.6,0,0}{#1}}
\newcommand{\greenFG}[1]{\textcolor[rgb]{0,0.4,0}{#1}}
\newcommand{\blueFG}[1]{\textcolor[rgb]{0,0,0.8}{#1}}
\newcommand{\orangeFG}[1]{\textcolor[rgb]{0.8,0.4,0}{#1}}
\newcommand{\purpleFG}[1]{\textcolor[rgb]{0.4,0,0.4}{#1}}
\newcommand{\yellowFG}[1]{\textcolor{yellow}{#1}}
\newcommand{\brownFG}[1]{\textcolor[rgb]{0.5,0.2,0.2}{#1}}
\newcommand{\blackFG}[1]{\textcolor[rgb]{0,0,0}{#1}}
\newcommand{\whiteFG}[1]{\textcolor[rgb]{1,1,1}{#1}}
\newcommand{\yellowBG}[1]{\colorbox[rgb]{1,1,0.2}{#1}}
\newcommand{\brownBG}[1]{\colorbox[rgb]{1.0,0.7,0.4}{#1}}

\newcommand{\ColourStuff}{
  \newcommand{\red}{\redFG}
  \newcommand{\green}{\greenFG}
  \newcommand{\blue}{\blueFG}
  \newcommand{\orange}{\orangeFG}
  \newcommand{\purple}{\purpleFG}
  \newcommand{\yellow}{\yellowFG}
  \newcommand{\brown}{\brownFG}
  \newcommand{\black}{\blackFG}
  \newcommand{\white}{\whiteFG}
}

\newcommand{\MonochromeStuff}{
  \newcommand{\red}{\blackFG}
  \newcommand{\green}{\blackFG}
  \newcommand{\blue}{\blackFG}
  \newcommand{\orange}{\blackFG}
  \newcommand{\purple}{\blackFG}
  \newcommand{\yellow}{\blackFG}
  \newcommand{\brown}{\blackFG}
  \newcommand{\black}{\blackFG}
  \newcommand{\white}{\blackFG}
}

\ColourStuff

\newcommand{\D}[1]{\blue{\mathsf{#1}}}
\newcommand{\C}[1]{\red{\mathsf{#1}}}
\newcommand{\F}[1]{\green{\mathsf{#1}}}
\newcommand{\V}[1]{\purple{\mathit{#1}}}

\newtheorem{princ}{Principle}

%format Set = "\D{Set}"
%format Set1 = "\D{Set_1}"

\title{How to Keep Your Neighbours in Order}
\authorinfo{Conor McBride}
           {University of Strathclyde}
           {Conor.McBride@@strath.ac.uk}

\begin{document}
\maketitle

\begin{abstract} 
\end{abstract}

%if False
\begin{code}

module Pivotal where

data Nat : Set where
  ze : Nat
  su : Nat -> Nat

{-# BUILTIN NATURAL Nat #-}
{-# BUILTIN ZERO ze #-}
{-# BUILTIN SUC su #-}

postulate BROWN : {X Y : Set} -> X -> Y
postulate HOLE : {X : Set} -> Nat -> X
postulate FOOL : {X Y : Set} -> Y -> X -> Y

\end{code}
%endif
%format (HOLE n) = "\yellowBG{\(?_{" n "}\)}"
%format (BROWN x) = "\brownBG{\(" x "\)}"
%format (FOOL y x) = y

\section{Introduction}

It has taken years to see what was under my nose. I have been
experimenting with ordered container structures for a \emph{long}
time \cite{dtpTalkLFCS}: how to keep lists ordered, how to keep binary
search trees ordered, how to flatten the latter to the
former. Recently, the pattern common to the structures and methods I
had often found effective became clear to me. Let me tell you about
it.  Patterns are, of course, underarticulated
abstractions. Correspondingly, let us construct a \emph{universe} of
container-like datatypes ensuring that elements are in increasing
order, good for intervals, ordered lists, binary search trees, and
more besides.

\section{Preliminaries}

%format pattern = "\mathkw{pattern}"
%format constructor = "\mathkw{constructor}"
%format One = "\D{1}"
%format it = "\C{\langle\rangle}"
%format + = "\D{+}"
%format _+_ = "\_\!" + "\!\_"
%format inl = "\C{inl}"
%format inr = "\C{inr}"
%format Sg = "\D{\Upsigma}"
%format * = "\F{\times}"
%format _*_ = "\_\!" * "\!\_"
%format / = "\C{,}"
%format _/_ = "\_\!" / "\!\_"
%format fst = "\F{\uppi_1}"
%format snd = "\F{\uppi_2}"
%format Zero = "\D{0}"
%format Two = "\D{2}"
%format tt = "\C{t\!t}"
%format ff = "\C{f\!f}"
%format not = "\F{\neg}"
%format forall = "\D{\forall}"
%format o = "\F{\circ}"
%format So = "\F{So}"
%format so = "\F{so}"
%format Maybe = "\D{Maybe}"
%format yes = "\C{yes}"
%format no = "\C{no}"
%format if = "\F{if}"
%format then = "\F{then}"
%format else = "\F{else}"
%format if_then_else_ = if "\_" then "\_" else "\_"

\begin{code}
data Zero : Set where

record One : Set where constructor it
\end{code}

\begin{code}
data Two : Set where tt ff : Two
\end{code}

\begin{code}
not : Two -> Two
not tt  = ff
not ff  = tt
\end{code}

\begin{code}
if_then_else_ : {X : Set} -> Two -> X -> X -> X
if tt  then t else f = t
if ff  then t else f = f
infix 1 if_then_else_
\end{code}

\begin{code}
So : Two -> Set
So tt  = One
So ff  = Zero
\end{code}

\begin{code}
data _+_ (S T : Set) : Set where
  inl : S -> S + T
  inr : T -> S + T
infixr 4 _+_
\end{code}

\begin{code}
data Maybe (X : Set) : Set where
  yes  : X -> Maybe X
  no   : Maybe X
\end{code}

\begin{code}
so : forall {X} -> Two -> Maybe X -> Maybe X
so tt  mx  = mx
so ff  _   = no
\end{code}

\begin{code}
record Sg (S : Set)(T : S -> Set) : Set where
  constructor _/_
  field
    fst : S
    snd : T fst
open Sg
infixr 5 _/_

_*_ : Set -> Set -> Set
S * T = Sg S \ _ -> T
infixr 5 _*_

_o_ : {A : Set}{B : A -> Set}{C : (a : A) -> B a -> Set}
      (f : {a : A}(b : B a) -> C a b)(g : (a : A) -> B a) ->
      (a : A) -> C a (g a)
(f o g) x = f (g x)
\end{code}


\section{Searching for Search Trees (and Barking up the Wrong One)}

%if False
\begin{code}
module BinarySearchTreeBad (P : Set)(le : P -> P -> Two) where
\end{code}
%endif

David Turner \cite{turner:ESFP} notes that whilst \emph{quicksort} is
often cited as a program which defies structural recursion, it
performs the same sorting algorithm (although not with the same memory
usage pattern) as building a binary search tree and then flattening
it. The irony is completed by noting that the latter sorting algorithm
is the archetype of structural recursion in Rod Burstall's development
of the concept \cite{burstall:induction}. Binary search trees have
empty leaves and nodes labelled with elements which act like \emph{pivots}
in quicksort: the left subtree stores elements which precede the pivot
in the order, the right subtree elements which follow it. Surely this
invariant is crying out to be captured in a dependent type! Let us search
for a type for search trees.

We could, of course, choose to define binary search trees as ordinary
node-labelled trees with parameter |P| giving the type of pivots:
%format TrS = "\D{Tree}"
%format lfS = "\C{leaf}"
%format ndS = "\C{node}"
%format IsBST = "\F{IsBST}"

\begin{code}
  data TrS : Set where
    lfS  : TrS
    ndS  : TrS -> P -> TrS -> TrS
\end{code}
We might then introduce the invariant as a predicate |IsBST : TrS -> Set|.
We could then implement insertion in our usual way, and then prove separately
that our program maintains the invariant. However, the joy of dependently
typed programming is that working with refined types for the data themselves
can often alleviate and sometimes obviate the burden of proof. Let us try to
bake the invariant in.

\paragraph{What should the type of a subtree tell us?} If we want to
check the invariant at a given node, we shall need some information
about the subtrees which we might expect comes from their type. We
require that the elements left of the pivot precede it, so we could
require the whole set of those elements represented somehow, but of
course, for any order worthy of the name, it suffices to check only
the largest. Similarly, we shall need to know the smallest element of
the right subtree. It would seem that we need the type of a search
tree to tell us its extreme elements (or that it is empty).

%format BST = "\D{BST}"
%format STRange = "\D{STRange}"
%format empty = "\C{\emptyset}"
%format - = "\!\C{{}-}\!"
%format _-_ = "\_" - "\_"
\begin{code}
  data STRange : Set where
    empty  : STRange
    _-_    : P -> P -> STRange
  infix 9 _-_
\end{code}

\paragraph{From checking the invariant to enforcing it.}
Assuming we can test the order on |P| with some |le : P -> P -> Two|,
we could write a recursive function to check whether a |TrS| is a valid
search tree and compute its range:

%format valid = "\F{valid}"
\begin{code}
  valid : TrS -> Maybe STRange
  valid lfS = yes empty
  valid (ndS l p r) with valid l | valid r
  ... | yes empty    | yes empty    = yes (p - p)
  ... | yes empty    | yes (c - d)  = so (le p c) (yes (p - d))
  ... | yes (a - b)  | yes empty    = so (le b p) (yes (a - p))
  ... | yes (a - b)  | yes (c - d)
    = so (le b p) (so (le p c) (yes (a - d)))
  ... | _            | _            = no
\end{code}

As |valid| is a \emph{fold} over the structure of |TrS|, we can follow
my colleagues Bob Atkey, Neil Ghani and Patricia Johann in computing
the \emph{partial refinement} \cite{DBLP:journals/corr/abs-1205-2492}
of |TrS| which |valid| induces. We seek a type |BST : STRange -> Set|
such that \(|BST r| \cong \{|t : TrS| \mid |valid t| = |yes r|\}\) and
we find it by refining the type of each constructor of |TrS| with the
check performed by the corresponding case of |valid|, assuming that
the subtrees yielded valid ranges. We can calculate the conditions to
check and the means to compute the output range if successful.

%format leftOK = "\F{lOK}"
%format rightOK = "\F{rOK}"
%format nodeRange = "\F{rOut}"
\begin{code}
  leftOK   : STRange -> P -> Two
  leftOK   empty    p  = tt
  leftOK   (_ - u)  p  = le u p

  rightOK  : P -> STRange -> Two
  rightOK  p  empty    = tt
  rightOK  p  (l - _)  = le p l

  nodeRange : STRange -> P -> STRange -> STRange
  nodeRange empty    p  empty    = p - p
  nodeRange empty    p  (_ - u)  = p - u
  nodeRange (l - _)  p  empty    = l - p
  nodeRange (l - _)  _  (_ - u)  = l - u
\end{code}

We thus obtain the following refinement from |TrS| to |BST|:

\begin{code}
  data BST : STRange -> Set where
    lfS  :  BST empty
    ndS  :  forall {l r} -> BST l -> (p : P) -> BST r ->
            {_ : So (leftOK l p)} -> {_ : So (rightOK p r)} ->
            BST (nodeRange l p r)
\end{code}

The |So| function maps |tt| to |One| and |ff| to |Zero|, requiring
that the tests on left and right ranges succeed. When a test passes,
Agda can infer the value |it|, hence we may safely leave this evidence
implicit. If a test fails, Agda will complain that it cannot
synthesize the implicit argument, for a very good reason!

\paragraph{Attempting to implement insertion.}
Now that each binary search tree tells us its type, can we implement
insertion? Rod Burstall's implementation is as follows
%format insertS = "\F{insert}"
\begin{code}
  insertS : P -> TrS -> TrS
  insertS y lfS            = ndS lfS y lfS
  insertS y (ndS lt p rt)  =
    if le y p  then  ndS (insertS y lt) p rt
               else  ndS lt p (insertS y rt)
\end{code}
but we shall have to try a little harder to give a type to |insertS|,
as we must somehow negotiate the ranges. If we are inserting a new
extremum, then the output range will be wider than the input range.
%format oRange = "\F{oRange}"
\begin{code}
  oRange : STRange -> P -> STRange
  oRange empty    y = y - y
  oRange (l - u)  y =
    if le y l then y - u else if le u y then l - y else l - u
\end{code}

So, we have the right type for our data and for our program. Surely the
implementation will go like clockwork!
%format shite = "\F{insert}"
\begin{spec}
  shite : forall {r} y -> BST r -> BST (oRange r y)
  shite y lfS            = ndS lfS y lfS
  shite y (ndS lt p rt)  =
    if le y p  then  (BROWN (ndS (shite y lt) p rt))
               else  (BROWN (ndS lt p (shite y rt)))
\end{spec}
The |lfS| case checks easily, but alas for |ndS|! We have |lt : BST l|
and |rt : BST r| for some ranges |l| and |r|. The |then| branch delivers
a |BST (nodeRange (oRange l y) p r)|, but the type required is
|BST (oRange (nodeRange l p r) y)|, so we need some theorem-proving to
fix the types, let alone to discharge the
obligation |So (leftOK (oRange l y) p)|. Of course, we could plough on,
despite the slough of proof, and force this definition through, but I
have had enough and so have you!

We have written a datatype definition which is logically correct but
which is pragmatically disastrous. Is it thus inevitable that all
datatype definitions which enforce the ordering invariant will be
pragmatically disastrous? Or are there lessons we can learn about
dependently typed programming that will help us to do better?


\section{Why Measure When You Can Require?}

In the previous section, we got the wrong answer because we asked the
wrong question: ``What should the type of a subtree tell us?''
somewhat presupposes that information bubbles outward from subtrees to
the nodes which contain them. As functional programmers in Milner's
tradition, we are used to synthesizing the type of a thing. Moreover,
the very syntax we use for |data| declarations treats the index
delivered from each constructor as some sort of output. It seems
natural to take datatype indices as some sort of measure of the data,
which is all very well for the length of a vector, but when the
measurement is computationally intricate, as in the case of computing
a search tree's extrema, programming becomes vexed by the need to
prove theorems about the measuring functions. The presence of `green
slime'---defined functions in the return types of constructors---is a
danger sign in type design.

We can, however, take an alternative view of types, not as synthesized
measurements of data, bubbled outward, but as checked
\emph{requirements} of data, pushed \emph{inward}. To enforce the
invariant, let us rather ask the question ``What should we tell the
type of a subtree?''.

The elements of the left subtree must precede the pivot in the order;
those of the right must follow it. Correspondingly, our requirements
on a subtree amount to an \emph{interval} in which its elements must
fall. As any element can find a place somewhere in a search tree, we
shall need to consider unbounded intervals also. We can extend any
type with top and bottom elements as follows.

%format <$  = "\!\!"
%format $>D = "\D{\!_\bot^\top}"
%format <$_$>D = "\_" $>D
%format tb = "\C{\scriptscriptstyle{\#}}"
%format top = "\C{\top}"
%format bot = "\C{\bot}"

\begin{code}
data <$_$>D (P : Set) : Set where
  top  :       <$ P $>D
  tb   : P ->  <$ P $>D
  bot  :       <$ P $>D
\end{code}

Correspondingly, we can extend the order, putting |top| at the
top and |bot| at the bottom.

%format $>B = "\F{\!_\bot^\top}"
%format <$_$>B = "\_" $>B
\begin{code}
<$_$>B : forall {P} -> (P -> P -> Two) -> <$ P $>D -> <$ P $>D -> Two
<$ le $>B _       top     = tt
<$ le $>B (tb x)  (tb y)  = le x y
<$ le $>B bot     _       = tt
<$ le $>B _       _       = ff
\end{code}

We can now index search trees by a pair of \emph{loose bounds}, not measuring
the range of the contents exactly, but constraining it sufficiently. At
each node, we can require that the pivot falls in the interval, then use the
pivot to bound the subtrees.
%if False
\begin{code}
module BinarySearchTreeBetter (P : Set)(le : P -> P -> Two) where
\end{code}
%endif
%format leaf = "\C{leaf}"
%format node = "\C{node}"
%format Between = "\F{Between}"
\begin{code}
  data BST (l u : <$ P $>D) : Set where
    leaf :  BST l u
    node :  (p : P) -> So (<$ le $>B l (tb p)) -> So (<$ le $>B (tb p) u) ->
            BST l (tb p) -> BST (tb p) u -> BST l u
\end{code}
In doing so, we eliminate all the `green slime' from the indices of the
type. The |leaf| constructor now has many types, indicating all its elements
satisfy any requirements. We also gain |BST bot top| as the general type of
binary search trees for |P|.

%format insert2 = "\F{insert}"
Can we implement |insert2| for this definition? We can certainly give it a
rather cleaner type. When we insert a new element into the left subtree of a
node, we must ensure that it precedes the pivot: that is, we expect
insertion to \emph{preserve} the bounds of the subtree, and we should already
know that the new element falls within them.
\begin{code}
  insert2 :  forall {l u} y -> So (<$ le $>B l (tb y)) -> So (<$ le $>B (tb y) u) ->
             BST l u -> BST l u
  insert2 y ly yu  leaf                = node y ly yu leaf leaf
  insert2 y ly yu  (node p lp pu lt rt)  =
    if le y p  then  node p lp pu (insert2 y ly (HOLE 0) lt) rt
               else  node p lp pu lt (insert2 y (HOLE 1) yu rt)
\end{code}
We have no need to repair type errors by theorem proving, and most of
our proof obligations follow directly from our assumptions. Working
interactively, we can use Agda's proof search helper, Agsy, to fill them
in for us. Our only outstanding goals are
\begin{spec}
  (HOLE 0)  : So (le y p)  -- in the |then| branch
  (HOLE 1)  : So (le p y)  -- in the |else| branch
\end{spec}
The first of these is the very thing our conditional expression has found
to be true! We could choose to work with an evidence-producing version of
|if|.
%format eif = "\F{if}"
%format eif_then_else_ = if_then_else_
\begin{code}
  eif_then_else_ : forall {X : Set} b ->
    (So b -> X) -> (So (not b) -> X) -> X
  eif tt then t else f = t it
  eif ff then t else f = f it
\end{code}
We can now \emph{learn} by testing: the |then| branch has a type which is
reassuringly distinct from that of the |else| branch, and both are more
informative than the target type, |X|. We have made a little progress:
%format insert3 = "\F{insert}"
%if False
\begin{code}
  insert3 :  forall {l u} y -> So (<$ le $>B l (tb y)) -> So (<$ le $>B (tb y) u) ->
             BST l u -> BST l u
  insert3 y ly yu  leaf                  = node y ly yu leaf leaf
\end{code}
%endif
\begin{code}
  insert3 y ly yu  (node p lp pu lt rt)  = eif le y p
    then  (\ yp -> node p lp pu (insert3 y ly yp lt) rt)
    else  (\ py -> node p lp pu lt (insert3 y (BROWN py) yu rt))
\end{code}
However, we are now defeated by the fact that |py : So (not (le y p))|,
which is not the evidence we need for |(HOLE 1)|. For any given total ordering,
we should be able to fix this up by proving a theorem, but this is still more
work that I enjoy. The trouble is that we couched our definition in terms
of the truth of bits computed in a particular way, rather than the ordering
\emph{relation}. Let us now tidy up this detail.


\section{One Way Or The Other}

%format REL = "\F{Rel}"
%format $>F = "\F{\!_\bot^\top}"
%format <$_$>F = "\_" $>F
We can recast our definition in terms of relations---families of sets |REL P|
\begin{code}
REL : Set -> Set1
REL P = P -> P -> Set
\end{code}
giving us types which directly make statements about elements of |P|, rather
than about bits. Let us suppose we have some `less or equal' ordering relation
|L : REL P|. For natural numbers, we can define
%format <= = "\F{\le}"
%format _<=_ = "\_\!" <= "\!\_"
\begin{code}
_<=_ : REL Nat
ze    <= y     =  One
su x  <= ze    =  Zero
su x  <= su y  =  x <= y
\end{code}

The information we shall need just corresponds to the totality
of |L|: for any given |x| and |y|, |L| must hold \emph{one way or the other}.
For |Nat|, we may define
%format nowoto = "\F{owoto}"
\begin{code}
nowoto : forall x y -> (x <= y) + (y <= x)
nowoto ze      ze      = inl it
nowoto ze      (su y)  = inl it
nowoto (su x)  ze      = inr it
nowoto (su x)  (su y)  = nowoto x y
\end{code}
using only mechanical case-splitting and proof search.

Any such ordering relation on elements lifts readily to bounds.
\begin{code}
<$_$>F : forall {P} -> REL P -> REL <$ P $>D
<$ L $>F _       top     = One
<$ L $>F (tb x)  (tb y)  = L x y
<$ L $>F bot     _       = One
<$ L $>F _       _       = Zero
\end{code}

Let us then parametrize over some
\[ |owoto : forall x y -> L x y + L y x| \]
and reorganise our development.
%if False
\begin{code}
module BinarySearchTreeWorks
  {P : Set}(L : REL P)(owoto : forall x y -> L x y + L y x) where
\end{code}
%endif
\begin{code}
  data BST (l u : <$ P $>D) : Set where
    leaf  :  BST l u
    node  :  (p : P) -> <$ L $>F l (tb p) -> <$ L $>F (tb p) u ->
             BST l (tb p) -> BST (tb p) u -> BST l u

  insert2 :  forall {l u} y -> <$ L $>F l (tb y) -> <$ L $>F (tb y) u ->
             BST l u -> BST l u
  insert2 y ly yu leaf = node y ly yu leaf leaf
  insert2 y ly yu (node p lp pu lt rt)  with owoto y p
  ... | inl  yp  = node p lp pu (insert2 y ly yp lt) rt
  ... | inr  py  = node p lp pu lt (insert2 y py yu rt)
\end{code}

The evidence generated by testing |owoto y p| is just what is needed
to enable insertion in the appropriate subtree. We have found a method
which seems to work! However, I fear we should not get too excited.


\section{The Importance of Local Knowledge}

Our current representation of an ordered tree with $n$ elements
contains $2n$ pieces of ordering evidence, which is $n-1$ too many. We
should need only $n+1$ proofs, relating the lower bound to the least
element, then comparing neighbours all the way along to the greatest
element (one per element, so far) which must then fall below the upper
bound (so, one more). As things stand, the pivot at the root is known
to be greater than every element in the right spine of its left subtree
and less than every element in the left spine of its right subtree.
If the tree was built by iterated insertion, these comparisons will
surely have happened, but that does not mean we should retain the
information.

Suppose, for example, that we want to rotate a tree, perhaps to keep it
balanced, then we have a little problem:
%format rotater = "\F{rotater}"
\begin{code}
  rotater : forall {l u} -> BST l u -> BST l u
  rotater (node p lp pu (node m lm mp lt mt) rt)
    = node m lm (HOLE 0) lt (node p mp pu mt rt)
  rotater t = t
\end{code}
We have discarded the non-local ordering evidence |lp : <$ L $>F l (tb p)|,
but now we need the non-local |(HOLE 0) : <$ L $>F (tb m) u| and we do not
have it. Of course, we can prove this goal from |mp| and |pu| if we know
that |L| is transitive, but if we want to make less work for ourselves, we
should rather not demand non-local ordering evidence in the first place.

Looking back at the type of |node|, note that the indices at which we
demand \emph{ordering} are the same as the indices at which we demand
\emph{subtrees}. If we strengthen the invariant on trees to ensure that
there is a sequence of ordering steps from the lower to the upper bound,
we could dispense with the sometimes non-local evidence stored in |node|s,
at the cost of a new constraint for |leaf|.

%if False
\begin{code}
module BinarySearchTreeBest
  {P : Set}(L : REL P)(owoto : forall x y -> L x y + L y x) where
\end{code}
%endif
\begin{code}
  data BST (l u : <$ P $>D) : Set where
    leaf  :  <$ L $>F l u -> BST l u
    node  :  (p : P) ->
             BST l (tb p) -> BST (tb p) u -> BST l u
\end{code}

Indeed, a binary tree with $n$ nodes will have $n+1$ leaves. An in-order
traversal of a binary tree is a strict alternation,
leaf-node-leaf-\ldots -node-leaf, making a leaf the ideal place to keep
the evidence that neighbouring nodes are in order! Insertion remains easy.

\begin{code}
  insert2 :  forall {l u} y -> <$ L $>F l (tb y) -> <$ L $>F (tb y) u ->
             BST l u -> BST l u
  insert2 y ly yu (leaf _) = node y (leaf ly) (leaf yu)
  insert2 y ly yu (node p lt rt)  with owoto y p
  ... | inl  yp  = node p (insert2 y ly yp lt) rt
  ... | inr  py  = node p lt (insert2 y py yu rt)
\end{code}

Rotation becomes very easy, with not a proof in sight!

\begin{code}
  rotater : forall {l u} -> BST l u -> BST l u
  rotater (node p (node m lt mt) rt) =
    node m lt (node p mt rt)
  rotater t = t
\end{code}

We have arrived at a neat way to keep a search tree in order,
storing pivot elements at nodes and ordering evidence in leaves. Phew!

%format OList = "\D{OList}"
%format nil = "\C{nil}"
%format cons = "\C{cons}"
But it is only the end of the beginning. To complete our sorting
algorithm, we need to flatten binary search trees to ordered
\emph{lists}. Are we due another long story about the discovery
of a good definition of the latter? Fortunately not! The key idea
is that an ordered list is just a particularly badly balanced binary
search tree, where every left subtree is a |leaf|. We can nail that
down in short order, just by inlining |leaf|'s data in the left
subtree of |node|, yielding a sensible |cons|.
\begin{code}
  data OList (l u : <$ P $>D) : Set where
    nil   :  <$ L $>F l u -> OList l u
    cons  :  (p : P) ->
             <$ L $>F l (tb p) -> OList (tb p) u -> OList l u 
\end{code}

\section{Jansson and Jeuring's PolyP Universe}

%format JJ = "\D{JJ}"
%format qP = "\C{`P}"
%format qR = "\C{`R}"
%format q1 = "\C{`1}"
%format q+ = "\C{`+}"
%format _q+_ = "\_\!" q+ "\!\_"
%format q* = "\C{`\times}"
%format _q*_ = "\_\!" q* "\!\_"
%format (ElJJ) = "\F{\llbracket\_\rrbracket_{" JJ "}}}"
%format (ElJJ (t)) = "\F{\llbracket}" t "\F{\rrbracket_{" JJ "}}"
%format <! = "\F{\llbracket}"
%format !>JJ = "\F{\rrbracket_{" JJ "}}"
%format <!_!>JJ = <! "\_" !>JJ
%format MuJJ = "\D{\upmu_{" JJ "}}"
%format la = "\C{\langle}"
%format ra = "\C{\rangle}"
%format la_ra = la "\_" ra

\begin{code}

data JJ : Set where
  qR qP q1   : JJ
  _q+_ _q*_  : JJ -> JJ -> JJ
infixr 4 _q+_
infixr 5 _q*_

<!_!>JJ : JJ -> Set -> Set -> Set
<! qR !>JJ      R P = R
<! qP !>JJ      R P = P
<! q1 !>JJ      R P = One
<! S q+ T !>JJ  R P = <! S !>JJ R P + <! T !>JJ R P
<! S q* T !>JJ  R P = <! S !>JJ R P * <! T !>JJ R P

data MuJJ (F : JJ)(P : Set) : Set where
  la_ra : <! F !>JJ (MuJJ F P) P -> MuJJ F P

\end{code}

The |qR| stands for `recursive substructure' and the |qP| stands for
`parameter'---the type of elements stored in the container. When we
`tie the knot' in |MuJJ F P|, we replace interpret |F|'s |qP|s by some
actual |P| and its |qR|s by |MuJJ F P|.


\section{The Simple Orderable Universe}

%format SO = "\D{SO}"
%format !>SO = "\F{\rrbracket_{" SO "}}"
%format <!_!>SO = <! "\_" !>SO
%format MuSO = "\F{\upmu_{" SO "}}"
%format q^ = "\C{`\wedge}"
%format _q^_ = "\_\!" q^ "\!\_"

The quicksort algorithm divides a sorting problem in two by
partitioning about a selected \emph{pivot} element the remaining
data. Rendered as the process of building then flattening a binary
search tree \cite{burstall:induction}, the pivot element clearly marks
the upper bound of the lower subtree and the lower bound of the upper
subtree, giving exactly the information required to guide insertion.

We can require the presence of pivots between substructures by combining
the parameter |qP| and pairing |q*| constructs of the PolyP universe into a
single pivoting construct, |q^|, with two substructures and a pivot in between.
We thus acquire the simple orderable universe, |SO|, a subset of
|JJ| picked out as the image of a function, |<!_!>SO|. Now, |P| stands also for
pivot!

\begin{code}
data SO : Set where
  qR q1      : SO
  _q+_ _q^_  : SO -> SO -> SO
infixr 5 _q^_

<!_!>SO : SO -> JJ
<! qR !>SO      = qR
<! q1 !>SO      = q1
<! S q+ T !>SO  = <! S !>SO q+ <! T !>SO
<! S q^ T !>SO  = <! S !>SO q* qP q* <! T !>SO

MuSO : SO -> Set -> Set
MuSO F P = MuJJ <! F !>SO P
\end{code}

Let us give |SO| codes for structures we often order and bound:

%format qListSO = "\F{`List}"
%format qTreeSO = "\F{`Tree}"
%format qIntervalSO = "\F{`Interval}"
\begin{code}
qListSO qTreeSO qIntervalSO : SO
qListSO      = q1 q+ (q1 q^ qR)
qTreeSO      = q1 q+ (qR q^ qR)
qIntervalSO  = q1 q^ q1
\end{code}

%format treeSO = "\F{tree}"
%format go = "\F{go}"
Every data structure described by |SO| is a regulated variety of
node-labelled binary trees. Let us check that we can turn anything
into a tree, preserving the substructure relationship. The
method\footnote{If you try constructing the division
operator as a primitive recursive function, this method will teach
itself to you.}
is to introduce a helper function, |go|, whose type separates |G|,
the structure of the top node, from |F| the structure of recursive
subnodes, allowing us to take the top node apart: we kick off with
|G = F|.

\begin{code}
treeSO : forall {P F} -> MuSO F P -> MuSO qTreeSO P
treeSO {P}{F} la f ra = go F f where
  go : forall G -> <! <! G !>SO !>JJ (MuSO F P) P -> MuSO qTreeSO P
  go qR        f            = treeSO f
  go q1        it           = la inl it ra
  go (S q+ T)  (inl s)      = go S s
  go (S q+ T)  (inr t)      = go T t
  go (S q^ T)  (s / p / t)  = la inr (go S s / p / go T t) ra
\end{code}

All |treeSO| does is strip out the |inl|s and |inr|s corresponding to
the structural choices offered by the input type and instead label the
void leaves |inl| and the pivoted nodes |inr|. Note well that a
singleton tree has void leaves as its left and right substructures,
and hence that the inorder traversal is a strict alternation of leaves
and pivots, beginning with the leaf at the end of the left spine and
ending with the leaf at the end of the right spine. As our |treeSO|
function preserves the leaf/pivot structure of its input, we learn that
\emph{every} datatype we can define in |SO| stores such an alternation
of leaves and pivots.

\textbf{draw a diagram, showing a tree projected onto a line}

We are now in a position to roll out the ``loose bounds'' method to
the whole of the |SO| universe. We need to ensure that each pivot is
in order with its neighbours and with the outer bounds, and the
alternating leaf/pivot structure gives us just what we need: let us store
the ordering evidence at the leaves!

%format MuOSO = "\F{\upmu^\le_{" SO "}}"
%format !>OSO = "\F{\rrbracket^\le_{" SO "}}"
%format <!_!>OSO = <! "\_" !>OSO
%if False
\begin{code}
pattern SHUNT X = X
\end{code}
%endif
%format SHUNT = "\hspace*{0.5in}"
\begin{code}
<!_!>OSO : SO -> forall {P} -> REL <$ P $>D -> REL P -> REL <$ P $>D
<! qR !>OSO       R L l u = R l u
<! q1 !>OSO       R L l u = <$ L $>F l u
<! S q+ T !>OSO R L l u = <! S !>OSO R L l u + <! T !>OSO R L l u
<! S q^ T !>OSO R L l u = Sg _ \ p ->
  SHUNT <! S !>OSO R L l (tb p) * <! T !>OSO R L (tb p) u

data MuOSO  (F : SO){P : Set}(L : REL P)
            (l u : <$ P $>D) : Set where
  la_ra : <! F !>OSO (MuOSO F L) L l u -> MuOSO F L l u
\end{code}
We have shifted from sets to relations, in that our types are indexed
by lower and upper bounds. The leaves demand evidence that the bounds
are in order, whilst the nodes require the pivot first, then use it to
bound the substructures appropriately. I promise that I shall never name
the evidence: I shall always match it with the |_| pattern and construct
it by means of the following device, making use of \emph{instance arguments}:

%format ! = "\F{\scriptstyle{!}}"
\begin{code}
! : forall {X : Set}{{x : X}} -> X
! {X}{{x}} = x
\end{code}

When we use |!| at type |X|, Agda treats the |x| as an implicit argument,
but rather than solving for |x| by \emph{unification}, Agda
seeks an \emph{assumption} of type |X| in the context, succeeding if there
is exactly one.

Meanwhile, the need in nodes to bound the left substructure's type
with the pivot value disrupts the left-to-right spatial ordering of the
data, but we can apply a little cosmetic treatment, thanks to the
availability of \emph{pattern synonyms}~\cite{aitken.reppy}.

%format \\ = "\C{\raisebox{ -0.07in}[0in][0in]{`}}"
%format _\\_\\_ = "\_\!" \\ "\!\_" \\ "\!\_"
\begin{code}
pattern _\\_\\_ s p t = p / s / t
infixr 5 _\\_\\_ 
\end{code}

%format treeOSO = "\F{tree}"
With these two devices available, let us check that we can still turn
any ordered data into an ordered tree.
\begin{code}
treeOSO :  forall {P F}{L : REL P}{l u} ->
           MuOSO F L l u                -> MuOSO qTreeSO L l u
treeOSO {P}{F}{L} la f ra = go F f where
  go : forall G {l u}  ->
           <! G !>OSO (MuOSO F L) L l u  -> MuOSO qTreeSO L l u
  go qR        f              = treeOSO f
  go q1        _              = la inl ! ra
  go (S q+ T)  (inl s)        = go S s
  go (S q+ T)  (inr t)        = go T t
  go (S q^ T)  (s \\ p \\ t)  = la inr (go S s \\ p \\ go T t) ra
\end{code}

We have acquired a collection of orderable datatypes which all amount
to specific patterns of node-labelled binary trees: an interval is a
singleton node; a list is a right spine. All share the treelike
structure which ensures that pivots alternate with leaves bearing the
evidence the pivots are correctly placed with respect to their
immediate neighbours.


\section{Flattening With Concatenation}

%format $>+ = "\!\F{^{+}}"
If we are in the sorting business, whatever intermediate data structures
we might choose, we shall want to deliver some kind of list in the end.
Let us name our family of ordered lists |<$ L $>+|, as the leaves form
a nonempty chain of |<$ L $>F| ordering evidence.

\begin{code}
<$_$>+ : forall {P} -> REL P -> REL <$ P $>D
<$ L $>+ = MuOSO qListSO L
\end{code}

As all of our orderable structures amount to trees, it suffices to flatten
trees to lists. Let us take the usual na{\"\i}ve approach as our starting
point. In Haskell, we might write
\begin{alltt}
flatten Leaf         = []
flatten (Node l p r) = flatten l ++ p : flatten r
\end{alltt}
so let us try to do the same in Agda with ordered lists. We shall need
concatenation, so let us try to join lists with a shared bound |p| in the
middle.
%format ++ = "\F{+\!\!+}"
%format _++_ = "\_\!" ++ "\!\_"
\begin{code}
infixr 8 _++_
_++_ :  forall {P}{L : REL P}{l p u} ->
  <$ L $>+ l p -> <$ L $>+ p u -> <$ L $>+ l u
la inl _ ra               ++ ys = (BROWN ys)
la inr (_ \\ x \\ xs) ra  ++ ys = la inr (! \\ x \\ xs ++ ys) ra
\end{code}

The `cons' case goes without a hitch, but there is trouble at `nil'.
We have |ys : MuOSO qListSO L p u| and we know |<$ L $>F l p|, but
we need to return a |MuOSO qListSO L l u|.

\textbf{draw a diagram showing the --- ---o---o--- situation}

``The trouble is easy to fix,'' one might confidently assert, whilst
secretly thinking, ``What a nuisance!''. We can readily write a helper
function which unpacks |ys|, and whether it is nil or cons, extends its
leftmost order evidence by transitivity. And this really is a nuisance,
because, thus far, we have not required transitivity to keep our code
well typed: all order evidence has stood between neighbouring elements.
Here, we have two pieces of ordering evidence which we must join, because
we have nothing to put in between them.
Then, the penny drops. Looking back at the code for flatten, observe that
|p| is the pivot and the whole plan is to put it between the lists. You
can't always get what you want, but you can get what you need.

%format sandwich = "\F{sandwich}"
\begin{code}
sandwich :  forall {P}{L : REL P}{l u} p ->
  <$ L $>+ l (tb p) -> <$ L $>+ (tb p) u -> <$ L $>+ l u
sandwich p la inl _ ra               ys = la inr (! \\ p \\ ys) ra
sandwich p la inr (_ \\ x \\ xs) ra  ys = la inr (! \\ x \\ sandwich p xs ys) ra
\end{code}

%format flattenT = "\F{flatten}"
%format flattenOSO = "\F{flatten}^\le_{" SO "}"
We are now ready to flatten trees, and thence any ordered
structure: 

\begin{code}
flattenT : forall {P}{L : REL P}{l u} ->
  MuOSO qTreeSO L l u -> <$ L $>+ l u
flattenT la inl _ ra              = la inl ! ra
flattenT la inr (l \\ p \\ r) ra  = sandwich p (flattenT l) (flattenT r)

flattenOSO : forall {P}{L : REL P}{F}{l u} ->
  MuOSO F L l u -> <$ L $>+ l u
flattenOSO = flattenT o treeOSO
\end{code}

For a little extra speed we might fuse that composition, but it seems
frivolous to do so as then benefit is outweighed by the quadratic penalty
of left-nested concatenation. The standard remedy applies: we can introduce
an accumulator \cite{Wadler87theconcatenate}, but our experience with |++|
should alert us to the possibility that it may require some thought.


\section{Faster Flattening, Generically}

%format flandwich = "\F{flandwich}"
%format fflatten = "\F{flatten}"
We may define |fflatten| generically, and introduce an accumulator yielding a
combined flatten-and-append which works right-to-left, growing the
result with successive conses. But what should be the bounds of the
accumulator? If we have not learned our lesson, we might be tempted by
%format flapp = "\F{flapp}"
\begin{spec}
flapp : forall {P}{L : REL P}{F}{l p u} ->
  MuOSO F L l p -> <$ L $>+ p u -> <$ L $>+ l u 
\end{spec}
but again we face the question of what to do when we reach a leaf. We
should not need transitivity to rearrange a tree of ordered neighbours
into a sequence. We can adopt the previous remedy of inserting the element
|p| in the middle, but we shall then need to think about where |p| will
come from in the first instance, for example when flattening an empty
structure.
\begin{code}
flapp : forall {P}{L : REL P}{F}{l u} G p ->
    <! G !>OSO (MuOSO F L) L l (tb p) ->
   <$ L $>+ (tb p) u -> <$ L $>+ l u
flapp {F = F} qR  p la t ra         ys  = flapp F p t ys
flapp q1          p _               ys  = la inr (! \\ p \\ ys) ra
flapp (S q+ T)    p (inl s)         ys  = flapp S p s ys
flapp (S q+ T)    p (inr t)         ys  = flapp T p t ys
flapp (S q^ T)    p (s \\ p' \\ t)  ys  = flapp S p' s (flapp T p t ys)
\end{code}
To finish the job, we need to work our way down the right spine of the
input in search of its rightmost element, which initialises |p|.
\begin{code}
fflatten : forall {P}{L : REL P}{F}{l u} ->
  MuOSO F L l u -> <$ L $>+ l u 
fflatten {P}{L}{F}{l}{u} la t ra = go F t  where
  go : forall {l} G -> <! G !>OSO (MuOSO F L) L l u -> <$ L $>+ l u
  go qR        t              = fflatten t
  go q1        _              = la inl ! ra
  go (S q+ T)  (inl s)        = go S s
  go (S q+ T)  (inr t)        = go T t
  go (S q^ T)  (s \\ p \\ t)  = flapp S p s (go T t)
\end{code}

This is effective, but it is more complicated than I should like. It
is basically the same function twice, in two different modes,
depending on what is to be affixed \emph{after} the rightmost order
evidence in the structure being flattened: either a pivot-and-tail in
the case of |flapp|, or nothing in the case of |fflatten|. The problem
is one of parity: the thing we must affix to one odd-length
leaf-node-leaf alternation to get another is an even-length node-leaf
alternation. Correspondingly, it is hard to express the type of the
accumulator cleanly. Once again, I begin to suspect that this is a
difficult thing to do because it is the wrong thing to do. How can we
reframe the problem, so that we work only with odd-length leaf-delimited
data?


\section{A Replacement for Concatenation}

My mathematical mentor, Tom K\"orner, is fond of remarking ``A
mathematician is someone who knows that $0$ is $0+0$". It is often
difficult to recognize the structure you need when the problem in front of
you is a degenerate case of it. If we think again about concatenation,
we might realise that it does not amount to \emph{affixing} one list
to another, but rather \emph{replacing} the `nil' of the first list
with the whole of the second. We might then notice that the
\emph{monoidal} structure of lists is in fact degenerate
\emph{monadic} structure.

Any syntax has a monadic structure, where `return' embeds variables as
terms and `bind' is substitution. Quite apart from their `prioritised
choice' monadic structure, lists are the terms of a degenerate syntax
with one variable (called `nil') and only unary operators (`cons` with
a choice of element). Correspondingly, they have this substitution
structure: substituting nil gives concatenation, and the monad laws
are the monoid laws.

Given this clue, let us consider concatenation and flattening in terms
of \emph{replacing} the rightmost leaf by a list, rather than affixing
more data to it. We replace the list to append with a function which
maps the contents of the rightmost leaf---some order evidence---to its
replacement. The type looks more like that of `bind' than `append',
because in some sense it is!

%format +++ = ++
%format _+++_ = _++_
%format Replacement = "\F{Replacement}"
\begin{code}
infixr 8 _+++_
Replacement : forall {P}(L : REL P)(n u : <$ P $>D) -> Set
Replacement L n u = forall {m}{{_ : <$ L $>F m n}} -> <$ L $>+ m u

_+++_ : forall {P}{L : REL P}{l n u} ->
  MuOSO qListSO L l n -> Replacement L n u ->
  MuOSO qListSO L l u
la inl _ ra               +++ ys = ys
la inr (_ \\ x \\ xs) ra  +++ ys = la inr (! \\ x \\ xs +++ ys) ra
\end{code}

Careful use of instance arguments leaves all the manipulation of
evidence to the machine. In the `nil' case, |ys| is silently
instantiated with exactly the evidence exposed in the `nil' pattern
on the left.

Let us now deploy the same technique for |fflatten|.

%format fflapp = "\F{flapp}"
%format flatten = "\F{flatten}"
\begin{code}
fflapp : forall {P}{L : REL P}{F}{l n u} ->
  MuOSO F L l n ->  Replacement L n u -> <$ L $>+ l u 
fflapp {P}{L}{F}{u = u} la t ra ys = go F t ys where
  go :   forall {l n} G -> <! G !>OSO (MuOSO F L) L l n ->
          Replacement L n u -> <$ L $>+ l u
  go qR        t              ys  = fflapp t ys
  go q1        _              ys  = ys
  go (S q+ T)  (inl s)        ys  = go S s ys
  go (S q+ T)  (inr t)        ys  = go T t ys
  go (S q^ T)  (s \\ p \\ t)  ys  = go S s la inr (! \\ p \\ go T t ys) ra

flatten : forall {P}{L : REL P}{F}{l u} ->
  MuOSO F L l u -> <$ L $>+ l u
flatten t = fflapp t la inl ! ra
\end{code}

\bibliographystyle{plainnat} % basic style, author-year citations
\bibliography{Ornament} % name your BibTeX data base

\end{document}